import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../utils/log.dart';
import '../wrappers/analytics_wrapper.dart';
import '../wrappers/http_wrapper.dart';
import '../wrappers/io_wrapper.dart';
import '../wrappers/shared_preferences_wrapper.dart';
import 'properties_manager.dart';
import 'time_manager.dart';

final _log = const Log("EmailManager");

/// A file attachment for [EmailManager.send].
class EmailAttachment {
  final String filename;
  final String contentType;
  final String base64Content;

  const EmailAttachment({
    required this.filename,
    required this.contentType,
    required this.base64Content,
  });
}

/// The result of [EmailManager.send].
enum EmailSendResult {
  /// The email was sent, or was silently dropped by the spam filter. The two
  /// are intentionally indistinguishable to callers so users can't tell when
  /// their message was filtered.
  sent,

  /// The email failed to send.
  failed,

  /// An email was sent too recently; the user should wait before retrying.
  rateLimited,
}

/// Sends transactional emails via Mailjet's Send API v3.1
/// (https://dev.mailjet.com/email/guides/send-api-v31/). Callers assemble
/// the subject and body content; this class only handles the Mailjet
/// request/response mechanics (auth, request shape, status checking).
class EmailManager {
  static var _instance = EmailManager._();

  static EmailManager get get => _instance;

  @visibleForTesting
  static void set(EmailManager manager) => _instance = manager;

  @visibleForTesting
  static void reset() => _instance = EmailManager._();

  EmailManager._();

  static const _url = "https://api.mailjet.com/v3.1/send";
  static const _keyLastSentAt = "EmailManager.lastSentAt";
  static const _eventBlocked = "email_blocked";
  static const _cooldown = Duration(minutes: 10);
  static const _minMessageLength = 10;

  static final _emailRegex = RegExp(r"\S+@\S+\.\S+");
  static final _urlRegex = RegExp(r"https?://|www\.", caseSensitive: false);

  // Case-sensitive so a missing space after a period (e.g. "the app.Me and")
  // isn't mistaken for a domain.
  static final _domainRegex = RegExp(
    r"\b[\w-]+\.(com|net|org|io|co|ru|xyz|info|biz|me|ly|link)\b",
  );
  static final _numericRegex = RegExp(r"^[\d\s.,+\-()]+$");

  /// Sends an email with [text] as its body. [userMessage] is the raw text
  /// entered by the user, and is used for spam filtering when
  /// [isSpamFilterEnabled] is true. Filtered messages are not sent, but
  /// [EmailSendResult.sent] is still returned. Messages with [attachments]
  /// are rate limited, but never filtered.
  Future<EmailSendResult> send({
    required String appName,
    required String replyToEmail,
    required String replyToName,
    required String subject,
    required String text,
    required String userMessage,
    List<EmailAttachment> attachments = const [],
    bool isSpamFilterEnabled = true,
  }) async {
    if (isSpamFilterEnabled) {
      var cooldownRemaining = _cooldownRemaining(await _lastSentAt());
      if (cooldownRemaining != null) {
        _log.d(
          "Email blocked: rate_limited "
          "(${cooldownRemaining.inSeconds}s left)",
        );

        unawaited(
          AnalyticsWrapper.get.logEvent(
            name: _eventBlocked,
            parameters: {"reason": "rate_limited"},
          ),
        );
        return EmailSendResult.rateLimited;
      }

      var blockedReason = attachments.isEmpty
          ? _spamReason(userMessage.trim())
          : null;

      if (blockedReason != null) {
        _log.d("Email blocked: $blockedReason");
        unawaited(
          AnalyticsWrapper.get.logEvent(
            name: _eventBlocked,
            parameters: {"reason": blockedReason},
          ),
        );
        // Nothing was sent, so there's no need to start the cooldown.
        return EmailSendResult.sent;
      }
    }

    if (!await _post(
      appName: appName,
      replyToEmail: replyToEmail,
      replyToName: replyToName,
      subject: subject,
      text: text,
      attachments: attachments,
    )) {
      return EmailSendResult.failed;
    }

    if (isSpamFilterEnabled) {
      await _setLastSentAt();
    }

    return EmailSendResult.sent;
  }

  Future<bool> _post({
    required String appName,
    required String replyToEmail,
    required String replyToName,
    required String subject,
    required String text,
    required List<EmailAttachment> attachments,
  }) async {
    var fromName =
        "$appName ${IoWrapper.get.isAndroid ? "Android" : "iOS"} App";

    var body = {
      "Messages": [
        {
          "From": {
            "Email": PropertiesManager.get.clientSenderEmail,
            "Name": fromName,
          },
          "To": [
            {"Email": PropertiesManager.get.supportEmail},
          ],
          "ReplyTo": {"Email": replyToEmail, "Name": replyToName},
          "Subject": subject,
          "TextPart": text,
          if (attachments.isNotEmpty)
            "Attachments": attachments
                .map(
                  (a) => {
                    "ContentType": a.contentType,
                    "Filename": a.filename,
                    "Base64Content": a.base64Content,
                  },
                )
                .toList(),
        },
      ],
    };

    http.Response response;
    try {
      response = await HttpWrapper.get.post(
        Uri.parse(_url),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": _basicAuthHeader(),
        },
        body: jsonEncode(body),
      );
    } catch (e) {
      _log.e(e, reason: "Sending email via Mailjet");
      return false;
    }

    if (response.statusCode != HttpStatus.ok) {
      _log.e(
        HttpException(response.statusCode.toString()),
        reason: "Mailjet error sending email: ${response.body}",
      );
      return false;
    }

    if (_messageStatus(response.body) != "success") {
      _log.e(
        HttpException(response.body),
        reason: "Mailjet reported a non-success message status",
      );
      return false;
    }

    return true;
  }

  /// Returns the time the last email was sent, or null if it's unknown. Fails
  /// open so a storage error never blocks sending.
  Future<int?> _lastSentAt() async {
    try {
      return await SharedPreferencesWrapper.get.sharedPreferencesAsync().getInt(
        _keyLastSentAt,
      );
    } catch (e) {
      _log.e(e, reason: "Reading email last sent time");
      return null;
    }
  }

  /// Returns the time left before another email can be sent, or null if one
  /// can be sent now.
  Duration? _cooldownRemaining(int? lastSentAt) {
    if (lastSentAt == null) {
      return null;
    }

    var elapsed = TimeManager.get.currentTimestamp - lastSentAt;

    // A negative value means the clock moved backwards; don't lock the user
    // out until it catches up.
    if (elapsed < 0 || elapsed >= _cooldown.inMilliseconds) {
      return null;
    }

    return Duration(milliseconds: _cooldown.inMilliseconds - elapsed);
  }

  Future<void> _setLastSentAt() async {
    try {
      await SharedPreferencesWrapper.get.sharedPreferencesAsync().setInt(
        _keyLastSentAt,
        TimeManager.get.currentTimestamp,
      );
    } catch (e) {
      _log.e(e, reason: "Writing email last sent time");
    }
  }

  /// Returns the reason [message] is considered spam, or null if it isn't.
  String? _spamReason(String message) {
    if (message.length < _minMessageLength) {
      return "too_short";
    }
    // Email addresses are allowed within a message (e.g. to reference another
    // account), but not as the entire message. They're removed before
    // checking for links so their domains aren't mistaken for one.
    var withoutEmails = message.replaceAll(_emailRegex, "").trim();
    if (withoutEmails.isEmpty) {
      return "email_address";
    }
    if (_urlRegex.hasMatch(withoutEmails) ||
        _domainRegex.hasMatch(withoutEmails)) {
      return "link";
    }
    if (_numericRegex.hasMatch(message)) {
      return "numeric";
    }
    return null;
  }

  String _basicAuthHeader() {
    var credentials =
        "${PropertiesManager.get.mailjetApiKey}:"
        "${PropertiesManager.get.mailjetSecretKey}";
    return "Basic ${base64Encode(utf8.encode(credentials))}";
  }

  String? _messageStatus(String responseBody) {
    try {
      var messages =
          (jsonDecode(responseBody) as Map<String, dynamic>)["Messages"]
              as List<dynamic>;
      return (messages.first as Map<String, dynamic>)["Status"] as String?;
    } catch (e) {
      _log.e(e, reason: "Parsing Mailjet response body");
      return null;
    }
  }
}

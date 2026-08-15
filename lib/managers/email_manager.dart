import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../utils/log.dart';
import '../wrappers/http_wrapper.dart';
import '../wrappers/io_wrapper.dart';
import 'properties_manager.dart';

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

  Future<bool> send({
    required String appName,
    required String replyToEmail,
    required String replyToName,
    required String subject,
    required String text,
    List<EmailAttachment> attachments = const [],
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

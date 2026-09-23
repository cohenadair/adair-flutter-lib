import 'dart:async';
import 'dart:convert';

import 'package:adair_flutter_lib/managers/email_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';
import '../test_utils/stubbed_managers.dart';

const _keyLastSentAt = "EmailManager.lastSentAt";
const _validMessage = "This is a valid feedback message about the app.";
const _cooldown = Duration(minutes: 10);

void main() {
  late StubbedManagers managers;
  late MockSharedPreferencesAsync sharedPrefsAsync;

  setUp(() async {
    managers = await StubbedManagers.create();
    EmailManager.reset();

    sharedPrefsAsync = MockSharedPreferencesAsync();
    when(sharedPrefsAsync.getInt(any)).thenAnswer((_) async => null);
    when(sharedPrefsAsync.setInt(any, any)).thenAnswer((_) async {});
    when(
      managers.sharedPreferencesWrapper.sharedPreferencesAsync(
        options: anyNamed("options"),
      ),
    ).thenReturn(sharedPrefsAsync);

    when(
      managers.analyticsWrapper.logEvent(
        name: anyNamed("name"),
        parameters: anyNamed("parameters"),
      ),
    ).thenAnswer((_) async {});

    when(managers.propertiesManager.mailjetApiKey).thenReturn("api-key");
    when(managers.propertiesManager.mailjetSecretKey).thenReturn("secret");
    when(
      managers.propertiesManager.clientSenderEmail,
    ).thenReturn("from@test.com");
    when(managers.propertiesManager.supportEmail).thenReturn("to@test.com");
    when(managers.ioWrapper.isAndroid).thenReturn(false);
  });

  Future<EmailSendResult> send({
    List<EmailAttachment> attachments = const [],
    String userMessage = _validMessage,
    bool isSpamFilterEnabled = true,
  }) {
    return EmailManager.get.send(
      appName: "App Name",
      replyToEmail: "reply@test.com",
      replyToName: "Reply Name",
      subject: "Test Subject",
      text: "Test body",
      userMessage: userMessage,
      attachments: attachments,
      isSpamFilterEnabled: isSpamFilterEnabled,
    );
  }

  void stubPostSuccess() {
    when(
      managers.httpWrapper.post(
        any,
        headers: anyNamed("headers"),
        body: anyNamed("body"),
      ),
    ).thenAnswer(
      (_) async => http.Response('{"Messages":[{"Status":"success"}]}', 200),
    );
  }

  void verifyNoPost() {
    verifyNever(
      managers.httpWrapper.post(
        any,
        headers: anyNamed("headers"),
        body: anyNamed("body"),
      ),
    );
  }

  void verifyPost() {
    verify(
      managers.httpWrapper.post(
        any,
        headers: anyNamed("headers"),
        body: anyNamed("body"),
      ),
    ).called(1);
  }

  void stubLastSentAgo(Duration ago) {
    when(sharedPrefsAsync.getInt(_keyLastSentAt)).thenAnswer(
      (_) async => managers.timeManager.currentTimestamp - ago.inMilliseconds,
    );
  }

  Future<void> expectSent(String message) async {
    stubPostSuccess();
    expect(await send(userMessage: message), EmailSendResult.sent);
    verifyPost();
  }

  void verifyBlocked(String reason) {
    verify(
      managers.analyticsWrapper.logEvent(
        name: "email_blocked",
        parameters: {"reason": reason},
      ),
    ).called(1);
  }

  /// Runs [body] and returns everything it printed to the console.
  Future<List<String>> capturePrints(Future<void> Function() body) async {
    var prints = <String>[];
    await runZoned(
      body,
      zoneSpecification: ZoneSpecification(
        print: (_, _, _, line) => prints.add(line),
      ),
    );
    return prints;
  }

  Future<void> expectFiltered(String message, String reason) async {
    stubPostSuccess();
    var prints = await capturePrints(
      () async =>
          expect(await send(userMessage: message), EmailSendResult.sent),
    );
    expect(prints, contains("D/AL-EmailManager: Email blocked: $reason"));
    verifyNoPost();
    verifyBlocked(reason);
    verifyNever(sharedPrefsAsync.setInt(any, any));
  }

  test("send returns sent on a successful Mailjet response", () async {
    stubPostSuccess();
    expect(await send(), EmailSendResult.sent);
    verify(sharedPrefsAsync.setInt(_keyLastSentAt, any)).called(1);
  });

  test("send posts the Mailjet request shape with Basic Auth", () async {
    when(
      managers.httpWrapper.post(
        any,
        headers: anyNamed("headers"),
        body: anyNamed("body"),
      ),
    ).thenAnswer(
      (_) async => http.Response('{"Messages":[{"Status":"success"}]}', 200),
    );

    await send();

    var result = verify(
      managers.httpWrapper.post(
        Uri.parse("https://api.mailjet.com/v3.1/send"),
        headers: captureAnyNamed("headers"),
        body: captureAnyNamed("body"),
      ),
    )..called(1);
    var headers = result.captured.first as Map<String, String>;
    var json = jsonDecode(result.captured.last) as Map<String, dynamic>;
    var message = (json["Messages"] as List<dynamic>).first;

    expect(
      headers["Authorization"],
      "Basic ${base64Encode(utf8.encode("api-key:secret"))}",
    );
    expect(message["From"], {
      "Email": "from@test.com",
      "Name": "App Name iOS App",
    });
    expect(message["To"], [
      {"Email": "to@test.com"},
    ]);
    expect(message["ReplyTo"], {
      "Email": "reply@test.com",
      "Name": "Reply Name",
    });
    expect(message["Subject"], "Test Subject");
    expect(message["TextPart"], "Test body");
    expect(message.containsKey("Attachments"), isFalse);
  });

  test("send uses the Android app name suffix on Android", () async {
    when(managers.ioWrapper.isAndroid).thenReturn(true);
    when(
      managers.httpWrapper.post(
        any,
        headers: anyNamed("headers"),
        body: anyNamed("body"),
      ),
    ).thenAnswer(
      (_) async => http.Response('{"Messages":[{"Status":"success"}]}', 200),
    );

    await send();

    var result = verify(
      managers.httpWrapper.post(
        any,
        headers: anyNamed("headers"),
        body: captureAnyNamed("body"),
      ),
    )..called(1);
    var json = jsonDecode(result.captured.first) as Map<String, dynamic>;
    var message = (json["Messages"] as List<dynamic>).first;

    expect(message["From"], {
      "Email": "from@test.com",
      "Name": "App Name Android App",
    });
  });

  test("send includes attachments in the request body", () async {
    when(
      managers.httpWrapper.post(
        any,
        headers: anyNamed("headers"),
        body: anyNamed("body"),
      ),
    ).thenAnswer(
      (_) async => http.Response('{"Messages":[{"Status":"success"}]}', 200),
    );

    await send(
      attachments: const [
        EmailAttachment(
          filename: "test.db",
          contentType: "application/x-sqlite3",
          base64Content: "base64content",
        ),
      ],
    );

    var result = verify(
      managers.httpWrapper.post(
        any,
        headers: anyNamed("headers"),
        body: captureAnyNamed("body"),
      ),
    )..called(1);
    var json = jsonDecode(result.captured.first) as Map<String, dynamic>;
    var message = (json["Messages"] as List<dynamic>).first;

    expect(message["Attachments"], [
      {
        "ContentType": "application/x-sqlite3",
        "Filename": "test.db",
        "Base64Content": "base64content",
      },
    ]);
  });

  test("send returns failed when the HTTP status code isn't 200", () async {
    when(
      managers.httpWrapper.post(
        any,
        headers: anyNamed("headers"),
        body: anyNamed("body"),
      ),
    ).thenAnswer((_) async => http.Response("Unauthorized", 401));

    expect(await send(), EmailSendResult.failed);
    verifyNever(sharedPrefsAsync.setInt(any, any));
  });

  test(
    "send returns failed when Mailjet reports a non-success message status",
    () async {
      when(
        managers.httpWrapper.post(
          any,
          headers: anyNamed("headers"),
          body: anyNamed("body"),
        ),
      ).thenAnswer(
        (_) async =>
            http.Response('{"Messages":[{"Status":"error","Errors":[]}]}', 200),
      );

      expect(await send(), EmailSendResult.failed);
      verifyNever(sharedPrefsAsync.setInt(any, any));
    },
  );

  test("send returns failed when the HTTP call throws", () async {
    when(
      managers.httpWrapper.post(
        any,
        headers: anyNamed("headers"),
        body: anyNamed("body"),
      ),
    ).thenThrow(Exception("Network error"));

    expect(await send(), EmailSendResult.failed);
    verifyNever(sharedPrefsAsync.setInt(any, any));
  });

  test("send returns rateLimited when an email was sent recently", () async {
    stubLastSentAgo(_cooldown ~/ 2);

    var prints = await capturePrints(
      () async => expect(await send(), EmailSendResult.rateLimited),
    );
    expect(
      prints,
      contains(
        "D/AL-EmailManager: Email blocked: rate_limited "
        "(${(_cooldown ~/ 2).inSeconds}s left)",
      ),
    );
    verifyNoPost();
    verifyBlocked("rate_limited");
  });

  test("send sends when the cooldown has expired", () async {
    stubPostSuccess();
    stubLastSentAgo(_cooldown + const Duration(minutes: 1));

    expect(await send(), EmailSendResult.sent);
    verifyPost();
  });

  test("send filters messages that are too short", () async {
    await expectFiltered("Hi there", "too_short");
  });

  test("send filters messages that are only an email address", () async {
    await expectFiltered("someone@example.com", "email_address");
  });

  test("send sends messages that contain an email address", () async {
    await expectSent("My wife's account jane@example.com lost all her data");
  });

  test("send filters messages that contain a URL", () async {
    await expectFiltered("Check out https://spam.example for more", "link");
  });

  test("send filters messages that contain a www link", () async {
    await expectFiltered("Check out www.spam-site for great deals", "link");
  });

  test("send filters messages that contain a bare domain", () async {
    await expectFiltered("Great deals are available at spamsite.com", "link");
  });

  test("send filters messages that are only numbers", () async {
    await expectFiltered("+1 (555) 123-4567, 555.987.6543 00", "numeric");
  });

  test("send trims the message before filtering", () async {
    await expectFiltered("   Hi there                    ", "too_short");
  });

  test("send skips the cooldown and filters when disabled", () async {
    stubPostSuccess();
    when(
      sharedPrefsAsync.getInt(_keyLastSentAt),
    ).thenAnswer((_) async => managers.timeManager.currentTimestamp);

    expect(
      await send(userMessage: "", isSpamFilterEnabled: false),
      EmailSendResult.sent,
    );
    verifyPost();
    verifyNever(sharedPrefsAsync.getInt(any));
    verifyNever(sharedPrefsAsync.setInt(any, any));
    verifyNever(
      managers.analyticsWrapper.logEvent(
        name: anyNamed("name"),
        parameters: anyNamed("parameters"),
      ),
    );
  });

  test("send sends short messages at the minimum length", () async {
    await expectSent("It crashes");
  });

  test("send sends messages with a missing space after a period", () async {
    await expectSent("Love the app.Me and my son use it daily");
  });

  test("send sends messages that mention an iOS app name", () async {
    await expectSent("I exported to Files.app and it was empty");
  });

  test("send filters messages that contain an uppercase URL", () async {
    await expectFiltered("Visit HTTPS://SPAM.EXAMPLE for deals", "link");
  });

  test("send skips content filtering when there are attachments", () async {
    stubPostSuccess();
    expect(
      await send(
        userMessage: "",
        attachments: const [
          EmailAttachment(
            filename: "data.db",
            contentType: "application/x-sqlite3",
            base64Content: "AAAA",
          ),
        ],
      ),
      EmailSendResult.sent,
    );
    verifyPost();
    verify(sharedPrefsAsync.setInt(_keyLastSentAt, any)).called(1);
  });

  test("send is not rate limited when the clock moved backwards", () async {
    stubPostSuccess();
    stubLastSentAgo(-const Duration(days: 365));

    expect(await send(), EmailSendResult.sent);
    verifyPost();
  });

  test("send sends when reading the last sent time throws", () async {
    stubPostSuccess();
    when(sharedPrefsAsync.getInt(any)).thenThrow(Exception("Read error"));

    expect(await send(), EmailSendResult.sent);
    verifyPost();
  });

  test("send returns sent when writing the last sent time throws", () async {
    stubPostSuccess();
    when(sharedPrefsAsync.setInt(any, any)).thenThrow(Exception("Write error"));

    expect(await send(), EmailSendResult.sent);
    verifyPost();
  });
}

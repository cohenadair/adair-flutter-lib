import 'dart:convert';

import 'package:adair_flutter_lib/managers/email_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../test_utils/stubbed_managers.dart';

void main() {
  late StubbedManagers managers;

  setUp(() async {
    managers = await StubbedManagers.create();
    EmailManager.reset();

    when(managers.propertiesManager.mailjetApiKey).thenReturn("api-key");
    when(managers.propertiesManager.mailjetSecretKey).thenReturn("secret");
    when(
      managers.propertiesManager.clientSenderEmail,
    ).thenReturn("from@test.com");
    when(managers.propertiesManager.supportEmail).thenReturn("to@test.com");
    when(managers.ioWrapper.isAndroid).thenReturn(false);
  });

  Future<bool> send({List<EmailAttachment> attachments = const []}) {
    return EmailManager.get.send(
      appName: "App Name",
      replyToEmail: "reply@test.com",
      replyToName: "Reply Name",
      subject: "Test Subject",
      text: "Test body",
      attachments: attachments,
    );
  }

  test("send returns true on a successful Mailjet response", () async {
    when(
      managers.httpWrapper.post(
        any,
        headers: anyNamed("headers"),
        body: anyNamed("body"),
      ),
    ).thenAnswer(
      (_) async => http.Response('{"Messages":[{"Status":"success"}]}', 200),
    );

    expect(await send(), isTrue);
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

  test("send returns false when the HTTP status code isn't 200", () async {
    when(
      managers.httpWrapper.post(
        any,
        headers: anyNamed("headers"),
        body: anyNamed("body"),
      ),
    ).thenAnswer((_) async => http.Response("Unauthorized", 401));

    expect(await send(), isFalse);
  });

  test(
    "send returns false when Mailjet reports a non-success message status",
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

      expect(await send(), isFalse);
    },
  );

  test("send returns false when the HTTP call throws", () async {
    when(
      managers.httpWrapper.post(
        any,
        headers: anyNamed("headers"),
        body: anyNamed("body"),
      ),
    ).thenThrow(Exception("Network error"));

    expect(await send(), isFalse);
  });
}

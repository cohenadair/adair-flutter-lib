import 'package:adair_flutter_lib/app_config.dart';
import 'package:adair_flutter_lib/l10n/l10n.dart';
import 'package:adair_flutter_lib/pages/scroll_page.dart';
import 'package:adair_flutter_lib/res/dimen.dart';
import 'package:adair_flutter_lib/utils/widget.dart';
import 'package:adair_flutter_lib/widgets/empty_or.dart';
import 'package:adair_flutter_lib/widgets/input_controller.dart';
import 'package:adair_flutter_lib/widgets/loading.dart';
import 'package:adair_flutter_lib/widgets/text_input.dart';
import 'package:adair_flutter_lib/wrappers/firebase_auth_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

import '../res/theme.dart';
import '../utils/log.dart';
import '../widgets/button.dart';
import 'landing_page.dart';

// TODO: Support other providers (Apple, Google at a minimum).
class SignInPage extends StatefulWidget {
  final SignInPageInfo info;
  final WidgetCallback homeBuilder;

  const SignInPage({required this.info, required this.homeBuilder});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  static const _logoSize = 200.0;

  late final Stream<User?> _authStateStream;

  final _emailController = EmailInputController(required: false);
  final _passwordController = TextInputController();
  final _log = Log("SignInPage");

  var _error = "";
  var _isSigningIn = false;

  @override
  void initState() {
    super.initState();
    _authStateStream = FirebaseAuthWrapper.get.authStateChanges();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authStateStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          _log.e(snapshot.error!, reason: "Fetching auth state");
          return LandingPage(hasError: true);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LandingPage(hasError: false);
        }

        return snapshot.hasData && !_isSigningIn
            ? widget.homeBuilder(context)
            : _buildPage(context);
      },
    );
  }

  Widget _buildPage(BuildContext context) {
    return ScrollPage(
      restrictWidth: true,
      padding: insetsDefault,
      spacing: paddingDefault,
      centerContent: true,
      children: [
        _buildLogo(),
        _buildEmailField(context),
        _buildPasswordField(context),
        _buildError(context),
        _buildSignInButton(context),
      ],
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: insetsDefault,
      child: widget.info.logo ?? Icon(AppConfig.get.appIcon, size: _logoSize),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return TextInput.email(
      context,
      controller: _emailController,
      textInputAction: TextInputAction.next,
      hideMaxLength: true, // Not needed for login.
      onChanged: (_) => setState(() {}),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    // TODO: Refactor to TextInput.password constructor.
    return TextInput(
      label: L10n.get.lib.signInPagePasswordLabel,
      controller: _passwordController,
      obscureText: true,
      maxLines: 1,
      maxLength: null,
      textInputAction: TextInputAction.done,
      onChanged: (_) => setState(() {}),
      onSubmitted: _isInputValid() ? _signIn : null,
    );
  }

  Widget _buildError(BuildContext context) {
    return EmptyOr(
      isShowing: isNotEmpty(_error),
      builder: (context) => Text(_error, style: context.styleError),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(),
        _isSigningIn ? Loading.minimized() : const SizedBox(),
        const SizedBox(width: paddingDefault),
        Button(
          onPressed: _isInputValid() && !_isSigningIn ? _signIn : null,
          text: L10n.get.lib.signInPageSignInButton,
        ),
      ],
    );
  }

  bool _isInputValid() =>
      _emailController.editingController.text.isNotEmpty &&
      _passwordController.editingController.text.isNotEmpty;

  Future<void> _signIn() async {
    setState(() => _isSigningIn = true);

    var error = "";
    try {
      await FirebaseAuthWrapper.get.signInWithEmailAndPassword(
        email: _emailController.editingController.text,
        password: _passwordController.editingController.text,
      );
    } on FirebaseAuthException catch (e) {
      error = _errorMessage(e.code);
    }

    if (error.isEmpty) {
      try {
        if ((await widget.info.postSignInVerification?.call() ?? "")
            .isNotEmpty) {
          error = await widget.info.postSignInVerification?.call() ?? "";
        }
      } catch (e, stackTrace) {
        _log.e(e, stackTrace: stackTrace, reason: "Post-sign in verification");
        error = e.toString();
      }
    }

    // Something bad happened. Make sure we're signed out.
    if (error.isNotEmpty) {
      await FirebaseAuthWrapper.get.signOut();
    }

    setState(() {
      _isSigningIn = false;
      _error = error;

      // Clear password field on successful sign in so it must be re-entered
      // when the user signs out.
      if (_error.isEmpty) {
        _passwordController.clearText();
      }
    });
  }

  // TODO: Should probably only handle common errors here, and the generic
  //  "unknown" text is enough for uncommon ones.
  String _errorMessage(String code) {
    // Possible codes: https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithEmailAndPassword.html
    switch (code) {
      case "invalid-email":
        return L10n.get.lib.signInPageErrorInvalidEmail;
      case "user-disabled":
        return L10n.get.lib.signInPageErrorUserDisabled;
      case "user-not-found":
        return L10n.get.lib.signInPageErrorUserNotFound;
      case "too-many-requests":
        return L10n.get.lib.signInPageErrorTooManyRequests;
      case "user-token-expired":
        return L10n.get.lib.signInPageErrorTokenExpired;
      case "network-request-failed":
        return L10n.get.lib.signInPageErrorNetworkFailed;
      case "INVALID_LOGIN_CREDENTIALS":
      case "invalid-credential":
      case "wrong-password":
        return L10n.get.lib.signInPageErrorInvalidCredentials;
      case "operation-not-allowed":
        return L10n.get.lib.signInPageErrorOperationNotAllowed;
      default:
        return L10n.get.lib.signInPageErrorUnknown(code);
    }
  }
}

class SignInPageInfo {
  /// If null, defaults to [AppConfig.appIcon].
  final Widget? logo;

  /// Called after sign in, if not null. Return an error string to stop the
  /// sign in. The returned value is shown to the user. Return null to signal a
  /// successful verification.
  final Future<String?> Function()? postSignInVerification;

  SignInPageInfo({this.logo, this.postSignInVerification});
}

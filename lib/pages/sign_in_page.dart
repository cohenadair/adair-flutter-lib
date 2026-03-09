import 'package:adair_flutter_lib/app_config.dart';
import 'package:adair_flutter_lib/l10n/l10n.dart';
import 'package:adair_flutter_lib/pages/scroll_page.dart';
import 'package:adair_flutter_lib/res/dimen.dart';
import 'package:adair_flutter_lib/utils/widget.dart';
import 'package:adair_flutter_lib/widgets/empty_or.dart';
import 'package:adair_flutter_lib/widgets/loading.dart';
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

  // TODO: Refactor to use TextInput + realtime validation.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _log = Log("SignInPage");

  var _error = "";
  var _isSigningIn = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onTextChanged);
    _passwordController.addListener(_onTextChanged);
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
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          _log.e(snapshot.error!, reason: "Fetching auth state");
          return LandingPage(hasError: true);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LandingPage(hasError: false);
        }

        return snapshot.hasData && !_isSigningIn
            ? widget.homeBuilder(context)
            : _buildPage();
      },
    );
  }

  Widget _buildPage() {
    return ScrollPage(
      restrictWidth: true,
      padding: insetsDefault,
      spacing: paddingDefault,
      centerContent: true,
      children: [
        _buildLogo(),
        _buildEmailField(),
        _buildPasswordField(),
        _buildError(),
        _buildSignInButton(),
      ],
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: insetsDefault,
      child: widget.info.logo ?? Icon(AppConfig.get.appIcon, size: _logoSize),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(labelText: L10n.get.lib.signInPageEmailLabel),
      textCapitalization: TextCapitalization.none,
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: L10n.get.lib.signInPagePasswordLabel,
      ),
      textCapitalization: TextCapitalization.none,
    );
  }

  Widget _buildError() {
    return EmptyOr(
      isShowing: isNotEmpty(_error),
      builder: (context) => Text(_error, style: context.styleError),
    );
  }

  Widget _buildSignInButton() {
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
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  void _onTextChanged() => setState(() {});

  Future<void> _signIn() async {
    setState(() => _isSigningIn = true);

    var error = "";
    try {
      await FirebaseAuthWrapper.get.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if ((await widget.info.postSignInVerification?.call() ?? "").isNotEmpty) {
        error = await widget.info.postSignInVerification?.call() ?? "";
        await FirebaseAuthWrapper.get.signOut();
      }
    } on FirebaseAuthException catch (e) {
      error = errorMessage(e.code);
    } catch (e) {
      _log.e(e, reason: "Sign in with email");
      error = errorMessage(e.toString());
    }

    setState(() {
      _isSigningIn = false;
      _error = error;

      // Clear password field on successful sign in so it must be re-entered
      // when the user signs out.
      if (_error.isEmpty) {
        _passwordController.clear();
      }
    });
  }

  String errorMessage(String code) {
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

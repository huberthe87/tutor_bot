import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'confirm_signup_screen.dart';
import '../../l10n/app_localizations.dart';

class SignInScreen extends StatefulWidget {
  final Future<void> Function() onSignIn;

  const SignInScreen({
    super.key,
    required this.onSignIn,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmationCodeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isResendingCode = false;
  bool _showConfirmationCode = false;

  Future<void> _resendConfirmationCode() async {
    final username = _emailController.text.trim();
    if (username.isEmpty) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.pleaseEnterEmail;
      });
      return;
    }

    setState(() {
      _isResendingCode = true;
      _errorMessage = null;
    });

    try {
      debugPrint('DEBUG: Attempting to resend confirmation code to: $username');
      final result = await Amplify.Auth.resendSignUpCode(username: username);
      debugPrint('DEBUG: Resend confirmation code result: $result');

      if (!mounted) return;

      debugPrint('DEBUG: Confirmation code resent successfully');
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.confirmationCodeSent),
        ),
      );
    } on AuthException catch (e) {
      debugPrint('DEBUG: Error resending confirmation code: ${e.message}');
      debugPrint('DEBUG: Error type: ${e.runtimeType}');
      debugPrint('DEBUG: Error details: ${e.toString()}');
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      debugPrint('DEBUG: Unexpected error during resend: $e');
      debugPrint('DEBUG: Error type: ${e.runtimeType}');
      if (!mounted) return;
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.unexpectedResendError;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isResendingCode = false;
        });
      }
    }
  }

  Future<void> _confirmSignUp() async {
    final username = _emailController.text.trim();
    final code = _confirmationCodeController.text.trim();

    if (code.isEmpty) {
      setState(() {
        _errorMessage =
            AppLocalizations.of(context)!.pleaseEnterConfirmationCode;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      debugPrint('DEBUG: Attempting to confirm sign up for user: $username');
      final result = await Amplify.Auth.confirmSignUp(
        username: username,
        confirmationCode: code,
      );

      debugPrint('DEBUG: Confirm sign up result: $result');

      if (!mounted) return;

      if (result.isSignUpComplete) {
        debugPrint('DEBUG: Sign up confirmed successfully');
        setState(() {
          _showConfirmationCode = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.emailConfirmed),
          ),
        );
      }
    } on AuthException catch (e) {
      debugPrint('DEBUG: Error confirming sign up: ${e.message}');
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      debugPrint('DEBUG: Unexpected error during confirmation: $e');
      if (!mounted) return;
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.unexpectedError;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    // Hide keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final username = _emailController.text.trim();
      final password = _passwordController.text;

      debugPrint('DEBUG: Starting sign in process for user: $username');

      // Track sign-in attempt
      await Amplify.Analytics.recordEvent(
        event: AnalyticsEvent('SignInAttempted'),
      );

      // Perform sign in
      final result = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );

      debugPrint('DEBUG: Sign in result: ${result.isSignedIn}');
      debugPrint('DEBUG: Sign in next step: ${result.nextStep.signInStep}');

      // Handle different sign-in steps
      switch (result.nextStep.signInStep) {
        case AuthSignInStep.confirmSignInWithNewPassword:
          debugPrint('DEBUG: User needs to set a new password');
          setState(() {
            _errorMessage = AppLocalizations.of(context)!.newPasswordRequired;
          });
          break;

        case AuthSignInStep.confirmSignUp:
          debugPrint('DEBUG: User needs to confirm sign-up');
          if (!mounted) return;
          // Navigate to confirmation screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConfirmSignUpScreen(
                username: username,
                onSignIn: widget.onSignIn,
              ),
            ),
          );
          break;

        case AuthSignInStep.confirmSignInWithCustomChallenge:
          debugPrint('DEBUG: User needs to complete a custom challenge');
          setState(() {
            _errorMessage =
                AppLocalizations.of(context)!.customChallengeRequired;
          });
          break;

        case AuthSignInStep.done:
          debugPrint(
              'DEBUG: ${AppLocalizations.of(context)!.signInSuccessful}');
          if (!mounted) return;

          // Track successful sign-in
          await Amplify.Analytics.recordEvent(
            event: AnalyticsEvent('SignInSuccessful'),
          );

          // Update auth state
          await widget.onSignIn();

          if (!mounted) return;
          // Navigate to home
          Navigator.pushReplacementNamed(context, '/');
          break;

        default:
          debugPrint(
              'DEBUG: Unexpected sign-in step: ${result.nextStep.signInStep}');
          setState(() {
            _errorMessage = AppLocalizations.of(context)!.unexpectedSignInError;
          });
      }
    } on AuthException catch (e) {
      debugPrint('DEBUG: Auth exception caught:');
      debugPrint('DEBUG: Exception type: ${e.runtimeType}');
      debugPrint('DEBUG: Exception message: ${e.message}');
      debugPrint('DEBUG: Exception details: ${e.toString()}');

      // Track sign-in failure
      await Amplify.Analytics.recordEvent(
        event: AnalyticsEvent('SignInFailed'),
      );

      if (!mounted) return;

      // Check if the error message indicates user not confirmed
      if (e.message.contains(AppLocalizations.of(context)!.userNotConfirmed)) {
        debugPrint('DEBUG: User not confirmed detected from error message');
        // Show resend confirmation code option
        if (!mounted) return;
        debugPrint('DEBUG: Showing confirmation dialog...');

        try {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.emailNotConfirmed),
              content:
                  Text(AppLocalizations.of(context)!.emailNotConfirmedMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    debugPrint('DEBUG: User cancelled resend code');
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                TextButton(
                  onPressed: () {
                    debugPrint('DEBUG: User requested to resend code');
                    Navigator.pop(context);
                    _resendConfirmationCode();
                  },
                  child: Text(AppLocalizations.of(context)!.resendCode),
                ),
              ],
            ),
          );
          debugPrint('DEBUG: Dialog closed');
        } catch (dialogError) {
          debugPrint('DEBUG: Error showing dialog: $dialogError');
        }
      } else {
        setState(() {
          _errorMessage = e.message;
        });
      }
    } catch (e) {
      debugPrint('DEBUG: Unexpected error during sign in:');
      debugPrint('DEBUG: Error type: ${e.runtimeType}');
      debugPrint('DEBUG: Error details: $e');
      if (!mounted) return;
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.unexpectedError;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmationCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/icon/icon.png',
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.welcomeMessage,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.appTagline,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.7),
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: l10n.email,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.pleaseEnterEmail;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      border: const OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.pleaseEnterPassword;
                      }
                      return null;
                    },
                  ),
                  if (_showConfirmationCode) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmationCodeController,
                      decoration: InputDecoration(
                        labelText: l10n.confirmationCode,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.pleaseEnterConfirmationCode;
                        }
                        return null;
                      },
                    ),
                  ],
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),
                  if (_showConfirmationCode)
                    ElevatedButton(
                      onPressed: _isLoading ? null : _confirmSignUp,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(l10n.signUp),
                    )
                  else
                    ElevatedButton(
                      onPressed: _isLoading ? null : _signIn,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(l10n.signIn),
                    ),
                  if (_isResendingCode) ...[
                    const SizedBox(height: 16),
                    Center(
                      child: Text(l10n.resendingConfirmationCode),
                    ),
                  ],
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Text(l10n.dontHaveAccount),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

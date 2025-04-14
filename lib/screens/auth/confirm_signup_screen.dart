import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class ConfirmSignUpScreen extends StatefulWidget {
  final String username;
  final Future<void> Function() onSignIn;

  const ConfirmSignUpScreen({
    super.key,
    required this.username,
    required this.onSignIn,
  });

  @override
  State<ConfirmSignUpScreen> createState() => _ConfirmSignUpScreenState();
}

class _ConfirmSignUpScreenState extends State<ConfirmSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _confirmationCodeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isResendingCode = false;

  Future<void> _resendConfirmationCode() async {
    setState(() {
      _isResendingCode = true;
      _errorMessage = null;
    });

    try {
      debugPrint(
          'DEBUG: Attempting to resend confirmation code to: ${widget.username}');
      final result =
          await Amplify.Auth.resendSignUpCode(username: widget.username);
      debugPrint('DEBUG: Resend confirmation code result: $result');

      if (!mounted) return;

      debugPrint('DEBUG: Confirmation code resent successfully');
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Confirmation code has been resent to your email'),
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
        _errorMessage =
            'An unexpected error occurred while resending the code.';
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
    if (!_formKey.currentState!.validate()) return;

    final code = _confirmationCodeController.text.trim();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      debugPrint(
          'DEBUG: Attempting to confirm sign up for user: ${widget.username}');
      final result = await Amplify.Auth.confirmSignUp(
        username: widget.username,
        confirmationCode: code,
      );

      debugPrint('DEBUG: Confirm sign up result: $result');

      if (!mounted) return;

      if (result.isSignUpComplete) {
        debugPrint('DEBUG: Sign up confirmed successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email confirmed successfully! Please sign in.'),
          ),
        );
        // Update auth state
        await widget.onSignIn();
        if (!mounted) return;
        // Navigate back to sign in
        Navigator.pop(context);
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
        _errorMessage = 'An unexpected error occurred. Please try again.';
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
    _confirmationCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Sign Up'),
      ),
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
                  const Text(
                    'Confirm Your Email',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'We\'ve sent a confirmation code to:',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _confirmationCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Confirmation Code',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the confirmation code';
                      }
                      return null;
                    },
                  ),
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
                        : const Text('Confirm Sign Up'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed:
                        _isResendingCode ? null : _resendConfirmationCode,
                    child: _isResendingCode
                        ? const Text('Resending code...')
                        : const Text('Resend Confirmation Code'),
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

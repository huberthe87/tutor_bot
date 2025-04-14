import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tutor_bot/screens/grade_process/grade_processing_screen.dart';
import 'package:tutor_bot/screens/grade_result/grade_result_screen.dart';
import 'package:tutor_bot/models/grade_result.dart';
import 'dart:io';
import 'screens/main_screen.dart';
import 'screens/worksheet_editor/worksheet_editor_screen.dart';
import 'screens/image_crop_screen.dart';
import 'screens/recent_grade/grade_details_screen.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/auth/sign_up_screen.dart';
import 'screens/auth/confirm_signup_screen.dart';
import 'theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'amplifyconfiguration.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:provider/provider.dart';
import 'services/language_service.dart';

void main() async {
  try {
    // Ensure Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize shared preferences
    final prefs = await SharedPreferences.getInstance();

    // Initialize Amplify
    await AmplifyConfiguration.configureAmplify();

    // Set the default status bar style
    SystemChrome.setSystemUIOverlayStyle(AppTheme.lightStatusBarStyle);

    runApp(MyApp(prefs: prefs));
  } catch (e) {
    debugPrint('Error initializing Amplify: $e');
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("Error configuring app: ${e.toString()}"),
        ),
      ),
    ));
  }
}

class MyApp extends StatefulWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      if (mounted) {
        setState(() {
          _isSignedIn = session.isSignedIn;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSignedIn = false;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> updateAuthState() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    await _checkAuthState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LanguageService(widget.prefs),
        ),
      ],
      child: MaterialApp(
        title: 'Tutor Bot',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: _isLoading
            ? const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : _isSignedIn
                ? const MainScreen()
                : SignInScreen(onSignIn: updateAuthState),
        routes: _isLoading
            ? {}
            : {
                '/signin': (context) => SignInScreen(onSignIn: updateAuthState),
                '/signup': (context) => SignUpScreen(onSignIn: updateAuthState),
                '/confirm': (context) => ConfirmSignUpScreen(
                      username: '',
                      onSignIn: updateAuthState,
                    ),
                '/worksheetEditor': (context) {
                  final args = ModalRoute.of(context)?.settings.arguments;
                  return WorksheetEditorScreen(
                    imageFile: args as File?,
                  );
                },
                '/grading': (context) {
                  final args = ModalRoute.of(context)!.settings.arguments
                      as Map<String, dynamic>;
                  final imageFile = args['imageFile'] as File;
                  final subject = args['subject'] as String;
                  final language = args['language'] as String;
                  return GradeProcessingScreen(
                    imageFile: imageFile,
                    subject: subject,
                    language: language,
                  );
                },
                '/gradeResult': (context) {
                  final args = ModalRoute.of(context)!.settings.arguments
                      as Map<String, dynamic>;
                  final imageFile = args['imageFile'] as File;
                  final gradeResult = args['gradeResult'] as GradeResult;
                  return GradeResultScreen(
                      imageFile: imageFile, gradingResult: gradeResult);
                },
                '/gradeDetails': (context) {
                  final grade =
                      ModalRoute.of(context)!.settings.arguments as GradeResult;
                  return GradeDetailsScreen(grade: grade);
                },
                '/imageCrop': (context) => ImageCropScreen(
                      imageFile:
                          ModalRoute.of(context)!.settings.arguments as File,
                    ),
              },
      ),
    );
  }
}

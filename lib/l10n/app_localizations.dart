import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Common
      'app_name': 'Tutor Bot',
      'welcome': 'Welcome',
      'welcome_message': 'Hello! I\'m Tutor Bot',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'done': 'Done',
      'app_tagline': 'Your AI-powered teaching assistant',
      'please_enter_email': 'Please enter your email',
      'please_enter_valid_email': 'Please enter a valid email',
      'please_enter_password': 'Please enter your password',
      'please_confirm_password': 'Please confirm your password',
      'passwords_dont_match': 'Passwords do not match',
      'password_min_length': 'Password must be at least 8 characters',
      'account_created': 'Account created successfully! Please sign in.',
      'create_account': 'Create Account',
      'resending_confirmation_code': 'Resending confirmation code...',
      'confirmation_code': 'Confirmation Code',
      'please_enter_confirmation_code': 'Please enter the confirmation code',
      'email_not_confirmed': 'Email Not Confirmed',
      'confirmation_code_sent':
          'Confirmation code has been resent to your email',
      'email_confirmed': 'Email confirmed successfully! Please sign in.',
      'email_not_confirmed_message':
          'Your email address has not been confirmed. Would you like to resend the confirmation code?',
      'resend_code': 'Resend Code',

      // Auth
      'sign_in': 'Sign In',
      'sign_up': 'Sign Up',
      'sign_out': 'Sign Out',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'forgot_password': 'Forgot Password?',
      'dont_have_account': 'Don\'t have an account?',
      'already_have_account': 'Already have an account?',

      // Profile
      'profile': 'Profile',
      'personal_info': 'Personal Information',
      'notifications': 'Notifications',
      'privacy_security': 'Privacy & Security',
      'language': 'Language',
      'theme': 'Theme',
      'help_center': 'Help Center',
      'about': 'About',

      // Home
      'quick_grade': 'Quick Grade',
      'take_photo': 'Take Photo',
      'choose_image': 'Choose Image',
      'recent_grades': 'Recent Grades',
      'no_recent_grades': 'No recent grades',

      // Grade
      'grade_result': 'Grade Result',
      'ai_grading_result': 'AI Grading Result',
      'original_image': 'Original Image',
      'score': 'Score',
      'feedback': 'Feedback',
      'subject': 'Subject',
      'date': 'Date',

      // History
      'history': 'History',
      'graded_on': 'Graded on',
      'grade_history': 'Grade History',
      'no_grades_found': 'No grades found',
      'error_loading_grades': 'Error loading grades: {error}',
      'refresh': 'Refresh',

      // Reports
      'reports': 'Reports',
      'reports_coming_soon': 'Reports Coming Soon',
      'reports_under_construction': 'This feature is under construction.',
      'reports_check_back':
          'Check back later for detailed analytics and reports.',
      'reports_feature_coming_soon': 'Reports feature is coming soon!',

      // Settings
      'settings': 'Settings',
      'settings_coming_soon': 'Settings coming soon!',
      'new_password_required':
          'You need to set a new password. Please contact support.',
      'custom_challenge_required': 'Please complete the custom challenge.',
      'unexpected_error': 'An unexpected error occurred. Please try again.',
      'unexpected_signin_error': 'An unexpected error occurred during sign-in.',
      'unexpected_resend_error':
          'An unexpected error occurred while resending the code.',
      'user_not_confirmed': 'User is not confirmed',
      'sign_in_successful': 'Sign in successful',
      'sign_in_failed': 'Sign in failed',
      'pick_image': 'Pick Image',
      'welcome': 'Welcome',
      'recent_grades': 'Recent Grades',
      'no_recent_grades': 'No recent grades',
      'graded_on': 'Graded on {date}',
      'grade_details': 'Grade Details - {subject}',
      'image_not_available': 'Image not available',
      'questions': 'Questions',
      'question_number': 'Question {number}',
      'correct': '✓ Correct',
      'incorrect': '✗ Incorrect',
      'expression': 'Expression: {expr}',
      'student_answer': 'Student Answer: {answer}',
      'steps': 'Steps:',
      'comprehension_score': 'Score: {score}/10',
      'grammar_errors': 'Grammar Errors: {errors}',
      'spelling_errors': 'Spelling Errors: {errors}',
      'delete_grade': 'Delete Grade',
      'delete_grade_confirmation':
          'Are you sure you want to delete this grade? This action cannot be undone.',
      'error_deleting_grade': 'Error deleting grade: {error}',
      'grade_deleted': 'Grade deleted successfully',
      'home': 'Home',
    },
    'zh': {
      // Common
      'app_name': '知改',
      'welcome': '欢迎',
      'welcome_message': '你好！我是知改',
      'loading': '加载中...',
      'error': '错误',
      'success': '成功',
      'cancel': '取消',
      'save': '保存',
      'delete': '删除',
      'edit': '编辑',
      'done': '完成',
      'app_tagline': '您的AI教学助手',
      'please_enter_email': '请输入您的邮箱',
      'please_enter_valid_email': '请输入有效的邮箱地址',
      'please_enter_password': '请输入您的密码',
      'please_confirm_password': '请确认您的密码',
      'passwords_dont_match': '两次输入的密码不一致',
      'password_min_length': '密码长度至少为8个字符',
      'account_created': '账号创建成功！请登录。',
      'create_account': '创建账号',
      'resending_confirmation_code': '正在重新发送验证码...',
      'confirmation_code': '验证码',
      'please_enter_confirmation_code': '请输入验证码',
      'email_not_confirmed': '邮箱未验证',
      'confirmation_code_sent': '验证码已重新发送到您的邮箱',
      'email_confirmed': '邮箱验证成功！请登录。',
      'email_not_confirmed_message': '您的邮箱地址尚未验证。是否要重新发送验证码？',
      'resend_code': '重新发送',

      // Auth
      'sign_in': '登录',
      'sign_up': '注册',
      'sign_out': '退出登录',
      'email': '邮箱',
      'password': '密码',
      'confirm_password': '确认密码',
      'forgot_password': '忘记密码？',
      'dont_have_account': '还没有账号？',
      'already_have_account': '已有账号？',

      // Profile
      'profile': '个人资料',
      'personal_info': '个人信息',
      'notifications': '通知',
      'privacy_security': '隐私与安全',
      'language': '语言',
      'theme': '主题',
      'help_center': '帮助中心',
      'about': '关于',

      // Home
      'quick_grade': '快速评分',
      'take_photo': '拍照',
      'choose_image': '选择图片',
      'recent_grades': '最近评分',
      'no_recent_grades': '暂无最近评分',

      // Grade
      'grade_result': '评分结果',
      'ai_grading_result': 'AI评分结果',
      'original_image': '原始图片',
      'score': '分数',
      'feedback': '反馈',
      'subject': '科目',
      'date': '日期',

      // History
      'history': '历史',
      'graded_on': '评分于',
      'grade_history': '评分历史',
      'no_grades_found': '暂无评分记录',
      'error_loading_grades': '加载评分失败：{error}',
      'refresh': '刷新',

      // Reports
      'reports': '报告',
      'reports_coming_soon': '报告功能即将推出',
      'reports_under_construction': '此功能正在建设中。',
      'reports_check_back': '请稍后再查看详细的分析和报告。',
      'reports_feature_coming_soon': '报告功能即将推出！',

      // Settings
      'settings': '设置',
      'settings_coming_soon': '设置功能即将推出！',
      'new_password_required': '您需要设置新密码。请联系支持。',
      'custom_challenge_required': '请完成自定义验证。',
      'unexpected_error': '发生意外错误。请重试。',
      'unexpected_signin_error': '登录过程中发生意外错误。',
      'unexpected_resend_error': '重新发送验证码时发生意外错误。',
      'user_not_confirmed': '用户未验证',
      'sign_in_successful': '登录成功',
      'sign_in_failed': '登录失败',
      'pick_image': '选择图片',
      'welcome': '欢迎',
      'recent_grades': '最近评分',
      'no_recent_grades': '暂无最近评分',
      'graded_on': '评分时间：{date}',
      'grade_details': '评分详情 - {subject}',
      'image_not_available': '图片不可用',
      'questions': '题目',
      'question_number': '第{number}题',
      'correct': '✓ 正确',
      'incorrect': '✗ 错误',
      'expression': '表达式：{expr}',
      'student_answer': '学生答案：{answer}',
      'steps': '步骤：',
      'comprehension_score': '得分：{score}/10',
      'grammar_errors': '语法错误：{errors}',
      'spelling_errors': '拼写错误：{errors}',
      'delete_grade': '删除评分',
      'delete_grade_confirmation': '确定要删除这个评分吗？此操作无法撤销。',
      'error_deleting_grade': '删除评分时出错：{error}',
      'grade_deleted': '评分已成功删除',
      'home': '首页',
    },
  };

  // Common
  String get appName => _localizedValues[locale.languageCode]!['app_name']!;
  String get welcome => _localizedValues[locale.languageCode]!['welcome']!;
  String get welcomeMessage =>
      _localizedValues[locale.languageCode]!['welcome_message']!;
  String get loading => _localizedValues[locale.languageCode]!['loading']!;
  String get error => _localizedValues[locale.languageCode]!['error']!;
  String get success => _localizedValues[locale.languageCode]!['success']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get delete => _localizedValues[locale.languageCode]!['delete']!;
  String get edit => _localizedValues[locale.languageCode]!['edit']!;
  String get done => _localizedValues[locale.languageCode]!['done']!;
  String get appTagline =>
      _localizedValues[locale.languageCode]!['app_tagline']!;
  String get pleaseEnterEmail =>
      _localizedValues[locale.languageCode]!['please_enter_email']!;
  String get pleaseEnterValidEmail =>
      _localizedValues[locale.languageCode]!['please_enter_valid_email']!;
  String get pleaseEnterPassword =>
      _localizedValues[locale.languageCode]!['please_enter_password']!;
  String get pleaseConfirmPassword =>
      _localizedValues[locale.languageCode]!['please_confirm_password']!;
  String get passwordsDontMatch =>
      _localizedValues[locale.languageCode]!['passwords_dont_match']!;
  String get passwordMinLength =>
      _localizedValues[locale.languageCode]!['password_min_length']!;
  String get accountCreated =>
      _localizedValues[locale.languageCode]!['account_created']!;
  String get createAccount =>
      _localizedValues[locale.languageCode]!['create_account']!;
  String get resendingConfirmationCode =>
      _localizedValues[locale.languageCode]!['resending_confirmation_code']!;
  String get confirmationCode =>
      _localizedValues[locale.languageCode]!['confirmation_code']!;
  String get pleaseEnterConfirmationCode =>
      _localizedValues[locale.languageCode]!['please_enter_confirmation_code']!;
  String get emailNotConfirmed =>
      _localizedValues[locale.languageCode]!['email_not_confirmed']!;
  String get confirmationCodeSent =>
      _localizedValues[locale.languageCode]!['confirmation_code_sent']!;
  String get emailConfirmed =>
      _localizedValues[locale.languageCode]!['email_confirmed']!;
  String get emailNotConfirmedMessage =>
      _localizedValues[locale.languageCode]!['email_not_confirmed_message']!;
  String get resendCode =>
      _localizedValues[locale.languageCode]!['resend_code']!;

  // Auth
  String get signIn => _localizedValues[locale.languageCode]!['sign_in']!;
  String get signUp => _localizedValues[locale.languageCode]!['sign_up']!;
  String get signOut => _localizedValues[locale.languageCode]!['sign_out']!;
  String get email => _localizedValues[locale.languageCode]!['email']!;
  String get password => _localizedValues[locale.languageCode]!['password']!;
  String get confirmPassword =>
      _localizedValues[locale.languageCode]!['confirm_password']!;
  String get forgotPassword =>
      _localizedValues[locale.languageCode]!['forgot_password']!;
  String get dontHaveAccount =>
      _localizedValues[locale.languageCode]!['dont_have_account']!;
  String get alreadyHaveAccount =>
      _localizedValues[locale.languageCode]!['already_have_account']!;

  // Profile
  String get profile => _localizedValues[locale.languageCode]!['profile']!;
  String get personalInfo =>
      _localizedValues[locale.languageCode]!['personal_info']!;
  String get notifications =>
      _localizedValues[locale.languageCode]!['notifications']!;
  String get privacySecurity =>
      _localizedValues[locale.languageCode]!['privacy_security']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get theme => _localizedValues[locale.languageCode]!['theme']!;
  String get helpCenter =>
      _localizedValues[locale.languageCode]!['help_center']!;
  String get about => _localizedValues[locale.languageCode]!['about']!;

  // Home
  String get home => _localizedValues[locale.languageCode]!['home']!;
  String get quickGrade =>
      _localizedValues[locale.languageCode]!['quick_grade']!;
  String get takePhoto => _localizedValues[locale.languageCode]!['take_photo']!;
  String get chooseImage =>
      _localizedValues[locale.languageCode]!['choose_image']!;
  String get recentGrades =>
      _localizedValues[locale.languageCode]!['recent_grades']!;
  String get noRecentGrades =>
      _localizedValues[locale.languageCode]!['no_recent_grades']!;
  String get pickImage => _localizedValues[locale.languageCode]!['pick_image']!;
  String get errorLoadingGrades =>
      _localizedValues[locale.languageCode]!['error_loading_grades']!;

  // Grade
  String get gradeResult =>
      _localizedValues[locale.languageCode]!['grade_result']!;
  String get aiGradingResult =>
      _localizedValues[locale.languageCode]!['ai_grading_result']!;
  String get originalImage =>
      _localizedValues[locale.languageCode]!['original_image']!;
  String get score => _localizedValues[locale.languageCode]!['score']!;
  String get feedback => _localizedValues[locale.languageCode]!['feedback']!;
  String get subject => _localizedValues[locale.languageCode]!['subject']!;
  String get date => _localizedValues[locale.languageCode]!['date']!;
  String get gradeDetails =>
      _localizedValues[locale.languageCode]!['grade_details']!;
  String get questions => _localizedValues[locale.languageCode]!['questions']!;
  String get questionNumber =>
      _localizedValues[locale.languageCode]!['question_number']!;
  String get correct => _localizedValues[locale.languageCode]!['correct']!;
  String get incorrect => _localizedValues[locale.languageCode]!['incorrect']!;
  String get expression =>
      _localizedValues[locale.languageCode]!['expression']!;
  String get studentAnswer =>
      _localizedValues[locale.languageCode]!['student_answer']!;
  String get steps => _localizedValues[locale.languageCode]!['steps']!;
  String get comprehensionScore =>
      _localizedValues[locale.languageCode]!['comprehension_score']!;
  String get grammarErrors =>
      _localizedValues[locale.languageCode]!['grammar_errors']!;
  String get spellingErrors =>
      _localizedValues[locale.languageCode]!['spelling_errors']!;
  String get deleteGrade =>
      _localizedValues[locale.languageCode]!['delete_grade']!;
  String get deleteGradeConfirmation =>
      _localizedValues[locale.languageCode]!['delete_grade_confirmation']!;
  String get errorDeletingGrade =>
      _localizedValues[locale.languageCode]!['error_deleting_grade']!;
  String get gradeDeleted =>
      _localizedValues[locale.languageCode]!['grade_deleted']!;

  // History
  String get history => _localizedValues[locale.languageCode]!['history']!;
  String get gradedOn => _localizedValues[locale.languageCode]!['graded_on']!;
  String get gradeHistory =>
      _localizedValues[locale.languageCode]!['grade_history']!;
  String get noGradesFound =>
      _localizedValues[locale.languageCode]!['no_grades_found']!;
  String get refresh => _localizedValues[locale.languageCode]!['refresh']!;

  // Reports
  String get reports => _localizedValues[locale.languageCode]!['reports']!;
  String get reportsComingSoon =>
      _localizedValues[locale.languageCode]!['reports_coming_soon']!;
  String get reportsUnderConstruction =>
      _localizedValues[locale.languageCode]!['reports_under_construction']!;
  String get reportsCheckBack =>
      _localizedValues[locale.languageCode]!['reports_check_back']!;
  String get reportsFeatureComingSoon =>
      _localizedValues[locale.languageCode]!['reports_feature_coming_soon']!;

  // Settings
  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get settingsComingSoon =>
      _localizedValues[locale.languageCode]!['settings_coming_soon']!;
  String get newPasswordRequired =>
      _localizedValues[locale.languageCode]!['new_password_required']!;
  String get customChallengeRequired =>
      _localizedValues[locale.languageCode]!['custom_challenge_required']!;
  String get unexpectedError =>
      _localizedValues[locale.languageCode]!['unexpected_error']!;
  String get unexpectedSignInError =>
      _localizedValues[locale.languageCode]!['unexpected_signin_error']!;
  String get unexpectedResendError =>
      _localizedValues[locale.languageCode]!['unexpected_resend_error']!;
  String get userNotConfirmed =>
      _localizedValues[locale.languageCode]!['user_not_confirmed']!;
  String get signInSuccessful =>
      _localizedValues[locale.languageCode]!['sign_in_successful']!;
  String get signInFailed =>
      _localizedValues[locale.languageCode]!['sign_in_failed']!;

  String get imageNotAvailable =>
      _localizedValues[locale.languageCode]!['image_not_available']!;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

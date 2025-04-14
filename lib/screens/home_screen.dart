import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../models/grade_result.dart';
import '../services/grade_storage_service.dart';
import '../utils/permission_utils.dart';
import 'recent_grade/recent_grades_list.dart';
import 'history_screen.dart';
import 'reports_screen.dart';
import 'profile_screen.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _selectedTabIndex = 0;

  final List<Widget> _tabs = [
    const _HomeTab(),
    const HistoryScreen(),
    const ReportsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: _tabs[_selectedTabIndex],
    );
  }
}

class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => HomeTabState();
}

class HomeTabState extends State<_HomeTab> {
  final ImagePicker _picker = ImagePicker();
  final GradeStorageService _gradeStorage = GradeStorageService();
  final List<GradeResult> _recentGrades = [];
  bool _isLoading = true;
  String _userEmail = 'Welcome';

  @override
  void initState() {
    super.initState();
    loadRecentGrades();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      setState(() {
        _userEmail = user.username;
      });
    } catch (e) {
      debugPrint('Error loading user info: $e');
      setState(() {
        _userEmail = 'Welcome';
      });
    }
  }

  Future<void> loadRecentGrades() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final grades = await _gradeStorage.getRecentGradeResults();
      setState(() {
        _recentGrades.clear();
        _recentGrades.addAll(grades);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading grades: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading grades: $e')),
        );
      }
    }
  }

  Future<void> _takePhoto() async {
    if (!await PermissionUtils.requestCameraPermission(context)) return;

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      // Navigate to the crop screen
      if (!mounted) return;
      Navigator.pushNamed(
        context,
        '/imageCrop',
        arguments: File(photo.path),
      );
    }
  }

  Future<void> _pickImage() async {
    if (!await PermissionUtils.checkGalleryPermission(context)) return;

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Navigate to the crop screen
      if (!mounted) return;
      Navigator.pushNamed(
        context,
        '/imageCrop',
        arguments: File(image.path),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Text(
                _userEmail.isNotEmpty ? _userEmail[0].toUpperCase() : 'W',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                _userEmail,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  margin: const EdgeInsets.all(20),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Quick Grade',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 140,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.3),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextButton(
                                onPressed: _takePhoto,
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_alt,
                                        color: Theme.of(context).primaryColor,
                                        size: 28),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Take Photo',
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Container(
                              width: 140,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.3),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextButton(
                                onPressed: _pickImage,
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.photo_library,
                                        color: Theme.of(context).primaryColor,
                                        size: 28),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Choose Image',
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Recent Grades Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: RecentGradesList(
                    grades: _recentGrades,
                    isLoading: _isLoading,
                    formatDate: _formatDate,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

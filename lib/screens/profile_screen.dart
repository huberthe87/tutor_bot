import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import 'language_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      await Amplify.Auth.signOut();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/signin');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing out: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings coming soon!'),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Prof. John Doe',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Mathematics Teacher',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),
          _buildSection(
            context,
            'Account Settings',
            [
              _buildMenuItem(
                context,
                Icons.person_outline,
                'Personal Information',
                () {},
              ),
              _buildMenuItem(
                context,
                Icons.notifications_outlined,
                'Notifications',
                () {},
              ),
              _buildMenuItem(
                context,
                Icons.security,
                'Privacy & Security',
                () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            'Preferences',
            [
              Consumer<LanguageService>(
                builder: (context, languageService, child) {
                  final languageCode = languageService.currentLanguage;
                  final languageName =
                      LanguageService.supportedLanguages[languageCode] ??
                          'English';
                  return _buildMenuItem(
                    context,
                    Icons.language,
                    'Language',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LanguageScreen(),
                        ),
                      );
                    },
                    trailing: Text(
                      languageName,
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                context,
                Icons.dark_mode,
                'Theme',
                () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            'Support',
            [
              _buildMenuItem(
                context,
                Icons.help_outline,
                'Help Center',
                () {},
              ),
              _buildMenuItem(
                context,
                Icons.info_outline,
                'About',
                () {},
              ),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => _signOut(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'Log Out',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

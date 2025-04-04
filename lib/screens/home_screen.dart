import 'package:flutter/material.dart';
import 'worksheet_editor_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Home Screen'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/worksheetEditor',
                );
              },
              icon: const Icon(Icons.edit_document),
              label: const Text('Open Worksheet Editor'),
            ),
          ],
        ),
      ),
    );
  }
} 
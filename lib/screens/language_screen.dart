import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Language'),
      ),
      body: Consumer<LanguageService>(
        builder: (context, languageService, child) {
          return ListView.builder(
            itemCount: LanguageService.supportedLanguages.length,
            itemBuilder: (context, index) {
              final languageCode =
                  LanguageService.supportedLanguages.keys.elementAt(index);
              final languageName =
                  LanguageService.supportedLanguages[languageCode]!;
              final isSelected =
                  languageService.currentLanguage == languageCode;

              return ListTile(
                leading: Text(
                  _getLanguageEmoji(languageCode),
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(languageName),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).primaryColor,
                      )
                    : null,
                onTap: () async {
                  debugPrint(
                      'LanguageScreen: Setting language to $languageCode');
                  await languageService.setLanguage(languageCode);
                  debugPrint(
                      'LanguageScreen: Language set to ${languageService.currentLanguage}');
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  String _getLanguageEmoji(String languageCode) {
    switch (languageCode) {
      case 'en':
        return '🇺🇸';
      case 'es':
        return '🇪🇸';
      case 'fr':
        return '🇫🇷';
      case 'de':
        return '🇩🇪';
      case 'it':
        return '🇮🇹';
      case 'pt':
        return '🇵🇹';
      case 'ru':
        return '🇷🇺';
      case 'zh':
        return '🇨🇳';
      case 'ja':
        return '🇯🇵';
      case 'ko':
        return '🇰🇷';
      default:
        return '🌐';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/language_service.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return ExpansionTile(
          title: Row(
            children: [
              const Icon(Icons.language),
              const SizedBox(width: 12),
              Text(
                languageService.getCurrentLanguageName(),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          children:
              languageService.availableLanguages.map((language) {
                final isSelected =
                    languageService.currentLocale.languageCode ==
                    language['code'];

                return ListTile(
                  leading: Radio<String>(
                    value: language['code']!,
                    groupValue: languageService.currentLocale.languageCode,
                    onChanged: (value) {
                      if (value != null) {
                        languageService.changeLanguage(value);
                      }
                    },
                  ),
                  title: Text(
                    language['nativeName']!,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(language['name']!),
                  onTap: () {
                    languageService.changeLanguage(language['code']!);
                  },
                );
              }).toList(),
        );
      },
    );
  }
}

// Simple language picker dialog
class LanguagePickerDialog extends StatelessWidget {
  const LanguagePickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return AlertDialog(
          title: const Text('Chọn ngôn ngữ / Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                languageService.availableLanguages.map((language) {
                  final isSelected =
                      languageService.currentLocale.languageCode ==
                      language['code'];

                  return ListTile(
                    leading: Radio<String>(
                      value: language['code']!,
                      groupValue: languageService.currentLocale.languageCode,
                      onChanged: (value) {
                        if (value != null) {
                          languageService.changeLanguage(value);
                        }
                      },
                    ),
                    title: Text(
                      language['nativeName']!,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(language['name']!),
                    onTap: () {
                      languageService.changeLanguage(language['code']!);
                    },
                  );
                }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đóng / Close'),
            ),
          ],
        );
      },
    );
  }
}

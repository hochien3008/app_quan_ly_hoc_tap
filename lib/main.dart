import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_hoc_tap/config/firebase_options.dart';
import 'package:quan_ly_hoc_tap/core/services/language_service.dart';
import 'package:quan_ly_hoc_tap/features/auth/presentation/screens/welcome_screen.dart';
import 'package:quan_ly_hoc_tap/localization/app_localizations.dart';
import 'package:quan_ly_hoc_tap/routes/app_router.dart';
import 'package:quan_ly_hoc_tap/core/theme/app_theme.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:quan_ly_hoc_tap/features/dashboard/presentation/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Note: Firebase App Check removed to avoid MissingPluginException
  // App Check can be added later when needed for production

  // Enable Firestore offline persistence and disable App Check
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // Disable App Check for development
  if (kDebugMode) {
    // This will suppress App Check warnings in debug mode
    print('🔧 App Check disabled for development');
  }

  tz.initializeTimeZones();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LanguageService(),
      child: Consumer<LanguageService>(
        builder: (context, languageService, child) {
          return MaterialApp(
            title: 'StudyBuddy',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            locale: languageService.currentLocale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}

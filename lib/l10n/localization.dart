import 'dart:ui';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'available_language.dart';

class Localization {
  static final List<Locale> all = [
    Locale("en"),
    Locale("tr"),
  ];
  static final Map<String, String> languageCodes = {
    'en': 'English',
    'tr': 'Türkçe',
  };

  static final delegates = const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static List<AvailableLanguage> availableLanguages = [
    AvailableLanguage(
        languageName: "Turkish",
        languageCode: "tr",
        nativeLanguageName: "Türkçe",
        flagURI:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Flag_of_Turkey.svg/1280px-Flag_of_Turkey.svg.png"),
    AvailableLanguage(
        languageName: "English",
        languageCode: "en",
        nativeLanguageName: "English",
        flagURI:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Flag_of_the_United_States.svg/960px-Flag_of_the_United_States.svg.png"),
  ];
}

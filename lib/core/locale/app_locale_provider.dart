import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Fallback when the device locale is unsupported.
const Locale kDefaultAdminLocale = Locale('hu');

const String _storageKey = 'admin_app_locale_code';

/// `null` means follow the device locale via [resolveAppLocale].
final appLocaleProvider =
    NotifierProvider<AppLocaleNotifier, Locale?>(AppLocaleNotifier.new);

class AppLocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() {
    _loadSavedLocale();
    return null;
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_storageKey);
    if (code == 'en') {
      state = const Locale('en');
    } else if (code == 'hu') {
      state = const Locale('hu');
    }
  }

  Future<void> setLocale(Locale locale) async {
    final normalized = locale.languageCode == 'en'
        ? const Locale('en')
        : const Locale('hu');
    state = normalized;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, normalized.languageCode);
  }
}

Locale resolveAppLocale(Locale? deviceLocale, Iterable<Locale> supported) {
  for (final locale in supported) {
    if (locale.languageCode == deviceLocale?.languageCode) {
      return locale;
    }
  }
  return kDefaultAdminLocale;
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// HU-first default for operator staging flows.
const Locale kDefaultAdminLocale = Locale('hu');

const String _storageKey = 'admin_app_locale_code';

final appLocaleProvider =
    NotifierProvider<AppLocaleNotifier, Locale>(AppLocaleNotifier.new);

class AppLocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    _loadSavedLocale();
    return kDefaultAdminLocale;
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_storageKey);
    if (code == 'en') {
      state = const Locale('en');
    }
  }

  Future<void> setLocale(Locale locale) async {
    final normalized = locale.languageCode == 'en'
        ? const Locale('en')
        : kDefaultAdminLocale;
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

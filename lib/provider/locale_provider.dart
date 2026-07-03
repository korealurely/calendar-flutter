import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kAppLocaleKey = "app_locale_language";

final appLocaleProvider = NotifierProvider<AppLocaleNotifier,Locale?>((){
  return AppLocaleNotifier();
});

class AppLocaleNotifier extends Notifier<Locale?>{
  late SharedPreferences _prefs;

  @override
  Locale? build() {
    _initPrefs();
    return null;
  }

  Future<void> _initPrefs() async{
    _prefs = await SharedPreferences.getInstance();
    final String? languageCode = _prefs.getString(kAppLocaleKey);

    if(languageCode != null && languageCode.isNotEmpty){
      if(languageCode.contains('_')){
        final parts = languageCode.split('_');
        state = Locale(parts[0],parts[1]);
      }else{
        state = Locale(languageCode);
      }
    }
  }

  Future<void> changeLocale(Locale? locale) async{
    state = locale;
    _prefs = await SharedPreferences.getInstance();
    if(locale == null){
      await _prefs.remove(kAppLocaleKey);
    }else{
      final String saveValue = locale.countryCode != null ?
      '${locale.languageCode}_${locale.countryCode}'
          : locale.languageCode;
      await _prefs.setString(kAppLocaleKey, saveValue);
    }
  }
}
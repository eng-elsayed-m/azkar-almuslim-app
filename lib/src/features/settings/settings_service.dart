import 'package:azkar/src/core/utils/sh_p.dart';
import 'package:flutter/material.dart';

final themeMap = {
  "dark": ThemeMode.dark,
  "light": ThemeMode.light,
  "system": ThemeMode.system,
};

class SettingsService {
  ThemeMode _themeMode = ThemeMode.system;

  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeModeInit() async {
    String? stringTheme = await SHP.loadString(key: 'theme');

    ThemeMode? theme =
        stringTheme == null ? ThemeMode.system : themeMap[stringTheme];

    if (theme == null) {
      await SHP.saveString(
          key: 'theme', value: ThemeMode.system.toString().split(".").last);

      _themeMode = ThemeMode.system;
    }
    _themeMode = theme!;
    return _themeMode;
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode newTheme) async {
    if (_themeMode == newTheme) {
      return;
    }
    _themeMode = newTheme;

    await SHP.saveString(
      key: 'theme',
      value: newTheme.toString().split('.').last,
    );
  }
}
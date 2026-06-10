import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  static const _selectedThemeKey = 'selected_theme_id';

  String _selectedThemeId = AppTheme.defaultThemeId;
  bool _loaded = false;

  String get selectedThemeId => _selectedThemeId;
  bool get loaded => _loaded;
  List<AppThemeConfig> get themes => AppTheme.themes;
  AppThemeConfig get currentTheme => AppTheme.themeById(_selectedThemeId);
  ThemeData get themeData => currentTheme.themeData;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeId = prefs.getString(_selectedThemeKey);
    if (savedThemeId != null && AppTheme.hasTheme(savedThemeId)) {
      _selectedThemeId = savedThemeId;
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> selectTheme(String themeId) async {
    if (!AppTheme.hasTheme(themeId) || themeId == _selectedThemeId) return;

    _selectedThemeId = themeId;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedThemeKey, themeId);
  }
}

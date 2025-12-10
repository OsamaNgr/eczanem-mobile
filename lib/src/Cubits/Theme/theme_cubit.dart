import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial());

  static const String _themeKey = 'theme_mode';

  // Load theme from storage
  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_themeKey) ?? false;
      emit(ThemeChanged(isDark: isDark));
    } catch (e) {
      emit(ThemeChanged(isDark: false));
    }
  }

  // Toggle theme
  Future<void> toggleTheme() async {
    try {
      final currentState = state;
      final isDark = currentState is ThemeChanged ?  ! currentState.isDark : true;
      
      final prefs = await SharedPreferences. getInstance();
      await prefs. setBool(_themeKey, isDark);
      
      emit(ThemeChanged(isDark: isDark));
    } catch (e) {
      // Handle error
    }
  }

  // Set specific theme
  Future<void> setTheme({required bool isDark}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, isDark);
      emit(ThemeChanged(isDark:  isDark));
    } catch (e) {
      // Handle error
    }
  }
}
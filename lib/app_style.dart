import 'package:flutter/material.dart';

class AppStyle {
  static const tableTitleFontSize = 18.0;
  static const tableTextFontSize = 16.0;

  static const double pad8 = 8.0;
  static const double pad16 = 16.0;
  static const double pad24 = 24.0;
  static const double formFieldSpacing = 20.0;

  static const TextStyle formField = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  static const TextStyle formLabel = TextStyle(
    fontSize: 16,
    color: Colors.white70,
    fontWeight: FontWeight.w500,
  );

  static InputDecoration baseInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: formLabel,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white24),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  static final errorBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red.shade400),
    borderRadius: BorderRadius.circular(8),
  );

  static final focusedErrorBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red.shade600, width: 2),
    borderRadius: BorderRadius.circular(8),
  );

  static final errorStyle = TextStyle(
    color: Colors.red.shade300,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
}

final myDarkTheme = ThemeData.dark().copyWith(
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF9C27B0), // Viola primario
    secondary: Color(0xFF00BCD4), // Ciano per link
    surface: Color(0xFF1E1B2E), // Sfondo secondario (righe dispari)
    background: Color(0xFF121212), // Sfondo principale
    onPrimary: Colors.white,
    onSecondary: Colors.black,
  ),
  scaffoldBackgroundColor: Color(0xFF121212),
  dividerColor: Color(0xFF333333),
  iconTheme: IconThemeData(color: Color(0xFFAB47BC)),
);

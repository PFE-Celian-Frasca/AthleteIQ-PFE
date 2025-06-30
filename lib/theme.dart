import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static TextTheme _customTextTheme(TextTheme base) {
    return TextTheme(
      titleLarge: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold), // 'Bienvenue,' on LoginScreen
      titleMedium: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold), // Titles on OnboardingItem
      titleSmall: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600), // Parcour title on parcourTile
      bodyLarge: TextStyle(fontSize: 17.sp), // 'Connectez-vous pour continuer,' on LoginScreen
      bodyMedium: TextStyle(fontSize: 15.sp), // Visibility text on parcourTile
      bodySmall: TextStyle(fontSize: 13.sp), // Descriptions on OnboardingItem, Login screen bottom text
      labelMedium: TextStyle(fontSize: 12.sp), // Recent message in groupTile
      labelSmall: TextStyle(fontSize: 11.sp), // Timestamp in groupTile
      labelLarge: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500) // Button text
    );
  }

  static ThemeData get lightTheme {
    final ThemeData base = ThemeData.light();
    return ThemeData(
      colorScheme: const ColorScheme(
          error: Color(0xFFba1a1a),
          brightness: Brightness.light,
          primary: Color(0xFF2292db),
          secondary: Color(0xFF536a8b),
          tertiary: Color(0xFFbcbcbc),
          surface: Colors.white,
          onError: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Color(0xFF121212)
      ),
      textTheme: _customTextTheme(base.textTheme),
    );
  }

  static ThemeData get darkTheme {
    final ThemeData base = ThemeData.dark();
    return ThemeData(
      colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF1E88E5), // Variante de bleu plus sombre
          secondary: Color(0xFF8E24AA), // Variante de violet plus sombre
          surface: Color(0xFF303030), // Surface pour les éléments de l'UI
          error: Color(0xFFCF6679), // Rouge d'erreur dans les thèmes sombres
          onPrimary: Colors.white, // Texte/icones sur fond primaire
          onSecondary: Colors.white, // Texte/icones sur fond secondaire
          onSurface: Colors.white, // Texte/icones sur la surface
          onError: Colors.black, // Texte/icones sur les erreurs
          onTertiary: Colors.white, // Texte sur la couleur tertiaire (si utilisé)
          tertiary: Color(0xffeaeaea) // Une couleur tertiaire pour ajouter de la diversité
      ),
      textTheme: _customTextTheme(base.textTheme),
    );
  }
}

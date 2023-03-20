import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: GoogleFonts.montserrat(
      color: Colors.black87,
      fontWeight: FontWeight.w900,
      fontSize: 30,
    ),
    headlineMedium: GoogleFonts.montserrat(
      color: Colors.black87,
      fontWeight: FontWeight.w900,
      fontSize: 26,
    ),
    headlineSmall: GoogleFonts.montserrat(
      color: Colors.black87,
      fontWeight: FontWeight.w900,
      fontSize: 24,
    ),
    titleLarge: GoogleFonts.poppins(
      color: Colors.black54,
      fontSize: 24,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: GoogleFonts.poppins(
      color: Colors.black54,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.poppins(
      color: Colors.black54,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: GoogleFonts.montserrat(
      color: Colors.black45,
      fontWeight: FontWeight.w400,
      fontSize: 18,
    ),
    bodyMedium: GoogleFonts.montserrat(
      color: Colors.black45,
      fontWeight: FontWeight.w400,
      fontSize: 16,
    ),
    bodySmall: GoogleFonts.montserrat(
      color: Colors.black45,
      fontWeight: FontWeight.w400,
      fontSize: 12,
    ),
  );
  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: GoogleFonts.montserrat(
      color: Colors.white70,
      fontWeight: FontWeight.w900,
      fontSize: 30,
    ),
    headlineMedium: GoogleFonts.montserrat(
      color: Colors.white70,
      fontWeight: FontWeight.w900,
      fontSize: 26,
    ),
    headlineSmall: GoogleFonts.montserrat(
      color: Colors.white70,
      fontWeight: FontWeight.w900,
      fontSize: 24,
    ),
    titleLarge: GoogleFonts.poppins(
      color: Colors.white60,
      fontSize: 24,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: GoogleFonts.poppins(
      color: Colors.white60,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.poppins(
      color: Colors.white60,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: GoogleFonts.montserrat(
      color: Colors.white30,
      fontWeight: FontWeight.w400,
      fontSize: 18,
    ),
    bodyMedium: GoogleFonts.montserrat(
      color: Colors.white30,
      fontWeight: FontWeight.w400,
      fontSize: 16,
    ),
    bodySmall: GoogleFonts.montserrat(
      color: Colors.white30,
      fontWeight: FontWeight.w400,
      fontSize: 12,
    ),
  );
}

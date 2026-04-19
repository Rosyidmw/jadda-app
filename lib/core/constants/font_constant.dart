import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontConstant {
  static const FontWeight reguler = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  static TextStyle h1 = GoogleFonts.poppins(fontSize: 24, fontWeight: bold);

  static TextStyle h2 = GoogleFonts.poppins(fontSize: 20, fontWeight: semiBold);

  static TextStyle h3 = GoogleFonts.poppins(fontSize: 18, fontWeight: semiBold);

  static TextStyle body = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: reguler,
  );

  static TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: reguler,
  );

  static TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: reguler,
  );

  static TextStyle caption = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: medium,
  );

  static TextStyle button = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: semiBold,
  );
}

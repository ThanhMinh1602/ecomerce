import 'package:ecomerce/core/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {
  AppStyle._();

  // --- Title (Size 32.0) ---
  static TextStyle titleBold = GoogleFonts.robotoSerif(
    fontSize: 32.0,
    fontWeight: FontWeight.w700,
    color: AppColor.black500,
  );
  static TextStyle titleSemiBold = GoogleFonts.robotoSerif(
    fontSize: 32.0,
    fontWeight: FontWeight.w600,
  );
  static TextStyle titleMedium = GoogleFonts.robotoSerif(
    fontSize: 32.0,
    fontWeight: FontWeight.w500,
  );
  static TextStyle titleRegular = GoogleFonts.robotoSerif(
    fontSize: 32.0,
    fontWeight: FontWeight.w400,
  );

  // --- Content (Size 24.0) - Mới thêm --- [cite: 2026-03-03]
  static TextStyle contentBold = GoogleFonts.roboto(
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    color: AppColor.black500,
  );
  static TextStyle contentSemiBold = GoogleFonts.roboto(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
  );
  static TextStyle contentMedium = GoogleFonts.roboto(
    fontSize: 24.0,
    fontWeight: FontWeight.w500,
  );
  static TextStyle contentRegular = GoogleFonts.roboto(
    fontSize: 24.0,
    fontWeight: FontWeight.w400,
  );

  // --- SmallContent (Size 16.0) ---
  static TextStyle smallContentBold = GoogleFonts.roboto(
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
  );
  static TextStyle smallContentSemiBold = GoogleFonts.roboto(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
  );
  static TextStyle smallContentMedium = GoogleFonts.roboto(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  );
  static TextStyle smallContentRegular = GoogleFonts.roboto(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColor.k949494,
  );
}
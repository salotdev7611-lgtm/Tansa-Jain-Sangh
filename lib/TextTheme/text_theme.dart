import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

extension AppTextTheme on TextTheme{

  TextStyle get headingMain => GoogleFonts.koHo(
    fontSize: 50.px,
    fontWeight: FontWeight.w700,
  );

  TextStyle get headingBold => GoogleFonts.nunito(
    fontSize: 22.px,
    fontWeight: FontWeight.w700,
  );

  TextStyle get headingSemiBold => GoogleFonts.nunito(
    fontSize: 20.px,
    fontWeight: FontWeight.w600,
  );

  TextStyle get headingRegular => GoogleFonts.nunito(
    fontSize: 20.px,
    fontWeight: FontWeight.w400,
  );

  TextStyle get bodyBold => GoogleFonts.nunito(
    fontSize: 16.px,
    fontWeight: FontWeight.w700,
  );

  TextStyle get bodySemiBold => GoogleFonts.nunito(
    fontSize: 16.px,
    fontWeight: FontWeight.w600,
  );

  TextStyle get bodyRegular => GoogleFonts.nunito(
    fontSize: 16.px,
    fontWeight: FontWeight.w400,
  );

  TextStyle get bodyLight => GoogleFonts.nunito(
    fontSize: 16.px,
    fontWeight: FontWeight.w300,
  );

  TextStyle get body1Bold => GoogleFonts.nunito(
    fontSize: 14.px,
    fontWeight: FontWeight.w700,
  );

  TextStyle get body1SemiBold => GoogleFonts.nunito(
    fontSize: 14.px,
    fontWeight: FontWeight.w600,
  );

  TextStyle get body1Regular => GoogleFonts.nunito(
    fontSize: 14.px,
    fontWeight: FontWeight.w400,
  );

  TextStyle get body1Light => GoogleFonts.nunito(
    fontSize: 14.px,
    fontWeight: FontWeight.w300,
  );

  TextStyle get body2Bold => GoogleFonts.nunito(
    fontSize: 12.px,
    fontWeight: FontWeight.w700,
  );

  TextStyle get body2SemiBold => GoogleFonts.nunito(
    fontSize: 12.px,
    fontWeight: FontWeight.w600,
  );

  TextStyle get body2Regular => GoogleFonts.nunito(
    fontSize: 12.px,
    fontWeight: FontWeight.w400,
  );

  TextStyle get body2Light => GoogleFonts.nunito(
    fontSize: 12.px,
    fontWeight: FontWeight.w300,
  );

  TextStyle get body3Bold => GoogleFonts.nunito(
    fontSize: 10.px,
    fontWeight: FontWeight.w700,
  );

  TextStyle get body3SemiBold => GoogleFonts.nunito(
    fontSize: 10.px,
    fontWeight: FontWeight.w600,
  );

  TextStyle get body3Regular => GoogleFonts.nunito(
    fontSize: 10.px,
    fontWeight: FontWeight.w400,
  );

  TextStyle get body3Light => GoogleFonts.nunito(
    fontSize: 10.px,
    fontWeight: FontWeight.w300,
  );

  TextStyle get body4Bold => GoogleFonts.nunito(
    fontSize: 8.px,
    fontWeight: FontWeight.w700,
  );

  TextStyle get body4SemiBold => GoogleFonts.nunito(
    fontSize: 8.px,
    fontWeight: FontWeight.w600,
  );

  TextStyle get body4Regular => GoogleFonts.nunito(
    fontSize: 8.px,
    fontWeight: FontWeight.w400,
  );

  TextStyle get body4Light => GoogleFonts.nunito(
    fontSize: 8.px,
    fontWeight: FontWeight.w300,
  );
}
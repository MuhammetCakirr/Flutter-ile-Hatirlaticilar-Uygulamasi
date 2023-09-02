import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishClr=Color.fromARGB(255, 58, 151, 244);
const primaryclr=bluishClr;
Color darkHeaderClr=Color(0xFF424242);
const Color darkGreyClr=Color(0xFF121212);

class Themes{
  static final light =ThemeData(
  backgroundColor: Colors.white,
  primaryColor: primaryclr, //appbarı değiştiriyor
  brightness: Brightness.light  //backgroundu değiştirir
  );

  static final dark =ThemeData(
      backgroundColor:darkGreyClr,
      primaryColor: darkGreyClr, //appbarı değiştiriyor
      brightness: Brightness.dark //backgroundu değiştirir
  );
}

TextStyle get subHeadingStyle{
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode?Colors.grey[400]:Colors.grey
    )
  );
}

TextStyle get HeadingStyle{
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode?Colors.white:Colors.black
    )
  );
}

TextStyle get titleStyle{
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode?Colors.white:Colors.black
    )
  );
}

TextStyle get subtitleStyle{
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode?Colors.grey[100]:Colors.grey[600]
    )
  );
}
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color.fromRGBO(255, 90, 22, 1);
   static const Color appBlack = Color.fromRGBO(18, 18, 18, 1);
  static const Color buttonGrey = Color.fromRGBO(231, 234, 240, 1);
  static const Color buttonGreyLight = Color.fromRGBO(243, 244, 247, 1);
  static const Color textGrey = Color.fromRGBO(102, 102, 102, 1);
  static const Color textBlack = Color.fromRGBO(34, 34, 34, 1);
  static const Color subtitletextGreyLight = Color.fromRGBO(85, 85, 85, 1);
  static const Color subtitletextGreyDark = Color.fromRGBO(160, 160, 160, 1);
  static const Color textGrey2 = Color.fromRGBO(187, 187, 187, 1);
  static const Color green = Color.fromRGBO(0, 135, 83, 1);
  static const Color red = Color.fromRGBO(206, 3, 3, 1);
  static const Color bottomBarGrey = Color.fromRGBO(136, 136, 136, 1);
  static const Color borderGrey = Color(0xFFE5E7EB);
  static const Color white = Colors.white;
  static const Color grey = Color.fromRGBO(102, 102, 102, 1);
  static const borDerColor = Color.fromRGBO(231, 234, 240, 1); 

    static const Color appDarkGrey = Color.fromRGBO(46, 46, 46, 1);
    static const Color appLightGrey = Color.fromRGBO(226, 232, 240, 1);


}

class TextFieldColors {
  static const borDerColor = Color.fromRGBO(231, 234, 240, 1);
}

//salas

checkIfPalindrome(String word) {
  for (int i = 0; i < word.length; i++) {
    if (word[i] != word[word.length - i - 1]) {
      return false;
    }
  }
  return true;
}

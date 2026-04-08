import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenUtils {
  static bool isTokenExpired(String token, {bool isRefreshToken = false}) {
    try {
      if (token.isEmpty) return true;
      final value = getTokenExpirationDate(token);
      
      print(" ${isRefreshToken ? 'Refresh' : 'Access'} token expiration time is $value");
      return JwtDecoder.isExpired(token);
    } catch (e) {
      return true; // If there's any error decoding, consider it expired
    }
  }

  static Map<String, dynamic>? decodeToken(String token) {
    try {
      if (token.isEmpty) return null;
      return JwtDecoder.decode(token);
    } catch (e) {
      return null;
    }
  }

  static DateTime? getTokenExpirationDate(String token) {
    try {
      if (token.isEmpty) return null;
      return JwtDecoder.getExpirationDate(token);
    } catch (e) {
      return null;
    }
  }
}



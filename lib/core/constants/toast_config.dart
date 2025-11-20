import 'package:flutter/material.dart';

class ToastConfig {
  static const defaultPosition = ToastPosition.bottom;
  static const defaultDuration = Duration(seconds: 4);
  static const longDuration = Duration(seconds: 5);

  static const errorBackground = Color(0xFFDC3545);
  static const successBackground = Color(0xFF198754);
  static const infoBackground = Color(0xFF0DCAF0);
  static const warningBackground = Color(0xFFFFC107);

  // Private constructor to prevent instantiation
  ToastConfig._();
}

enum ToastPosition {
  top,
  center,
  bottom,
}
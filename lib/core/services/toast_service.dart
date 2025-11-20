import 'package:diet_lenz/core/constants/toast_config.dart';
import 'package:diet_lenz/core/services/message_service.dart';
import 'package:diet_lenz/core/utils/error_handler.dart';
import 'package:diet_lenz/core/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oktoast/oktoast.dart';

class ToastService implements MessageService {
  void _showToast(
    dynamic message, {
    required Color backgroundColor,
    Color textColor = Colors.white,
    IconData? icon,
    Duration? duration,
  }) {
    showToastWidget(
      CustomToast(
        message: ErrorHandler.getErrorMessage(message),
        backgroundColor: backgroundColor,
        textColor: textColor,
        icon: icon,
      ),
      // position: ToastPosition,
      duration: duration ?? ToastConfig.defaultDuration,
      // dismissOtherOnShow: true,
    );
  }

  @override
  void showError(dynamic message) {
    _showToast(
      message,
      backgroundColor: ToastConfig.errorBackground,
      icon: Icons.error_outline,
      duration: ToastConfig.longDuration,
    );
  }

  @override
  void showSuccess(String message) {
    _showToast(
      message,
      backgroundColor: ToastConfig.successBackground,
      icon: Icons.check_circle_outline,
    );
  }

  @override
  void showInfo(String message) {
    _showToast(
      message,
      backgroundColor: ToastConfig.infoBackground,
      icon: Icons.info_outline,
    );
  }

  @override
  void showWarning(String message) {
    _showToast(
      message,
      backgroundColor: ToastConfig.warningBackground,
      textColor: Colors.black87,
      icon: Icons.warning_amber_rounded,
    );
  }
}

final messageServiceProvider = Provider<MessageService>((ref) {
  return ToastService();
});

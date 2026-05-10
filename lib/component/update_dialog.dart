import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

/// Custom update alert dialog that matches the app's dark theme.
///
/// Wraps [UpgradeAlert] and overrides its dialog builder to render
/// the app's branded blurred-background style dialog.
class AppUpdateAlert extends StatelessWidget {
  final Widget child;
  final Upgrader? upgrader;

  const AppUpdateAlert({
    super.key,
    required this.child,
    this.upgrader,
  });

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: upgrader ?? Upgrader(),
      dialogStyle: UpgradeDialogStyle.material,
      barrierDismissible: false,
      child: child,
    );
  }
}

import 'package:diet_lenz/core/providers/storage_providers.dart';
import 'package:diet_lenz/core/services/biometric_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService();
});

/// Reads whether biometric login is currently enabled from local storage.
final biometricEnabledProvider = Provider<bool>((ref) {
  final repo = ref.watch(storageRepositoryProvider);
  return repo.isBiometricEnabled();
});

/// Notifier for toggling biometric enabled state.
final biometricEnabledNotifierProvider =
    NotifierProvider<BiometricEnabledNotifier, bool>(
        BiometricEnabledNotifier.new);

class BiometricEnabledNotifier extends Notifier<bool> {
  @override
  bool build() {
    final repo = ref.watch(storageRepositoryProvider);
    return repo.isBiometricEnabled();
  }

  Future<void> setEnabled(bool value) async {
    final repo = ref.read(storageRepositoryProvider);
    await repo.setBiometricEnabled(value);
    state = value;
  }
}

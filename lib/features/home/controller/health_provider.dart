import 'package:diet_lenz/data/models/health_ui_state.dart';
import 'package:diet_lenz/data/repositories/health_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for HealthRepository
final healthRepositoryProvider = Provider<HealthRepository>((ref) {
  return HealthRepository();
});

// StateNotifier for Health Data Management
class HealthNotifier extends StateNotifier<HealthUiState> {
  final HealthRepository _repository;

  HealthNotifier(this._repository) : super(const HealthUiState()) {
    _initialize();
  }

  /// Initialize - check availability and permissions
  Future<void> _initialize() async {
    // Check if Health Connect is available
    final isAvailable = await _repository.isHealthAvailable();

    if (!isAvailable) {
      state = state.copyWith(status: HealthStatus.unavailable);
      return;
    }

    // Check permissions
    await checkPermissions();
  }

  /// Check if permissions are granted
  Future<void> checkPermissions() async {
    final hasPerms = await _repository.hasPermissions();

    if (hasPerms) {
      await loadHealthData();
    } else {
      state = state.copyWith(status: HealthStatus.noPermissions);
    }
  }

  /// Request health permissions
  Future<bool> requestPermissions() async {
    final granted = await _repository.requestPermissions();

    if (granted) {
      await loadHealthData();
    } else {
      state = state.copyWith(status: HealthStatus.noPermissions);
    }

    return granted;
  }

  /// Load health data based on time range
  Future<void> loadHealthData([TimeRange timeRange = TimeRange.daily]) async {
    state = state.copyWith(status: HealthStatus.loading);

    try {
      final healthData = await _repository.fetchHealthData(timeRange);
      state = state.copyWith(
        status: HealthStatus.loaded,
        healthData: healthData,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: HealthStatus.error,
        errorMessage: 'Failed to load health data: $e',
      );
    }
  }

  /// Refresh health data with specific time range
  Future<void> refresh([TimeRange timeRange = TimeRange.daily]) =>
      loadHealthData(timeRange);
}

// Provider for HealthNotifier
final healthProvider =
    StateNotifierProvider<HealthNotifier, HealthUiState>((ref) {
  final repository = ref.watch(healthRepositoryProvider);
  return HealthNotifier(repository);
});

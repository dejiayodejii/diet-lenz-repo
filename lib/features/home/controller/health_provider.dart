import 'dart:io';

import 'package:diet_lenz/core/providers/storage_providers.dart';
import 'package:diet_lenz/core/repositories/storage_repository.dart';
import 'package:diet_lenz/data/models/health_ui_state.dart';
import 'package:diet_lenz/data/repositories/health_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for HealthRepository
final healthRepositoryProvider = Provider<HealthRepository>((ref) {
  return HealthRepository();
});

// StateNotifier for Health Data Management
class HealthNotifier extends StateNotifier<HealthUiState> {
  final HealthRepository _repository;
  final StorageRepository _storageRepository;

  HealthNotifier(this._repository, this._storageRepository)
      : super(const HealthUiState()) {
    if (Platform.isIOS) {
      _initialize();
    } else {
      state = state.copyWith(status: HealthStatus.unavailable);
    }
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
      _storageRepository.setHealthPermissionGranted(true);
      await loadHealthData();
      return;
    }

    // If hasPermissions returned false but we previously granted permissions,
    // try loading data anyway (Health().hasPermissions is unreliable on Android)
    if (_storageRepository.getHealthPermissionGranted()) {
      debugPrint(
          'Health: hasPermissions returned false but previously granted — trying to load data');
      try {
        await loadHealthData();
        return;
      } catch (_) {
        // Data load failed, permissions truly revoked — clear stored state
        _storageRepository.setHealthPermissionGranted(false);
      }
    }

    state = state.copyWith(status: HealthStatus.noPermissions);
  }

  /// Request health permissions
  Future<bool> requestPermissions() async {
    final granted = await _repository.requestPermissions();

    if (granted) {
      _storageRepository.setHealthPermissionGranted(true);
      await loadHealthData();
    } else {
      state = state.copyWith(status: HealthStatus.noPermissions);
    }

    return granted;
  }

  /// Load health data based on time range
  Future<void> loadHealthData([TimeRange timeRange = TimeRange.daily]) async {
    // Only show loading shimmer on initial load; keep existing data visible on tab switch
    if (state.status != HealthStatus.loaded) {
      state = state.copyWith(status: HealthStatus.loading);
    }

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
  final storageRepository = ref.watch(storageRepositoryProvider);
  return HealthNotifier(repository, storageRepository);
});

import 'package:diet_lenz/data/models/health_data.dart';

enum HealthStatus {
  initial,
  loading,
  loaded,
  error,
  noPermissions,
  unavailable
}

class HealthUiState {
  final HealthData healthData;
  final HealthStatus status;
  final String? errorMessage;

  const HealthUiState({
    this.healthData = const HealthData(),
    this.status = HealthStatus.initial,
    this.errorMessage,
  });

  bool get isLoading => status == HealthStatus.loading;
  bool get hasError => status == HealthStatus.error;
  bool get needsPermissions => status == HealthStatus.noPermissions;
  bool get isUnavailable => status == HealthStatus.unavailable;
  bool get hasData => status == HealthStatus.loaded;

  HealthUiState copyWith({
    HealthData? healthData,
    HealthStatus? status,
    String? errorMessage,
  }) {
    return HealthUiState(
      healthData: healthData ?? this.healthData,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

import 'package:diet_lenz/core/exceptions/app_exceptions.dart';

class Result<T> {
  final T? data;
  final AppException? error;
  final bool isSuccess;

  Result._({
    this.data,
    this.error,
    required this.isSuccess,
  });

  factory Result.success(T data) {
    return Result._(data: data, isSuccess: true);
  }

  factory Result.failure(AppException error) {
    return Result._(error: error, isSuccess: false);
  }

  bool get isFailure => !isSuccess;

  R when<R>({
    required R Function(T data) success,
    required R Function(AppException error) failure,
  }) {
    if (isSuccess) {
      return success(data as T);
    } else {
      return failure(error!);
    }
  }
}

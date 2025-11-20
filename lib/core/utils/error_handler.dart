import 'package:diet_lenz/core/exceptions/app_exceptions.dart';

class ErrorHandler {
  static String getErrorMessage( dynamic error) {

    if(error is AppException){
          if (error is NetworkException) {
      return _handleNetworkError(error);
    } else if (error is DataException) {
      return _handleDataError(error);
    }
    return error.message;

    }else{
      return error.toString();
    }

  }

  static String _handleNetworkError(NetworkException error) {
    if (error is UnauthorizedException) {
      return 'Session expired. Please login again.';
    } else if (error is ServerException) {
      return 'Server error occurred. Please try again later.';
    }
    return error.message;
  }



  static String _handleDataError(DataException error) {
    if (error is CacheException) {
      return 'Failed to save data locally. Please try again.';
    }
    return error.message;
  }
}

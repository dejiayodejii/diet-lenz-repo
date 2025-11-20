// ignore_for_file: public_member_api_docs, sort_constructors_first
class BaseResponse {
  bool? error;
  String? message;
  dynamic data;
  dynamic html;

  BaseResponse({this.data, this.message, this.error, this.html});

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
      error: json['error'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] ?? {},
      html: json);

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['error'] = error;
    data['message'] = message;
    data['data'] = this.data;
    return data;
  }

  @override
  String toString() {
    return message ?? 'An error occurred';
    
  }
}

class ApiResponse<T> {
  ApiResponse({
    this.data,
    this.message,
    required this.error,
  });

  T? data;
  String? message;
  bool? error;

  @override
  String toString() => '$message';
}

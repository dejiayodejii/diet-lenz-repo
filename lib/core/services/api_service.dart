// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:io';

// class ApiService {
//   final String baseUrl;
//   final Map<String, String> defaultHeaders;

//   ApiService({
//     required this.baseUrl,
//     this.defaultHeaders = const {
//       'Content-Type': 'application/json',
//     },
//   });

//   Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
//     final response = await http.get(
//       Uri.parse('$baseUrl$endpoint'),
//       headers: {...defaultHeaders, ...?headers},
//     );
//     return _handleResponse(response);
//   }

//   Future<dynamic> post(
//     String endpoint, {
//     Map<String, String>? headers,
//     dynamic body,
//   }) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl$endpoint'),
//       headers: {...defaultHeaders, ...?headers},
//       body: jsonEncode(body),
//     );
//     return _handleResponse(response);
//   }

//   Future<dynamic> put(
//     String endpoint, {
//     Map<String, String>? headers,
//     dynamic body,
//   }) async {
//     final response = await http.put(
//       Uri.parse('$baseUrl$endpoint'),
//       headers: {...defaultHeaders, ...?headers},
//       body: jsonEncode(body),
//     );
//     return _handleResponse(response);
//   }

//   Future<dynamic> delete(String endpoint,
//       {Map<String, String>? headers}) async {
//     final response = await http.delete(
//       Uri.parse('$baseUrl$endpoint'),
//       headers: {...defaultHeaders, ...?headers},
//     );
//     return _handleResponse(response);
//   }

//   dynamic _handleResponse(http.Response response) {
//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       return jsonDecode(response.body);
//     } else {
//       throw HttpException(
//         response.body,
//         uri: response.request?.url,
//         statusCode: response.statusCode,
//       );
//     }
//   }
// }

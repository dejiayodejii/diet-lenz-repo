// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:diet_lenz/data/network/base_response.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// abstract class CardRepo {
//   Future<ApiResponse<BaseResponse>> createCard({
//     required Map<String, dynamic> data,
//   });

//   Future<ApiResponse<BaseResponse>> getCreateCardDetails({
//     required Map<String, dynamic> data,
//   });
//   Future<ApiResponse<BaseResponse>> getCard(
//       {Map<String, dynamic> data = const {}});

//   Future<ApiResponse<BaseResponse>> deleteCard({
//     required Map<String, dynamic> data,
//   });

//   Future<ApiResponse<BaseResponse>> changeCardPin({
//     required Map<String, dynamic> data,
//   });
//   Future<ApiResponse<BaseResponse>> getCardTransaction({
//     required Map<String, dynamic> data,
//     String? nextPageUrl,
//   });

//   Future<ApiResponse<BaseResponse>> getCardBalance({
//     required Map<String, dynamic> data,
//   });

//   Future<ApiResponse<BaseResponse>> cardFunding({
//     required Map<String, dynamic> data,
//   });

//   Future<ApiResponse<BaseResponse>> cardFundingDetails(
//       {required Map<String, dynamic> data, bool isWithrawal = false});

//   Future<ApiResponse<BaseResponse>> cardWithdrawal({
//     required Map<String, dynamic> data,
//   });

//   Future<ApiResponse<BaseResponse>> cardWithdrawalDetails({
//     required Map<String, dynamic> data,
//   });

//   Future<ApiResponse<BaseResponse>> freezeUnfreezeCard(
//       {required Map<String, dynamic> data, bool isFreeze = false});

//   Future<ApiResponse<BaseResponse>> getReferrals({
 
//     String? nextPageUrl,
//   });
// }

// class CardRepoImpl extends CardRepo {
//   final NetworkProvider _networkProvider;
//   CardRepoImpl(
//     this._networkProvider,
//   );

//   @override
//   Future<ApiResponse<BaseResponse>> createCard({
//     required Map<String, dynamic> data,
//   }) async {
//     try {
//       final result = await _networkProvider.call(
//         path: AppEndpoint.createCard,
//         method: RequestMethod.post,
//         body: data,
//       );
//       if (result is ApiError) {
//         return ApiResponse(message: result.errorMessage, error: true);
//       }
//       var data2 = BaseResponse.fromJson(result);
//       return ApiResponse(message: data2.message, error: false, data: data2);
//     } catch (e) {
//       print('error is ${e.toString()}');
//       return ApiResponse(message: 'An error occured', error: true);
//     }
//   }

//   @override
//   Future<ApiResponse<BaseResponse>> cardFunding(
//       {required Map<String, dynamic> data, bool isWithdrawal = false}) async {
//     try {
//       final result = await _networkProvider.call(
//         path: isWithdrawal
//             ? AppEndpoint.getCardWithdrawDetails
//             : AppEndpoint.getCardFundingDetails,
//         method: RequestMethod.post,
//         body: data,
//       );
//       if (result is ApiError) {
//         return ApiResponse(message: result.errorMessage, error: true);
//       }
//       var data2 = BaseResponse.fromJson(result);
//       return ApiResponse(message: data2.message, error: false, data: data2);
//     } catch (e) {
//       return ApiResponse(message: 'An error occured', error: true);
//     }
//   }

//   @override
//   Future<ApiResponse<BaseResponse>> cardFundingDetails(
//       {required Map<String, dynamic> data, bool isWithrawal = false}) async {
//     try {
//       final result = await _networkProvider.call(
//         path: isWithrawal
//             ? AppEndpoint.getCardWithdrawDetails
//             : AppEndpoint.getCardFundingDetails,
//         method: RequestMethod.get,
//         queryParams: data,
//       );
//       if (result is ApiError) {
//         return ApiResponse(message: result.errorMessage, error: true);
//       }
//       var data2 = BaseResponse.fromJson(result);
//       return ApiResponse(message: data2.message, error: false, data: data2);
//     } catch (e) {
//       print('error is ${e.toString()}');
//       return ApiResponse(message: 'An error occured', error: true);
//     }
//   }

//   @override
//   Future<ApiResponse<BaseResponse>> cardWithdrawal(
//       {required Map<String, dynamic> data}) {
//     // TODO: implement cardWithdrawal
//     throw UnimplementedError();
//   }

//   @override
//   Future<ApiResponse<BaseResponse>> cardWithdrawalDetails(
//       {required Map<String, dynamic> data}) {
//     // TODO: implement cardWithdrawalDetails
//     throw UnimplementedError();
//   }

//   @override
//   Future<ApiResponse<BaseResponse>> getCard(
//       {Map<String, dynamic> data = const {}}) async {
//     try {
//       final result = await _networkProvider.call(
//           path: AppEndpoint.getCard,
//           method: RequestMethod.get,
//           queryParams: data);
//       if (result is ApiError) {
//         return ApiResponse(message: result.errorMessage, error: true);
//       }
//       var data2 = BaseResponse.fromJson(result);
//       return ApiResponse(message: data2.message, error: false, data: data2);
//     } catch (e) {
//       print('error is ${e.toString()}');
//       return ApiResponse(message: 'An error occured', error: true);
//     }
//   }

//   @override
//   Future<ApiResponse<BaseResponse>> changeCardPin(
//       {required Map<String, dynamic> data}) async {
//     try {
//       final result = await _networkProvider.call(
//           path: AppEndpoint.changeCardPin,
//           method: RequestMethod.patch,
//           body: data);
//       if (result is ApiError) {
//         return ApiResponse(message: result.errorMessage, error: true);
//       }
//       var data2 = BaseResponse.fromJson(result);
//       return ApiResponse(message: data2.message, error: false, data: data2);
//     } catch (e) {
//       print('error is ${e.toString()}');
//       return ApiResponse(message: 'An error occured', error: true);
//     }
//   }

//   @override
//   Future<ApiResponse<BaseResponse>> getCardBalance(
//       {required Map<String, dynamic> data}) async {
//     try {
//       final result = await _networkProvider.call(
//           path: AppEndpoint.getCardBalance,
//           method: RequestMethod.get,
//           queryParams: data);
//       if (result is ApiError) {
//         return ApiResponse(message: result.errorMessage, error: true);
//       }
//       var data2 = BaseResponse.fromJson(result);
//       return ApiResponse(message: data2.message, error: false, data: data2);
//     } catch (e) {
//       return ApiResponse(message: 'An error occured', error: true);
//     }
//   }

//   @override
//   Future<ApiResponse<BaseResponse>> getCreateCardDetails(
//       {required Map<String, dynamic> data}) async {
//     try {
//       final result = await _networkProvider.call(
//         path: AppEndpoint.creationDetails,
//         method: RequestMethod.get,
//         queryParams: data,
//       );
//       if (result is ApiError) {
//         return ApiResponse(message: result.errorMessage, error: true);
//       }
//       var data2 = BaseResponse.fromJson(result);
//       return ApiResponse(message: data2.message, error: false, data: data2);
//     } catch (e) {
//       return ApiResponse(message: 'An error occured', error: true);
//     }
//   }

//   @override
//   Future<ApiResponse<BaseResponse>> deleteCard(
//       {required Map<String, dynamic> data}) async {
//     try {
//       final result = await _networkProvider.call(
//         path: AppEndpoint.deleteCards,
//         method: RequestMethod.delete,
//         body: data,
//       );
//       if (result is ApiError) {
//         return ApiResponse(message: result.errorMessage, error: true);
//       }
//       var data2 = BaseResponse.fromJson(result);
//       return ApiResponse(message: data2.message, error: false, data: data2);
//     } catch (e) {
//       return ApiResponse(message: 'An error occured', error: true);
//     }
//   }

//   @override
//   Future<ApiResponse<BaseResponse>> getCardTransaction({
//     required Map<String, dynamic> data,
//     String? nextPageUrl,
//   }) async {
//     try {
//       final result = await _networkProvider.call(
//         path: nextPageUrl ?? AppEndpoint.getCardTransactns,
//         method: RequestMethod.get,
//         queryParams: data,
//       );
//       if (result is ApiError) {
//         return ApiResponse(message: result.errorMessage, error: true);
//       }
//       var data2 = BaseResponse.fromJson(result);
//       return ApiResponse(message: data2.message, error: false, data: data2);
//     } catch (e) {
//       return ApiResponse(message: 'An error occured', error: true);
//     }
//   }

//   @override
//   Future<ApiResponse<BaseResponse>> freezeUnfreezeCard(
//       {required Map<String, dynamic> data, bool isFreeze = false}) async {
//     try {
//       final result = await _networkProvider.call(
//         path: isFreeze ? AppEndpoint.freezeCards : AppEndpoint.unfreezeCards,
//         method: RequestMethod.patch,
//         body: data,
//       );
//       if (result is ApiError) {
//         return ApiResponse(message: result.errorMessage, error: true);
//       }
//       var data2 = BaseResponse.fromJson(result);
//       return ApiResponse(message: data2.message, error: false, data: data2);
//     } catch (e) {
//       print('error is ${e.toString()}');
//       return ApiResponse(message: 'An error occured', error: true);
//     }
//   }

//   @override
//   Future<ApiResponse<BaseResponse>> getReferrals({

//     String? nextPageUrl,
//   }) async {
//     try {
//       final result = await _networkProvider.call(
//         path: nextPageUrl ?? AppEndpoint.referal,
//         method: RequestMethod.get,
//       );
//       if (result is ApiError) {
//         return ApiResponse(message: result.errorMessage, error: true);
//       }
//       var data2 = BaseResponse.fromJson(result);
//       return ApiResponse(message: data2.message, error: false, data: data2);
//     } catch (e) {
//       return ApiResponse(message: 'An error occured', error: true);
//     }
//   }
// }

// final cardRepoProvider = Provider((ref) => CardRepoImpl(
//       NetworkProviderImp(ref.watch(storageRepositoryProvider)),
//     ));

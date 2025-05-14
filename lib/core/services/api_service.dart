import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import '../models/voter_model.dart';

class ApiResponse<T> {
  final T? data;
  final String? errorMessage;
  final bool isSuccess;

  ApiResponse({this.data, this.errorMessage, required this.isSuccess});
}

class ApiService {
  Future<ApiResponse<VoterModel>> getVoterInfo(String voterId) async {
    // Check for connectivity first
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return ApiResponse(
          errorMessage: AppConstants.networkErrorMessage,
          isSuccess: false,
        );
      }

      final response = await http
          .get(
            Uri.parse(
              '${ApiConstants.baseUrl}${ApiConstants.voterEndpoint}$voterId',
            ),
            headers: {
              'Authorization': 'Bearer ${ApiConstants.apiKey}',
              'Content-Type': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException(
                'The connection has timed out, please try again later.',
              );
            },
          );

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        return ApiResponse(
          data: VoterModel.fromJson(responseData['data']),
          isSuccess: true,
        );
      } else if (response.statusCode == 404) {
        return ApiResponse(
          errorMessage: AppConstants.noVoterFoundMessage,
          isSuccess: false,
        );
      } else if (response.statusCode >= 500) {
        return ApiResponse(
          errorMessage: 'Server error. Please try again later.',
          isSuccess: false,
        );
      } else {
        return ApiResponse(
          errorMessage:
              responseData['message'] ?? AppConstants.generalErrorMessage,
          isSuccess: false,
        );
      }
    } on FormatException {
      return ApiResponse(
        errorMessage: 'Invalid response format from server',
        isSuccess: false,
      );
    } on TimeoutException {
      return ApiResponse(
        errorMessage:
            'Request timed out. Please check your connection and try again.',
        isSuccess: false,
      );
    } catch (e) {
      return ApiResponse(
        errorMessage: 'Error: ${e.toString()}',
        isSuccess: false,
      );
    }
  }
}

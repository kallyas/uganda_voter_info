import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/voter_model.dart';

class ApiResponse<T> {
  final T? data;
  final String? errorMessage;
  final bool isSuccess;

  ApiResponse({
    this.data,
    this.errorMessage,
    required this.isSuccess,
  });
}

class ApiService {
  Future<ApiResponse<VoterModel>> getVoterInfo(String voterId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.voterEndpoint}$voterId'),
        headers: {
          'Authorization': 'Bearer ${ApiConstants.apiKey}',
          'Content-Type': 'application/json',
        },
      );

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        return ApiResponse(
          data: VoterModel.fromJson(responseData['data']),
          isSuccess: true,
        );
      } else {
        return ApiResponse(
          errorMessage: responseData['message'] ?? 'Failed to fetch voter information',
          isSuccess: false,
        );
      }
    } catch (e) {
      return ApiResponse(
        errorMessage: 'Network error: ${e.toString()}',
        isSuccess: false,
      );
    }
  }
}

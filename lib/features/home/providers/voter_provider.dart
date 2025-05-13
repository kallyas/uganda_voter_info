// lib/features/home/providers/voter_provider.dart
import 'package:flutter/material.dart';
import '../../../core/models/voter_model.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/constants/app_constants.dart';

class VoterProvider extends ChangeNotifier {
  final StorageService _storageService;
  final ApiService _apiService = ApiService();
  
  VoterModel? _voter;
  String? _errorMessage;
  bool _isLoading = false;
  
  VoterProvider(this._storageService);
  
  VoterModel? get voter => _voter;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  
  Future<void> searchVoter(String voterId) async {
    _setLoading(true);
    _clearError();
    
    final response = await _apiService.getVoterInfo(voterId);
    
    if (response.isSuccess && response.data != null) {
      _voter = response.data;
      // Save to search history
      await _storageService.saveToHistory(_voter!);
      _setLoading(false);
    } else {
      _voter = null;
      _setError(response.errorMessage ?? AppConstants.noVoterFoundMessage);
      _setLoading(false);
    }
  }
  
  void setSelectedVoter(VoterModel voter) {
    _voter = voter;
    _clearError();
    notifyListeners();
  }
  
  // Public method to clear error state
  void clearError() {
    _clearError();
  }
  
  // Get search history from storage service
  List<VoterModel> getSearchHistory() {
    return _storageService.getSearchHistory();
  }
  
  // Clear search history
  Future<bool> clearSearchHistory() async {
    final result = await _storageService.clearHistory();
    notifyListeners();
    return result;
  }
  
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
  
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
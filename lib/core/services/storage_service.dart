import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/voter_model.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<bool> saveToHistory(VoterModel voter) async {
    try {
      final List<String> history = _prefs.getStringList(AppConstants.searchHistoryKey) ?? [];
      
      // Convert the voter model to JSON string
      final String voterJson = jsonEncode(voter.toJson());
      
      // Add to history if it doesn't exist already
      if (!history.contains(voterJson)) {
        history.add(voterJson);
        await _prefs.setStringList(AppConstants.searchHistoryKey, history);
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  List<VoterModel> getSearchHistory() {
    try {
      final List<String> history = _prefs.getStringList(AppConstants.searchHistoryKey) ?? [];
      
      return history.map((String voterJson) {
        final Map<String, dynamic> voterMap = jsonDecode(voterJson);
        return VoterModel.fromJson(voterMap);
      }).toList()
        ..sort((a, b) => b.searchedAt.compareTo(a.searchedAt)); // Sort by most recent first
      
    } catch (e) {
      return [];
    }
  }

  Future<bool> clearHistory() async {
    try {
      await _prefs.remove(AppConstants.searchHistoryKey);
      return true;
    } catch (e) {
      return false;
    }
  }
}
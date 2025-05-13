class VoterModel {
  final String names;
  final String dateOfBirth;
  final String gender;
  final String voterIdentificationNumber;
  final String village;
  final String district;
  final String electoralArea;
  final String subCounty;
  final String parish;
  final String pollingStation;
  final DateTime searchedAt;

  VoterModel({
    required this.names,
    required this.dateOfBirth,
    required this.gender,
    required this.voterIdentificationNumber,
    required this.village,
    required this.district,
    required this.electoralArea,
    required this.subCounty,
    required this.parish,
    required this.pollingStation,
    DateTime? searchedAt,
  }) : searchedAt = searchedAt ?? DateTime.now();

  factory VoterModel.fromJson(Map<String, dynamic> json) {
    return VoterModel(
      names: json['names'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      gender: json['gender'] ?? '',
      voterIdentificationNumber: json['voterIdentificationNumber'] ?? '',
      village: json['village'] ?? '',
      district: json['district'] ?? '',
      electoralArea: json['electoralArea'] ?? '',
      subCounty: json['subCounty'] ?? '',
      parish: json['parish'] ?? '',
      pollingStation: json['pollingStation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'names': names,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'voterIdentificationNumber': voterIdentificationNumber,
      'village': village,
      'district': district,
      'electoralArea': electoralArea,
      'subCounty': subCounty,
      'parish': parish,
      'pollingStation': pollingStation,
      'searchedAt': searchedAt.toIso8601String(),
    };
  }
}
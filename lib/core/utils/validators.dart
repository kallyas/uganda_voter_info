class Validators {
  static bool isValidVoterId(String id) {
    // Basic validation for voter ID
    // nin_regex = r'^C[F|M]\d{2}[0-9]{5}[A-Z0-9]{5}$'
    final RegExp regex = RegExp(r'^C[F|M]\d{2}[0-9]{5}[A-Z0-9]{5}$');
    return regex.hasMatch(id);
  }
}
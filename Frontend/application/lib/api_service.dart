import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl = "http://127.0.0.1:8000/api";

  Future<http.Response> checkUser(String nationalId, String phoneNumber) async {
    final Uri url = Uri.parse('$apiUrl/checkUser');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "NationalID": nationalId,
          "PhoneNumber": phoneNumber,
        }),
      );
      return response;
    } catch (e) {
      throw Exception("خطأ في الاتصال: $e");
    }
  }
}

import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static Future<bool> authenticate(String login, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.4:5000/api/authenticate'),
        body: {
          'login': login,
          'motdepasse': password,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Authentification failed with status code ${response}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}

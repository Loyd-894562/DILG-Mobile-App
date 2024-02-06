import 'dart:convert';
import '../Services/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  static Future<http.Response> login(String email, String password) async {
    try {
      Map data = {
        'email': email,
        'password': password,
      };
      var body = json.encode(data);
      var url = Uri.parse('${baseURL}auth/login');

      var token;
      http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          // Other headers if needed
          'Content-Type': 'application/json',
        },
        body: body,
      );

      print(response.body);

      if (response.statusCode == 200) {
        print("Hello World");
        return response;
      } else {
        print('Login failed with status code: ${response.statusCode}');
        return response;
      }
    } catch (error) {
      print('Error during login: $error');
      throw error;
    }
  }

  static Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  final url = Uri.parse('${baseURL}logout');
  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    // Successfully logged out
    // Clear local storage or perform other necessary tasks
  } else {
    print('Logout failed with status code: ${response.statusCode}');
  }
}

}

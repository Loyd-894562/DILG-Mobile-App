import 'dart:convert';

import '../Services/globals.dart';
import 'package:http/http.dart' as http;

class AuthServices{
 static Future<http.Response> login(String email, String password) async {
 
  
  try {
    Map data = {
      'email': email,
      'password': password,
    };
    var body = json.encode(data);
    var url = Uri.parse('${baseURL}auth/login');
    http.Response response = await http.post(
      url,
      headers: headers,
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

}

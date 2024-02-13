import 'dart:convert';
import 'package:DILGDOCS/Services/globals.dart';
import 'package:DILGDOCS/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/auth_services.dart';
import 'package:http/http.dart' as http; // Make sure to import your HomeScreen widget

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.title});

  final String title;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
   bool rememberMe = false;
  String emailError = '';
  String passwordError = '';
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLoggedIn(); // Check if user is already logged in when screen initializes
  }

  checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');

    if (authToken != null) {
      // If authToken exists, navigate to HomeScreen directly
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  loginPressed() async {
    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      try {
        http.Response response = await AuthServices.login(
          _emailController.text,
          _passwordController.text,
        );

        Map responseMap = jsonDecode(response.body);

        print("Server Response: $responseMap");

        if (response.statusCode == 200) {
          final token = responseMap['token'];

          // Store token locally
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('authToken', token);

          // Navigate to HomeScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          setState(() {
            emailError = '';
            passwordError = responseMap['message'] ?? 'Login failed';
          });
        }
      } catch (error, stackTrace) {
        print("Error during login: $error");
        print("Stack trace: $stackTrace");
        setState(() {
          emailError = '';
          passwordError = 'An error occurred during login';
        });
      }
    } else {
      setState(() {
        emailError = 'Enter your email';
        passwordError = 'Enter your password';
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 34,
                backgroundImage: AssetImage('assets/dilg-main.png'),
              ),
              SizedBox(height: 15),
              Text(
                'Department of the Interior and Local Government - Bohol Province',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromARGB(255, 0, 0, 255)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      'Sign in to your Account',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                  TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (_emailController) {
                        if (_emailController == null || _emailController.isEmpty) {
                          return 'Please enter your email';
                        }
                        // Add more complex email validation if needed
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        errorText:
                            passwordError.isNotEmpty ? passwordError : null,
                        
                      ),
                    
                     
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value!;
                            });
                          },
                        ),
                        Text('Remember Me'),
                        Spacer(),
                        
                           ElevatedButton(
                           onPressed: (){
                            loginPressed();
                          }, // Directly pass the function reference
                          child: Text('Log in'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14),
              Text(
                '© DILG-Bohol Province 2024',
                style: TextStyle(
                  fontSize: 10,
                  color: const Color.fromARGB(255, 6, 0, 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
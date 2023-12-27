import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdhesionPage extends StatefulWidget {
  @override
  _AdhesionPageState createState() => _AdhesionPageState();
}

class _AdhesionPageState extends State<AdhesionPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String errorMessage = '';
  String successMessage = '';

  Future<String> getToken() async {
    final String apiUrl = 'https://fo-atalian.kitra-consulting.fr/wp-json/jwt-auth/v1/token';

    // Replace 'your-username' with an actual WordPress username.
    final String username = 'fo_create_user';
    // Use the value of JWT_AUTH_SECRET_KEY as the password.
    final String password = 'nuWs 7k1j rKjV 0Nyw CGah vbDZ'; // Replace with the actual secret key.

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('data') && data['data'].containsKey('token')) {
          String token = data['data']['token'];
          return token;
        }

        throw Exception('Token not found in response data');
      } else {
        throw Exception('Failed to obtain JWT token. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error obtaining token: $error');
      throw Exception('An error occurred while obtaining the token. Please try again.');
    }
  }

  Future<void> createUser() async {
    try {
      final String token = await getToken();

      final String apiUrl = 'https://fo-atalian.kitra-consulting.fr/wp-json/wp/v2/users';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(
          <String, dynamic>{
            'first_name': firstNameController.text,
            'last_name': lastNameController.text,
            'username': usernameController.text,
            'email': emailController.text,
            'password': passwordController.text,
          'roles': ['demande_abonnement'], // Assign the 'demande_abonnement' role
          },
        ),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String message = responseData['message'] ?? 'User created successfully';
        print('User created successfully: $message');
        setState(() {
          successMessage = message;
          errorMessage = '';
        });
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String message = responseData['message'] ?? 'Failed to create user';
        print('Failed to create user. Error: ${response.statusCode}, Message: $message');
        setState(() {
          errorMessage = message;
          successMessage = '';
        });
      }
    } catch (error) {
      print('Error creating user: $error');
      setState(() {
        errorMessage = 'An error occurred. Please try again.';
        successMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adhésion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                createUser();
              },
              child: Text('Create User'),
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            if (successMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  successMessage,
                  style: TextStyle(color: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

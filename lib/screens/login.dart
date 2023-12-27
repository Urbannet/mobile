// login.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fo_proprete_atalian/screens/login_form.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fo_proprete_atalian/screens/espaces_prives.dart';
import 'package:jwt_decode/jwt_decode.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _usernameError = '';
  String _passwordError = '';
  bool _hasError = false;

  Future<void> _login(String username, String password, BuildContext context) async {
    if (_hasError) {
      // Réinitialisez l'état d'erreur uniquement si une erreur persiste
      setState(() {
        _usernameError = '';
        _passwordError = '';
        _hasError = false;
      });
    }

    final String endpoint = 'https://fo-atalian.kitra-consulting.fr/wp-json/jwt-auth/v1/token';

    final response = await http.post(
      Uri.parse(endpoint),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);


      print(data);

      if (data.containsKey('data') && data['data'].containsKey('token')) {
        String token 		= data['data']['token'];
        String firstName 	= data['data']['firstName'];
        String lastName 	= data['data']['lastName'];

        String role 	= '';
        if (data.containsKey('role')){
          role = data['role'];
        }

        final storage = FlutterSecureStorage();
        await storage.write(key: 'jwt_token', value: token);
        await storage.write(key: 'firstName', value: firstName);
        await storage.write(key: 'lastName', value: lastName);
        await storage.write(key: 'role', value: role);

        // print('Token: $token');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EspacesPrives()),
        );
      } else {
        _handleError('Réponse JSON invalide - La clé "token" est manquante.', '');
      }
    } else {

      // Logique de validation
      if (username.isEmpty) {
        setState(() {
          _usernameError = 'Identifiant obligatoire';
        });
      } else {
        setState(() {
          _usernameError = '';
        });
      }

      if (password.isEmpty) {
        setState(() {
          _passwordError = 'Mot de passe obligatoire';
        });
      } else {
        setState(() {
          _passwordError = '';
        });
      }

     _handleError(_usernameError, _passwordError);
      print('Corps de la réponse : ${response.body}');
    }
  }

  
  void _handleError(String usernameError, String passwordError) {
	  setState(() {
	    _usernameError = usernameError;
	    _passwordError = passwordError;
	    _hasError = true;
	  });
	
	  _showError('Échec de la connexion: Veuillez vérifier vos identifiants.');
  }


  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 204, 204, 1.0), // Couleur RGB
        title: Center(
          child: Image.asset(
            'assets/images/logo.png',
            width: 190.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: LoginForm(
          onSubmit: (username, password) => _login(username, password, context),
          usernameError: _usernameError,
          passwordError: _passwordError,
        ),
      ),
    );
  }
}

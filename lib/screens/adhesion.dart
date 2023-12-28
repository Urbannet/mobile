import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fo_proprete_atalian/widgets/appbar_custom.dart';
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

    final String username = 'fo_create_user';
    final String password = 'nuWs 7k1j rKjV 0Nyw CGah vbDZ';

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
    // Vérifier si les champs obligatoires sont vides
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      setState(() {
        errorMessage = 'Veuillez remplir tous les champs obligatoires.';
        successMessage = '';
      });
      print('Champs vides. Message d\'erreur : $errorMessage');
      return;
    }

    try {
      print('Tentative de création de l\'utilisateur...');
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
            'roles': ['demande_abonnement'],
          },
        ),
      );

      print('Réponse du serveur : ${response.statusCode}');
      print('Réponse du serveur : ${response.body}');

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String message = responseData['message'] ?? 'User created successfully';
        print('Utilisateur créé avec succès: $message');
        setState(() {
          successMessage = ''
              'Nous vous remercions chaleureusement pour avoir soumis votre demande d\'adhésion. \n'
              'Votre engagement contribue à renforcer notre communauté, et nous sommes honorés de vous accueillir parmi nous. \n'
              'Ensemble, nous poursuivrons notre mission commune en faveur des droits et des intérêts des travailleurs. \n'
              'Merci pour votre soutien précieux.'; // Message de remerciement
          errorMessage = '';
        });
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String message = responseData['message'] ?? 'Failed to create user';
        print('Échec de la création de l\'utilisateur. Erreur: ${response.statusCode}, Message: $message');
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
      appBar: CustomAppBar(),
      body: Container(
        color: Colors.red,
        child: Center(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.0),
                  if (successMessage.isEmpty)
                    Text(
                      'REMPLISSEZ LE FORMULAIRE D\'ADHÉSION',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  if (successMessage.isNotEmpty)
                    Text(
                      successMessage,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  SizedBox(height: 20.0),
                  if (successMessage.isEmpty)
                    Column(
                      children: [
                        TextField(
                          controller: firstNameController,
                          decoration: InputDecoration(
                            labelText: 'Prénom',
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        TextField(
                          controller: lastNameController,
                          decoration: InputDecoration(
                            labelText: 'Nom',
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            labelText: 'Identifiant',
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Mot de passe',
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontSize: 20.0,
                            ),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            createUser();
                          },
                          child: Text(
                            'Valider mon inscription',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontSize: 22.0,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        errorMessage,
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

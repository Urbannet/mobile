import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final Function(String, String) onSubmit;
  final String usernameError;
  final String passwordError;

  LoginForm({
    required this.onSubmit,
    required this.usernameError,
    required this.passwordError,
  });

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: 450.0,
      child: Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.symmetric(vertical: 10.0), // Ajustez cette valeur pour le positionnement vertical
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Align(
          alignment: Alignment.center,
          child: Column(
           // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Identifiant de connexion',
                  errorText: widget.usernameError.isNotEmpty ? widget.usernameError : null,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  errorText: widget.passwordError.isNotEmpty ? widget.passwordError : null,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                ),
                obscureText: true,
              ),
              SizedBox(height: 40),
              Container(
                width: 200, // Ajustez la largeur selon vos besoins
                height: 50, // Ajustez la hauteur selon vos besoins
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFF00000), Color(0xFFDC281E)],
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    String username = _usernameController.text.trim();
                    String password = _passwordController.text.trim();
                    widget.onSubmit(username, password);
                  },
                  child: Center(
                    child: Text(
                      'SE CONNECTER',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent, // Le fond du bouton est transparent
                    padding: EdgeInsets.all(0.0), // Ajustez l'espacement du texte par rapport au bouton
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}

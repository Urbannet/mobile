import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fo_proprete_atalian/screens/login.dart';
import 'package:fo_proprete_atalian/widgets/maintab.dart';
import 'package:fo_proprete_atalian/widgets/mydrawer.dart';
import 'package:fo_proprete_atalian/widgets/right_drawer_espace_prives.dart';

class EspacesPrives extends StatefulWidget {
  const EspacesPrives({Key? key}) : super(key: key);

  @override
  _EspacesPrivesState createState() => _EspacesPrivesState();
}

class _EspacesPrivesState extends State<EspacesPrives> {
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      // Vérifie si le token est présent dans le stockage sécurisé
      future: storage.read(key: 'jwt_token'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            // Le token est présent, affiche la page normalement
            return buildContent();
          } else {
            // Le token n'est pas présent, affiche la page de connexion
            return Login(); // Remplacez par votre widget LoginPage
          }
        } else {
          // Attend la fin de la vérification du token
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget buildContent() {
    return Scaffold(
        // title: Text('Espaces privés'),
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
      drawer: Container(
        child: MyDrawer(),
      ),
      endDrawer: Container(
        child: RightDrawerEspacePrives(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Je m\'appelle [Nom de l\'utilisateur]', // Remplacez par le nom de l'utilisateur
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Supprimer le token du stockage
                await storage.delete(key: 'jwt_token');

                // Actualiser la page
                setState(() {});
                
                // Rediriger vers MainTab()
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainTab()),
                );
                
                
              },
              child: Text('Se déconnecter'),
            ),
          ],
        ),
      ),
    );
  }
}

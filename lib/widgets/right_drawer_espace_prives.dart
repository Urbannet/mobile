import 'package:flutter/material.dart';
import 'package:fo_proprete_atalian/widgets/maintab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RightDrawerEspacePrives extends StatelessWidget {
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Accueil'),
            onTap: () {
              // Naviguez vers la page d'accueil ici
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainTab()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Se déconnecter'),
            onTap: () async {
              // Déconnexion ici
              await storage.delete(key: 'jwt_token');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainTab()),
              );
            },
          ),
          // Ajoutez d'autres éléments de tiroir selon vos besoins
        ],
      ),
    );
  }
}

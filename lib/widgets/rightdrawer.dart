import 'package:flutter/material.dart';

class RightDrawer extends StatelessWidget {
  @override


  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.home), // Icône spécifique au tiroir de gauche
            title: Text('Accueil'),
            onTap: () {
              // Ajoutez des actions pour cet élément du tiroir ici
            },
          ),
          ListTile(
            leading: Icon(Icons.category), // Icône spécifique au tiroir de gauche
            title: Text('Catégories'),
            onTap: () {
              // Ajoutez des actions pour cet élément du tiroir ici
            },
          ),
          // Ajoutez d'autres éléments de tiroir selon vos besoins
        ],
      ),
    );
  }


}


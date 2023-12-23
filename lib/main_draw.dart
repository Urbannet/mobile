import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drawer Example'),
      ),
      body: Center(
        child: Text('Contenu de l\'application'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Mon App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Accueil'),
              onTap: () {
                // Mettez ici le code que vous souhaitez exécuter lorsque l'élément du Drawer est cliqué.
                Navigator.pop(context); // Ferme le Drawer
              },
            ),
            ListTile(
              title: Text('Paramètres'),
              onTap: () {
                // Mettez ici le code que vous souhaitez exécuter lorsque l'élément du Drawer est cliqué.
                Navigator.pop(context); // Ferme le Drawer
              },
            ),
          ],
        ),
      ),
    );
  }
}

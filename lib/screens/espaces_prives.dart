import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fo_proprete_atalian/screens/login.dart';
import 'package:fo_proprete_atalian/screens/publication_interne.dart';
import 'package:fo_proprete_atalian/widgets/maintab.dart';
import 'package:fo_proprete_atalian/widgets/mydrawer.dart';
import 'package:fo_proprete_atalian/widgets/right_drawer_espace_prives.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fo_proprete_atalian/widgets/appbar_custom.dart';

class EspacesPrives extends StatefulWidget {
  const EspacesPrives({Key? key}) : super(key: key);

  @override
  _EspacesPrivesState createState() => _EspacesPrivesState();
}

class _EspacesPrivesState extends State<EspacesPrives> {
  final storage = FlutterSecureStorage();
  late String userName = '';
  late String userRole = '';
  
  @override
  void initState() {
    super.initState();
    loadUserNameAndRole();
  }

  Future<void> loadUserNameAndRole() async {
    String? firstName = await storage.read(key: 'firstName');
    String? lastName  = await storage.read(key: 'lastName');
    String? role  	  = await storage.read(key: 'role');
    firstName = firstName ?? '';
    lastName  = lastName ?? '';
    role  = role ?? '';
    setState(() {
      userName = '$firstName $lastName';
      userRole = '$role';
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      // Vérifie si le token est présent dans le stockage sécurisé
      future: storage.read(key: 'jwt_token'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            // Le token est présent, affiche la page normalement

            if (userRole == 'administrator') {
              return buildContent(); // administrator';
            } else if (userRole == 'subscriber') {
              return buildContent(); //subscriber';
            } else if (userRole == 'demande_abonnement') {
              return buildContentDemandeAbonnementOuResilier(); //demande_abonnement';
            } else if (userRole == 'desabonne') {
              return buildContentDemandeAbonnementOuResilier(); //desabonne';
            }

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
      appBar: CustomAppBar(),
    drawer: Container(
      child: MyDrawer(),
    ),
    endDrawer: Container(
      child: RightDrawerEspacePrives(),
    ),
    body: Container(
      color: Colors.red, // Ajout de la couleur rouge
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Bonjour $userName',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  buildListItem('Publication interne', '', Icons.message, () {}, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PublicationInterne()));
                  }),
                  buildListItem('Votes', '', Icons.how_to_vote, () {}, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PublicationInterne()));
                  }),
                  buildListItem('Questions réponses', '', Icons.help, () {}, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PublicationInterne()));
                  }),
                  buildListItem('Bases documentaires', 'FO ATALIAN PROPRETE', Icons.description, () {}, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PublicationInterne()));
                  }),

                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await storage.delete(key: 'jwt_token');
                setState(() {});
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
    ),
  );
}


  Widget buildContentDemandeAbonnementOuResilier() {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: Container(
        child: MyDrawer(),
      ),
      endDrawer: Container(
        child: RightDrawerEspacePrives(),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.red, // Ajout de la couleur rouge
          ),
          Positioned(
            top: 50, // Ajustez la valeur selon votre besoin
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Bonjour $userName',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),

                  // Titre de paragraphe
                  Text(
                    'DEMANDE D’ADHÉSION EN COURS DE VALIDATION',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Texte stylisé
                  Text(

                    userRole == 'demande_abonnement'
                        ? 'Nous avons bien reçu votre demande d\'adhésion.\n'
                        'Votre demande est en cours de traitement pas nos services..\n'
                        'Nous revenons vers vous dans les meilleurs délais pour l’activation de votre compte.\n'
                        : userRole == 'desabonne'
                        ? 'compte désabonné.'
                        : userRole == 'troisieme_role'
                        ? 'Contenu pour le rôle "troisieme_role".'
                        : 'Autre contenu en fonction du rôle.',



                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                    softWrap: true,
                  ),
                  SizedBox(height: 16.0),


                  ElevatedButton(
                    onPressed: () async {
                      await storage.delete(key: 'jwt_token');
                      setState(() {});
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
          ),
        ],
      ),
    );
  }



  Widget buildListItem(String title, String subtitle, IconData icon, VoidCallback onTap, Function onTapAction) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white,
            width: 1.0, // Épaisseur de la ligne de soulignement
          ),
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Arial',
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
            fontSize: 26.0,
            color: Colors.white,
          ),
        ),
        subtitle: subtitle.isNotEmpty
            ? Text(
          subtitle,
          style: TextStyle(
            fontFamily: 'Arial',
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
            fontSize: 16.0,
            color: Colors.white70,
          ),
        )
            : null,
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        onTap: () {
          if (onTap != null) {
            onTap(); // Exécutez la fonction onTap fournie
          }

          // Exécutez l'action onTapAction fournie
          onTapAction();
        },
      ),
    );
  }

}

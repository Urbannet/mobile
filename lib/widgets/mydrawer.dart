import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fo_proprete_atalian/screens/espaces_prives.dart';
import 'package:fo_proprete_atalian/screens/pageDetail.dart';
import 'package:fo_proprete_atalian/services/page.dart';
import 'package:fo_proprete_atalian/widgets/maintab.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  MyPage pageService = MyPage();
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  bool connected = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    String? token = await _storage.read(key: 'jwt_token');
    setState(() {
      connected = token != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.redAccent[200],
        child: Column(
          children: [
            Container(
              height: 200,
              child: DrawerHeader(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.redAccent[200],
                ),
                child: Image.asset(
                  'assets/images/Logo_FO_ARA.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: FutureBuilder<List>(
                  future: pageService.getAllPage(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data?.length == 0) {
                        return Center(
                          child: Text("No Page"),
                        );
                      }
                      return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            title: Text(
                              snapshot.data?[i]['title']['rendered'],
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PageDetail(data: snapshot.data?[i]),
                                ),
                              )
                            },
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Espaces privés',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EspacesPrives(),
                  ),
                ),
              },
            ),
            if (connected)
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Se déconnecter'),
                onTap: () async {
                  // Déconnexion ici
                  await _storage.delete(key: 'jwt_token');
                  _checkLoginStatus(); // Met à jour l'état après la déconnexion
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainTab()),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fo_proprete_atalian/screens/pageDetail.dart';
import 'package:fo_proprete_atalian/services/page.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  MyPage pageService = MyPage();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.redAccent[200],
        child: Column(
          children: [
            Container(
              height: 200, // Ajustez la hauteur selon vos besoins
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
          ],
        ),
      ),
    );
  }
}

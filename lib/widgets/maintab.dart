import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fo_proprete_atalian/screens/categorypost.dart';
import 'package:fo_proprete_atalian/screens/login.dart';
import 'package:fo_proprete_atalian/widgets/mydrawer.dart';
import 'package:fo_proprete_atalian/widgets/rightdrawer.dart';
import 'package:fo_proprete_atalian/screens/actualites.dart';

class MainTab extends StatefulWidget {
  MainTab({Key? key}) : super(key: key);

  @override
  _MainTabState createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final List<Tab> topTabs = <Tab>[

    // Tab(child: Text("Connexion")),

    Tab(child: Text("ACTUALITÉS")),
    Tab(child: Text("COMMUNIQUÉS")),


  ];

  @override
  void initState() {
    _tabController =
    TabController(length: topTabs.length, initialIndex: 0, vsync: this)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  Future<bool> _onWillPop() async {
    print("on Will Pop");
    if (_tabController?.index == 0) {
      await SystemNavigator.pop();
    }

    Future.delayed(Duration(microseconds: 200), () {
      print("Set Index");
      _tabController?.index = 0;
    });

    print("Return");
    return _tabController?.index == 0;
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(255, 204, 204, 1.0), // Couleur RGB
            centerTitle: true,
            title: InkWell(
              onTap: () {
                // Naviguez vers la page d'accueil ici
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainTab()),
                );
              },
              child: Image.asset(
                'assets/images/logo.png',
                width: 190.0,
                //height: 40.0,
              ),
            ),

            actions: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: IconButton(
                  icon: Icon(Icons.settings),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent[200],
                ),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.black,
              tabs: topTabs,
            ),
          ),
          drawer: Container(
            child: MyDrawer(),
          ),
          endDrawer: Container(
            child: RightDrawer(),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [

              // Login(),

              Actualite(),
              CategoryPost(),
              //LatestPost(),

            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/screens/categorypost.dart';
import 'package:mobile/screens/latestpost.dart';
import 'package:mobile/screens/photos.dart';
import 'package:mobile/screens/videos.dart';
import 'package:mobile/widgets/mydrawer.dart';

class MainTab extends StatefulWidget {
  MainTab({Key? key}) : super(key: key);

  @override
  _MainTabState createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(child: Text("ACTUALITES")),
    const Tab(child: Text("POPULAR")),
    const Tab(child: Text("VIDEOS")),
    const Tab(child: Text("PHOTOS")),
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
            title: Text(
              'FO-ATALIAN',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            actions: [
              Container(
                child: IconButton(
                  icon: Icon(Icons.search),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    print('Search Button Clicked');
                  },
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.pink[300],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: IconButton(
                  icon: Icon(Icons.menu),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.pink[300],
                ),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.black,
              tabs: topTabs,
            ),
          ),
          endDrawer: Container(
            child: MyDrawer(),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              LatestPost(),
              CategoryPost(),
              Video(),
              Photo(),
            ],
          ),
        ),
      ),
    );
  }
}

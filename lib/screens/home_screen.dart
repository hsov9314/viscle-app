import 'package:demo_app/providers/db_initializer.dart';
import 'package:demo_app/screens/home_screen_tab.dart';
import 'package:demo_app/widgets/base/base_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/screens/stats_screen_tab.dart';
import 'package:demo_app/screens/profile_screen_tab.dart';
import 'package:demo_app/screens/select_training_screen.dart';

class HomeScreen extends StatefulWidget {
  static final String id = "Home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _selectedTab = HomeScreenTab();

  static List<Widget> _pageList = [
    HomeScreenTab(),
    StatsScreenTab(),
    StatsScreenTab(),
    ProfileScreenTab()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedTab = _pageList[index];
    });
  }

  @override
  void initState() {
    initializeDatabase("viscle.db");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
////          shape: ContinuousRectangleBorder(
////              borderRadius: BorderRadius.only(
////                  bottomLeft: Radius.circular(50),
////                  bottomRight: Radius.circular(50))),
//          title: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: [
//          Icon(
//            Icons.dehaze,
//          ),
//          Container(padding: const EdgeInsets.all(8.0), child: Text(_tabTitle)),
//          Icon(Icons.edit),
//        ],
//      )),
      body: _selectedTab,
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, SelectTrainingScreen.id);
        },
        child: Image(
          image: AssetImage("assets/images/logo.png"),
          width: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BaseBottomAppBar(
        color: Colors.black38,
        selectedColor: Colors.redAccent,
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: _onItemTapped,
        items: [
          BaseBottomAppBarItem(iconData: Icons.home, text: "ホーム"),
          BaseBottomAppBarItem(iconData: Icons.assessment, text: "グラフ"),
          BaseBottomAppBarItem(iconData: Icons.assessment, text: "グラフ"),
          BaseBottomAppBarItem(iconData: Icons.person, text: "設定")
        ],
      ),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//      floatingActionButton: FloatingActionButton(onPressed: (){},),
    );
  }
}

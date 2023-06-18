import 'package:flutter/material.dart'
    show
        BottomNavigationBar,
        BottomNavigationBarItem,
        BuildContext,
        Icon,
        Icons,
        IndexedStack,
        Key,
        Scaffold,
        State,
        StatefulWidget,
        Widget;
import 'package:pariwisata_jember/mylib/color.dart';
import 'bookmark/index.dart' show BookMark;
import 'profile/index.dart' show Profile;
import 'tourist/index.dart' show Tourist;

// ignore: must_be_immutable
class Home extends StatefulWidget {
  int currentPage;
  Home({
    Key? key,
    this.currentPage = 0,
  }) : super(key: key) {
    if (currentPage > 2) {
      currentPage = 2;
    }
    if (currentPage < 0) {
      currentPage = 0;
    }
  }

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _HomeState();

  final List<Widget> _screens = [
    const Tourist(),
    const BookMark(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: _screens[currentPage],
      body: IndexedStack(
        index: widget.currentPage,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentPage,
        onTap: (value) {
          setState(() {
            widget.currentPage = value;
          });
        },
        enableFeedback: true,
        fixedColor: bl1,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Beranda",
            tooltip: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: "Penanda",
            tooltip: "Penanda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
            tooltip: "Profile",
          ),
        ],
      ),
    );
  }
}

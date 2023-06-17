import 'package:flutter/material.dart'
    show
        StatefulWidget,
        State,
        BuildContext,
        Widget,
        Scaffold,
        IndexedStack,
        BottomNavigationBar,
        BottomNavigationBarItem,
        Icon,
        Icons;
import 'package:pariwisata_jember/mylib/color.dart';
import 'bookmark/index.dart' show BookMark;
import 'profile/index.dart' show Profile;
import 'tourist/index.dart' show Tourist;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentPage = 0;

  final List<Widget> _screens = [
    const Tourist(),
    const BookMark(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: _screens[_currentPage],
      body: IndexedStack(
        index: _currentPage,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (value) {
          setState(() {
            _currentPage = value;
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

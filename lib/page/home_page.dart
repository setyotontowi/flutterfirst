import 'package:flutter/material.dart';
import 'package:velmo/page/favorites_page.dart';
import 'package:velmo/page/news_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<Widget> pages = [
    NewsPage(),
    FavoritesPage(),
  ];

  void _onItemTapped(int i) {
    setState(() {
      _selectedIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Monday Apr 23", style: TextStyle(fontSize: 14),),
            Text("Breaking News", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
          ]),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: "News"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites")
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

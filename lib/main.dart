import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velmo/screens/favorites_page.dart';
import 'package:velmo/screens/generator_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MyAppState(),
        child: MaterialApp(
          title: "Velmo Trials",
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          ),
          home: HomePage(),
        ));
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  void next() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];
  void toggleFavorites() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }

    notifyListeners();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  late PageController _pageController;

  List<BottomNavigationBarItem> _buildNavigation() {
    return [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      const BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites")
    ];
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [GeneratorPage(), FavoritePage()];

    return Scaffold(
      body: SizedBox.expand(
          child: PageView(
              controller: _pageController,
              onPageChanged: (index) => {setState(() => selectedIndex = index)},
              children: content)),
      bottomNavigationBar: BottomNavigationBar(
        items: _buildNavigation(),
        currentIndex: selectedIndex,
        onTap: (index) => setState(() {
          selectedIndex = index;
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuint);
        }),
      ),
    );
  }
}

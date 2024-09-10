import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/blog.dart';
import 'pages/recommend.dart';
import 'pages/search.dart';
import 'pages/my_list.dart';
import 'pages/loading.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {
  try {
    await dotenv.load();
  } catch (e) {
    print("Error loading .env file: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ViewerVault',
      theme: ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.grey[900],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[400],
          elevation: 8,
        ),
        dividerColor: Colors.grey[800],
      ),
      // initial route is loading page
      initialRoute: '/',
      routes: {
        '/': (context) => const LoadingPage(), // Initial route
        '/home': (context) => const MyHomePage(title: 'ViewerVault'),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const BlogPage(),
    const RecommendPage(),
    const SearchPage(),
    const MyListPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Blog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Recommend',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'My List',
          ),
        ],
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.grey[400],
        backgroundColor: Colors.grey[900],
        elevation: 8,
      ),
    );
  }
}

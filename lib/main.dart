import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:lnbac_5525/searchPage.dart';
import 'package:lnbac_5525/settingsPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          theme: themeNotifier.getTheme(),
          home: HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    SearchPage(),
    CoursesPage(),
    ChatPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor:
            themeNotifier.isDarkTheme ? Colors.black : Colors.white,
        selectedItemColor:
            themeNotifier.isDarkTheme ? Colors.white : Colors.black,
        unselectedItemColor:
            themeNotifier.isDarkTheme ? Colors.grey : Colors.black54,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Exams Searching',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories_rounded),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_outlined),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_suggest_outlined),
            label: 'Paramètres',
          ),
        ],
      ),
    );
  }
}

class CoursesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Téléchargements'),
      ),
      body: Center(
        child: Text('Liste des fichiers téléchargés'),
      ),
    );
  }
}

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: Center(
        child: Text('Fonctionnalité de chat à venir'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'posts_screen.dart';
import 'favorites_screen.dart';
import 'notes_screen.dart';
import '../widgets/bottom_nav_bar.dart';
import '../provider/theme_provider.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  final int tabIndex;

  const MainScreen({this.tabIndex = 0});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.tabIndex;
  }

  static const List<String> _routes = <String>[
    '/posts',
    '/favorites',
    '/notes',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      GoRouter.of(context).go(_routes[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('NEWS ROOM'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          PostsScreen(),
          FavoritesScreen(),
          NotesScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}


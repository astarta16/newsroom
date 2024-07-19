import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_project/provider/theme_provider.dart';
import 'package:task_project/theme.dart';
import 'router.dart';
import 'services/favorite_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          routerDelegate: router.routerDelegate,
          routeInformationParser: router.routeInformationParser,
        );
      },
    );
  }
}

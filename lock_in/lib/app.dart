import 'package:flutter/material.dart';
import 'package:lock_in/config/routes.dart';
import 'package:lock_in/config/themes.dart';
import 'package:provider/provider.dart';
import 'package:lock_in/providers/theme_provider.dart';

class LockInApp extends StatelessWidget {
  const LockInApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Lock-In',
          debugShowCheckedModeBanner: false,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: AppRoutes.home,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:fordevs/ui/theme/theme.dart';

import '../pages/pages.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = const TextTheme();
    MaterialTheme materialTheme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'ForDev',
      debugShowCheckedModeBanner: false,
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: ThemeMode.system,
      home: const LoginPage(),
    );
  }
}

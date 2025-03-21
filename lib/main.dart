import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/screens/home_screen.dart';

final kColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.deepPurple, brightness: Brightness.dark);

void main() {
  runApp(ProviderScope(
    child: MaterialApp(
      home: const HomeScreen(),
      theme: ThemeData(
          colorScheme: kColorScheme,
          brightness: Brightness.dark,
          appBarTheme: AppBarTheme(backgroundColor: kColorScheme.onPrimary),
          scaffoldBackgroundColor: kColorScheme.secondary),
    ),
  ));
}

import 'package:flutter/material.dart';

void main() {
  runApp(const AurynApp());
}

class AurynApp extends StatelessWidget {
  const AurynApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AURYN Offline',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'AURYN Offline',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}

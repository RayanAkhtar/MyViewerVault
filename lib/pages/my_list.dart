import 'package:flutter/material.dart';

class MyListPage extends StatelessWidget {
  const MyListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(170, 58, 175, 185),
        title: const Center(child: Text('My List Page')),
      ),
      body: const Center(
        child: Text('This is the My List Page'),
      ),
    );
  }
}

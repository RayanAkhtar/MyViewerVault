import 'package:flutter/material.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(170, 58, 175, 185),
        title: const Center(child: Text('Blog Page')),
      ),
      body: const Center(
        child: Text('This is the Blog Page'),
      ),
    );
  }
}

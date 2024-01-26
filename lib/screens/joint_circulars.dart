import 'package:flutter/material.dart';
import 'sidebar.dart';

class JointCirculars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joint Circulars'),
      ),
      body: Center(
        child: Text('Joint Circulars'),
      ),
      drawer: Sidebar(
        currentIndex: 2, // Adjust the index based on your sidebar menu
        onItemSelected: (index) {
          // Handle item selection if needed
          Navigator.pop(context); // Close the drawer after handling selection
        },
      ),
    );
  }
}

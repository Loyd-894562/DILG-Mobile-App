import 'package:flutter/material.dart';
import 'sidebar.dart'; // Import the sidebar.dart file

class MemoCirculars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memo Circulars'),
      ),
      body: Center(
        child: Text('Memo Circulars'),
      ),
      drawer: Sidebar(
        currentIndex: 3, // Adjust the index based on your sidebar menu
        onItemSelected: (index) {
          // Handle item selection if needed
          Navigator.pop(context); // Close the drawer after handling selection
        },
      ),
    );
  }
}

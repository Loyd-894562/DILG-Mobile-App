import 'package:flutter/material.dart';
import 'sidebar.dart';
import '../utils/routes.dart';
import 'home_screen.dart';

class LatestIssuances extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Latest Issuances',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.blue[900]),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: _buildBody(),
      drawer: Sidebar(
        currentIndex: 1,
        onItemSelected: (index) {
          // Handle item selection if needed
          _navigateToSelectedPage(context, index);
        },
      ),
    );
  }

  Widget _buildBody() {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Latest Issuances Content',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Add your widgets for Latest Issuances content
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToSelectedPage(BuildContext context, int index) {
    // Handle navigation if needed
  }
  // bool _handleBackButton(BuildContext context) {
  //   // Handle back button press logic here
  //   // You can check conditions and navigate accordingly
  //   // For example, if you are on a specific screen, navigate to the home screen
  //   Navigator.of(context).pushReplacementNamed(Routes.home);
  //   return false; // Prevent back navigation
  // }
}

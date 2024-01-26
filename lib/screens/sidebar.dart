import 'package:flutter/material.dart';
import 'latest_issuances.dart';
import 'joint_circulars.dart';
import 'memo_circulars.dart';
import 'presidential_directives.dart';
import 'draft_issuances.dart';
import 'republic_acts.dart';
import 'legal_opinions.dart';
import 'home_screen.dart';
import '../utils/routes.dart';

class Sidebar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  Sidebar({required this.currentIndex, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blue[900],
        child: Column(
          children: [
            // Place the burger button at the top right corner
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[900]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/dilg-main.png',
                    width: 70.0,
                    height: 70.0,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'DILG - BOHOL PROVINCE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _buildSidebarItem(Icons.home, 'Home', 0, context),
            _buildSidebarItem(Icons.article, 'Latest Issuances', 1, context),
            _buildSidebarItem(
                Icons.compare_arrows, 'Joint Circulars', 2, context),
            _buildSidebarItem(Icons.note, 'Memo Circulars', 3, context),
            _buildSidebarItem(
                Icons.gavel, 'Presidential Directives', 4, context),
            _buildSidebarItem(Icons.drafts, 'Draft Issuances', 5, context),
            _buildSidebarItem(
                Icons.account_balance, 'Republic Acts', 6, context),
            _buildSidebarItem(
                Icons.library_books, 'Legal Opinions', 7, context),
            _buildSidebarItem(
              Icons.exit_to_app,
              'Logout',
              8,
              context,
              onPressed: () {
                // Implement your logout logic here
                // For example, redirect to login page
                Navigator.pushReplacementNamed(context, Routes.login);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPageByIndex(int index) {
    switch (index) {
      case 1:
        return LatestIssuances();
      case 2:
        return JointCirculars();
      case 3:
        return MemoCirculars();
      case 4:
        return PresidentialDirectives();
      case 5:
        return DraftIssuances();
      case 6:
        return RepublicActs();
      case 7:
        return LegalOpinions();
      // Add cases for other items
      // ...
      default:
        return Container(); // Return a default widget or an empty container
    }
  }

  // void _navigateToPage(BuildContext context, Widget page) {
  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  //   onItemSelected(
  //       0); // Reset the selected index to home when navigating to a new page
  // }

  Widget _buildSidebarItem(
      IconData icon, String title, int index, BuildContext context,
      {VoidCallback? onPressed}) {
    return ListTile(
      title: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24.0),
          SizedBox(width: 8.0),
          Text(
            title,
            style: TextStyle(
              color: currentIndex == index
                  ? Colors.white
                  : Colors.white.withOpacity(0.5),
              fontWeight:
                  currentIndex == index ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
      onTap: () {
        if (onPressed != null) {
          onPressed();
        } else {
          onItemSelected(index);
          Navigator.of(context).pop(); // Close the sidebar
          // Ensure the index is within bounds before navigating
          if (index >= 0 && index < 8) {
            switch (index) {
              case 0:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
                break;
              case 1:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LatestIssuances(),
                  ),
                );
                break;
              case 2:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JointCirculars(),
                  ),
                );
                break;
              case 3:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MemoCirculars(),
                  ),
                );
                break;
              case 4:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PresidentialDirectives(),
                  ),
                );
                break;
              case 5:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DraftIssuances(),
                  ),
                );
                break;
              case 6:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RepublicActs(),
                  ),
                );
                break;
              case 7:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LegalOpinions(),
                  ),
                );
                break;
              // Add cases for other items
              // ...
              default:
                print("Invalid index: $index");
                break;
            }
          } else {
            print("Index out of bounds: $index");
          }
        }
      },
    );
  }
}

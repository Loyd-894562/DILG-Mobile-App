import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'library_screen.dart';
import 'sidebar.dart';
import 'latest_issuances.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<String> _drawerMenuItems = [
    'Home',
    'Search',
    'Library',
    'Latest Issuances'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _drawerMenuItems[_currentIndex.clamp(0, _drawerMenuItems.length - 1)],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: _currentIndex == 0
            ? Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu, color: Colors.blue[900]),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              )
            : null,
        automaticallyImplyLeading: true,
      ),
      body: _buildBody(),
      drawer: Sidebar(
        currentIndex: _currentIndex,
        onItemSelected: (index) {
          _navigateToSelectedPage(context, index);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index.clamp(0, _drawerMenuItems.length - 1);
          });
        },
        backgroundColor: Colors.blue[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.5),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Library',
          ),
          
        ],
      ),
    );
  }

  bool _handleBackButton() {
    // Handle back button press logic here
    // You can check conditions and navigate accordingly
    // For example, if you are on a specific screen, navigate to the home screen
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
      return false; // Prevent back navigation
    }
    return true; // Allow back navigation
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        // Home Screen
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Recently Opened Issuances
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recently Opened Issuances',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildRecentIssuances(),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            // Recently Downloaded Issuances
            
          ],
        );
      case 1:
        // Search Screen
        return SearchScreen();
      case 2:
        // Library Screen
        return LibraryScreen();
      case 3:
        return LatestIssuances();
      default:
        return Container();
    }
  }

  Widget _buildRecentIssuances() {
    return SizedBox(
      height: 200.0,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('Opened Issuance $index'),
            ),
          );
        },
      ),
    );
  }

  
  void _navigateToSelectedPage(BuildContext context, int index) {
    switch (index) {
      case 1:
        _navigateToLatestIssuances(context);
        break;
      // Add conditions for other pages if needed
    }
  }

  void _navigateToLatestIssuances(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LatestIssuances(),
      ),
    );
  }
}

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../utils/routes.dart';
import 'sidebar.dart';
import 'details_screen.dart';
import 'package:http/http.dart' as http;

class LatestIssuances extends StatefulWidget {
  @override
  _LatestIssuancesState createState() => _LatestIssuancesState();
}

class _LatestIssuancesState extends State<LatestIssuances> {
  List<LatestIssuance> _latestIssuances = [];
  List<LatestIssuance> get latestIssuances => _latestIssuances;

  List<String> categories = ['Category 1', 'Category 2', 'Category 3'];
  String selectedCategory = 'Category 1'; // Default selection
//   String formatDate(String dateString) {
//   return DateFormat('MMMM dd, yyyy').format(DateTime.parse(dateString));
// }

@override
  void initState() {
    super.initState();
    fetchLatestIssuances();
  }


 Future<void> fetchLatestIssuances() async {
    final response = await http.get(
      Uri.parse('http://dilg.mdc-devs.com/api/latest_issuances'),
      headers: {
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['latests'];

      setState(() {
        _latestIssuances = data.map((item) => LatestIssuance.fromJson(item)).toList();
      });
    } else {
      // Handle error
      print('Failed to load latest issuances');     
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Latest Issuances',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: _buildBody(),
      drawer: Sidebar(
        currentIndex: 1,
        onItemSelected: (index) {
          _navigateToSelectedPage(context, index);
        },
      ),
    );
  }

  Widget _buildBody() {
    TextEditingController searchController = TextEditingController();

    return SingleChildScrollView(
      child: Column(
        children: [
          // Filter Category Dropdown
          Container(
            margin: EdgeInsets.only(bottom: 8.0),
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Outcome Area/Program: ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Container(
                  margin: EdgeInsets.only(top: 8.0),
                  padding: EdgeInsets.all(16.0),
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedCategory = newValue;
                          // Call a method to fetch and display issuances based on the selected category
                          // Example: fetchAndDisplayIssuances(selectedCategory);
                        });
                      }
                    },
                    items: categories
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Search Input
          Container(
            // margin: EdgeInsets.only(top: 4.0),
            padding: EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                // Handle search input changes
              },
            ),
          ), // Adjust the spacing as needed

          // Sample Table Section
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Latest',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                for (int index = 0; index < _latestIssuances.length; index++)
              InkWell(
                onTap: () {
                  _navigateToDetailsPage(context, 'Row $index');
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.article, color: Colors.blue[900]),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _latestIssuances[index].issuance.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                'Ref #${_latestIssuances[index].issuance.referenceNo}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Text(
                          DateFormat('MMMM dd, yyyy').format(
                            DateTime.parse(_latestIssuances[index].issuance.date),
                          ),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetailsPage(BuildContext context, String content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(
          title: 'Details',
          content: content,
        ),
      ),
    );
  }

  void _navigateToSelectedPage(BuildContext context, int index) {
    // Handle navigation if needed
  }
}

//for Latest getters and setters
class LatestIssuance {
  final int id;
  final String category;
  final String outcome;
  final Issuance issuance;

  LatestIssuance({
    required this.id,
    required this.category,
    required this.outcome,
    required this.issuance,
  });

  factory LatestIssuance.fromJson(Map<String, dynamic> json) {
    return LatestIssuance(
      id: json['id'],
      category: json['category'],
      // title: json['issuance']['title'],
      outcome: json['outcome'],
      issuance: Issuance.fromJson(json['issuance']),
    );
  }
}

//for Issuance
class Issuance {
  final int id;
  final String date;
  final String title;
  final String referenceNo;
  final String keyword;
  final String urlLink;

  Issuance({
    required this.id,
    required this.date,
    required this.title,
    required this.referenceNo,
    required this.keyword,
    required this.urlLink,
  });

  factory Issuance.fromJson(Map<String, dynamic> json) {
    return Issuance(
      id: json['id'],
      date: json['date'],
      title: json['title'],
      referenceNo: json['reference_no'],
      keyword: json['keyword'],
      urlLink: json['url_link'],
    );
  }
}

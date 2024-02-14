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
  List<String> categories = [
    'All Outcome Area',
    'ACCOUNTABLE, TRANSPARENT, PARTICIPATIVE',
    'AND EFFECTIVE LOCAL GOVERNANCE',
    'PEACEFUL, ORDERLY AND SAFE LGUS STRATEGIC PRIORITIES',
    'SOCIALLY PROTECTIVE LGUS',
    'ENVIRONMENT-PROTECTIVE, CLIMATE CHANGE ADAPTIVE AND DISASTER RESILIENT LGUS',
    'BUSINESS-FRIENDLY AND COMPETITIVE LGUS',
    'STRENGTHENING OF INTERNAL GOVERNANCE'
  ];

  String selectedCategory = 'All Outcome Area'; // Default selection

  @override
  void initState() {
    super.initState();
    fetchLatestIssuances();
  }

  Future<void> fetchLatestIssuances() async {
    final response = await http.get(
      Uri.parse('https://issuances.dilgbohol.com/api/latest_issuances'),
      headers: {
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['latests'];

      setState(() {
        _latestIssuances =
            data.map((item) => LatestIssuance.fromJson(item)).toList();
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
            padding: EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: selectedCategory,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                }
              },
              items: categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: selectedCategory == value
                      ? Text(
                          _truncateText(
                              value, 30), // Adjust the maxLength as needed
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      : Text(value),
                );
              }).toList(),
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
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                // Handle search input changes
              },
            ),
          ), // Adjust the spacing as needed

          // Sample Table Section
          Container(
            // padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Latest',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  // Add margin to the left
                  textAlign: TextAlign.left,
                  // Use the EdgeInsets.only to specify margin for specific sides
                  // In this case, only the left margin is set to 3.0
                  // margin: EdgeInsets.only(left: 3.0),
                ),
                SizedBox(height: 16.0),
                for (int index = 0; index < _latestIssuances.length; index++)
                  InkWell(
                    onTap: () {
                      _navigateToDetailsPage(context, _latestIssuances[index]);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: const Color.fromARGB(255, 203, 201, 201),
                              width: 1.0),
                        ),
                      ),
                      child: Card(
                        elevation: 0,
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
                                  DateTime.parse(
                                      _latestIssuances[index].issuance.date),
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
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetailsPage(BuildContext context, LatestIssuance issuance) {
    print('PDF URL: ${issuance.issuance.urlLink}');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(
          title: issuance.issuance.title,
          content:
              'Ref #${issuance.issuance.referenceNo}\n${DateFormat('MMMM dd, yyyy').format(DateTime.parse(issuance.issuance.date))}',
          pdfUrl: issuance.issuance.urlLink,
          type: getTypeForDownload(issuance.issuance.type),
        ),
      ),
    );
  }

  void _navigateToSelectedPage(BuildContext context, int index) {
    // Handle navigation if needed
  }
}

String _truncateText(String text, int maxLength) {
  if (text.length <= maxLength) {
    return text;
  } else {
    return text.substring(0, maxLength) + '...';
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
  final String type;

  Issuance(
      {required this.id,
      required this.date,
      required this.title,
      required this.referenceNo,
      required this.keyword,
      required this.urlLink,
      required this.type});

  factory Issuance.fromJson(Map<String, dynamic> json) {
    return Issuance(
        id: json['id'],
        date: json['date'],
        title: json['title'],
        referenceNo: json['reference_no'],
        keyword: json['keyword'],
        urlLink: json['url_link'],
        type: json['type']);
  }
}

String getTypeForDownload(String issuanceType) {
  // Map issuance types to corresponding download types
  switch (issuanceType) {
    case 'Latest Issuance':
      return 'Latest Issuance';
    case 'Joint Circulars':
      return 'Joint Circulars';
    case 'Memo Circulars':
      return 'Memo Circulars';
    case 'Presidential Directives':
      return 'Presidential Directives';
    case 'Draft Issuances':
      return 'Draft Issuances';
    case 'Republic Acts':
      return 'Republic Acts';
    case 'Legal Opinions':
      return 'Legal Opinions';

    default:
      return 'Other';
  }
}

import 'dart:convert';

import 'package:DILGDOCS/Services/globals.dart';
// import 'package:DILGDOCS/screens/joint_circulars.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  TextEditingController _searchController = TextEditingController();
  
  List<LatestIssuance> _latestIssuances = [];
  List<JointCircular> _jointCirculars = [];
  List<MemoCircular> _memoCirculars = [];
  List<PresidentialDirective> _presidentialDirectives = [];
    
    // List<String> _presidentialDirectives =
    //     List.generate(6, (index) => 'Presidential Directive $index');
    List<String> _draftIssuances =
        List.generate(6, (index) => 'Draft Issuance $index');
    List<String> _republicActs =
        List.generate(6, (index) => 'Republic Act $index');
    List<String> _legalOpinions =
        List.generate(6, (index) => 'Legal Opinion $index');

  String _selectedCategory = 'All';
  List<String> _categories = [
    'All',
    'Latest Issuances',
    'Joint Circulars',
    'Memo Circulars',
    'Presidential Directives',
    'Draft Issuances',
    'Republic Acts',
    'Legal Opinions',
  ];


//For Latest Issuances
  @override
  void initState() {
    super.initState();
    fetchLatestIssuances();
    fetchJointCirculars();
    fetchMemoCirculars();
    fetchPresidentialCirculars();
  }

//for Latest Issuances - API
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

  //for Joint Circulars API
  Future<void> fetchJointCirculars() async {
    final response = await http.get(
      Uri.parse('http://dilg.mdc-devs.com/api/joint_circulars'),
      headers: {
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['joints'];

      setState(() {
        _jointCirculars = data.map((item) => JointCircular.fromJson(item)).toList();
      });
    } else {
      // Handle error
      print('Failed to load latest issuances');
            
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  //for Presidential Directives API
  Future<void> fetchPresidentialCirculars() async {
    final response = await http.get(
      Uri.parse('http://dilg.mdc-devs.com/api/presidential_directives'),
      headers: {
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['presidentials'];

      setState(() {
        _presidentialDirectives = data.map((item) => PresidentialDirective.fromJson(item)).toList();
      });
    } else {
      // Handle error
      print('Failed to load latest issuances');
            
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  //for Memo Circular API

  Future<void> fetchMemoCirculars() async {
    final response = await http.get(
      Uri.parse('http://dilg.mdc-devs.com/api/memo_circulars'),
      headers: {
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['memos'];

      setState(() {
        _memoCirculars = data.map((item) => MemoCircular.fromJson(item)).toList();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSearchAndFilterRow(),
              // Use a common method to build each section
              _buildLatestSection('Latest Issuances', _latestIssuances),
              _buildJointSection('Joint Circulars', _jointCirculars),
              _buildMemoSection('Memo Circulars', _memoCirculars),
              _buildPresidentialSection('Memo Circulars', _presidentialDirectives),
              // _buildSection('Presidential Directives', _presidentialDirectives),
              // _buildSection('Draft Issuances', _draftIssuances),
              // _buildSection('Republic Acts', _republicActs),
              // _buildSection('Legal Opinions', _legalOpinions),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build the search input and category filter row
  Widget _buildSearchAndFilterRow() {
    return Row(
      children: [
        DropdownButton<String>(
          value: _selectedCategory,
          onChanged: (String? newValue) {
            setState(() {
              _selectedCategory = newValue!;
            });
          },
          items: _categories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(
                category,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          style: TextStyle(color: Colors.black),
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          underline: Container(
            height: 2,
            color: Colors.blue[900],
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  // Handle search query changes here
                });
              },
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                icon: Icon(Icons.search),
              ),
            ),
             
          ),
        ),
      ],
    );
  }

  

  // Updated _buildSection method to filter items based on selected category and search query
  // Updated _buildSection method to filter items based on selected category and search query
  Widget _buildLatestSection(String title, List<LatestIssuance> items) {
    // Filter items based on selected category and search query
            
      List<LatestIssuance> filteredItems = items
            .where((item) =>
                (_selectedCategory == 'All' || item.category == _selectedCategory) &&
                (item.outcome.toLowerCase().contains(_searchController.text.toLowerCase())))
            .toList();

            if (filteredItems.isEmpty) {
            return Container(
              alignment: Alignment.center,
              child: Text('No data available'),
            );
      }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  width: 300,
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text('ID: ${filteredItems[index].id}'),
                      Text(
                        'Title: ${filteredItems[index].issuance.title}',
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                         
                        ),
                      ),
                      Text('Category: ${filteredItems[index].category}'),
                      Text('Outcome: ${filteredItems[index].outcome}',
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,                     
                        )
                      ),
                      Text('Issuance Date: ${filteredItems[index].issuance.date}'),
                      Text('Reference No: ${filteredItems[index].issuance.referenceNo}'),
                      Text('Url Link: ${filteredItems[index].issuance.urlLink}'),
                      // ...
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        
      ],
    );
  }
  
  Widget _buildJointSection(String title, List<JointCircular> items) {
    // Filter items based on selected category and search query
            
      List<JointCircular> filteredItems = items
        .where((item) =>      
            (_selectedCategory == 'All' || item.responsible_office == _selectedCategory) ||
            (item.responsible_office.isEmpty))
        .toList();

        if (filteredItems.isEmpty) {
        return Container(
          alignment: Alignment.center,
          child: Text('No data available'),
        );
      }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  width: 300,
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text('ID: ${filteredItems[index].id}'),
                      Text('Title: ${filteredItems[index].issuance.title}',
                        style: TextStyle(
                         overflow: TextOverflow.ellipsis,  
                        ),
                      ),
                      Text('Responsible Office: ${filteredItems[index].responsible_office ?? 'N/A'}'),
                     
                      // Display other issuance details as needed
                      // For example:
                      Text('Issuance Date: ${filteredItems[index].issuance.date}'),
                      Text('Reference No: ${filteredItems[index].issuance.referenceNo}'),
                      Text('Url Link: ${filteredItems[index].issuance.urlLink}'),
                      // ...
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        
      ],
    );
  }

   Widget _buildMemoSection(String title, List<MemoCircular> items) {
  // filter MemoCicrulars even if the responsible office is empty
     List<MemoCircular> filteredItems = items
    .where((item) =>
        (_selectedCategory == 'All' || item.responsible_office == _selectedCategory) ||
        (item.responsible_office.isEmpty))
    .toList();


    if (filteredItems.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: Text('No data available'),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    width: 300,
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text('ID: ${filteredItems[index].id}'),
                        Text('Title: ${filteredItems[index].issuance.title}',
                          style: TextStyle(
                          overflow: TextOverflow.ellipsis,  
                          ),
                        ),
                        Text('Responsible Office: ${filteredItems[index].responsible_office ?? 'N/A'}'),
                        Text('Issuance Date: ${filteredItems[index].issuance.date}'),
                        Text('Reference No: ${filteredItems[index].issuance.referenceNo}'),
                        Text('Url Link: ${filteredItems[index].issuance.urlLink}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    } 
  }


   Widget _buildPresidentialSection(String title, List<PresidentialDirective> items) {
  // filter MemoCicrulars even if the responsible office is empty
     List<PresidentialDirective> filteredItems = items
    .where((item) =>
        (_selectedCategory == 'All' || item.responsible_office == _selectedCategory) ||
        (item.responsible_office.isEmpty))
    .toList();


    if (filteredItems.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: Text('No data available'),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    width: 300,
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text('ID: ${filteredItems[index].id}'),
                        Text('Title: ${filteredItems[index].issuance.title}',
                          style: TextStyle(
                          overflow: TextOverflow.ellipsis,  
                          ),
                        ),
                        Text('Responsible Office: ${filteredItems[index].responsible_office ?? 'N/A'}'),
                        Text('Issuance Date: ${filteredItems[index].issuance.date}'),
                        Text('Reference No: ${filteredItems[index].issuance.referenceNo}'),
                        Text('Url Link: ${filteredItems[index].issuance.urlLink}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    } 
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

//for Joint getters and setters
class JointCircular {
  final int id;
  final String responsible_office;
   final Issuance issuance;

  JointCircular({
    required this.id,
    required this.responsible_office,
   required this.issuance,
   
  });

  factory JointCircular.fromJson(Map<String, dynamic> json) {
    return JointCircular(
      id: json['id'],
      responsible_office: json['responsible_office'],
      // title: json['issuance']['title'],
     
      issuance: Issuance.fromJson(json['issuance']),
    );
  }
}

//for MemoCicular
class MemoCircular {
  final int id;
  final String responsible_office;
   final Issuance issuance;

  MemoCircular({
    required this.id,
    required this.responsible_office,
   required this.issuance,
   
  });

  factory MemoCircular.fromJson(Map<String, dynamic> json) {
    return MemoCircular(
      id: json['id'],
      responsible_office: json['responsible_office'], 
      issuance: Issuance.fromJson(json['issuance']),
    );
  }
}

//for Presidential Directives

class PresidentialDirective {
  final int id;
  final String responsible_office;
   final Issuance issuance;

  PresidentialDirective({
    required this.id,
    required this.responsible_office,
   required this.issuance,
   
  });

  factory PresidentialDirective.fromJson(Map<String, dynamic> json) {
    return PresidentialDirective(
      id: json['id'],
      responsible_office: json['responsible_office'], 
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

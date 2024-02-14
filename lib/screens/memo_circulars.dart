import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../utils/routes.dart';
import 'sidebar.dart';
import 'details_screen.dart';
import 'package:http/http.dart' as http;
import 'package:DILGDOCS/screens/draft_issuances.dart' as draft;

class MemoCirculars extends StatefulWidget {
  @override
  State<MemoCirculars> createState() => _MemoCircularsState();
}

class _MemoCircularsState extends State<MemoCirculars> {
  List<MemoCircular> _memoCirculars = [];

  @override
  void initState() {
    super.initState();
    fetchMemoCirculars();
  }

  Future<void> fetchMemoCirculars() async {
    final response = await http.get(
      Uri.parse('https://issuances.dilgbohol.com/api/memo_circulars'),
      headers: {
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['memos'];

      setState(() {
        _memoCirculars =
            data.map((item) => MemoCircular.fromJson(item)).toList();
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
          'Memo Circulars',
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
          Container(
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
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Memo Circulars',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 16.0),
                for (int index = 0; index < _memoCirculars.length; index++)
                  InkWell(
                    onTap: () {
                      _navigateToDetailsPage(context, _memoCirculars[index]);
                    },
                    child: Card(
                      elevation: 0,
                      child: Column(
                        children: [
                          ListTile(
                            leading:
                                Icon(Icons.article, color: Colors.blue[900]),
                            title: Text(
                              _memoCirculars[index].issuance.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ref #${_memoCirculars[index].issuance.referenceNo}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  'Responsible Office: ${_memoCirculars[index].responsibleOffice}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Text(
                              DateFormat('MMMM dd, yyyy').format(
                                DateTime.parse(
                                    _memoCirculars[index].issuance.date),
                              ),
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey[400],
                            height: 0,
                            thickness: 1,
                          ),
                        ],
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

  void _navigateToDetailsPage(BuildContext context, MemoCircular issuance) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(
          title: issuance.issuance.title,
          content:
              'Ref #${issuance.issuance.referenceNo}\n${DateFormat('MMMM dd, yyyy').format(DateTime.parse(issuance.issuance.date))} \n\n ${issuance.responsibleOffice}',
          pdfUrl: issuance.issuance.urlLink,
          type: draft.getTypeForDownload(issuance.issuance.type),
        ),
      ),
    );
  }

  void _navigateToSelectedPage(BuildContext context, int index) {
    // Handle navigation if needed
  }
}

class MemoCircular {
  final int id;
  final String responsibleOffice;
  final Issuance issuance;

  MemoCircular({
    required this.id,
    required this.responsibleOffice,
    required this.issuance,
  });

  factory MemoCircular.fromJson(Map<String, dynamic> json) {
    return MemoCircular(
      id: json['id'],
      responsibleOffice: json['responsible_office'],
      issuance: Issuance.fromJson(json['issuance']),
    );
  }
}

class Issuance {
  final int id;
  final String date;
  final String title;
  final String referenceNo;
  final String keyword;
  final String urlLink;
  final String type;

  Issuance({
    required this.id,
    required this.date,
    required this.title,
    required this.referenceNo,
    required this.keyword,
    required this.urlLink,
    required this.type,
  });

  factory Issuance.fromJson(Map<String, dynamic> json) {
    return Issuance(
      id: json['id'],
      date: json['date'],
      title: json['title'],
      referenceNo: json['reference_no'],
      keyword: json['keyword'],
      urlLink: json['url_link'],
      type: json['type'],
    );
  }
}

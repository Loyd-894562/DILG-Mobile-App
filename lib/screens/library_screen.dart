import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'downloadedfile_screen.dart';
import 'dart:io'; // Import 'dart:io' for File and Directory
import 'package:path_provider/path_provider.dart'; // Import 'package:path_provider/path_provider.dart' for getApplicationDocumentsDirectory
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  TextEditingController _searchController = TextEditingController();

 List<String> downloadedFiles = [];



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
    
    loadDownloadedFiles();
    // fetchJointCirculars();
    // fetchMemoCirculars();
    // fetchPresidentialCirculars();
    // fetchDraftIssuances();
    // fetchRepublicActs();
    // fetchLegalOpinion();
  }

 Future<void> loadDownloadedFiles() async {
    final appDir = await getExternalStorageDirectory();
    final directory = Directory(appDir!.path);

    // List all files in the directory
    List<FileSystemEntity> files = directory.listSync();

    setState(() {
      // Filter out only PDF files
      downloadedFiles = files
          .where((file) => file is File && file.path.toLowerCase().endsWith('.pdf'))
          .map((file) => file.path)
          .toList();
    });
  }
//for Latest Issuances - API
  


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
              
              _buildPdf(context), // Corrected this line
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
//Latest Issuances
 
  Widget _buildPdf(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ElevatedButton(
        //   onPressed: () {
        //     // Open the first downloaded file if available
        //     if (downloadedFiles.isNotEmpty) {
        //       openPdfViewer(context, downloadedFiles[0]);
        //     } else {
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         SnackBar(
        //           content: Text('No downloaded files available.'),
        //         ),
        //       );
        //     }
        //   },
        //   child: Text('View Downloaded Files'),
        // ),
        // SizedBox(height: 16),
        if (downloadedFiles.isNotEmpty)
          Text(
            'Downloaded Files:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        SizedBox(height: 8),
        if (downloadedFiles.isNotEmpty)
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: downloadedFiles.map((file) {
              return ElevatedButton(
                onPressed: () {
                  openPdfViewer(context, file);
                },
                child: Text(file.split('/').last), // Display only the file name
              );
            }).toList(),
          ),
      ],
    );
  }


Future<void> openPdfViewer(BuildContext context, String filePath) async {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PDFView(
        filePath: filePath,
        // Implement additional options if needed
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: true,
        pageSnap: true,
        onViewCreated: (PDFViewController controller) {
          // You can use the controller to interact with the PDFView
        },
        // onPageChanged: (int page, int total) {
        //   // Handle page changes if needed
        // },
      ),
    ),
  );
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

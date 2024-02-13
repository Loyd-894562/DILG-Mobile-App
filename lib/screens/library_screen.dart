import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'downloadedfile_screen.dart';
import 'dart:io'; // Import 'dart:io' for File and Directory
import 'package:path_provider/path_provider.dart'; // Import 'package:path_provider/path_provider.dart' for getApplicationDocumentsDirectory


class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  TextEditingController _searchController = TextEditingController();
  List<String> downloadedFiles = [];
  List<String> filteredFiles = [];



//For Latest Issuances
 @override
void initState() {
  super.initState();
  _loadRootDirectory();
}

void _loadRootDirectory() async {

    final appDir = await getExternalStorageDirectory();
    print('Root directory path: ${appDir?.path}');
    if (appDir == null) {
      print('Error: Failed to get the root directory path');
      return;
    }

    final rootDirectory = Directory(appDir.path);
    await loadDownloadedFiles(rootDirectory); // Use await here

    // Populate filteredFiles with all downloaded files
    setState(() {
      filteredFiles.addAll(downloadedFiles);
    });
  }
Future<void> loadDownloadedFiles(Directory directory) async {
  // Map to store files grouped by their folder names
   List<FileSystemEntity> entities = directory.listSync();

  // Iterate over each entity in the directory
  for (var entity in entities) {
    // If the entity is a directory, recursively call loadDownloadedFiles on it
    if (entity is Directory) {
      await loadDownloadedFiles(entity); // Use await here
    }
    // If the entity is a file and ends with .pdf, add its path to downloadedFiles
    else if (entity is File && entity.path.toLowerCase().endsWith('.pdf')) {
      downloadedFiles.add(entity.path);
    }
  }
  // Sort the downloaded files alphabetically
  downloadedFiles.sort();
  // Add the PDF files from the current directory to the downloadedFiles list
  
}

//for Latest Issuances - API@override
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSearchAndFilterRow(),
            _buildPdf(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilterRow() {
    return Row(
      children: [
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
                _filterFiles(value);
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

  Widget _buildPdf(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 16),
        if (filteredFiles.isEmpty)
          Center(
            child: Text(
              'No downloaded issuances',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        if (filteredFiles.isNotEmpty)
          Column(
            children: [
              Text(
                'Downloaded Files:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: filteredFiles.map((file) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        openPdfViewer(context, file);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          file.split('/').last,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
      ],
    );
  }



  void _filterFiles(String query) {
    setState(() {
      filteredFiles = downloadedFiles
          .where((file) => file.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
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

String getFolderName(String path) {
  List<String> parts = path.split('/');
  if (parts.length > 1) {
    String folder = parts[parts.length - 2]; // Get the second-to-last part of the path
    print('Folder name extracted: $folder');
    return folder;
  }
  // Default category if no matching folder is found
  print('No folder name found in path: $path');
  return 'Other';
}

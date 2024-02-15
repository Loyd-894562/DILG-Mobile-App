import 'dart:convert'; // Add this import statement

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LibraryScreen extends StatefulWidget {
  final Function(String, String) onFileOpened;

  LibraryScreen({required this.onFileOpened});

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  TextEditingController _searchController = TextEditingController();
  List<String> downloadedFiles = [];
  List<String> filteredFiles = [];

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
    await loadDownloadedFiles(rootDirectory);

    setState(() {
      filteredFiles.addAll(downloadedFiles);
    });
  }

  Future<void> loadDownloadedFiles(Directory directory) async {
    List<FileSystemEntity> entities = directory.listSync();

    for (var entity in entities) {
      if (entity is Directory) {
        await loadDownloadedFiles(entity);
      } else if (entity is File && entity.path.toLowerCase().endsWith('.pdf')) {
        downloadedFiles.add(entity.path);
      }
    }
    downloadedFiles.sort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSearchAndFilterRow(),
            _buildPdf(),
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

  Widget _buildPdf() {
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
                        openPdfViewer(context, file, widget.onFileOpened);
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

Future<void> openPdfViewer(BuildContext context, String filePath,
    Function(String, String) onFileOpened) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PDFView(
        filePath: filePath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: true,
        pageSnap: true,
        onViewCreated: (PDFViewController controller) {},
      ),
    ),
  );

  String fileName = filePath.split('/').last;
  onFileOpened(fileName, filePath);
}

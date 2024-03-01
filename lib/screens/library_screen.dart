import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class LibraryScreen extends StatefulWidget {
  final Function(String, String)? onFileOpened;
  final Function(String)? onFileDeleted;

  LibraryScreen({
    this.onFileOpened,
    this.onFileDeleted,
  });

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  TextEditingController _searchController = TextEditingController();
  List<String> downloadedFiles = [];
  List<String> filteredFiles = [];
  bool isSearching = false;
  String _selectedSortOption = 'Date';
  List<String> _sortOptions = ['Date', 'Name'];

  Map<String, DateTime> downloadedFilesWithTime = {};

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

    // Sort downloadedFiles based on modification time
    downloadedFiles.sort((a, b) {
      DateTime aModified = _getFileModificationTime(a);
      DateTime bModified = _getFileModificationTime(b);
      return bModified.compareTo(aModified); // Sort in descending order
    });
  }

  DateTime _getFileModificationTime(String filePath) {
    FileStat stat = File(filePath).statSync();
    return stat.modified;
  }

  Future<void> loadDownloadedFiles(Directory directory) async {
    List<FileSystemEntity> entities = directory.listSync();

    for (var entity in entities) {
      if (entity is Directory) {
        await loadDownloadedFiles(entity);
      } else if (entity is File && entity.path.toLowerCase().endsWith('.pdf')) {
        downloadedFiles.add(entity.path);
        // Store the last modified timestamp for sorting
        downloadedFilesWithTime[entity.path] = entity.lastModifiedSync();
      }
    }

    // Sort files by last modified timestamp in descending order
    downloadedFiles.sort((a, b) =>
        downloadedFilesWithTime[b]!.compareTo(downloadedFilesWithTime[a]!));

    // Update filteredFiles list to reflect the changes
    _filterFiles(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove back arrow
        backgroundColor: Colors.white, // Change background color
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 16.0), // Add margin top here
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSearchAndFilterRow(),
              _buildPdf(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      _filterFiles(value);
                    },
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  _filterFiles(_searchController.text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilterRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _buildSearchBar(),
              SizedBox(
                width: 10,
              ), // Add spacing between search bar and other widgets
              // Add other widgets here
            ],
          ),
          // Add other rows or widgets as needed
        ],
      ),
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
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredFiles.length,
                itemBuilder: (BuildContext context, int index) {
                  final String file = filteredFiles[index];
                  return Dismissible(
                    key: Key(file),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20.0),
                      color: Colors.red,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      return await _showDeleteConfirmationDialog(context, file);
                    },
                    onDismissed: (direction) {},
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.picture_as_pdf,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  file.split('/').last,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Container(
                            height: 0.5, // Adjust thickness here
                            color: Colors.black,
                          ),
                        ],
                      ),
                      onTap: () {
                        openPdfViewer(
                          context,
                          file,
                          widget.onFileOpened ??
                              (String fileName, String filePath) {},
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
      ],
    );
  }

  void _sortFiles(String option) {
    setState(() {
      if (option == 'Date') {
        downloadedFiles.sort((a, b) =>
            _getFileModificationTime(b).compareTo(_getFileModificationTime(a)));
      } else if (option == 'Name') {
        downloadedFiles.sort((a, b) => a.compareTo(b));
      }
      _filterFiles(_searchController.text);
    });
  }

  void _filterFiles(String query) {
    setState(() {
      filteredFiles = downloadedFiles
          .where((file) => file.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<bool> _showDeleteConfirmationDialog(
      BuildContext context, String filePath) async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this file?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false when cancelled
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteFile(filePath); // Delete the file when confirmed
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  void _deleteFile(String filePath) {
    try {
      File file = File(filePath);
      file.deleteSync();
      downloadedFiles.remove(filePath);
      filteredFiles.remove(filePath);

      // Call the callback function provided by HomeScreen
      widget.onFileDeleted?.call(filePath.split('/').last);

      // Show a confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("The file has been successfully deleted."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the success dialog
                  Navigator.of(context)
                      .pop(); // Dismiss the confirmation dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );

      setState(() {});
    } catch (e) {
      print("Failed to delete file: $e");
      // Show an error dialog if deletion fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to delete the file."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
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
}

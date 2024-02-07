import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'file_utils.dart';

class DetailsScreen extends StatelessWidget {
  final String title;
  final String content;
  final String pdfUrl; // Add a field for the PDF URL
  final String type;
  // final List<String> downloadedFiles;

  const DetailsScreen({
    required this.title,
    required this.content,
    required this.pdfUrl,
    required this.type,
    //  required this.downloadedFiles,
     
  });

  @override
  Widget build(BuildContext context) {
      // bool isDownloaded = downloadedFiles.contains(title);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 2),
                    Divider(
                      color: Colors.grey,
                      thickness: 2,
                      height: 2,
                    ),
                    Text(
                      content,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              downloadAndSavePdf(context, pdfUrl, type, title);
            },
            child: Text('Download PDF'),
          ),
        
          ],
        ),
      ),
    );
  }

Future<void> downloadAndSavePdf(BuildContext context, String url, String type, String title) async {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
    builder: (BuildContext context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Downloading PDF...'),
            ],
          ),
        ),
      );
    },
  );

  try {
    final appDir = await getExternalStorageDirectory();
    final directoryPath = '${appDir!.path}/$type';
    final filePath = '$directoryPath/$title.pdf';

    final file = File(filePath);
    if (await file.exists()) {
      // File already exists, close loading dialog and return
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('File Already Downloaded'),
            content: Text('The PDF has already been downloaded and saved locally.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Ensure the directory exists, create it if necessary
      final directory = Directory(directoryPath);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Write the file
      await file.writeAsBytes(response.bodyBytes);

      print('PDF downloaded and saved at: $filePath');

      // Close the loading dialog
      Navigator.of(context).pop();

      // Display a confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Download Complete'),
            content: Text('The PDF has been downloaded and saved locally.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      throw Exception('Failed to load PDF: ${response.statusCode}');
    }
  } catch (e) {
    print('Error downloading PDF: $e');
    // Close the loading dialog
    Navigator.of(context).pop();
  }
}



// String getTypeFromPath(String filePath) {
//   List<String> parts = filePath.split('/');
//   if (parts.length > 1) {
//     String folder = parts[parts.length - 2].toLowerCase();

//     if (folder.contains('Latest Issuance')) {
//       return 'Latest Issuance';
//     } else if (folder.contains('Joint Circulars')) {
//       return 'Joint Circulars';
//     } else if (folder.contains('Memo Circulars')) {
//       return 'Memo Circulars';
//     } else if (folder.contains('Presidential Directives')) {
//       return 'Presidential Directives';
//     } else if (folder.contains('Draft Issuances')) {
//       return 'Draft Issuances';
//     } else if (folder.contains('Republic Acts')) {
//       return 'Republic Acts';
//     } else if (folder.contains('Legal Opinions')) {
//       return 'Legal Opinions';
//     }
//   }
//   // Default category if no matching folder is found
//   return 'Other';
// }
}

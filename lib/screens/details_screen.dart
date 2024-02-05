import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DetailsScreen extends StatelessWidget {
  final String title;
  final String content;
  final String pdfUrl; // Add a field for the PDF URL

  const DetailsScreen({
    required this.title,
    required this.content,
    required this.pdfUrl,
  });

  @override
  Widget build(BuildContext context) {
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
                downloadAndSavePdf(context, pdfUrl);
              },
              child: Text('Download PDF'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> downloadAndSavePdf(BuildContext context, String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Get the local directory for saving the file
      final appDir = await getExternalStorageDirectory();
      final filePath = '${appDir!.path}/$title.pdf';

      // Write the file
      await File(filePath).writeAsBytes(response.bodyBytes);

      print('PDF downloaded and saved at: $filePath');

      // Display a confirmation dialog or navigate to the PDF viewer screen
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
  }
}
}

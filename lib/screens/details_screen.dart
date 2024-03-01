import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Issuance {
  final String title;
  final String content;
  final String pdfUrl;

  Issuance({
    required this.title,
    required this.content,
    required this.pdfUrl,
  });

  factory Issuance.fromJson(Map<String, dynamic> json) {
    return Issuance(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      pdfUrl: json['pdf_url'] ?? '',
    );
  }
}

Future<List<Issuance>> fetchIssuances() async {
  final response = await http
      .get(Uri.parse('https://issuances.dilgbohol.com/api/latest_issuances'));
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Issuance.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load issuances');
  }
}

class DetailsScreen extends StatelessWidget {
  final String title;
  final String content;
  final String pdfUrl;
  final String type; // Add type parameter

  const DetailsScreen({
    required this.title,
    required this.content,
    required this.pdfUrl,
    required this.type, // Add this line
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
            SizedBox(height: 10),
            PdfPreview(url: pdfUrl),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                downloadAndSavePdf(context, pdfUrl, title);
              },
              child: Text('Download PDF'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> downloadAndSavePdf(
      BuildContext context, String url, String title) async {
    showDialog(
      context: context,
      barrierDismissible: false,
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
      final directoryPath = '${appDir!.path}/PDFs';
      final sanitizedTitle = title.replaceAll(
          '/', '-'); // Replace "/" with "-" in order to download
      final filePath = '$directoryPath/$sanitizedTitle.pdf';

      final file = File(filePath);
      if (await file.exists()) {
        Navigator.of(context).pop(); // Close the loading dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('File Already Downloaded'),
              content: Text(
                  'The PDF has already been downloaded and saved locally.'),
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
        final directory = Directory(directoryPath);
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        await file.writeAsBytes(response.bodyBytes);

        print('PDF downloaded and saved at: $filePath');

        Navigator.of(context).pop(); // Close the loading dialog

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
      Navigator.of(context).pop(); // Close the loading dialog
    }
  }
}

class PdfPreview extends StatelessWidget {
  final String url;

  const PdfPreview({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: _loadPdfFromUrl(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Previewing PDF...',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading PDF: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return Expanded(
            child: PDFView(
              filePath: snapshot.data!.path,
              pageSnap: true,
              swipeHorizontal: true,
              autoSpacing: true,
              pageFling: true,
              onError: (error) {
                print('Error loading PDF: $error');
              },
            ),
          );
        } else {
          return Center(child: Text('Unknown error occurred'));
        }
      },
    );
  }

  Future<File> _loadPdfFromUrl(String url) async {
    final filename = url.split('/').last;
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$filename';
    final file = File(filePath);

    if (await file.exists()) {
      return file;
    } else {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        throw Exception('Failed to load PDF: ${response.statusCode}');
      }
    }
  }
}

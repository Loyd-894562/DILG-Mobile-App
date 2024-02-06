import 'package:flutter/material.dart';

class DownloadedFilesScreen extends StatelessWidget {
  final List<String> downloadedFiles;

  const DownloadedFilesScreen({
    Key? key,
    required this.downloadedFiles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloaded Files'),
      ),
      body: ListView.builder(
        itemCount: downloadedFiles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(downloadedFiles[index]),
            onTap: () {
              // You can perform any action here when a file is tapped
              // For example, open the PDF viewer
              // openPdfViewer(context, downloadedFiles[index]);
            },
          );
        },
      ),
    );
  }
}

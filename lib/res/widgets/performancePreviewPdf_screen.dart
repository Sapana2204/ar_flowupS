import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:my_new_project/res/widgets/performancePdf_service.dart';
import 'package:printing/printing.dart';

class PerformancePdfPreviewScreen extends StatelessWidget {
  final Uint8List pdfBytes;
  final String fileName;

  const PerformancePdfPreviewScreen({
    super.key,
    required this.pdfBytes,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Performance Report PDF"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              await PerformancePdfService.downloadPdf(
                pdfBytes: pdfBytes,
                fileName: fileName,
              );

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("PDF downloaded successfully")),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              await PerformancePdfService.sharePdf(
                pdfBytes: pdfBytes,
                fileName: fileName,
              );
            },
          ),
        ],
      ),
      body: PdfPreview(
        build: (format) async => pdfBytes,
        allowPrinting: true,
        allowSharing: false, // because you already have custom share button
        canChangePageFormat: false,
        canDebug: false,
      ),
    );
  }
}
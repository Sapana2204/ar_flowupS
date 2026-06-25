import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../../viewmodel/workPerformance_viewmodel.dart';

class PerformancePdfService {
  static Future<Uint8List> generatePerformanceReportPdf({
    required WorkPerformanceViewModel vm,
  }) async {
    final pdf = pw.Document();

    /// PAGE 1 → Summary + Ticket details
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
          pw.Text(
            'Performance Report',
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 16),

          /// Employee details
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "Selected User",
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  vm.user?.name ?? "-",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                if ((vm.user?.email ?? '').isNotEmpty)
                  pw.Text(
                    vm.user!.email!,
                    style: pw.TextStyle(
                      fontSize: 11,
                      color: PdfColors.grey700,
                    ),
                  ),
              ],
            ),
          ),

          pw.SizedBox(height: 20),

          /// Summary
          pw.Text(
            "Summary",
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),

          pw.Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _summaryBox("Assigned", "${vm.assigned}"),
              _summaryBox("Closed", "${vm.closed}"),
              _summaryBox("Pending", "${vm.pending}"),
              _summaryBox("Delegated", "${vm.delegated}"),
              _summaryBox("Overdue", "${vm.overdue}"),
              _summaryBox("Avg Resolution", "${vm.avgResolutionTime} hrs"),
              _summaryBox("Productivity", "${vm.productivityScore}"),
            ],
          ),

          pw.SizedBox(height: 24),

          /// Ticket Details
          pw.Text(
            "Filtered Ticket Details",
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),

          if (vm.tickets.isEmpty)
            pw.Text("No ticket data available")
          else
            pw.TableHelper.fromTextArray(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
              cellStyle: const pw.TextStyle(fontSize: 9),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey200,
              ),
              columnWidths: {
                0: const pw.FlexColumnWidth(1.3),
                1: const pw.FlexColumnWidth(2.2),
                2: const pw.FlexColumnWidth(1.3),
                3: const pw.FlexColumnWidth(1.2),
                4: const pw.FlexColumnWidth(1.6),
                5: const pw.FlexColumnWidth(1.6),
                6: const pw.FlexColumnWidth(1.2),
              },
              headers: const [
                'Ticket No',
                'Customer',
                'Status',
                'Priority',
                'Assigned',
                'Due',
                'Time',
              ],
              data: vm.tickets.map((ticket) {
                return [
                  ticket.ticketNo ?? '-',
                  ticket.customerName ?? '-',
                  ticket.ticketStatus ?? '-',
                  ticket.ticketPriority ?? '-',
                  ticket.assignedDate ?? '-',
                  ticket.dueDate ?? '-',
                  '${ticket.resolutionTime ?? 0} hrs',
                ];
              }).toList(),
            ),
        ],
      ),
    );

    /// PAGE 2 → Activities
    if (vm.activities.isNotEmpty) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          build: (context) => [
            pw.Text(
              "Activities",
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 12),
            ...vm.activities.map(
                  (activity) => pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 8),
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      activity.createdDate?.toString() ?? '',
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      activity.message?.toString() ?? '',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return pdf.save();
  }

  static Future<File> downloadPdf({
    required Uint8List pdfBytes,
    required String fileName,
  }) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String filePath = '${dir.path}/$fileName';

    final File file = File(filePath);
    await file.writeAsBytes(pdfBytes, flush: true);

    return file;
  }

  static Future<void> sharePdf({
    required Uint8List pdfBytes,
    required String fileName,
  }) async {
    final Directory tempDir = await getTemporaryDirectory();
    final String filePath = '${tempDir.path}/$fileName';

    final File file = File(filePath);
    await file.writeAsBytes(pdfBytes, flush: true);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: fileName,
    );
  }

  static pw.Widget _summaryBox(String title, String value) {
    return pw.Container(
      width: 120,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey700,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
import 'dart:io';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../model/workReport_model.dart';

class WorkReportPdfService {
  static Future<Uint8List> generateWorkReportPdf(
      WorkReportModel report,
      String fromDate,
      String toDate,
      ) async {
    final pdf = pw.Document();

    final summary = report.summary;
    final companies = report.companySummary ?? [];
    final logs = report.data ?? [];

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [

          /// HEADER
          pw.Center(
            child: pw.Text(
              "Work Report",
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),

          pw.SizedBox(height: 5),

          pw.Center(
            child: pw.Text(
              "Report Period : $fromDate to $toDate",
            ),
          ),

          pw.SizedBox(height: 5),

          pw.Center(
            child: pw.Text(
              "Generated On : ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
            ),
          ),

          pw.SizedBox(height: 20),

          /// SUMMARY
          pw.Text(
            "Summary",
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 18,
            ),
          ),

          pw.SizedBox(height: 10),

          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(
                children: [
                  _summaryCell(
                    "Logs",
                    "${summary?.totalLogs ?? 0}",
                  ),
                  _summaryCell(
                    "Time",
                    "${summary?.totalMinutes ?? 0} Min",
                  ),
                  _summaryCell(
                    "Employees",
                    "${summary?.employeeCount ?? 0}",
                  ),
                  _summaryCell(
                    "Tickets",
                    "${summary?.ticketCount ?? 0}",
                  ),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 25),

          /// COMPANY SUMMARY
          pw.Text(
            "Company Summary",
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 18,
            ),
          ),

          pw.SizedBox(height: 10),

          companies.isEmpty
              ? pw.Text("No company summary available")
              : pw.TableHelper.fromTextArray(
            headers: const [
              "Company",
              "Logs",
              "Minutes",
            ],
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 10,
            ),
            cellStyle: const pw.TextStyle(
              fontSize: 9,
            ),
            headerDecoration: const pw.BoxDecoration(
              color: PdfColors.grey300,
            ),
            data: companies.map((e) {
              return [
                e.companyName ?? "-",
                "${e.totalLogs ?? 0}",
                e.totalMinutes ?? "0",
              ];
            }).toList(),
          ),

          pw.SizedBox(height: 25),

          /// WORK LOGS
          pw.Text(
            "Work Logs",
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 18,
            ),
          ),

          pw.SizedBox(height: 10),

          logs.isEmpty
              ? pw.Text("No work logs found")
              : pw.TableHelper.fromTextArray(
            headers: const [
              "Date",
              "Employee",
              "Company",
              "Ticket",
              "Client",
              "Time",
              "Minutes",
              "Details",
            ],
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 8,
            ),
            cellStyle: const pw.TextStyle(
              fontSize: 7,
            ),
            headerDecoration: const pw.BoxDecoration(
              color: PdfColors.grey300,
            ),
            data: logs.map((log) {
              return [
                log.workDate ?? "-",
                log.employeeName ?? "-",
                log.companyName ?? "-",
                log.ticketNo ?? "-",
                log.clientName ?? "-",
                log.workTime ?? "-",
                log.spentMinutes ?? "0",
                log.workDetails ?? "-",
              ];
            }).toList(),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _summaryCell(
      String title,
      String value,
      ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> downloadPdf({
    required Uint8List pdfBytes,
    required String fileName,
  }) async {
    await FileSaver.instance.saveFile(
      name: fileName.replaceAll(".pdf", ""),
      bytes: pdfBytes,
      ext: "pdf",
      mimeType: MimeType.pdf,
    );
  }

  static Future<void> sharePdf({
    required Uint8List pdfBytes,
    required String fileName,
  }) async {
    final dir = await getTemporaryDirectory();

    final file = File("${dir.path}/$fileName");

    await file.writeAsBytes(pdfBytes);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: "Work Report",
    );
  }
}
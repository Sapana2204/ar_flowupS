import 'dart:io';
import 'dart:typed_data';
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../model/customerTicketReport_model.dart';

class PdfService {
  static Future<Uint8List> generateCustomerReportPdf(
      CustomerTicketReportModel report,
      String fromDate,
      String toDate,
      ) async {
    final pdf = pw.Document();

    final customer = report.data?.customer;
    final summary = report.data?.summary;
    final tickets = report.data?.tickets ?? [];
    final products = report.data?.products ?? [];

    debugPrint(
      "Tickets: ${report.data?.tickets?.length}",
    );

    debugPrint(
      "Products: ${report.data?.products?.length}",
    );
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [

          /// HEADER
          pw.Center(
            child: pw.Text(
              "Customer Ticket Report",
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),

          pw.SizedBox(height: 5),


          pw.Center(
            child: pw.Text(
              "Report Period: $fromDate to $toDate",
              style: const pw.TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          pw.SizedBox(height: 5),

          pw.Center(
            child: pw.Text(
              "Generated On: ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
              style: const pw.TextStyle(fontSize: 11),
            ),
          ),

          pw.SizedBox(height: 15),

          /// CUSTOMER DETAILS
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [

                pw.Text(
                  customer?.name ?? "-",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 10),

                pw.Text("Email: ${customer?.email ?? '-'}"),
                pw.Text("Mobile: ${customer?.mobileNo ?? '-'}"),
                pw.Text(
                  "Contact Person: ${customer?.contactPerson ?? '-'}",
                ),
                pw.Text(
                  "AMC End Date: ${customer?.amcEndDate ?? '-'}",
                ),
                pw.Text(
                  "AMC Status: ${customer?.isAmc == 'yes' ? 'AMC' : 'Non AMC'}",
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 20),

          /// SUMMARY
          pw.Text(
            "Summary",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 10),

          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(
                children: [
                  _summaryCell(
                    "Total Tickets",
                    "${summary?.total ?? 0}",
                  ),
                  _summaryCell(
                    "Resolved",
                    "${summary?.resolved ?? 0}",
                  ),
                  _summaryCell(
                    "Pending",
                    "${summary?.pending ?? 0}",
                  ),
                  _summaryCell(
                    "Overdue",
                    "${summary?.overdue ?? 0}",
                  ),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 25),

          /// TICKETS
          pw.Text(
            "Ticket Support Report",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 10),

          if (tickets.isEmpty)
            pw.Text("No tickets found")
          else
            pw.TableHelper.fromTextArray(
              headers: const [
                "Ticket No",
                "Description",
                "Status",
                "Priority",
                "Product",
                "Serial No",
                "Resolver",
                "Start Date",
                "Due Date",
              ],
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 9,
              ),
              cellStyle: const pw.TextStyle(
                fontSize: 8,
              ),
              cellAlignment: pw.Alignment.centerLeft,
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
              data: tickets.map((ticket) {
                final description =
                (ticket.description ?? "").replaceAll(RegExp(r'<[^>]*>'), '').trim();

                return [
                  ticket.ticketNo ?? "-",
                  description.isEmpty ? "-" : description,
                  ticket.ticketStatus ?? "-",
                  ticket.ticketPriority ?? "-",
                  ticket.productName ?? "-",
                  ticket.productSerialNumber ?? "-",
                  ticket.resolverName ?? "-",
                  ticket.startDate ?? "-",
                  ticket.dueDate ?? "-",
                ];
              }).toList(),
            ),

          pw.SizedBox(height: 25),

          /// PRODUCTS
          pw.Text(
            "Customer Products",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 10),

          if (products.isEmpty)
            pw.Text("No products assigned")
          else
            pw.TableHelper.fromTextArray(
              headers: const [
                "Product",
                "Serial Number",
                "Add-ons",
              ],
              data: products.map((product) {
                return [
                  product.productName ?? "-",
                  product.serialNumber ?? "-",
                  (product.addOns ?? []).join(", "),
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
      name: fileName.replaceAll('.pdf', ''),
      bytes: pdfBytes,
      ext: 'pdf',
      mimeType: MimeType.pdf,
    );
  }

  static Future<void> sharePdf({
    required Uint8List pdfBytes,
    required String fileName,
  }) async {
    final tempDir = await getTemporaryDirectory();

    final file = File(
      "${tempDir.path}/$fileName",
    );

    await file.writeAsBytes(pdfBytes);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: "Customer Ticket Report",
    );
  }
}
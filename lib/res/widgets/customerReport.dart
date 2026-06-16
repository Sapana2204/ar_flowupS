import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../model/customerTicketReport_model.dart';

class PdfService {
  static Future<void> generateCustomerReportPdf(
      CustomerTicketReportModel report,
      ) async {
    final pdf = pw.Document();

    final customer = report.data?.customer;
    final summary = report.data?.summary;
    final tickets = report.data?.tickets ?? [];

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              "Customer Ticket Report",
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),

          pw.SizedBox(height: 10),

          pw.Text("Customer : ${customer?.name ?? '-'}"),
          pw.Text("Mobile : ${customer?.mobileNo ?? '-'}"),
          pw.Text("Email : ${customer?.email ?? '-'}"),
          pw.Text(
            "Contact Person : ${customer?.contactPerson ?? '-'}",
          ),

          pw.SizedBox(height: 20),

          pw.Text(
            "Summary",
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 8),

          pw.Row(
            mainAxisAlignment:
            pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text("Total : ${summary?.total ?? 0}"),
              pw.Text("Resolved : ${summary?.resolved ?? 0}"),
              pw.Text("Pending : ${summary?.pending ?? 0}"),
              pw.Text("Overdue : ${summary?.overdue ?? 0}"),
            ],
          ),

          pw.SizedBox(height: 20),

          pw.Text(
            "Tickets",
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 10),

          if (tickets.isEmpty)
            pw.Text("No tickets found")
          else
            pw.Text(
              "Ticket table will be shown here.",
            ),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();

    final file = File(
      "${dir.path}/customer_report_${customer?.customerId}.pdf",
    );

    await file.writeAsBytes(
      await pdf.save(),
    );

    await Share.shareXFiles(
      [XFile(file.path)],
      text: "Customer Ticket Report",
    );
  }
}
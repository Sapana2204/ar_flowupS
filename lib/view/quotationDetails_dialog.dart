import 'package:flutter/material.dart';

import '../model/quotation_model.dart';
import '../utils/app_colors.dart';

class QuotationDetailsDialog extends StatelessWidget {
  final QuotationModel quotation;

  const QuotationDetailsDialog({
    super.key,
    required this.quotation,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 32,
        vertical: isMobile ? 20 : 40,
      ),
      child: Container(
        width: isMobile ? double.infinity : 650,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.92,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 40,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          children: [
            /// HEADER
            _buildHeader(context),

            /// CONTENT
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 18 : 28,
                  vertical: 22,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// BASIC INFORMATION
                    _sectionTitle(
                      icon: Icons.info_outline_rounded,
                      title: "Quotation Information",
                    ),

                    const SizedBox(height: 14),

                    _buildInformationCard(
                      children: [
                        _infoItem(
                          icon: Icons.business_rounded,
                          title: "Company",
                          value: quotation.companyId,
                        ),
                        _infoItem(
                          icon: Icons.person_outline_rounded,
                          title: "Lead",
                          value: quotation.leadId,
                        ),
                        _infoItem(
                          icon: Icons.person_rounded,
                          title: "Customer",
                          value: quotation.customerId,
                        ),
                        if (quotation.contactId != null &&
                            quotation.contactId!.isNotEmpty)
                          _infoItem(
                            icon: Icons.phone_outlined,
                            title: "Contact",
                            value: quotation.contactId!,
                          ),
                        if (quotation.ticketId != null &&
                            quotation.ticketId!.isNotEmpty)
                          _infoItem(
                            icon: Icons.confirmation_number_outlined,
                            title: "Ticket",
                            value: quotation.ticketId!,
                          ),
                      ],
                    ),

                    const SizedBox(height: 26),

                    /// DATE INFORMATION
                    _sectionTitle(
                      icon: Icons.calendar_month_rounded,
                      title: "Dates",
                    ),

                    const SizedBox(height: 14),

                    _buildDateCard(),

                    const SizedBox(height: 26),

                    /// AMOUNT
                    _sectionTitle(
                      icon: Icons.payments_outlined,
                      title: "Quotation Summary",
                    ),

                    const SizedBox(height: 14),

                    _buildAmountSection(),

                    /// NOTES
                    if (quotation.notes.isNotEmpty) ...[
                      const SizedBox(height: 26),

                      _sectionTitle(
                        icon: Icons.sticky_note_2_outlined,
                        title: "Notes",
                      ),

                      const SizedBox(height: 14),

                      _buildTextCard(
                        icon: Icons.notes_rounded,
                        text: quotation.notes,
                      ),
                    ],

                    /// TERMS
                    if (quotation.terms.isNotEmpty) ...[
                      const SizedBox(height: 26),

                      _sectionTitle(
                        icon: Icons.gavel_rounded,
                        title: "Terms & Conditions",
                      ),

                      const SizedBox(height: 14),

                      _buildTextCard(
                        icon: Icons.description_outlined,
                        text: quotation.terms,
                      ),
                    ],

                    const SizedBox(height: 26),

                    /// AUDIT INFORMATION
                    _sectionTitle(
                      icon: Icons.history_rounded,
                      title: "Record Information",
                    ),

                    const SizedBox(height: 14),

                    _buildInformationCard(
                      children: [
                        _infoItem(
                          icon: Icons.person_outline_rounded,
                          title: "Created By",
                          value: quotation.createdBy,
                        ),
                        _infoItem(
                          icon: Icons.access_time_rounded,
                          title: "Created Date",
                          value: _formatDateTime(
                            quotation.createdDate,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            /// FOOTER
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 22, 18, 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primary,
            primary.withOpacity(0.88),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Icon
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.18),
              ),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),

          const SizedBox(width: 14),

          /// Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Quotation Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  quotation.quotationNo.isEmpty
                      ? "Quotation"
                      : quotation.quotationNo,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.78),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          /// Status
          _statusChip(
            quotation.quotationStatus,
            isHeader: true,
          ),

          const SizedBox(width: 8),

          /// Close
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION TITLE
  // ---------------------------------------------------------------------------

  Widget _sectionTitle({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            icon,
            size: 17,
            color: primary,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // INFORMATION CARD
  // ---------------------------------------------------------------------------

  Widget _buildInformationCard({
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE7EAF0),
        ),
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Divider(
                  height: 1,
                  color: Colors.grey.shade200,
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _infoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            color: primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            color: primary,
            size: 19,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11.5,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value.isEmpty ? "-" : value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // DATE CARD
  // ---------------------------------------------------------------------------

  Widget _buildDateCard() {
    final validColor = getValidUntilColor(
      quotation.validUntil,
    );

    return Row(
      children: [
        Expanded(
          child: _dateItem(
            icon: Icons.event_outlined,
            title: "Quotation Date",
            value: _formatDate(
              quotation.quotationDate,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _dateItem(
            icon: Icons.event_available_rounded,
            title: "Valid Until",
            value: _formatDate(
              quotation.validUntil,
            ),
            valueColor: validColor,
          ),
        ),
      ],
    );
  }

  Widget _dateItem({
    required IconData icon,
    required String title,
    required String value,
    Color valueColor = const Color(0xFF1E293B),
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE7EAF0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 17,
                color: primary,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Text(
            value.isEmpty ? "-" : value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // AMOUNT SECTION
  // ---------------------------------------------------------------------------

  Widget _buildAmountSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5E9F0),
        ),
      ),
      child: Column(
        children: [
          _amountRow(
            "Subtotal",
            quotation.subtotal,
          ),

          const SizedBox(height: 14),

          _amountRow(
            "Discount",
            quotation.discountTotal,
            valueColor: Colors.orange.shade700,
            prefix: "- ",
          ),

          const SizedBox(height: 14),

          _amountRow(
            "Tax",
            quotation.taxTotal,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(
              height: 1,
            ),
          ),

          /// GRAND TOTAL
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.07),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.payments_rounded,
                    color: Colors.white,
                    size: 19,
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Text(
                    "Grand Total",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),

                Text(
                  "₹ ${quotation.grandTotal.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _amountRow(
      String title,
      double amount, {
        Color valueColor = const Color(0xFF334155),
        String prefix = "",
      }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Text(
          "$prefix₹ ${amount.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // NOTES / TERMS
  // ---------------------------------------------------------------------------

  Widget _buildTextCard({
    required IconData icon,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE7EAF0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: primary,
              size: 18,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                height: 1.55,
                color: Color(0xFF475569),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FOOTER
  // ---------------------------------------------------------------------------

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close_rounded,
                  size: 19,
                ),
                label: const Text(
                  "Close",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF475569),
                  side: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            flex: 1,
            child: SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      content: Text(
                        "Navigate to Edit ${quotation.quotationNo}",
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 19,
                  color: Colors.white,
                ),
                label: const Text(
                  "Edit Quotation",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STATUS CHIP
  // ---------------------------------------------------------------------------

  Widget _statusChip(
      String status, {
        bool isHeader = false,
      }) {
    Color color;

    switch (status.toLowerCase()) {
      case "approved":
        color = Colors.green;
        break;

      case "rejected":
        color = Colors.red;
        break;

      case "draft":
        color = Colors.blue;
        break;

      case "pending":
        color = Colors.orange;
        break;

      default:
        color = Colors.grey;
    }

    if (isHeader) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.22),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 6,
              width: 6,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              status.isEmpty ? "UNKNOWN" : status.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.isEmpty ? "UNKNOWN" : status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// DATE HELPERS
// -----------------------------------------------------------------------------

Color getValidUntilColor(String date) {
  try {
    final validDate = DateTime.parse(date);

    final now = DateTime.now();

    final validUntil = DateTime(
      validDate.year,
      validDate.month,
      validDate.day,
    );

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    if (validUntil.isBefore(today)) {
      return Colors.red.shade600;
    }

    if (validUntil.isAtSameMomentAs(today)) {
      return Colors.orange.shade700;
    }

    return Colors.green.shade600;
  } catch (_) {
    return Colors.grey;
  }
}

String _formatDate(String value) {
  try {
    final date = DateTime.parse(value);

    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  } catch (_) {
    return value;
  }
}

String _formatDateTime(String value) {
  try {
    final date = DateTime.parse(value);

    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year} "
        "${date.hour.toString().padLeft(2, '0')}:"
        "${date.minute.toString().padLeft(2, '0')}";
  } catch (_) {
    return value;
  }
}
class QuotationModel {
  final int quotationId;
  final String quotationNo;
  final String companyId;
  final String leadId;
  final String customerId;
  final String? contactId;
  final String? ticketId;
  final String quotationDate;
  final String validUntil;
  final String quotationStatus;
  final double subtotal;
  final double discountTotal;
  final double taxTotal;
  final double grandTotal;
  final String notes;
  final String terms;
  final String status;
  final String createdBy;
  final String createdDate;

  QuotationModel({
    required this.quotationId,
    required this.quotationNo,
    required this.companyId,
    required this.leadId,
    required this.customerId,
    this.contactId,
    this.ticketId,
    required this.quotationDate,
    required this.validUntil,
    required this.quotationStatus,
    required this.subtotal,
    required this.discountTotal,
    required this.taxTotal,
    required this.grandTotal,
    required this.notes,
    required this.terms,
    required this.status,
    required this.createdBy,
    required this.createdDate,
  });

  factory QuotationModel.fromJson(Map<String, dynamic> json) {
    return QuotationModel(
      quotationId: json['quotation_id'] ?? 0,
      quotationNo: json['quotation_no'] ?? '',
      companyId: json['company_id'] ?? '',
      leadId: json['lead_id'] ?? '',
      customerId: json['customer_id'] ?? '',
      contactId: json['contact_id']?.toString(),
      ticketId: json['ticket_id']?.toString(),
      quotationDate: json['quotation_date'] ?? '',
      validUntil: json['valid_until'] ?? '',
      quotationStatus: json['quotation_status'] ?? '',
      subtotal: double.tryParse(
        json['subtotal']?.toString() ?? '0',
      ) ??
          0,
      discountTotal: double.tryParse(
        json['discount_total']?.toString() ?? '0',
      ) ??
          0,
      taxTotal: double.tryParse(
        json['tax_total']?.toString() ?? '0',
      ) ??
          0,
      grandTotal: double.tryParse(
        json['grand_total']?.toString() ?? '0',
      ) ??
          0,
      notes: json['notes'] ?? '',
      terms: json['terms'] ?? '',
      status: json['status'] ?? '',
      createdBy: json['created_by'] ?? '',
      createdDate: json['created_date'] ?? '',
    );
  }
}
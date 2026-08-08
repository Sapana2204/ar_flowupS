class QuotationModel {
  final int quotationId;
  final String quotationNo;
  final String customerName;
  final String firmName;
  final String contactNo;
  final String address;
  final String quotationDate;
  final String dueDate;
  final double quotedRate;
  final String status;
  final String description;

  QuotationModel({
    required this.quotationId,
    required this.quotationNo,
    required this.customerName,
    required this.firmName,
    required this.contactNo,
    required this.address,
    required this.quotationDate,
    required this.dueDate,
    required this.quotedRate,
    required this.status,
    required this.description,
  });
}

///--------------------------------------------------------------
/// STATIC DATA
///--------------------------------------------------------------

List<QuotationModel> dummyQuotations = [

  QuotationModel(
    quotationId: 1,
    quotationNo: "QT-2026-001",
    customerName: "ABC Industries",
    firmName: "ABC Engineering Pvt Ltd",
    contactNo: "9876543210",
    address: "MIDC Ambad, Nashik",
    quotationDate: "05 Aug 2026",
    dueDate: "12 Aug 2026",
    quotedRate: 125000,
    status: "Pending",
    description:
    "Supply of industrial automation panels, installation and commissioning.",
  ),

  QuotationModel(
    quotationId: 2,
    quotationNo: "QT-2026-002",
    customerName: "Shree Electricals",
    firmName: "Shree Electrical Works",
    contactNo: "9876543201",
    address: "Satpur, Nashik",
    quotationDate: "04 Aug 2026",
    dueDate: "10 Aug 2026",
    quotedRate: 85000,
    status: "Approved",
    description:
    "Supply of electrical materials and panel accessories.",
  ),

  QuotationModel(
    quotationId: 3,
    quotationNo: "QT-2026-003",
    customerName: "Flowups Technologies",
    firmName: "Flowups Technologies Pvt Ltd",
    contactNo: "9090909090",
    address: "College Road, Nashik",
    quotationDate: "03 Aug 2026",
    dueDate: "08 Aug 2026",
    quotedRate: 65000,
    status: "Pending",
    description:
    "CRM Software Development with Android & iOS Application.",
  ),

  QuotationModel(
    quotationId: 4,
    quotationNo: "QT-2026-004",
    customerName: "SP Traders",
    firmName: "SP Traders",
    contactNo: "9012345678",
    address: "Sinnar, Nashik",
    quotationDate: "02 Aug 2026",
    dueDate: "06 Aug 2026",
    quotedRate: 48000,
    status: "Rejected",
    description:
    "Website Development and Product Catalog Management.",
  ),

  QuotationModel(
    quotationId: 5,
    quotationNo: "QT-2026-005",
    customerName: "Celebration Studio",
    firmName: "Celebration Studio",
    contactNo: "8888888888",
    address: "Panchavati, Nashik",
    quotationDate: "01 Aug 2026",
    dueDate: "15 Aug 2026",
    quotedRate: 172500,
    status: "Approved",
    description:
    "Photography Booking System with Admin Dashboard.",
  ),

  QuotationModel(
    quotationId: 6,
    quotationNo: "QT-2026-006",
    customerName: "Royal Enterprises",
    firmName: "Royal Enterprises",
    contactNo: "9988776655",
    address: "Mumbai Naka, Nashik",
    quotationDate: "31 Jul 2026",
    dueDate: "07 Aug 2026",
    quotedRate: 91500,
    status: "Pending",
    description:
    "Industrial Billing Software with Inventory Module.",
  ),

  QuotationModel(
    quotationId: 7,
    quotationNo: "QT-2026-007",
    customerName: "Green Agro",
    firmName: "Green Agro Solutions",
    contactNo: "9000011111",
    address: "Sinnar MIDC",
    quotationDate: "30 Jul 2026",
    dueDate: "05 Aug 2026",
    quotedRate: 240000,
    status: "Approved",
    description:
    "Agriculture Billing Application with GST Module.",
  ),

  QuotationModel(
    quotationId: 8,
    quotationNo: "QT-2026-008",
    customerName: "Sai Industries",
    firmName: "Sai Industries",
    contactNo: "7777777777",
    address: "Aurangabad Road, Nashik",
    quotationDate: "29 Jul 2026",
    dueDate: "04 Aug 2026",
    quotedRate: 76000,
    status: "Rejected",
    description:
    "Annual Software Maintenance Contract (AMC).",
  ),

];
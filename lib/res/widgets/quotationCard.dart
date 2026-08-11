import 'package:flutter/material.dart';

import '../../model/quotation_model.dart';
import '../../utils/app_colors.dart';

class QuotationCard extends StatelessWidget {
final QuotationModel quotation;
final VoidCallback? onEdit;
final VoidCallback? onView;

const QuotationCard({
super.key,
required this.quotation,
this.onEdit,
this.onView,
});

@override
Widget build(BuildContext context) {
return InkWell(
borderRadius: BorderRadius.circular(14),
onTap: onView,
child: Container(
padding: const EdgeInsets.all(12),
decoration: BoxDecoration(
color: white,
borderRadius: BorderRadius.circular(14),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(.05),
blurRadius: 10,
offset: const Offset(0, 4),
),
],
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [

/// Quotation No + Status + Amount
Row(
children: [

Expanded(
child: Text(
quotation.quotationNo,
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
fontSize: 15,
fontWeight: FontWeight.bold,
),
),
),

_statusTag(
quotation.quotationStatus,
),

const SizedBox(width: 8),

Text(
"₹${quotation.grandTotal.toStringAsFixed(0)}",
style: const TextStyle(
fontSize: 15,
fontWeight: FontWeight.bold,
color: Colors.green,
),
),
],
),

const SizedBox(height: 7),

/// Customer + Company
Row(
children: [

const Icon(
Icons.person_outline,
size: 16,
color: Colors.grey,
),

const SizedBox(width: 5),

Expanded(
child: Text(
quotation.customerId,
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
fontSize: 13,
fontWeight: FontWeight.w600,
),
),
),

const SizedBox(width: 8),

Flexible(
child: Text(
quotation.companyId,
maxLines: 1,
overflow: TextOverflow.ellipsis,
textAlign: TextAlign.right,
style: const TextStyle(
fontSize: 12,
color: Colors.grey,
),
),
),
],
),

const SizedBox(height: 8),

/// Dates
Row(
children: [

const Icon(
Icons.calendar_today_outlined,
size: 14,
color: Colors.grey,
),

const SizedBox(width: 5),

Text(
quotation.quotationDate,
style: const TextStyle(
fontSize: 11,
color: Colors.grey,
),
),

const SizedBox(width: 14),

const Icon(
Icons.event_available_outlined,
size: 14,
color: Colors.grey,
),

const SizedBox(width: 5),

Text(
quotation.validUntil,
style: const TextStyle(
fontSize: 11,
color: Colors.grey,
),
),

const Spacer(),

IconButton(
onPressed: onEdit,
padding: EdgeInsets.zero,
constraints: const BoxConstraints(
minWidth: 30,
minHeight: 30,
),
splashRadius: 18,
icon: const Icon(
Icons.edit_outlined,
color: Colors.blue,
size: 19,
),
),
],
),

const Divider(
height: 12,
thickness: .6,
),

/// Amount Summary
Row(
children: [

Expanded(
child: _info(
"SUBTOTAL",
"₹${quotation.subtotal.toStringAsFixed(0)}",
),
),

Expanded(
child: _info(
"DISCOUNT",
"₹${quotation.discountTotal.toStringAsFixed(0)}",
color: Colors.orange,
),
),

Expanded(
child: _info(
"TAX",
"₹${quotation.taxTotal.toStringAsFixed(0)}",
),
),

Expanded(
child: _info(
"TOTAL",
"₹${quotation.grandTotal.toStringAsFixed(0)}",
color: Colors.green,
),
),
],
),
],
),
),
);
}

Widget _info(
String title,
String value, {
Color color = Colors.black,
}) {
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [

Text(
title,
style: const TextStyle(
fontSize: 9,
color: Colors.grey,
fontWeight: FontWeight.w500,
),
),

const SizedBox(height: 2),

Text(
value,
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: TextStyle(
fontWeight: FontWeight.bold,
color: color,
fontSize: 12,
),
),
],
);
}

Widget _statusTag(String status) {
Color color = Colors.orange;

switch (status.toLowerCase()) {
case "approved":
color = Colors.green;
break;

case "rejected":
color = Colors.red;
break;

case "pending":
color = Colors.orange;
break;

case "draft":
color = Colors.blue;
break;
}

return Container(
padding: const EdgeInsets.symmetric(
horizontal: 8,
vertical: 4,
),
decoration: BoxDecoration(
color: color.withOpacity(.12),
borderRadius: BorderRadius.circular(15),
),
child: Text(
status.toUpperCase(),
style: TextStyle(
color: color,
fontWeight: FontWeight.bold,
fontSize: 9,
),
),
);
}
}


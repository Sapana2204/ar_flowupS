import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/createVisit_model.dart';
import '../utils/app_colors.dart';
import '../viewModel/login_viewmodel.dart';
import '../viewmodel/tickets_viewmodel.dart';

class TicketVisitDialog extends StatefulWidget {
  final int ticketId;

  const TicketVisitDialog({
    super.key,
    required this.ticketId,
  });

  @override
  State<TicketVisitDialog> createState() =>
      _TicketVisitDialogState();
}

class _TicketVisitDialogState
    extends State<TicketVisitDialog> {
  late DateTime selectedDateTime;

  final TextEditingController detailsController =
  TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedDateTime = DateTime.now();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime:
      TimeOfDay.fromDateTime(selectedDateTime),
    );

    if (time == null) return;

    setState(() {
      selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  String get formattedDate {
    return "${selectedDateTime.day.toString().padLeft(2, '0')}-"
        "${selectedDateTime.month.toString().padLeft(2, '0')}-"
        "${selectedDateTime.year} "
        "${selectedDateTime.hour.toString().padLeft(2, '0')}:"
        "${selectedDateTime.minute.toString().padLeft(2, '0')}";
  }

  String formatDateTime(DateTime date) {
    return "${date.year}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')} "
        "${date.hour.toString().padLeft(2, '0')}:"
        "${date.minute.toString().padLeft(2, '0')}:00";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.only(
          bottom:
          MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 550,
            maxHeight: 700,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Schedule Visit",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Ticket Visit",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            Navigator.pop(context),
                        icon:
                        const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                Padding(
                  padding:
                  const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "VISIT DATE & TIME",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                          FontWeight.w700,
                          color: Colors.blueGrey,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        readOnly: true,
                        controller:
                        TextEditingController(
                          text: formattedDate,
                        ),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.calendar_today,
                            ),
                            onPressed:
                            _pickDateTime,
                          ),
                          border:
                          OutlineInputBorder(
                            borderRadius:
                            BorderRadius
                                .circular(8),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        "VISIT DETAILS",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                          FontWeight.w700,
                          color: Colors.blueGrey,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller:
                        detailsController,
                        maxLines: 5,
                        decoration:
                        InputDecoration(
                          hintText:
                          "Enter visit details",
                          border:
                          OutlineInputBorder(
                            borderRadius:
                            BorderRadius
                                .circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                Padding(
                  padding:
                  const EdgeInsets.all(14),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.end,
                    children: [

                      OutlinedButton(
                        onPressed: () =>
                            Navigator.pop(
                                context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: primary,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Consumer2<
                          TicketsViewModel,
                          LoginViewModel>(
                        builder: (
                            _,
                            ticketVm,
                            loginVm,
                            __,
                            ) {
                          return ElevatedButton
                              .icon(
                            style:
                            ElevatedButton
                                .styleFrom(
                              backgroundColor:
                              primary,
                            ),
                            onPressed: ticketVm
                                .createVisitLoading
                                ? null
                                : () async {

                              if (detailsController
                                  .text
                                  .trim()
                                  .isEmpty) {
                                ScaffoldMessenger.of(
                                    context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please enter visit details",
                                    ),
                                  ),
                                );
                                return;
                              }

                              final user =
                                  loginVm
                                      .userData;

                              if (user ==
                                  null) {
                                return;
                              }

                              final request =
                              CreateVisitModel(
                                ticketId:
                                widget
                                    .ticketId,
                                employeeId:
                                user
                                    .adminId,
                                visitScheduledAt:
                                formatDateTime(
                                  selectedDateTime,
                                ),
                                visitDetails:
                                detailsController
                                    .text
                                    .trim(),
                              );

                              final success =
                              await ticketVm
                                  .createVisit(
                                request,
                              );

                              if (!context
                                  .mounted) {
                                return;
                              }

                              ScaffoldMessenger
                                  .of(
                                  context)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? "Visit Scheduled Successfully"
                                        : "Failed to Schedule Visit",
                                  ),
                                ),
                              );

                              if (success) {
                                Navigator.pop(
                                    context);
                              }
                            },
                            icon: ticketVm
                                .createVisitLoading
                                ? const SizedBox(
                              width: 16,
                              height: 16,
                              child:
                              CircularProgressIndicator(
                                strokeWidth:
                                2,
                                color: Colors
                                    .white,
                              ),
                            )
                                : const Icon(
                              Icons
                                  .event_available,
                            ),
                            label: Text(
                              ticketVm
                                  .createVisitLoading
                                  ? "Scheduling..."
                                  : "Schedule Visit",
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    detailsController.dispose();
    super.dispose();
  }
}
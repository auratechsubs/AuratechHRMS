import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';
import '../controllers/attendance_controller.dart';
import '../models/attendance_models.dart';

/// CalendarView उपस्थिति को महीने की ग्रिड में दिखाता है।
class CalendarView extends StatelessWidget {
  CalendarView({super.key});

  final DateTime _focusedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );

  @override
  Widget build(BuildContext context) {
    final AttendanceController controller = Get.find<AttendanceController>();
    final List<AttendanceDay> monthRecords = controller.attendanceForMonth(
      _focusedMonth,
    );

    return Scaffold(
      appBar: AppBar(title: Text('calendar'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMM().format(_focusedMonth),
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 12),
            _buildLegend(context),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: DateUtils.getDaysInMonth(
                  _focusedMonth.year,
                  _focusedMonth.month,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final dayDate = DateTime(
                    _focusedMonth.year,
                    _focusedMonth.month,
                    index + 1,
                  );
                  AttendanceDay? dayRecord;
                  for (final record in monthRecords) {
                    if (record.date.year == dayDate.year &&
                        record.date.month == dayDate.month &&
                        record.date.day == dayDate.day) {
                      dayRecord = record;
                      break;
                    }
                  }
                  final status = dayRecord?.status ?? AttendanceStatus.absent;
                  final chekinTime =
                      dayRecord?.checkIn ?? AttendanceStatus.absent;
                  final chekoutTime =
                      dayRecord?.checkOut ?? AttendanceStatus.absent;
                  final breakentries =
                      dayRecord?.breaks.map((t) => t.start) ??
                      AttendanceStatus.absent;
                  final color = _statusColor(context, status);
                  return InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          final formattedCheckIn = chekinTime is DateTime
                              ? TimeOfDay.fromDateTime(
                                  chekinTime,
                                ).format(context)
                              : '-';
                          final formattedCheckOut = chekoutTime is DateTime
                              ? TimeOfDay.fromDateTime(
                                  chekoutTime,
                                ).format(context)
                              : '-';
                          final breakStartTimes =
                              breakentries is Iterable<DateTime>
                              ? breakentries
                                    .map(
                                      (e) => TimeOfDay.fromDateTime(
                                        e,
                                      ).format(context),
                                    )
                                    .join(', ')
                              : '-';

                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            insetPadding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 24,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: SingleChildScrollView(
                                // Scrollable if content overflows
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Selected Date",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "${dayDate.day}-${dayDate.month}-${dayDate.year}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(color: Colors.blueAccent),
                                      textAlign: TextAlign.center,
                                    ),
                                    const Divider(height: 30, thickness: 1),
                                    _infoRow(
                                      context,
                                      'Checked In Time:',
                                      formattedCheckIn,
                                    ),
                                    _infoRow(
                                      context,
                                      'Checked Out Time:',
                                      formattedCheckOut,
                                    ),
                                    _infoRow(
                                      context,
                                      'Break Entries:',
                                      breakStartTimes,
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      "Status: ${_statusLabel(status)}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w600,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [




                                    TextButton(
                                        onPressed: () async {
                              print("Saving as PDF...");

                              // 1. Create a new PDF document
                              final pdf = pw.Document();

                              // 2. Add page content (based on your dialog data)
                              pdf.addPage(
                              pw.Page(
                              pageFormat: PdfPageFormat.a4,
                              build: (pw.Context context) {
                              return pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                              pw.Center(
                              child: pw.Text(
                              'Attendance Details',
                              style: pw.TextStyle(
                              fontSize: 22,
                              fontWeight: pw.FontWeight.bold,
                              ),
                              ),
                              ),
                              pw.SizedBox(height: 20),
                              pw.Text('Selected Date: ${dayDate.day}-${dayDate.month}-${dayDate.year}'),
                              pw.Text('Checked In Time: $formattedCheckIn'),
                              pw.Text('Checked Out Time: $formattedCheckOut'),
                              pw.Text('Break Entries: $breakStartTimes'),
                              pw.Text('Status: ${_statusLabel(status)}'),
                              ],
                              );
                              },
                              ),
                              );

                              // 3. Save the PDF to local storage
                              final dir = await getApplicationDocumentsDirectory();
                              final file = File('${dir.path}/attendance_${dayDate.day}_${dayDate.month}_${dayDate.year}.pdf');
                              await file.writeAsBytes(await pdf.save());

                              // 4. Open the saved PDF
                              await OpenFilex.open(file.path);

                              print('PDF saved to: ${file.path}');
                              },
                                child: const Text(
                                  "Save as PDF",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),

                              // TextButton(
                                        //   onPressed: (){
                                        //     print("Saving as PDF...");
                                        //     // Implement PDF saving functionality here
                                        //
                                        //   },
                                        //   child: const Text(
                                        //     "Save as pdf",
                                        //     style: TextStyle(fontSize: 16),
                                        //   ),
                                        // ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text(
                                            "Close",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),

                                      ],
                                    )
                                    // Align(
                                    //   alignment: Alignment.centerRight,
                                    //   child:
                                    //   TextButton(
                                    //     onPressed: () => Navigator.pop(context),
                                    //     child: const Text(
                                    //       "Close",
                                    //       style: TextStyle(fontSize: 16),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },

                    child: Container(
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: color.withOpacity(0.4)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${dayDate.day}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _statusLabel(status),
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(value, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    final items = <Map<String, dynamic>>[
      {
        'label': 'Present',
        'color': _statusColor(context, AttendanceStatus.present),
      },
      {'label': 'Late', 'color': _statusColor(context, AttendanceStatus.late)},
      {
        'label': 'Half Day',
        'color': _statusColor(context, AttendanceStatus.halfDay),
      },
      {
        'label': 'Auto',
        'color': _statusColor(context, AttendanceStatus.autoCheckout),
      },
      {
        'label': 'Absent',
        'color': _statusColor(context, AttendanceStatus.absent),
      },
    ];
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: items
          .map(
            (item) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 6),
                Text(item['label'] as String),
              ],
            ),
          )
          .toList(),
    );
  }

  Color _statusColor(BuildContext context, AttendanceStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (status) {
      AttendanceStatus.present => colorScheme.primary,
      AttendanceStatus.late => colorScheme.tertiary,
      AttendanceStatus.halfDay => colorScheme.error,
      AttendanceStatus.autoCheckout => colorScheme.secondary,
      AttendanceStatus.absent => colorScheme.outline,
    };
  }

  String _statusLabel(AttendanceStatus status) {
    return switch (status) {
      AttendanceStatus.present => 'On time',
      AttendanceStatus.late => 'Late',
      AttendanceStatus.halfDay => 'Half',
      AttendanceStatus.autoCheckout => 'Auto',
      AttendanceStatus.absent => '—',
    };
  }
}

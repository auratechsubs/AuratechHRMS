import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:get/get.dart';

import '../modules/attendance/models/attendance_models.dart';


class ExcelExportService extends GetxService {
  Uint8List buildMisReport({
    required EmployeeModel employee,
    required List<AttendanceDay> records,
  }) {
    final Excel excel = Excel.createExcel();
    final Sheet sheet = excel['Attendance'];
    sheet.appendRow(<String>[
      'Date',
      'Employee Code',
      'Employee Name',
      'Department',
      'Shift (Start-End)',
      'Check-in',
      'Check-out',
      'Total Work (hh:mm)',
      'Total Break (hh:mm)',
      'Late (Y/N)',
      'Half Day (Y/N)',
      'Overtime (hh:mm)',
      'Status',
      'Auto Checkout (Y/N)',
      'Location',
      'Manager',
      'Notes',
    ]);

    for (final AttendanceDay day in records) {
      sheet.appendRow(<String>[
        _formatDate(day.date),
        employee.code,
        employee.name,
        employee.department,
        '${employee.shift.start.hour.toString().padLeft(2, '0')}:${employee.shift.start.minute.toString().padLeft(2, '0')}'
        '-${employee.shift.end.hour.toString().padLeft(2, '0')}:${employee.shift.end.minute.toString().padLeft(2, '0')}',
        day.checkIn?.toIso8601String() ?? '-',
        day.checkOut?.toIso8601String() ?? '-',
        _formatDuration(day.totalWorkDuration),
        _formatDuration(day.totalBreakDuration),
        day.status == AttendanceStatus.late ? 'Y' : 'N',
        day.status == AttendanceStatus.halfDay ? 'Y' : 'N',
        '-',
        day.status.name,
        day.autoCheckoutApplied ? 'Y' : 'N',
        employee.location,
        employee.managerName,
        day.notes ?? '-',
      ]);
    }

    return Uint8List.fromList(excel.encode()!);
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  String _formatDuration(Duration duration) {
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}

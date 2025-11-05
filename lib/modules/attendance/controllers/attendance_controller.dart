import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../services/biometric_service.dart';
import '../../../services/excel_export_service.dart';
import '../../../services/face_recognition_service.dart';
import '../../../services/offline_queue_service.dart';
import '../../../services/policy_service.dart';
import '../../../services/storage_service.dart';
import '../models/attendance_models.dart';

/// AttendanceController चेक-इन, ब्रेक और चेकआउट की पूरी स्टेट मैनेजमेंट करता है।
class AttendanceController extends GetxController {
  AttendanceController({
    required StorageService storageService,
    required PolicyService policyService,
    required BiometricService biometricService,
    required FaceRecognitionService faceRecognitionService,
    required OfflineQueueService offlineQueueService,
    required ExcelExportService excelExportService,
  })  : _storageService = storageService,
        _policyService = policyService,
        _biometricService = biometricService,
        _faceRecognitionService = faceRecognitionService,
        _offlineQueueService = offlineQueueService,
        _excelExportService = excelExportService;

  final StorageService _storageService;
  final PolicyService _policyService;
  final BiometricService _biometricService;
  final FaceRecognitionService _faceRecognitionService;
  final OfflineQueueService _offlineQueueService;
  final ExcelExportService _excelExportService;

  final RxList<EmployeeModel> employees = <EmployeeModel>[].obs;
  final RxMap<String, List<AttendanceDay>> _attendance =
      <String, List<AttendanceDay>>{}.obs;
  final RxList<RegularizationRequest> requests =
      <RegularizationRequest>[].obs;

  int get pendingQueueLength => _offlineQueueService.queueLength;

  EmployeeModel? get primaryEmployee =>
      employees.isNotEmpty ? employees.first : null;

  AttendanceDay? get todayRecord {
    if (primaryEmployee == null) return null;
    final records = _attendance[primaryEmployee!.id] ?? <AttendanceDay>[];
    final now = DateTime.now();
    for (final day in records) {
      if (day.date.year == now.year &&
          day.date.month == now.month &&
          day.date.day == now.day) {
        return day;
      }
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    employees.assignAll(_storageService.readEmployees());
    _attendance.assignAll(_storageService.readAttendance());
    requests.assignAll(_storageService.readRequests());
    _policyService.loadPolicy(_storageService.readPolicy());
  }

  /// दिन की रिकॉर्ड लिस्ट को सुनिश्चित करने वाला प्राइवेट हेल्पर।
  List<AttendanceDay> _recordsFor(String employeeId) {
    return _attendance.putIfAbsent(employeeId, () => <AttendanceDay>[]);
  }

  AttendanceDay _ensureTodayRecord(EmployeeModel employee) {
    final today = DateTime.now();
    final records = _recordsFor(employee.id);
    final normalizedToday = DateTime(today.year, today.month, today.day);
    AttendanceDay? existing;
    for (final record in records) {
      if (record.date.year == normalizedToday.year &&
          record.date.month == normalizedToday.month &&
          record.date.day == normalizedToday.day) {
        existing = record;
        break;
      }
    }
    if (existing != null) {
      return existing;
    }
    final newDay = AttendanceDay(date: normalizedToday);
    records.add(newDay);
    return newDay;
  }

  /// किसी खास महीने के सभी रिकॉर्ड उपलब्ध कराता है।
  List<AttendanceDay> attendanceForMonth(DateTime month) {
    final employee = primaryEmployee;
    if (employee == null) return <AttendanceDay>[];
    final records = _attendance[employee.id] ?? <AttendanceDay>[];
    return records
        .where((day) => day.date.year == month.year && day.date.month == month.month)
        .toList();
  }

  List<AttendanceDay> attendanceForDate(DateTime date) {
    final employee = primaryEmployee;
    if (employee == null) return <AttendanceDay>[];
    final records = _attendance[employee.id] ?? <AttendanceDay>[];
    return records
        .where((day) =>
            day.date.year == date.year &&
            day.date.month == date.month &&
            day.date.day == date.day)
        .toList();
  }

  Future<void> _persist() async {


    await _storageService.writeEmployees(employees);
    await _storageService.writeAttendance(_attendance);
    await _storageService.writeRequests(requests);
    await _storageService.writePolicy(_policyService.policy);
  }

  /// फेस व फिंगरप्रिंट दोनों की नीतियों के अनुसार जांच।
  Future<bool> _runBiometricChecks(EmployeeModel employee) async {
    // print('running biometric...');
    // if (!await _runBiometricChecks(employee));
    // print('biometric ok');
    // final day = _ensureTodayRecord(employee);
    // print('day record: $day');

    final policy = _policyService.policy;
    if (policy.faceRequired && !await _faceRecognitionService.captureAndValidateFace()) {
      Get.snackbar('Face', 'चेहरा प्रमाणीकरण विफल रहा।');
      return false;
    }
    if (policy.fingerprintRequired && !await _biometricService.authenticateFingerprint()) {
      Get.snackbar('Fingerprint', 'फिंगरप्रिंट प्रमाणीकरण असफल।');
      return false;
    }
    return true;
  }

  Future<void> performCheckIn() async {
    final employee = primaryEmployee;
    if (employee == null) return;
    if (!await _runBiometricChecks(employee)) return;

    final day = _ensureTodayRecord(employee);
    if (day.checkIn != null) {
      Get.snackbar('Check-in', 'आज का चेक-इन पहले से दर्ज है।');
      return;
    }
    final now = DateTime.now();
    print(now);
    final status = _policyService.resolveStatus(
      checkIn: now,
      shift: employee.shift,
    );
    final updatedDay = AttendanceDay(
      date: day.date,
      checkIn: now,
      status: status,
      breaks: day.breaks,
      autoCheckoutApplied: false,
      notes: status == AttendanceStatus.halfDay
          ? 'Late beyond 10:30'
          : status == AttendanceStatus.late
              ? 'Within grace exceeded'
              : null,
    );
print(updatedDay);
    _replaceDay(employee.id, updatedDay);
    print('persisting data...');
    await _persist();
    print('done persist');  }

  Future<void> startBreak() async {
    final employee = primaryEmployee;
    if (employee == null) return;
    final day = _ensureTodayRecord(employee);
    if (day.checkIn == null) {
      Get.snackbar('Break', 'पहले चेक-इन करें।');
      return;
    }
    if (day.breaks.isNotEmpty && day.breaks.last.end == null) {
      Get.snackbar('Break', 'ब्रेक पहले से जारी है।');
      return;
    }
    final policy = employee.shift.breakPolicy;
    if (day.breaks.length >= policy.maxBreaks) {
      Get.snackbar('Break', 'मैक्स ब्रेक लिमिट पूरी हुई।');
      return;
    }
    final updatedBreaks = List<BreakPeriod>.from(day.breaks)
      ..add(BreakPeriod(start: DateTime.now()));
    _replaceDay(employee.id, AttendanceDay(
      date: day.date,
      checkIn: day.checkIn,
      status: day.status,
      breaks: updatedBreaks,
      autoCheckoutApplied: day.autoCheckoutApplied,
      notes: day.notes,
    ));
    await _persist();
  }

  Future<void> endBreak() async {
    final employee = primaryEmployee;
    if (employee == null) return;
    final day = _ensureTodayRecord(employee);
    if (day.breaks.isEmpty || day.breaks.last.end != null) {
      Get.snackbar('Break', 'कोई सक्रिय ब्रेक नहीं मिला।');
      return;
    }
    final updatedBreaks = List<BreakPeriod>.from(day.breaks);
    updatedBreaks[updatedBreaks.length - 1] = BreakPeriod(
      start: updatedBreaks.last.start,
      end: DateTime.now(),
    );
    _replaceDay(employee.id, AttendanceDay(
      date: day.date,
      checkIn: day.checkIn,
      status: day.status,
      breaks: updatedBreaks,
      autoCheckoutApplied: day.autoCheckoutApplied,
      notes: day.notes,
    ));
    await _persist();
  }

  Future<void> performCheckOut() async {
    final employee = primaryEmployee;
    if (employee == null) return;
    if (!await _runBiometricChecks(employee)) return;

    final day = _ensureTodayRecord(employee);
    if (day.checkIn == null) {
      Get.snackbar('Checkout', 'पहले चेक-इन करें।');
      return;
    }
    if (day.breaks.isNotEmpty && day.breaks.last.end == null) {
      Get.snackbar('Checkout', 'ब्रेक चल रहा है, पहले समाप्त करें।');
      return;
    }
    final updatedDay = AttendanceDay(
      date: day.date,
      checkIn: day.checkIn,
      checkOut: DateTime.now(),
      status: day.status,
      breaks: day.breaks,
      autoCheckoutApplied: false,
      notes: day.notes,
    );
    _replaceDay(employee.id, updatedDay);
    await _persist();
  }

  Future<void> raiseRegularization({
    required DateTime date,
    required String type,
    required DateTime from,
    required DateTime to,
    required String reason,
    String? evidence,
  }) async {
    final employee = primaryEmployee;
    if (employee == null) return;
    final request = RegularizationRequest(
      id: const Uuid().v4(),
      employeeId: employee.id,
      date: date,
      type: type,
      fromTime: from,
      toTime: to,
      reason: reason,
      evidence: evidence,
    );
    requests.add(request);
    await _persist();
  }

  Future<Uint8List?> downloadMisReport() async {
    final employee = primaryEmployee;
    print(employee);
    if (employee == null) return null;
    final records = _attendance[employee.id] ?? <AttendanceDay>[];
    print(records);

    return _excelExportService.buildMisReport(
      employee: employee,
      records: records,
    );
  }

  void _replaceDay(String employeeId, AttendanceDay updated) {
    final records = _recordsFor(employeeId);
    final index = records.indexWhere((day) =>
        day.date.year == updated.date.year &&
        day.date.month == updated.date.month &&
        day.date.day == updated.date.day);
    if (index == -1) {
      records.add(updated);
    } else {
      records[index] = updated;
    }
    _attendance[employeeId] = records;
  }

  /// ऑफलाइन कतार में पेंडिंग रहने पर उसे पर्सिस्ट करना।
  Future<void> queueForSync() async {
    final employee = primaryEmployee;
    if (employee == null) return;
    final record = todayRecord;
    if (record == null) return;
    await _offlineQueueService.enqueueAttendanceEvent(
      employeeId: employee.id,
      day: record,
    );
  }
}

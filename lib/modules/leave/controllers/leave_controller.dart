import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/leave_models.dart';
 import 'package:intl/intl.dart';

class LeaveController extends GetxController {
  final requests = <LeaveRequest>[].obs;

  // form state
  final type = LeaveType.casual.obs;
  final causeCtrl = TextEditingController();
  final fromDate = Rx<DateTime?>(null);
  final toDate = Rx<DateTime?>(null);
  final fromTime = const TimeOfDay(hour: 9, minute: 30).obs;
  final toTime = const TimeOfDay(hour: 18, minute: 30).obs;

  final loading = false.obs;

  String fmtD(DateTime d) => DateFormat('EEE, dd MMM').format(d);

  int calcInclusiveDays(DateTime a, DateTime b) =>
      a.difference(DateTime(a.year, a.month, a.day)).inDays +
          b.difference(DateTime(b.year, b.month, b.day)).inDays +
          b.difference(a).inDays +
          1; // inclusive

  Future<void> pickFromDate(BuildContext context) async {
    final now = DateTime.now();
    final initial = fromDate.value ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(now) ? now : initial,
      firstDate: now.subtract(const Duration(days: 0)),
      lastDate: now.add(const Duration(days: 365)),
      helpText: 'Select start date',
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null) {
      fromDate.value = picked;
      // auto adjust toDate if null or before fromDate
      if (toDate.value == null || toDate.value!.isBefore(picked)) {
        toDate.value = picked;
      }
    }
  }

  Future<void> pickToDate(BuildContext context) async {
    final now = DateTime.now();
    final start = fromDate.value ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: toDate.value ?? start,
      firstDate: start,
      lastDate: now.add(const Duration(days: 365)),
      helpText: 'Select end date',
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null) toDate.value = picked;
  }

  Future<void> pickFromTime(BuildContext context) async {
    final t = await showTimePicker(context: context, initialTime: fromTime.value);
    if (t != null) fromTime.value = t;
  }

  Future<void> pickToTime(BuildContext context) async {
    final t = await showTimePicker(context: context, initialTime: toTime.value);
    if (t != null) toTime.value = t;
  }

  String? validate() {
    if (causeCtrl.text.trim().isEmpty) return 'Please enter a reason/cause.';
    if (fromDate.value == null) return 'Please select a start date.';
    if (toDate.value == null) return 'Please select an end date.';
    if (toDate.value!.isBefore(fromDate.value!)) return 'End date can’t be before start date.';
    return null;
  }

  Future<bool> submit() async {
    final err = validate();
    if (err != null) {
      Get.snackbar('Invalid', err);
      return false;
    }

    loading.value = true;
    await Future.delayed(const Duration(milliseconds: 600)); // fake API

    final total = calcInclusiveDays(fromDate.value!, toDate.value!);

    requests.insert(
      0,
      LeaveRequest(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: type.value,
        cause: causeCtrl.text.trim(),
        from: fromDate.value!,
        fromTime: fromTime.value,
        to: toDate.value!,
        toTime: toTime.value,
        totalDays: total,
        status: LeaveStatus.pending,
      ),
    );

    loading.value = false;
    clearForm();
    return true;
  }

  void clearForm() {
    causeCtrl.clear();
    fromDate.value = null;
    toDate.value = null;
    fromTime.value = const TimeOfDay(hour: 9, minute: 30);
    toTime.value = const TimeOfDay(hour: 18, minute: 30);
    type.value = LeaveType.casual;
  }

  @override
  void onClose() {
    causeCtrl.dispose();
    super.onClose();
  }
}

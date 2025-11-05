import 'package:get/get.dart';
import 'package:flutter/material.dart';


class AdminShellController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final RxBool compactMode = false.obs;

  // Global search/filter inputs
  final TextEditingController globalSearchCtrl = TextEditingController();
  final TextEditingController decisionNoteCtrl = TextEditingController();

  // Dashboard KPIs (Rx for live updates)
  final RxInt presentNow = 148.obs;
  final RxInt onBreakNow = 24.obs;
  final RxInt lateArrivals = 18.obs;
  final RxInt missingCheckout = 9.obs;

  // Team table paging
  final RxInt teamPage = 1.obs;
  final RxInt teamPageSize = 10.obs;

  // Requests list filters
  final RxString reqType = 'All'.obs; // Missed In/Out, Late, Other
  final RxString reqStatus = 'Pending'.obs; // Pending/Approved/Rejected
  final Rx<DateTimeRange?> reqRange = Rx<DateTimeRange?>(null);

  // Policies (example)
  final Rx<TimeOfDay> lateCutoff = const TimeOfDay(hour: 10, minute: 30).obs;
  final RxInt graceMinutes = 10.obs;
  final RxBool geoFenceEnabled = false.obs;
  final RxBool qrStationEnabled = false.obs;
  final RxBool faceEnabled = true.obs;
  final RxBool fingerprintEnabled = true.obs;
  final Rx<TimeOfDay> autoCheckout = const TimeOfDay(hour: 20, minute: 0).obs;

  // Theme & i18n toggles (use your AppTheme/AppTranslations)
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  final Rx<Locale> locale = const Locale('en', 'US').obs;

  void setIndex(int i) => currentIndex.value = i;
  void toggleCompact() => compactMode.toggle();

  void applyGlobalSearch(String q) {
    // TODO: call repository search for team/attendance/requests
    // print('Global search: $q');
  }

  // Requests actions
  Future<void> approveRequest(String id, {String? note}) async {
    // TODO: API call, state update + snackbar
  }

  Future<void> rejectRequest(String id, {required String reason}) async {
    // TODO: API call, state update + snackbar
  }

  // Shifts CRUD — only signatures (hook with repository)
  Future<void> createShift(Map<String, dynamic> payload) async {}
  Future<void> updateShift(String id, Map<String, dynamic> payload) async {}
  Future<void> deleteShift(String id) async {}

  // Holidays CRUD
  Future<void> createHoliday(Map<String, dynamic> payload) async {}
  Future<void> importHolidaysCsv(String csvPath) async {}
  Future<void> deleteHoliday(String id) async {}

  // Policies save
  Future<void> savePolicies() async {
    // TODO: persist policies; show success
  }

  // Reports/MIS
  Future<void> exportCompanyMIS(DateTimeRange range) async {
    // TODO: generate xlsx using your ExcelExportService
  }

  // Settings
  void switchTheme(ThemeMode mode) => themeMode.value = mode;
  void switchLocale(Locale l) => locale.value = l;

  @override
  void onClose() {
    globalSearchCtrl.dispose();
    super.onClose();
  }
}

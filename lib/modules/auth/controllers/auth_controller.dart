import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../app/routes/app_routes.dart';
import '../../attendance/models/attendance_models.dart';
import '../models/auth_models.dart';
import '../../../services/storage_service.dart';

/// AuthController लॉगिन, ओटीपी और संगठन चयन की पूरी प्रक्रिया संभालता है।
class AuthController extends GetxController {
  AuthController(this._storageService);

  final StorageService _storageService;
  final Rx<AuthCredentials?> _credentials = Rx<AuthCredentials?>(null);
  final Rx<OrganizationModel?> _organization = Rx<OrganizationModel?>(null);
  final RxBool otpSent = false.obs;
  final RxBool isVerifying = false.obs;

  /// उपलब्ध डमी ऑर्गनाइज़ेशन लिस्ट।
  final List<OrganizationModel> organizations = <OrganizationModel>[
    OrganizationModel(id: 'ptm', name: 'Auratech HQ'),
    OrganizationModel(id: 'sat', name: 'Saturn Consulting'),
    OrganizationModel(id: 'nxt', name: 'NextEdge Retail'),
  ];

  /// डिफ़ॉल्ट एम्प्लॉयी जिसे पहली बार लॉगिन पर बनाया जाता है।
  EmployeeModel get defaultEmployee => EmployeeModel(
    id: const Uuid().v4(),
    code: 'PTM-1001',
    name: 'Sohil Khan',
    department: 'Application',
    role: 'Software Engineer',
    shift: ShiftModel(
      id: 'general',
      name: 'General Shift',
      start: const TimeOfDay(hour: 9, minute: 30),
      end: const TimeOfDay(hour: 18, minute: 30),
      graceMinutes: 10,
      breakPolicy: const BreakPolicy(maxBreaks: 3, paidBreaks: 1),
      autoCheckoutTime: const TimeOfDay(hour: 20, minute: 0),
    ),
    managerName: 'Sona Sharma',
    location: 'Jaipur HQ',
  );

  /// उपयोगकर्ता द्वारा पहचान इनपुट करने पर सेव करना।
  void submitIdentifier(String identifier) {
    _credentials.value = AuthCredentials(identifier: identifier, otp: '');
    otpSent.value = true;
  }

  /// ओटीपी को अपडेट करना।
  void updateOtp(String otp) {
    if (_credentials.value == null) return;
    _credentials.value = AuthCredentials(
      identifier: _credentials.value!.identifier,
      otp: otp,
    );
  }

  /// संगठना चयन।
  void selectOrganization(OrganizationModel organizationModel) {
    _organization.value = organizationModel;
  }

  /// ओटीपी वेरिफाई करके होम पर नेविगेट करना।
  Future<void> verifyOtp() async {
    if (_credentials.value == null || _credentials.value!.otp.length < 4) {
      Get.snackbar('OTP', 'कृपया सही ओटीपी दर्ज करें।');
      return;
    }

    isVerifying.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 600));
    isVerifying.value = false;

    if (_storageService.readEmployees().isEmpty) {
      await _storageService.writeEmployees(<EmployeeModel>[defaultEmployee]);
    }

    Get.offAllNamed(AppRoutes.permissions);
  }

  /// सभी डेटा हटाकर लॉगआउट करना।
  Future<void> logout() async {
    await _storageService.clear();
    Get.offAllNamed(AppRoutes.login);
  }
}

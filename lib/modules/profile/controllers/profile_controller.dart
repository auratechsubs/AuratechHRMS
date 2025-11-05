import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../../services/storage_service.dart';
import '../../attendance/models/attendance_models.dart';

/// ProfileController भाषा, थीम व बायोमेट्रिक स्टेट मैनेज करता है।
class ProfileController extends GetxController {
  ProfileController(this._storageService);

  final StorageService _storageService;
  final Rx<EmployeeModel?> _employee = Rx<EmployeeModel?>(null);

  // Uploaded documents list observable
  final RxList<EmployeeDocument> employeeDocs = <EmployeeDocument>[].obs;

  // Salary slips list observable
  final RxList<SalarySlip> salarySlips = <SalarySlip>[].obs;
  EmployeeModel? get employee => _employee.value;

  @override
  void onInit() {
    super.onInit();
    final employees = _storageService.readEmployees();
    if (employees.isNotEmpty) {
      _employee.value = employees.first;
      _applyPreferences(employees.first);
    }
  }

  void _applyPreferences(EmployeeModel employee) {
    if (employee.themeMode == 'dark') {
      Get.changeThemeMode(ThemeMode.dark);
    } else if (employee.themeMode == 'light') {
      Get.changeThemeMode(ThemeMode.light);
    }
    final parts = employee.languageCode.split('_');
    if (parts.length == 2) {
      Get.updateLocale(Locale(parts.first, parts.last));
    }
  }

  Future<void> updateTheme(String mode) async {
    if (_employee.value == null) return;
    Get.changeThemeMode(
      mode == 'dark'
          ? ThemeMode.dark
          : mode == 'light'
          ? ThemeMode.light
          : ThemeMode.system,
    );
    await _persist(_employee.value!.copyWith(themeMode: mode));
  }

  Future<void> updateLanguage(String localeCode) async {
    if (_employee.value == null) return;
    final parts = localeCode.split('_');
    if (parts.length == 2) {
      Get.updateLocale(Locale(parts.first, parts.last));
    }
    await _persist(_employee.value!.copyWith(languageCode: localeCode));
  }

  Future<void> markFaceEnrollment(bool value) async {
    if (_employee.value == null) return;
    await _persist(_employee.value!.copyWith(faceEnrolled: value));
  }

  Future<void> markFingerprintEnrollment(bool value) async {
    if (_employee.value == null) return;
    await _persist(_employee.value!.copyWith(fingerprintEnrolled: value));
  }

  Future<void> _persist(EmployeeModel updated) async {
    final employees = _storageService.readEmployees();
    final index = employees.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      employees[index] = updated;
      await _storageService.writeEmployees(employees);
      _employee.value = updated;
    }
  }

  // Document Upload function
  Future<void> uploadDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileName = result.files.single.name;
        final fileExtension = fileName.split('.').last.toLowerCase();

        // Example: copy file to app directory या backend upload करें
        final appDir = await getApplicationDocumentsDirectory();
        final savedFile = await file.copy('${appDir.path}/$fileName');

        // Create EmployeeDocument model और लिस्ट में जोड़ें
        final doc = EmployeeDocument(
          filePath: savedFile.path,
          fileName: fileName,
          fileType: fileExtension,
        );

        employeeDocs.add(doc);
        Get.snackbar('Success', 'Document uploaded: $fileName');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload document: $e');
    }
  }

  Future<void> downloadDocument(EmployeeDocument doc) async {
    try {
      final file = File(doc.filePath);
      if (await file.exists()) {
        await OpenFile.open(file.path);
      } else {
        Get.snackbar('Error', 'File not found');
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not open file: $e');
    }
  }

  // Download Latest Salary Slip (simulate)
  Future<void> downloadSalarySlip() async {
    try {
      // यहाँ आप API कॉल कर सकते हैं latest slip लाने के लिए
      // फिलहाल simulate loading
      await Future.delayed(const Duration(seconds: 1));

      Get.snackbar('Salary Slip', 'Latest salary slip downloaded (demo)');
    } catch (e) {
      Get.snackbar('Error', 'Failed to download salary slip: $e');
    }
  }
  // Download specific slip file
  Future<void> downloadSalarySlipFile(SalarySlip slip) async {
    try {
      // यहाँ slip.filePath के आधार पर open करें या API से डाउनलोड करें
      final file = File(slip.filePath);
      if (await file.exists()) {
        await OpenFile.open(file.path);
      } else {
        Get.snackbar('Error', 'Salary slip file not found');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error opening salary slip: $e');
    }
  }
}

// Models (उदाहरण स्वरूप - अपनी आवश्यकता अनुसार बनाएँ)
class EmployeeDocument {
  final String filePath;
  final String fileName;
  final String fileType;

  EmployeeDocument({
    required this.filePath,
    required this.fileName,
    required this.fileType,
  });
}

class SalarySlip {
  final String filePath;
  final String month;
  final int year;

  SalarySlip({required this.filePath, required this.month, required this.year});
}

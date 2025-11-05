import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/localization/app_translations.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'modules/admin/controllers/admin_shell_controller.dart';
import 'modules/auth/controllers/auth_controller.dart';
import 'modules/attendance/controllers/attendance_controller.dart';
import 'modules/profile/controllers/profile_controller.dart';
import 'services/biometric_service.dart';
import 'services/excel_export_service.dart';
import 'services/face_recognition_service.dart';
import 'services/offline_queue_service.dart';
import 'services/policy_service.dart';
import 'services/storage_service.dart';

/// मुख्य प्रवेश बिंदु जहां से पूरा ऐप आरंभ होता है।
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// SharedPreferences आधारित लोकल स्टोरेज को तैयार करें।
  final storageService = await StorageService().init();
  Get.put<StorageService>(storageService, permanent: true);

  /// ऑफ़लाइन कतार जो पेंडिंग पंच को संभालेगी।
  final offlineQueueService = await OfflineQueueService().init();
  Get.put<OfflineQueueService>(offlineQueueService, permanent: true);

  /// पॉलिसी इंजन जो 10:30 कटऑफ व ऑटो चेकआउट जैसी गणना संभालेगा।
  Get.put<PolicyService>(PolicyService(), permanent: true);

  /// बायोमेट्रिक और फेस पहचान सेवाएँ।
  Get.put<BiometricService>(BiometricService(), permanent: true);
  Get.put<FaceRecognitionService>(FaceRecognitionService(), permanent: true);
  Get.put<ExcelExportService>(ExcelExportService(), permanent: true);

  /// आवश्यक कंट्रोलर रजिस्टर करें।
  Get.put<AuthController>(AuthController(storageService));
  Get.put<ProfileController>(ProfileController(storageService));
  Get.put<AdminShellController>(AdminShellController());
  Get.put<AttendanceController>(
    AttendanceController(
      storageService: storageService,
      policyService: Get.find<PolicyService>(),
      biometricService: Get.find<BiometricService>(),
      faceRecognitionService: Get.find<FaceRecognitionService>(),
      offlineQueueService: Get.find<OfflineQueueService>(),
      excelExportService: Get.find<ExcelExportService>(),
    ),
  );

  runApp(const AttendanceApp());
}

/// AttendanceApp पूरा रूट विजेट है जो GetMaterialApp को सेट करता है।
class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PulseTime Attendance',
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      getPages: AppPages.pages,
      initialRoute: AppRoutes.login,
    );
  }
}

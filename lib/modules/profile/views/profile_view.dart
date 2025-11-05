import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../attendance/controllers/attendance_controller.dart';
import '../../attendance/models/attendance_models.dart';
import '../controllers/profile_controller.dart';

/// ProfileView यूज़र प्रोफ़ाइल, डॉक्युमेंट अपलोड व सैलरी स्लिप डाउनलोड हैंडल करता है।
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();
    final AttendanceController attendanceController =
    Get.find<AttendanceController>();

    return Obx(() {
      final EmployeeModel? employee = controller.employee;
      if (employee == null) {
        return Scaffold(
          appBar: AppBar(title: Text('profile'.tr)),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: Text('profile'.tr),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit Profile',
              onPressed: (){},
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          children: [
            // TOP CARD: Avatar, Name, Emp Info, Edit Button
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                      child: Text(
                        employee.name.characters.first.toUpperCase(),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(employee.name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              )),
                          Text('${employee.department} • ${employee.role}',
                              style: Theme.of(context).textTheme.labelMedium),
                          SizedBox(height: 06,),
                          Chip(
                              label: Text('Emp ID: ${employee.code}'),
                              backgroundColor: Colors.grey.shade200),
                          const SizedBox(width: 6),
                          Chip(
                              label: Text('Manager: ${employee.managerName}'),
                              backgroundColor: Colors.grey.shade100),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 26),

            // Uploaded Documents section
            Text('Documents', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: BorderSide(color: ColorScheme.of(context).primary)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading:   Icon(Icons.upload_file, size: 28,color: ColorScheme.of(context).primary),
                      title: Text('Upload Document'),
                      subtitle: Text('PAN, Aadhaar, Offer Letter आदि PDF/IMG अपलोड करें'),
                      trailing:  InkWell(onTap: (){}, child: Icon(Icons.attach_file_outlined,color: ColorScheme.of(context).primary,))
                    ),
                    if (controller.employeeDocs.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 6, top: 4, bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: controller.employeeDocs.map(
                                (doc) => ListTile(
                              leading: Icon(Icons.insert_drive_file, color:  ColorScheme.of(context).primary,),
                              title: Text(doc.fileName),
                              subtitle: Text(doc.fileType),
                              trailing: IconButton(
                                icon: const Icon(Icons.download),
                                tooltip: 'Download',
                                onPressed: () => controller.downloadDocument(doc),
                              ),
                            ),
                          ).toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 22),

            // Salary Slips section
            Text('Salary Slips', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: BorderSide(color:  ColorScheme.of(context).primary, )),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading:   Icon(Icons.receipt_long,color:  ColorScheme.of(context).primary,),
                      title: const Text('Download Latest Salary Slip'),
                      subtitle: const Text('PDF format • Secure download'),
                      trailing: Icon(Icons.download_for_offline_outlined,color:  ColorScheme.of(context).primary,),
                      // trailing: ElevatedButton.icon(
                      //   icon: const Icon(Icons.download),
                      //   label: const Text('Download'),
                      //   onPressed: controller.downloadSalarySlip,
                      // ),
                    ),
                    if (controller.salarySlips.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 6, top: 4, bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: controller.salarySlips.map(
                                (slip) => ListTile(
                              leading: Icon(Icons.picture_as_pdf, color: Colors.red.shade400),
                              title: Text('Salary Slip (${slip.month} ${slip.year})'),
                              subtitle: Text('Download'),
                              trailing: IconButton(
                                icon: const Icon(Icons.download),
                                tooltip: 'Download',
                                onPressed: () => controller.downloadSalarySlipFile(slip),
                              ),
                            ),
                          ).toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 22),

            // Biometrics section
            Text('Biometrics', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            SwitchListTile.adaptive(
              title: Text('Face Recognition'),
              subtitle: const Text('Policy enabled होने पर आवश्यक।'),
              value: employee.faceEnrolled,
              onChanged: (value) => controller.markFaceEnrollment(value),
            ),
            SwitchListTile.adaptive(
              title: Text('Fingerprint Authentication'),
              subtitle: const Text('डिवाइस पर सुरक्षित रूप से स्टोर।'),
              value: employee.fingerprintEnrolled,
              onChanged: (value) => controller.markFingerprintEnrollment(value),
            ),

            const SizedBox(height: 22),

            // Settings section
            Text('Settings', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              initialValue: employee.languageCode,
              items: const [
                DropdownMenuItem(value: 'en_US', child: Text('English')),
                DropdownMenuItem(value: 'hi_IN', child: Text('हिंदी')),
                DropdownMenuItem(value: 'ar_SA', child: Text('Arabic')),
                DropdownMenuItem(value: 'es_ES', child: Text('Español')),
              ],
              onChanged: (value) => controller.updateLanguage(value!),
              decoration: InputDecoration(labelText: 'Language'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: employee.themeMode,
              items: const [
                DropdownMenuItem(value: 'system', child: Text('System')),
                DropdownMenuItem(value: 'light', child: Text('Light')),
                DropdownMenuItem(value: 'dark', child: Text('Dark')),
              ],
              onChanged: (value) => controller.updateTheme(value!),
              decoration: InputDecoration(labelText: 'Theme'),
            ),

            const SizedBox(height: 26),

            // Offline punch info section
            ListTile(
              leading: const Icon(Icons.cloud_off),
              title: const Text('Offline Queue'),
              subtitle: Text('Pending punches: ${attendanceController.pendingQueueLength}'),
              trailing: ElevatedButton(
                onPressed: attendanceController.queueForSync,
                child: const Text('Sync'),
              ),
            ),
          ],
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../shared/widgets/primary_button.dart';

/// PermissionsView उपयोगकर्ता को लोकेशन, कैमरा आदि परमिशन्स समझाता है।
class PermissionsView extends StatelessWidget {
  PermissionsView({super.key});

  final RxBool location = true.obs;
  final RxBool camera = true.obs;
  final RxBool notifications = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('permissions_title'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50,),
              Text(
                'बायोमेट्रिक और लोकेशन परमिशन्स ऑन करने से प्रॉक्सि कम होती है।',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              _permissionTile(
                context,
                title: 'Location',
                description:
                'Geo-fence 100m के भीतर रहने पर ही पंच की अनुमति मिलेगी।',
                state: location,
              ),
              _permissionTile(
                context,
                title: 'Camera & Face',
                description:
                'Face ID कैप्चर से सुरक्षा बढ़ती है। ऑटो ऑन-डिवाइस प्रोसेसिंग।',
                state: camera,
              ),
              _permissionTile(
                context,
                title: 'Notifications',
                description:
                'लेट कटऑफ व ऑटो चेकआउट रिमाइंडर समय पर भेजे जाएंगे।',
                state: notifications,
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'verify'.tr,
                icon: Icons.check_circle_outline,
                onPressed: () => Get.offAllNamed(AppRoutes.employeeShell),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _permissionTile(
    BuildContext context, {
    required String title,
    required String description,
    required RxBool state,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Obx(
      () => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outline.withOpacity(0.4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Switch(
              value: state.value,
              onChanged: (value) => state.value = value,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(description,
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

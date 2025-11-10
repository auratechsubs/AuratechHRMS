import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/widgets/primary_button.dart';
import '../controllers/attendance_controller.dart';
import '../models/attendance_models.dart';


class MarkAttendanceSheet extends StatelessWidget {
  const MarkAttendanceSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final AttendanceController controller = Get.find<AttendanceController>();
    final policy = controller.primaryEmployee != null
        ? controller.primaryEmployee!.shift.breakPolicy
        : const BreakPolicy();
    final day = controller.todayRecord;

    return Scaffold(
      appBar: AppBar(title: const Text('Mark Attendance')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Biometric rules',
                style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 8),
            Text(
              'Face/Fingerprint अनिवार्य यदि नीति में सक्षम है। ब्रेक सीमा: ${policy.maxBreaks}, Paid: ${policy.paidBreaks}.',
            ),
            const SizedBox(height: 24),
            _actionTile(
              context,
              icon: Icons.login,
              title: 'check_in'.tr,
              subtitle: 'Face + Fingerprint जाँच के बाद पंच होगा।',
              onPressed: controller.performCheckIn,
              enabled: day?.checkIn == null,
            ),
            _actionTile(
              context,
              icon: Icons.free_breakfast,
              title: day?.breaks.isNotEmpty == true && day?.breaks.last.end == null
                  ? 'end_break'.tr
                  : 'start_break'.tr,
              subtitle: 'ब्रेक टाइमर लाइव चलेगा और रिपोर्टिंग में शामिल होगा।',
              onPressed: () {
                if (day?.breaks.isNotEmpty == true &&
                    day?.breaks.last.end == null) {
                  controller.endBreak();
                } else {
                  controller.startBreak();
                }
              },
              enabled: day?.checkIn != null,
            ),
            _actionTile(
              context,
              icon: Icons.logout,
              title: 'check_out'.tr,
              subtitle: 'Checkout summary में कुल समय व ब्रेक दिखेंगे।',
              onPressed: controller.performCheckOut,
              enabled: day?.checkIn != null &&
                  (day?.breaks.isEmpty == true || day?.breaks.last.end != null),
            ),
            const Spacer(),
            PrimaryButton(
              label: 'Close',
              onPressed: () => Get.back<void>(),
              icon: Icons.close,
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
    bool enabled = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: enabled ? colorScheme.surfaceContainerHighest.withOpacity(0.3) : null,
        border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: enabled ? onPressed : null,
            child: const Icon(Icons.play_arrow_rounded),
          ),
        ],
      ),
    );
  }
}

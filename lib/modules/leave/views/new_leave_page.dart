import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/leave_controller.dart';
import '../models/leave_models.dart';

class NewLeavePage extends GetView<LeaveController> {
  const NewLeavePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('New Leave')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final type = controller.type.value;
          final fromD = controller.fromDate.value;
          final toD = controller.toDate.value;

          final days = (fromD != null && toD != null)
              ? controller.calcInclusiveDays(fromD, toD)
              : 0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type
              Text('Type', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              SegmentedButton<LeaveType>(
                segments: LeaveType.values
                    .map(
                      (t) => ButtonSegment(
                        value: t,
                        icon: Icon(t.icon),
                        label: Text(t.label),
                      ),
                    )
                    .toList(),
                selected: {type},
                onSelectionChanged: (s) => controller.type.value = s.first,
              ),

              const SizedBox(height: 16),
              // Cause
              Text('Cause', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: controller.causeCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'e.g. Trip to Cannes / Family emergency ...',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),

              const SizedBox(height: 16),
              // From
              _DateTimeRow(
                title: 'From',
                dateText: fromD != null
                    ? controller.fmtD(fromD)
                    : 'Select date',
                timeText: controller.fromTime.value.format(context),
                onPickDate: () => controller.pickFromDate(context),
                onPickTime: () => controller.pickFromTime(context),
              ),
              const SizedBox(height: 12),
              // To
              _DateTimeRow(
                title: 'To',
                dateText: toD != null ? controller.fmtD(toD) : 'Select date',
                timeText: controller.toTime.value.format(context),
                onPickDate: () => controller.pickToDate(context),
                onPickTime: () => controller.pickToTime(context),
              ),

              const SizedBox(height: 16),
              if (days > 0)
                Text(
                  'Applying for $days ${days == 1 ? 'Day' : 'Days'} Leave',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),

              const SizedBox(height: 16),

              if (days > 0)
                Text(
                  'From ${controller.fromDate.value != null ? '${controller.fmtD(controller.fromDate.value!)} ${controller.fromTime.value.format(context)}' : ''}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              if (days > 0)
                Text(
                  'To ${controller.toDate.value != null ? '${controller.fmtD(controller.toDate.value!)} ${controller.toTime.value.format(context)}' : ''}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),

               const SizedBox(height: 24),
              // Apply button
              FilledButton.icon(
                onPressed: controller.loading.value
                    ? null
                    : () async {
                        final ok = await controller.submit();
                        if (ok) {
                          if (context.mounted) {
                            Get.back();
                            Get.snackbar(
                              'Leave Submitted',
                              'Your request is sent for approval.',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        }
                      },
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                icon: const Icon(Icons.send_rounded),
                label: Obx(
                  () => Text(
                    controller.loading.value
                        ? 'Submitting...'
                        : 'Apply for Leave',
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _DateTimeRow extends StatelessWidget {
  const _DateTimeRow({
    required this.title,
    required this.dateText,
    required this.timeText,
    required this.onPickDate,
    required this.onPickTime,
  });

  final String title;
  final String dateText;
  final String timeText;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 6,
              child: OutlinedButton.icon(
                onPressed: onPickDate,
                icon: const Icon(Icons.calendar_today_outlined, size: 18),
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(dateText),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 4,
              child: OutlinedButton.icon(
                onPressed: onPickTime,
                icon: const Icon(Icons.schedule_outlined, size: 18),
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(timeText),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

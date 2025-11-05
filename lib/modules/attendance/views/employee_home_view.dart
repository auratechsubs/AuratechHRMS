import 'package:attendence_management_software/modules/attendance/views/mark_attendance_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/stat_tile.dart';
import '../../shared/widgets/status_chip.dart';
import '../controllers/attendance_controller.dart';
import '../models/attendance_models.dart';

  class EmployeeHomeView extends StatelessWidget {
  EmployeeHomeView({super.key});

  final RxInt _navIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    final AttendanceController controller = Get.find<AttendanceController>();

    return Obx(
          () {
        final employee = controller.primaryEmployee;
        final day = controller.todayRecord;

        return Scaffold(
          appBar: AppBar(
            title: Text('home_today'.tr),
            elevation: 3,
            actions: [
              IconButton(
                icon: const Icon(Icons.cloud_sync_outlined),
                tooltip: 'Sync Data',
                onPressed: controller.queueForSync,
              ),
              IconButton(
                icon: const Icon(Icons.file_download_outlined),
                tooltip: 'Download MIS',
                onPressed: () async {
                  final bytes = await controller.downloadMisReport();
                  if (bytes != null) {
                    Get.snackbar('Excel', 'MIS फाइल तैयार है (डेमो)।',
                        snackPosition: SnackPosition.BOTTOM);
                  }
                },
              ),
            ],
          ),
          bottomNavigationBar: Obx(
                () => NavigationBar(
              selectedIndex: _navIndex.value,
              onDestinationSelected: (index) {
                _navIndex.value = index;
                switch (index) {
                  case 0:
                    break;
                  case 1:
                    Get.toNamed(AppRoutes.calendar);
                    break;
                  case 2:
                    Get.toNamed(AppRoutes.requests);
                    break;
                  case 3:
                    Get.toNamed(AppRoutes.reports);
                    break;
                  case 4:
                    Get.toNamed(AppRoutes.profile);
                    break;
                }
              },
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
                NavigationDestination(icon: Icon(Icons.calendar_today_outlined), label: 'Calendar'),
                NavigationDestination(icon: Icon(Icons.inbox_outlined), label: 'Requests'),
                NavigationDestination(icon: Icon(Icons.bar_chart_outlined), label: 'Reports'),
                NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
              ],
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (employee != null) _buildHeader(context, employee, day),
                const SizedBox(height: 30),
                _buildActionCard(context, controller, day),
                const SizedBox(height: 30),
                _buildStatsRow(context, controller),
                const SizedBox(height: 30),
                _buildAlerts(context, controller),
                const SizedBox(height: 30),
                _buildRecentActivity(context, controller),
                const SizedBox(height: 30),
                const SizedBox(height: 620,child: MarkAttendanceSheet(),)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
      BuildContext context,
      EmployeeModel employee,
      AttendanceDay? day,
      ) {
    final status = day?.status ?? AttendanceStatus.absent;
    final colorScheme = Theme.of(context).colorScheme;

    final statusColor = switch (status) {
      AttendanceStatus.present => colorScheme.primary,
      AttendanceStatus.late => colorScheme.tertiary,
      AttendanceStatus.halfDay => colorScheme.error,
      AttendanceStatus.autoCheckout => colorScheme.tertiary,
      AttendanceStatus.absent => colorScheme.error,
    };

    final statusLabel = switch (status) {
      AttendanceStatus.present => 'On Time',
      AttendanceStatus.late => 'Late',
      AttendanceStatus.halfDay => 'Half Day',
      AttendanceStatus.autoCheckout => 'Auto Checkout',
      AttendanceStatus.absent => 'Not Marked',
    };

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(0.12),
            colorScheme.secondary.withOpacity(0.12),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: colorScheme.primary,
            child: Text(
              employee.name.characters.first.toUpperCase(),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(width: 22),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${employee.department} • ${employee.role}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                StatusChip(label: statusLabel, color: statusColor, ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
      BuildContext context,
      AttendanceController controller,
      AttendanceDay? day,
      ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.access_time, color: colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  day?.checkIn != null
                      ? 'Check-in: ${TimeOfDay.fromDateTime(day!.checkIn!).format(context)}'
                      : 'Check-in pending',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: day?.checkIn == null ? 'check_in'.tr : 'start_break'.tr,
                  onPressed: () {
                    if (day?.checkIn == null) {
                      controller.performCheckIn();
                    } else {
                      controller.startBreak();
                    }
                  },
                  icon: Icons.login,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: PrimaryButton(
                  label: day?.checkOut == null
                      ? (day?.breaks.isNotEmpty == true &&
                      day?.breaks.last.end == null
                      ? 'end_break'.tr
                      : 'check_out'.tr)
                      : 'check_out'.tr,
                  onPressed: () {
                    if (day == null) {
                      controller.performCheckIn();
                    } else if (day.breaks.isNotEmpty && day.breaks.last.end == null) {
                      controller.endBreak();
                    } else if (day.checkOut == null) {
                      controller.performCheckOut();
                    }
                  },
                  icon: Icons.logout,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'half_day_after'.tr,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: colorScheme.tertiary),
          ),
          if (day?.autoCheckoutApplied == true) ...[
            const SizedBox(height: 10),
            Text('auto_checkout_info'.tr, style: Theme.of(context).textTheme.bodySmall),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsRow(
      BuildContext context,
      AttendanceController controller,
      ) {
    final day = controller.todayRecord;
    final totalWork = day?.totalWorkDuration ?? Duration.zero;
    final totalBreak = day?.totalBreakDuration ?? Duration.zero;

    return Row(
      children: [
        Expanded(
          child: StatTile(
            title: 'Total Work',
            value:
            '${totalWork.inHours}h ${(totalWork.inMinutes % 60).toString().padLeft(2, '0')}m',
            icon: Icons.timer_outlined,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: StatTile(
            title: 'Break Time',
            value:
            '${totalBreak.inHours}h ${(totalBreak.inMinutes % 60).toString().padLeft(2, '0')}m',
            icon: Icons.free_breakfast_outlined,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildAlerts(BuildContext context, AttendanceController controller) {
    final day = controller.todayRecord;
    final now = TimeOfDay.now();
    final cutoff = controller.primaryEmployee?.shift.start;

    // Alert condition: Near cutoff time within 10 min window
    final bool nearCutoff = cutoff != null &&
        now.hour == cutoff.hour &&
        now.minute >= cutoff.minute - 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Smart Alerts',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            )),
        const SizedBox(height: 14),
        if (day?.checkIn == null && nearCutoff)
          _alertCard(context, icon: Icons.alarm, message: 'You’re nearing 10:30 AM cutoff.'),
        if (day?.checkOut == null)
          _alertCard(context, icon: Icons.logout, message: 'Remember to check-out before 8:00 PM.'),
      ],
    );
  }

  Widget _alertCard(BuildContext context,
      {required IconData icon, required String message}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.tertiary.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.tertiary),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(
      BuildContext context, AttendanceController controller) {
    final day = controller.todayRecord;
    final checkIn = day?.checkIn;
    final checkOut = day?.checkOut;
    final breaks = day?.breaks ?? <BreakPeriod>[];

    final items = <String>[
      if (checkIn != null)
        'Check-in at ${TimeOfDay.fromDateTime(checkIn).format(context)}',
      if (breaks.isNotEmpty) 'Breaks: ${breaks.length} entries',
      if (checkOut != null)
        'Check-out at ${TimeOfDay.fromDateTime(checkOut).format(context)}',
    ];
    if (items.isEmpty) {
      items.add('No activity logged today.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Activity',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            )),
        const SizedBox(height: 14),
        ...items.map(
              (item) => Card(
            elevation: 2,

            margin: const EdgeInsets.only(bottom: 12),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color:    ColorScheme.of(context).primary
    ,
    )
            ),
            child: ListTile(
              leading: const Icon(Icons.fiber_manual_record, size: 14, color: Colors.blueAccent),
              title: Text(item),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
        ),
      ],
    );
  }
}

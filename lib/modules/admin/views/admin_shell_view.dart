// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/admin_shell_controller.dart';
//
// import 'pages/dashboard_view.dart';
// import 'pages/team_view.dart';
// import 'pages/attendance_view.dart';
// import 'pages/requests_view.dart';
// import 'pages/shifts_view.dart';
// import 'pages/holidays_view.dart';
// import 'pages/policies_view.dart';
// import 'pages/reports_view.dart';
// import 'pages/settings_view.dart';
//
// class AdminShellView extends GetView<AdminShellController> {
//   const AdminShellView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     Get.put(AdminShellController());
//     final controller = Get.find<AdminShellController>();
//     return Obx(() {
//       final bool isWide = MediaQuery.of(context).size.width >= 1024;
//
//       final content = SafeArea(
//         child: SizedBox.expand(
//           // <-- guarantees tight constraints
//           child: AnimatedSwitcher(
//             duration: const Duration(milliseconds: 200),
//             child: _AdminContent(
//               key: ValueKey(controller.currentIndex.value),
//               index: controller.currentIndex.value,
//             ),
//           ),
//         ),
//       );
//
//       if (isWide) {
//         return Scaffold(
//           body: Row(
//             children: [
//               _AdminRail(isWide: isWide),
//               const VerticalDivider(width: 1),
//               Expanded(child: content),
//             ],
//           ),
//         );
//       }
//
//       // Mobile: bottom navigation
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Admin Console'),
//           actions: [
//             IconButton(
//               tooltip: 'Switch Theme',
//               onPressed: () {
//                 final next = controller.themeMode.value == ThemeMode.dark
//                     ? ThemeMode.light
//                     : ThemeMode.dark;
//                 controller.switchTheme(next);
//                 Get.changeThemeMode(next);
//               },
//               icon: const Icon(Icons.brightness_6_outlined),
//             ),
//             PopupMenuButton<String>(
//               itemBuilder: (context) => const [
//                 PopupMenuItem(value: 'en', child: Text('English')),
//                 PopupMenuItem(value: 'hi', child: Text('हिंदी')),
//                 PopupMenuItem(value: 'ar', child: Text('العربية')),
//                 PopupMenuItem(value: 'es', child: Text('Español')),
//               ],
//               onSelected: (v) {
//                 switch (v) {
//                   case 'hi':
//                     controller.switchLocale(const Locale('hi', 'IN'));
//                     Get.updateLocale(const Locale('hi', 'IN'));
//                     break;
//                   case 'ar':
//                     controller.switchLocale(const Locale('ar', 'SA'));
//                     Get.updateLocale(const Locale('ar', 'SA'));
//                     break;
//                   case 'es':
//                     controller.switchLocale(const Locale('es', 'ES'));
//                     Get.updateLocale(const Locale('es', 'ES'));
//                     break;
//                   default:
//                     controller.switchLocale(const Locale('en', 'US'));
//                     Get.updateLocale(const Locale('en', 'US'));
//                 }
//               },
//             ),
//           ],
//         ),
//         body: content,
//         bottomNavigationBar: NavigationBar(
//           selectedIndex: controller.currentIndex.value,
//           onDestinationSelected: controller.setIndex,
//           destinations: const [
//             NavigationDestination(
//               icon: Icon(Icons.dashboard_outlined),
//               label: 'Dashboard',
//             ),
//             NavigationDestination(
//               icon: Icon(Icons.groups_3_outlined),
//               label: 'Team',
//             ),
//             NavigationDestination(
//               icon: Icon(Icons.calendar_month_outlined),
//               label: 'Attendance',
//             ),
//             NavigationDestination(
//               icon: Icon(Icons.task_alt_outlined),
//               label: 'Requests',
//             ),
//             NavigationDestination(
//               icon: Icon(Icons.access_time_outlined),
//               label: 'Shifts',
//             ),
//             NavigationDestination(
//               icon: Icon(Icons.event_outlined),
//               label: 'Holidays',
//             ),
//             NavigationDestination(
//               icon: Icon(Icons.rule_folder_outlined),
//               label: 'Policies',
//             ),
//             NavigationDestination(
//               icon: Icon(Icons.assessment_outlined),
//               label: 'Reports',
//             ),
//             NavigationDestination(
//               icon: Icon(Icons.settings_outlined),
//               label: 'Settings',
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }
//
// class _AdminRail extends GetView<AdminShellController> {
//   const _AdminRail({required this.isWide});
//   final bool isWide;
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final bool extended = isWide && !controller.compactMode.value;
//
//       return NavigationRail(
//         extended: extended,
//         minExtendedWidth: 240,
//         leading: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12.0),
//           child: Row(
//             children: [
//               const SizedBox(width: 12),
//               Icon(
//                 Icons.hub_outlined,
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//               if (extended) ...[
//                 const SizedBox(width: 8),
//                 Text(
//                   'Admin Console',
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//                 const Spacer(),
//                 IconButton(
//                   tooltip: extended ? 'Compact' : 'Extended',
//                   onPressed: controller.toggleCompact,
//                   icon: Icon(
//                     extended ? Icons.chevron_left : Icons.chevron_right,
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//         destinations: const [
//           NavigationRailDestination(
//             icon: Icon(Icons.dashboard_outlined),
//             label: Text('Dashboard'),
//           ),
//           NavigationRailDestination(
//             icon: Icon(Icons.groups_3_outlined),
//             label: Text('Team'),
//           ),
//           NavigationRailDestination(
//             icon: Icon(Icons.calendar_month_outlined),
//             label: Text('Attendance'),
//           ),
//           NavigationRailDestination(
//             icon: Icon(Icons.task_alt_outlined),
//             label: Text('Requests'),
//           ),
//           NavigationRailDestination(
//             icon: Icon(Icons.access_time_outlined),
//             label: Text('Shifts'),
//           ),
//           NavigationRailDestination(
//             icon: Icon(Icons.event_outlined),
//             label: Text('Holidays'),
//           ),
//           NavigationRailDestination(
//             icon: Icon(Icons.rule_folder_outlined),
//             label: Text('Policies'),
//           ),
//           NavigationRailDestination(
//             icon: Icon(Icons.assessment_outlined),
//             label: Text('Reports'),
//           ),
//           NavigationRailDestination(
//             icon: Icon(Icons.settings_outlined),
//             label: Text('Settings'),
//           ),
//         ],
//         selectedIndex: controller.currentIndex.value,
//         onDestinationSelected: controller.setIndex,
//       );
//     });
//   }
// }
//
// class _AdminContent extends StatelessWidget {
//   const _AdminContent({super.key, required this.index});
//   final int index;
//
//   @override
//   Widget build(BuildContext context) {
//     switch (index) {
//       case 0:
//         return AdminDashboardView();
//       case 1:
//         return const AdminTeamView();
//       case 2:
//         return const AdminAttendanceView();
//       case 3:
//         return const AdminRequestsView();
//       case 4:
//         return const AdminShiftsView();
//       case 5:
//         return const AdminHolidaysView();
//       case 6:
//         return const AdminPoliciesView();
//       case 7:
//         return const AdminReportsView();
//       case 8:
//         return const AdminSettingsView();
//       default:
//         return AdminDashboardView();
//     }
//   }
// }


import 'package:attendence_management_software/modules/admin/views/pages/attendance_view.dart';
import 'package:attendence_management_software/modules/admin/views/pages/dashboard_view.dart';
import 'package:attendence_management_software/modules/admin/views/pages/holidays_view.dart';
import 'package:attendence_management_software/modules/admin/views/pages/policies_view.dart';
import 'package:attendence_management_software/modules/admin/views/pages/reports_view.dart';
import 'package:attendence_management_software/modules/admin/views/pages/requests_view.dart';
import 'package:attendence_management_software/modules/admin/views/pages/settings_view.dart';
import 'package:attendence_management_software/modules/admin/views/pages/shifts_view.dart';
import 'package:attendence_management_software/modules/admin/views/pages/team_view.dart';
import 'package:flutter/material.dart';

// Dummy page widgets for demonstration. Replace with your actual views.
// class AdminDashboardView extends StatelessWidget { @override Widget build(BuildContext ctx) => Center(child: Text('Dashboard')); }
// class AdminTeamView extends StatelessWidget { @override Widget build(BuildContext ctx) => Center(child: Text('Team')); }
// class AdminAttendanceView extends StatelessWidget { @override Widget build(BuildContext ctx) => Center(child: Text('Attendance')); }
// class AdminRequestsView extends StatelessWidget { @override Widget build(BuildContext ctx) => Center(child: Text('Requests')); }
// class AdminShiftsView extends StatelessWidget { @override Widget build(BuildContext ctx) => Center(child: Text('Shifts')); }
// class AdminHolidaysView extends StatelessWidget { @override Widget build(BuildContext ctx) => Center(child: Text('Holidays')); }
// class AdminPoliciesView extends StatelessWidget { @override Widget build(BuildContext ctx) => Center(child: Text('Policies')); }
// class AdminReportsView extends StatelessWidget { @override Widget build(BuildContext ctx) => Center(child: Text('Reports')); }
// class AdminSettingsView extends StatelessWidget { @override Widget build(BuildContext ctx) => Center(child: Text('Settings')); }

class AdminShellView extends StatefulWidget {
  const AdminShellView({super.key});
  @override
  State<AdminShellView> createState() => _AdminShellViewState();
}

class _AdminShellViewState extends State<AdminShellView> {
  int _selectedIndex = 0;

  final List<_TabModel> _tabs = [
    _TabModel('Dashboard', Icons.dashboard_outlined, AdminDashboardView()),
    _TabModel('Team', Icons.groups_3_outlined, AdminTeamView()),
    _TabModel('Attendance', Icons.calendar_month_outlined, AdminAttendanceView()),
    _TabModel('Requests', Icons.task_alt_outlined, AdminRequestsView()),
    _TabModel('Shifts', Icons.access_time_outlined, AdminShiftsView()),
    _TabModel('Holidays', Icons.event_outlined, AdminHolidaysView()),
    _TabModel('Policies', Icons.rule_folder_outlined, AdminPoliciesView()),
    _TabModel('Reports', Icons.assessment_outlined, AdminReportsView()),
    _TabModel('Settings', Icons.settings_outlined, AdminSettingsView()),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Admin Console'),
      // ),
      body: SafeArea(
          top: false,
          child: _tabs[_selectedIndex].content),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            border: Border(top: BorderSide(color: theme.dividerColor)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_tabs.length, (idx) {
                final isSelected = _selectedIndex == idx;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedIndex = idx),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_tabs[idx].icon, color: isSelected ? theme.colorScheme.primary : theme.iconTheme.color),
                          const SizedBox(height: 2),
                          Text(
                            _tabs[idx].label,
                            style: TextStyle(
                              color: isSelected ? theme.colorScheme.primary : theme.textTheme.bodySmall?.color,
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabModel {
  final String label;
  final IconData icon;
  final Widget content;
  _TabModel(this.label, this.icon, this.content);
}

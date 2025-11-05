// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import '../../controllers/admin_shell_controller.dart';
// import '../widgets/kpi_card.dart';
// import '../widgets/section_card.dart';
//
// class AdminDashboardView extends GetView<AdminShellController> {
//   AdminDashboardView({super.key});
//   @override
//   final AdminShellController controller = Get.find<AdminShellController>();
//   @override
//   Widget build(BuildContext context) {
//     final isWide = MediaQuery.of(context).size.width >= 1080;
//     final chartHeight = isWide ? 260.0 : 200.0;
//
//     return CustomScrollView(
//       slivers: [
//         SliverAppBar(
//           backgroundColor: Colors.blue,
//           pinned: true,
//           automaticallyImplyLeading: false,
//           toolbarHeight: 80,
//           systemOverlayStyle: SystemUiOverlayStyle.light, // status bar icons ke liye
//           title: const Text(
//             "Dashboard",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//               fontSize: 22,
//             ),
//           ),
//         ),
//
//         SliverPadding(
//           padding: const EdgeInsets.all(24),
//           sliver: SliverToBoxAdapter(
//             child: Text(
//               'Overview',
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//           ),
//         ),
//         SliverPadding(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           sliver: SliverGrid.count(
//             crossAxisCount: isWide ? 4 : 2,
//             crossAxisSpacing: 12,
//             mainAxisSpacing: 12,
//             childAspectRatio: 1.6,
//             children: [
//               KpiCard(
//                 colorKey: KpiColor.primary,
//                 label: 'Present now',
//                 value: '148',
//               ),
//               KpiCard(
//                 colorKey: KpiColor.warning,
//                 label: 'On break',
//                 value: '24',
//               ),
//               KpiCard(
//                 colorKey: KpiColor.error,
//                 label: 'Late arrivals',
//                 value: '18',
//               ),
//               KpiCard(
//                 colorKey: KpiColor.info,
//                 label: 'Missing checkout',
//                 value: '9',
//               ),
//             ],
//           ),
//         ),
//         SliverPadding(
//           padding: const EdgeInsets.all(24),
//           sliver: SliverToBoxAdapter(
//             child: Wrap(
//               spacing: 16,
//               runSpacing: 16,
//               children: [
//                 SectionCard(
//                   title: 'Attendance trend',
//                   width: _w(context, take: 2),
//                   child: Container(
//                     height: chartHeight,
//                     alignment: Alignment.center,
//                     decoration: _chartDeco(context),
//                     child: const Text('Line Chart Placeholder'),
//                   ),
//                 ),
//                 SectionCard(
//                   title: 'Late vs On-time',
//                   width: _w(context, take: 2),
//                   child: Container(
//                     height: chartHeight,
//                     alignment: Alignment.center,
//                     decoration: _chartDeco(context),
//                     child: const Text('Bar Chart Placeholder'),
//                   ),
//                 ),
//                 SectionCard(
//                   title: 'Dept heatmap',
//                   width: _w(context, take: 2),
//                   child: Container(
//                     height: 220,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(14),
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFFDCFCE7), Color(0xFFFFF7ED)],
//                       ),
//                     ),
//                     child: const Text('Heatmap Placeholder'),
//                   ),
//                 ),
//                 SectionCard(
//                   title: "Today's punches",
//                   width: _w(context, take: 2),
//                   child: _realtimeTable(context),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   BoxDecoration _chartDeco(BuildContext context) => BoxDecoration(
//     borderRadius: BorderRadius.circular(14),
//     border: Border.all(color: Colors.blueGrey.withOpacity(.12)),
//   );
//
//   static double _w(BuildContext ctx, {required int take}) {
//     final base = MediaQuery.of(ctx).size.width - 48; // padding
//     final gutter = 16.0;
//     if (base < 720) return base;
//     const columns = 4;
//     final colWidth = (base - (gutter * (columns - 1))) / columns;
//     return (colWidth * take) + gutter * (take - 1);
//   }
//
//   Widget _realtimeTable(BuildContext context) {
//     final theme = Theme.of(context);
//     final rows = List.generate(
//       6,
//       (i) => {
//         'name': 'Member ${i + 1}',
//         'first': i.isEven ? '09:34' : '—',
//         'last': i.isEven ? '—' : '18:21',
//         'status': i.isEven ? 'On Time' : 'Late',
//       },
//     );
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Text("Today's punches", style: theme.textTheme.titleMedium),
//               const Spacer(),
//               IconButton(onPressed: () {}, icon: const Icon(Icons.open_in_new)),
//             ],
//           ),
//           const SizedBox(height: 8),
//           ...rows.map((m) {
//             final isBad = m['status'] == 'Late';
//             return ListTile(
//               dense: true,
//               contentPadding: EdgeInsets.zero,
//               leading: CircleAvatar(child: Text(m['name']![0])),
//               title: Text(m['name']!, style: theme.textTheme.titleSmall),
//               subtitle: Row(
//                 children: [
//                   _pill(Icons.login, m['first'] ?? '—', context),
//                   const SizedBox(width: 8),
//                   _pill(Icons.logout, m['last'] ?? '—', context),
//                   const SizedBox(width: 8),
//                   Icon(
//                     Icons.circle,
//                     size: 8,
//                     color: isBad
//                         ? theme.colorScheme.error
//                         : theme.colorScheme.primary,
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     m['status']!,
//                     style: theme.textTheme.labelSmall?.copyWith(
//                       color: isBad
//                           ? theme.colorScheme.error
//                           : theme.colorScheme.primary,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }
//
//   Widget _pill(IconData icon, String label, BuildContext ctx) {
//     final t = Theme.of(ctx);
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(999),
//         color: t.colorScheme.surfaceContainerHighest.withOpacity(.6),
//         border: Border.all(color: t.dividerColor.withOpacity(.15)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 12),
//           const SizedBox(width: 6),
//           Text(label, style: t.textTheme.labelSmall),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../controllers/admin_shell_controller.dart';
import '../widgets/kpi_card.dart';
import '../widgets/section_card.dart';

class AdminDashboardView extends GetView<AdminShellController> {
  AdminDashboardView({super.key});
  @override
  final AdminShellController controller = Get.find<AdminShellController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(

      drawer: const _AppDrawer(),
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        top: false,
        child: CustomScrollView(
           slivers: [
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              toolbarHeight: 60,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
              ),
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                   colors: [Color(0xFF2563EB), Color(0xFF0EA5E9)],
                  ),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
                ),
              ),
              titleSpacing: 0,
              title: Row(
                children: [
                  const SizedBox(width: 8),
                  Builder(
                    builder: (ctx) => IconButton(
                      icon:   Icon(Icons.menu, color: ColorScheme.of(context).surface),
                      onPressed: () => Scaffold.of(ctx).openDrawer(),
                      tooltip: 'Menu',
                    ),
                  ),
                  const SizedBox(width: 4),
                    Text(
                    'Dashboard',
                    style: TextStyle(
                      color: ColorScheme.of(context).surface,
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      letterSpacing: .2,
                    ),
                  ),
                ],
              ),
            ),

            // -------- Overview title --------
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverToBoxAdapter(
                child: Text('Overview', style: Theme.of(context).textTheme.headlineSmall),
              ),
            ),

            // -------- KPI Grid --------
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.crossAxisExtent >= 1080;
                  return SliverGrid.count(
                    crossAxisCount: isWide ? 4 : 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.6,
                    children: const [
                      KpiCard(colorKey: KpiColor.primary, label: 'Present now', value: '148'),
                      KpiCard(colorKey: KpiColor.warning, label: 'On break', value: '24'),
                      KpiCard(colorKey: KpiColor.error, label: 'Late arrivals', value: '18'),
                      KpiCard(colorKey: KpiColor.info, label: 'Missing checkout', value: '9'),
                    ],
                  );
                },
              ),
            ),

            // -------- Sections with real charts --------
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverToBoxAdapter(
                child: LayoutBuilder(
                  builder: (ctx, box) {
                    final isWide = MediaQuery.of(ctx).size.width >= 1080;
                    final chartHeight = isWide ? 260.0 : 200.0;

                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        SectionCard(
                          title: 'Attendance trend',
                          width: _w(ctx, take: 2),
                          child: Container(
                            height: chartHeight,
                            decoration: _chartDeco(ctx),
                            padding: const EdgeInsets.all(12),
                            child: const _LineChart(
                              points: [20, 36, 28, 44, 52, 48, 60, 58, 72, 68],
                            ),
                          ),
                        ),
                        SectionCard(
                          title: 'Late vs On-time',
                          width: _w(ctx, take: 2),
                          child: Container(
                            height: chartHeight,
                            decoration: _chartDeco(ctx),
                            padding: const EdgeInsets.all(12),
                            child: const _BarChart(
                              values: [12, 8, 15, 10, 6, 18, 9],
                              secondary: [38, 42, 35, 40, 44, 32, 41], // on-time
                            ),
                          ),
                        ),
                        SectionCard(
                          title: 'Dept heatmap',
                          width: _w(ctx, take: 2),
                          child: Container(
                            height: 220,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: const LinearGradient(
                                colors: [Color(0xFFDCFCE7), Color(0xFFFFF7ED)],
                              ),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: const _Heatmap(
                              rows: ['HR', 'IT', 'Sales', 'Ops'],
                              cols: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
                              data: [
                                [0.4, 0.7, 0.5, 0.6, 0.8],
                                [0.8, 0.6, 0.75, 0.5, 0.9],
                                [0.3, 0.4, 0.45, 0.55, 0.6],
                                [0.6, 0.5, 0.65, 0.7, 0.8],
                              ],
                            ),
                          ),
                        ),
                        SectionCard(
                          title: "Today's punches",
                          width: _w(ctx, take: 2),
                          child: _realtimeTable(ctx),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static BoxDecoration _chartDeco(BuildContext context) => BoxDecoration(
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: Colors.blueGrey.withOpacity(.12)),
  );

  static double _w(BuildContext ctx, {required int take}) {
    final base = MediaQuery.of(ctx).size.width - 48; // padding
    final gutter = 16.0;
    if (base < 720) return base;
    const columns = 4;
    final colWidth = (base - (gutter * (columns - 1))) / columns;
    return (colWidth * take) + gutter * (take - 1);
  }

  static Widget _realtimeTable(BuildContext context) {
    final theme = Theme.of(context);
    final rows = List.generate(
      6,
          (i) => {
        'name': 'Member ${i + 1}',
        'first': i.isEven ? '09:34' : '—',
        'last': i.isEven ? '—' : '18:21',
        'status': i.isEven ? 'On Time' : 'Late',
      },
    );
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Text("Today's punches", style: theme.textTheme.titleMedium),
              const Spacer(),
              IconButton(onPressed: () {}, icon: const Icon(Icons.open_in_new)),
            ],
          ),
          const SizedBox(height: 8),
          ...rows.map((m) {
            final isBad = m['status'] == 'Late';
            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(child: Text(m['name']![0])),
              title: Text(m['name']!, style: theme.textTheme.titleSmall),
              subtitle: Row(
                children: [
                  _pill(Icons.login, m['first'] ?? '—', context),
                  const SizedBox(width: 8),
                  _pill(Icons.logout, m['last'] ?? '—', context),
                  const SizedBox(width: 8),
                  Icon(Icons.circle, size: 8, color: isBad ? theme.colorScheme.error : theme.colorScheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    m['status']!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isBad ? theme.colorScheme.error : theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  static Widget _pill(IconData icon, String label, BuildContext ctx) {
    final t = Theme.of(ctx);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: t.colorScheme.surfaceContainerHighest.withOpacity(.6),
        border: Border.all(color: t.dividerColor.withOpacity(.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12),
          const SizedBox(width: 6),
          Text(label, style: t.textTheme.labelSmall),
        ],
      ),
    );
  }
}

/// --------------------------
/// Drawer (single icon behavior)
/// --------------------------
// class _AppDrawer extends StatelessWidget {
//   const _AppDrawer();
//
//   @override
//   Widget build(BuildContext context) {
//     Widget item(IconData icon, String title, {VoidCallback? onTap, bool selected = false}) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(12),
//           onTap: onTap,
//           child: Container(
//             decoration: BoxDecoration(
//               color: selected ? Colors.white : const Color(0xFF1F2937),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//             child: Row(
//               children: [
//                 Icon(icon, size: 20, color: selected ? Colors.black87 : Colors.white70),
//                 const SizedBox(width: 12),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     color: selected ? Colors.black87 : Colors.white,
//                     fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }
//
//     return Drawer(
//       width: 280,
//       backgroundColor: ColorScheme.of(context).primary,
//       child: SafeArea(
//         top: false,
//         child: Column(
//           children: [
//             const SizedBox(height: 8),
//             ListTile(
//               leading: const CircleAvatar(
//                 backgroundColor: Color(0xFF374151),
//                 child: Text('L', style: TextStyle(color: Colors.white)),
//               ),
//               title: const Text('Auratech',
//                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
//               subtitle: Text('HRMS Platform', style: TextStyle(color: Colors.white.withOpacity(.7))),
//             ),
//             const SizedBox(height: 8),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     item(Icons.dashboard_outlined, 'Dashboard', selected: false, onTap: () {
//                       Navigator.pop(context);
//                     }),
//                     item(Icons.groups_2_outlined, 'Employees',
//                         onTap: () {
//
//                       Navigator.push(context, MaterialPageRoute(builder: (_) => AdminTeamView()));
//                     }
//                     ),
//                     item(Icons.badge_outlined, 'Interns',onTap: () {
//
//                       Navigator.push(context, MaterialPageRoute(builder: (_) => Interns()));
//                     }),
//                     item(Icons.checklist_rtl, 'Tasks'),
//                     item(Icons.schedule, 'Attendance',onTap: () {
//
//                       Navigator.push(context, MaterialPageRoute(builder: (_) => AdminAttendanceView()));
//                     }),
//                     item(Icons.payments_outlined, 'Payroll',onTap: () {
//
//                       Navigator.push(context, MaterialPageRoute(builder: (_) => Payroll()));
//                     }),
//                     item(Icons.bar_chart_outlined, 'Performance',onTap: () {
//
//                       Navigator.push(context, MaterialPageRoute(builder: (_) => Performance()));
//                     }),
//                     item(Icons.edit_document, 'Documents', onTap: () {
//
//                       Navigator.push(context, MaterialPageRoute(builder: (_) => Documents()));
//                     }),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF1F2937),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 padding: const EdgeInsets.all(14),
//                 child: Row(
//                   children: [
//                     const CircleAvatar(
//                       backgroundColor: Color(0xFF374151),
//                       child: Icon(Icons.person, color: Colors.white70),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: const [
//                           Text('HR Manager', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
//                           SizedBox(height: 2),
//                           Text('hr@auratech.com', style: TextStyle(color: Colors.white70, fontSize: 12)),
//                           SizedBox(height: 4),
//                           Text('HR ADMIN',
//                               style: TextStyle(color: Color(0xFF93C5FD), fontWeight: FontWeight.w700, fontSize: 12)),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             item(Icons.logout, 'Logout', onTap: () => Navigator.pop(context)),
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }
// }


class _AppDrawer extends StatelessWidget {
  const _AppDrawer();




  void _closeThen(VoidCallback go) {
    // Drawer band karo
    Get.back(); // same as Navigator.pop(context)
    // Next microtask me navigation, taaki pop complete ho jaye
    Future.microtask(go);
  }

// Drawer item:


  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Re-usable item builder that respects theme
    Widget item(
        IconData icon,
        String title, {
          VoidCallback? onTap,
          bool selected = false,
        }) {
      final bg = selected ? cs.secondaryContainer : cs.surfaceContainerHighest;
      final fg = selected ? cs.onSecondaryContainer : cs.onSurface;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? cs.outlineVariant : cs.outlineVariant.withOpacity(0.4),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(icon, size: 20, color: fg.withOpacity(0.9)),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: fg,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Drawer(
      width: 280,
      // Use themed surface for Drawer, not raw primary
      backgroundColor: cs.surface,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: cs.secondaryContainer,
                child: Text('L', style: TextStyle(color: cs.onSecondaryContainer)),
              ),
              title: Text(
                'Auratech',
                style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w800),
              ),
              subtitle: Text(
                'HRMS Platform',
                style: TextStyle(color: cs.onSurfaceVariant),
              ),
            ),
            const SizedBox(height: 8),

            // MENU
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    item(Icons.dashboard_outlined, 'Dashboard', onTap: () {
                      Navigator.pop(context);
                      Get.back();
                     }),

                    item(Icons.groups_2_outlined, 'Employees', onTap: () {
                      _closeThen(() => Get.toNamed(AppRoutes.AdminTeamView));

                    }),

                    item(Icons.badge_outlined, 'Interns', onTap: () {
                      _closeThen(() => Get.toNamed(AppRoutes.interns));

                      // Navigator.pop(context);
                      // Get.toNamed('/interns'); // define in AppPages
                    }),

                    item(Icons.checklist_rtl, 'Tasks', onTap: () {
                      _closeThen(() => Get.toNamed(AppRoutes.interns));

                    }),

                    item(Icons.schedule, 'Attendance', onTap: () {
                      _closeThen(() => Get.toNamed(AppRoutes.attendence));

                    }),

                    item(Icons.payments_outlined, 'Payroll', onTap: () {
                      _closeThen(() => Get.toNamed(AppRoutes.payroll));

                    }),

                    item(Icons.bar_chart_outlined, 'Performance', onTap: () {
                      _closeThen(() => Get.toNamed(AppRoutes.performance));
                    }),

                    item(Icons.edit_document, 'Documents', onTap: () {
                      _closeThen(() => Get.toNamed(AppRoutes.documents));

                    }),
                    item(Icons.show_chart_outlined, 'Reports', onTap: () {
                      _closeThen(() => Get.toNamed(AppRoutes.adminreportsview));

                    }),
                    item(Icons.settings_outlined, 'Settings', onTap: () {
                      _closeThen(() => Get.toNamed(AppRoutes.adminseting));

                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // USER CARD (theme-aware)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: cs.outlineVariant),
                ),
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: cs.secondaryContainer,
                      child: Icon(Icons.person, color: cs.onSecondaryContainer),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('HR Manager',
                              style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text('hr@auratech.com',
                              style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text('HR ADMIN',
                              style: TextStyle(color: cs.primary, fontWeight: FontWeight.w700, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            item(Icons.logout, 'Logout', onTap: () {
              Navigator.pop(context);
              // logout flow here
            }),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

/// --------------------------
/// Lightweight custom charts (no packages)
/// --------------------------

class _LineChart extends StatelessWidget {
  const _LineChart({required this.points});
  final List<double> points;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LineChartPainter(points, Theme.of(context).colorScheme.primary),
      child: const SizedBox.expand(),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter(this.points, this.color);
  final List<double> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paintAxis = Paint()
      ..color = Colors.black.withOpacity(.12)
      ..strokeWidth = 1;
    // axes
    canvas.drawLine(Offset(0, size.height - 20), Offset(size.width, size.height - 20), paintAxis);
    canvas.drawLine(Offset(32, 0), Offset(32, size.height), paintAxis);

    if (points.isEmpty) return;
    final maxY = points.reduce((a, b) => a > b ? a : b);
    final minY = points.reduce((a, b) => a < b ? a : b);
    final dx = (size.width - 48) / (points.length - 1);
    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final x = 32 + i * dx;
      final y = (size.height - 32) - ((points[i] - minY) / (maxY - minY + 0.0001)) * (size.height - 56);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(32 + (points.length - 1) * dx, size.height - 20)
      ..lineTo(32, size.height - 20)
      ..close();

    final fillPaint = Paint()..shader = LinearGradient(
      colors: [color.withOpacity(.28), color.withOpacity(.04)],
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter old) => old.points != points || old.color != color;
}

class _BarChart extends StatelessWidget {
  const _BarChart({required this.values, this.secondary});
  final List<double> values;
  final List<double>? secondary; // e.g., on-time vs late

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BarChartPainter(
        values: values,
        secondary: secondary,
        primary: Theme.of(context).colorScheme.error,
        secondaryColor: Theme.of(context).colorScheme.primary,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  _BarChartPainter({
    required this.values,
    required this.primary,
    this.secondary,
    required this.secondaryColor,
  });

  final List<double> values;
  final List<double>? secondary;
  final Color primary;
  final Color secondaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final axis = Paint()..color = Colors.black.withOpacity(.12)..strokeWidth = 1;
    canvas.drawLine(Offset(0, size.height - 20), Offset(size.width, size.height - 20), axis);

    final count = values.length;
    final groupWidth = (size.width - 40) / count;
    final barWidth = secondary == null ? groupWidth * .5 : groupWidth * .35;

    final maxV = [
      ...values,
      ...(secondary ?? const <double>[]),
    ].fold<double>(0, (p, n) => n > p ? n : p);

    for (int i = 0; i < count; i++) {
      final x = 20 + i * groupWidth + (secondary == null ? groupWidth * .25 : groupWidth * .15);

      double h1 = ((values[i]) / (maxV == 0 ? 1 : maxV)) * (size.height - 40);
      final r1 = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, (size.height - 20) - h1, barWidth, h1),
        const Radius.circular(6),
      );
      canvas.drawRRect(r1, Paint()..color = primary.withOpacity(.9));

      if (secondary != null && i < secondary!.length) {
        double h2 = ((secondary![i]) / (maxV == 0 ? 1 : maxV)) * (size.height - 40);
        final r2 = RRect.fromRectAndRadius(
          Rect.fromLTWH(x + barWidth + 6, (size.height - 20) - h2, barWidth, h2),
          const Radius.circular(6),
        );
        canvas.drawRRect(r2, Paint()..color = secondaryColor.withOpacity(.9));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter old) =>
      old.values != values || old.secondary != secondary || old.primary != primary;
}

class _Heatmap extends StatelessWidget {
  const _Heatmap({required this.rows, required this.cols, required this.data});
  final List<String> rows;
  final List<String> cols;
  final List<List<double>> data;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _HeatmapPainter(rows: rows, cols: cols, data: data),
      child: const SizedBox.expand(),
    );
  }
}

class _HeatmapPainter extends CustomPainter {
  _HeatmapPainter({required this.rows, required this.cols, required this.data});
  final List<String> rows;
  final List<String> cols;
  final List<List<double>> data;

  @override
  void paint(Canvas canvas, Size size) {
    final r = rows.length;
    final c = cols.length;
    final cellW = (size.width - 60) / c;
    final cellH = (size.height - 40) / r;

    // headers
    void tp(String s, double x, double y, {bool bold = false}) {
      final tp = TextPainter(
        text: TextSpan(
          text: s,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 11,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();
      tp.paint(canvas, Offset(x, y));
    }

    for (int i = 0; i < rows.length; i++) {
      tp(rows[i], 0, 20 + i * cellH + cellH / 2 - 7);
    }
    for (int j = 0; j < cols.length; j++) {
      tp(cols[j], 40 + j * cellW + cellW / 2 - 10, 0, bold: true);
    }

    for (int i = 0; i < r; i++) {
      for (int j = 0; j < c; j++) {
        final v = data[i][j].clamp(0.0, 1.0);
        final color = Color.lerp(const Color(0xFFd1fae5), const Color(0xFFfb923c), v)!;
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(40 + j * cellW, 20 + i * cellH, cellW - 6, cellH - 6),
          const Radius.circular(6),
        );
        canvas.drawRRect(rect, Paint()..color = color);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HeatmapPainter oldDelegate) => false;
}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controllers/admin_shell_controller.dart';
// import '../widgets/section_card.dart';
// import '../widgets/search_filter_row.dart';
// import '../widgets/paged_data_table.dart';
// import '../widgets/status_chip.dart';
//
//
// class AdminTeamView extends GetView<AdminShellController> {
//   const AdminTeamView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final isNarrow = constraints.maxWidth < 560; // phone / narrow pane
//         return Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(child: const ThemeDebugBanner()), // TEMP
//
//               // Header + actions (Wrap so it flows on small widths)
//               Wrap(
//                 spacing: 12,
//                 runSpacing: 8,
//                 crossAxisAlignment: WrapCrossAlignment.center,
//                 children: [
//                   Text(
//                     'Team & Attendance',
//                     style: theme.textTheme.headlineSmall,
//                   ),
//                   if (!isNarrow) const SizedBox(width: 12),
//                   // Push actions to the end on wide, stack on narrow
//                   if (!isNarrow) const Spacer(),
//                   OverflowBar(
//                     spacing: 8,
//                     overflowAlignment: OverflowBarAlignment.end,
//                     children: [
//                       FilledButton.icon(
//                         onPressed: () {},
//                         icon: const Icon(Icons.download_outlined),
//                         label: const Text('Export'),
//                       ),
//                       OutlinedButton.icon(
//                         onPressed: () {},
//                         icon: const Icon(Icons.add),
//                         label: const Text('Add member'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 16),
//
//               // Filters row (uses Wrap internally, safe on small screens)
//               SectionCard(
//                 title: 'Filters',
//                 child: SearchFilterRow(
//                   searchCtrl: controller.globalSearchCtrl,
//                   onSearch: controller.applyGlobalSearch,
//                   rightChildren: [
//                     DropdownButton<String>(
//                       value: 'All',
//                       items: const [
//                         DropdownMenuItem(
//                           value: 'All',
//                           child: Text('All Depts'),
//                         ),
//                         DropdownMenuItem(value: 'Sales', child: Text('Sales')),
//                         DropdownMenuItem(value: 'Ops', child: Text('Ops')),
//                       ],
//                       onChanged: (v) {},
//                     ),
//                     const SizedBox(width: 8),
//                     DropdownButton<String>(
//                       value: 'All',
//                       items: const [
//                         DropdownMenuItem(
//                           value: 'All',
//                           child: Text('All Shifts'),
//                         ),
//                         DropdownMenuItem(value: 'G1', child: Text('General')),
//                         DropdownMenuItem(value: 'N1', child: Text('Night')),
//                       ],
//                       onChanged: (v) {},
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//                Expanded(
//                 child: SectionCard(
//                   title: "Today's Status",
//                   trailing: Wrap(
//                     spacing: 8,
//                     children: [
//                       OutlinedButton.icon(
//                         onPressed: () {},
//                         icon: const Icon(Icons.select_all),
//                         label: const Text('Bulk Select'),
//                       ),
//                       OutlinedButton.icon(
//                         onPressed: () {},
//                         icon: const Icon(Icons.edit),
//                         label: const Text('Bulk Edit'),
//                       ),
//                     ],
//                   ),
//                   child: SizedBox(
//                     height: 400, // Fixed height for scrollable area
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       child: PagedDataTable(
//                         columns: const [
//                           DataColumn(label: Text('Employee'), tooltip: 'Employee name and details'),
//                           DataColumn(label: Text('Role'), tooltip: 'Employee role/position'),
//                           DataColumn(label: Text('Shift'), tooltip: 'Work shift timing'),
//                           DataColumn(label: Text('First Punch'), tooltip: 'First check-in time'),
//                           DataColumn(label: Text('Last Punch'), tooltip: 'Last check-out time'),
//                           DataColumn(label: Text('Status'), tooltip: 'Attendance status'),
//                           DataColumn(label: Text('Location'), tooltip: 'Check-in location'),
//                         ],
//                         rowsBuilder: (page, pageSize) {
//                           final start = (page - 1) * pageSize;
//                           return List<DataRow>.generate(pageSize, (i) {
//                             final idx = start + i + 1;
//                             final status = (idx % 3 == 0) ? 'Late' : 'On Time';
//                             final isEven = i.isEven;
//
//                             return DataRow(
//                               color: WidgetStateProperty.resolveWith(
//                                     (states) => isEven
//                                     ? Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.1)
//                                     : null,
//                               ),
//                               cells: [
//                                 DataCell(
//                                   Row(
//                                     children: [
//                                       CircleAvatar(
//                                         radius: 16,
//                                         backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
//                                         child: Text(
//                                           'E${idx % 10}',
//                                           style: TextStyle(
//                                             fontSize: 10,
//                                             fontWeight: FontWeight.w600,
//                                             color: Theme.of(context).colorScheme.primary,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 8),
//                                       Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Text(
//                                             'Employee $idx',
//                                             style: const TextStyle(fontWeight: FontWeight.w500),
//                                           ),
//                                           Text(
//                                             'EMP${1000 + idx}',
//                                             style: Theme.of(context).textTheme.labelSmall?.copyWith(
//                                               color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const DataCell(Text('Associate')),
//                                 const DataCell(Text('9:30–18:30')),
//                                 DataCell(
//                                   Text(
//                                     idx.isEven ? '09:22' : '—',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w500,
//                                       color: idx.isEven
//                                           ? Theme.of(context).colorScheme.primary
//                                           : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
//                                     ),
//                                   ),
//                                 ),
//                                 DataCell(
//                                   Text(
//                                     idx.isEven ? '—' : '18:41',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w500,
//                                       color: !idx.isEven
//                                           ? Theme.of(context).colorScheme.primary
//                                           : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
//                                     ),
//                                   ),
//                                 ),
//                                 DataCell(StatusChip(text: status)),
//                                 DataCell(
//                                   Row(
//                                     children: [
//                                       Icon(
//                                         Icons.location_on,
//                                         size: 14,
//                                         color: Theme.of(context).colorScheme.primary,
//                                       ),
//                                       const SizedBox(width: 4),
//                                       const Text('HQ-1'),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             );
//                           });
//                         },
//                         totalRows: 120,
//                         initialPage: controller.teamPage.value,
//                         pageSize: controller.teamPageSize.value,
//                         onPageChanged: (p) => controller.teamPage.value = p,
//                         onPageSizeChanged: (s) => controller.teamPageSize.value = s,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               ]),
//         );
//       },
//     );
//   }
// }
//
// class ThemeDebugBanner extends StatelessWidget {
//   const ThemeDebugBanner({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: theme.colorScheme.secondaryContainer,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: DefaultTextStyle(
//         style: theme.textTheme.labelMedium!.copyWith(
//           color: theme.colorScheme.onSecondaryContainer,
//         ),
//         child: Column(
//           children: [
//             Text('Theme.of.brightness: ${theme.brightness}'),
//             const SizedBox(width: 12),
//             Text('Get.isDarkMode: ${Get.isDarkMode}'),
//             const SizedBox(width: 12),
//             Text('Platform: ${MediaQuery.of(context).platformBrightness}'),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_shell_controller.dart';
import '../widgets/section_card.dart';
import '../widgets/search_filter_row.dart';
import '../widgets/paged_data_table.dart';
import '../widgets/status_chip.dart';

class AdminTeamView extends GetView<AdminShellController> {
  const AdminTeamView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // optional: force theme’s scaffold bg (Material 3 friendly)
      // backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Team & Attendance'),
        // If you already show header inside body, you can hide AppBar by removing it.
        // I kept it minimal; remove if not needed.
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 560;

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // OPTIONAL: remove AppBar above and keep this header OR vice-versa
                  if (false) // set to true if you want the old header instead of AppBar
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text('Team & Attendance', style: theme.textTheme.headlineSmall),
                        if (!isNarrow) const SizedBox(width: 12),
                        if (!isNarrow) const Spacer(),
                        OverflowBar(
                          spacing: 8,
                          overflowAlignment: OverflowBarAlignment.end,
                          children: [
                            FilledButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.download_outlined),
                              label: const Text('Export'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.add),
                              label: const Text('Add member'),
                            ),
                          ],
                        ),
                      ],
                    ),

                  const SizedBox(height: 16),

                  SectionCard(
                    title: 'Filters',
                    child: SearchFilterRow(
                      searchCtrl: controller.globalSearchCtrl,
                      onSearch: controller.applyGlobalSearch,
                      rightChildren: [
                        DropdownButton<String>(
                          value: 'All',
                          items: const [
                            DropdownMenuItem(value: 'All', child: Text('All Depts')),
                            DropdownMenuItem(value: 'Sales', child: Text('Sales')),
                            DropdownMenuItem(value: 'Ops', child: Text('Ops')),
                          ],
                          onChanged: (v) {},
                        ),
                        const SizedBox(width: 8),
                        DropdownButton<String>(
                          value: 'All',
                          items: const [
                            DropdownMenuItem(value: 'All', child: Text('All Shifts')),
                            DropdownMenuItem(value: 'G1', child: Text('General')),
                            DropdownMenuItem(value: 'N1', child: Text('Night')),
                          ],
                          onChanged: (v) {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: SectionCard(
                      title: "Today's Status",
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.select_all),
                            label: const Text('Bulk Select'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.edit),
                            label: const Text('Bulk Edit'),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        height: 400,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: PagedDataTable(
                            columns: const [
                              DataColumn(label: Text('Employee'), tooltip: 'Employee name and details'),
                              DataColumn(label: Text('Role'), tooltip: 'Employee role/position'),
                              DataColumn(label: Text('Shift'), tooltip: 'Work shift timing'),
                              DataColumn(label: Text('First Punch'), tooltip: 'First check-in time'),
                              DataColumn(label: Text('Last Punch'), tooltip: 'Last check-out time'),
                              DataColumn(label: Text('Status'), tooltip: 'Attendance status'),
                              DataColumn(label: Text('Location'), tooltip: 'Check-in location'),
                            ],
                            rowsBuilder: (page, pageSize) {
                              final start = (page - 1) * pageSize;
                              return List<DataRow>.generate(pageSize, (i) {
                                final idx = start + i + 1;
                                final status = (idx % 3 == 0) ? 'Late' : 'On Time';
                                final isEven = i.isEven;

                                return DataRow(
                                  color: WidgetStateProperty.resolveWith(
                                        (_) => isEven
                                        ? Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest
                                        .withOpacity(0.08)
                                        : null,
                                  ),
                                  cells: [
                                    DataCell(Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                                          child: Text(
                                            'E${idx % 10}',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('Employee $idx', style: const TextStyle(fontWeight: FontWeight.w500)),
                                            Text(
                                              'EMP${1000 + idx}',
                                              style: theme.textTheme.labelSmall?.copyWith(
                                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                    const DataCell(Text('Associate')),
                                    const DataCell(Text('9:30–18:30')),
                                    DataCell(Text(
                                      idx.isEven ? '09:22' : '—',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: idx.isEven
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.onSurface.withOpacity(0.4),
                                      ),
                                    )),
                                    DataCell(Text(
                                      idx.isEven ? '—' : '18:41',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: !idx.isEven
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.onSurface.withOpacity(0.4),
                                      ),
                                    )),
                                    DataCell(StatusChip(text: status)),
                                    DataCell(Row(
                                      children: [
                                        Icon(Icons.location_on, size: 14, color: theme.colorScheme.primary),
                                        const SizedBox(width: 4),
                                        const Text('HQ-1'),
                                      ],
                                    )),
                                  ],
                                );
                              });
                            },
                            totalRows: 120,
                            initialPage: controller.teamPage.value,
                            pageSize: controller.teamPageSize.value,
                            onPageChanged: (p) => controller.teamPage.value = p,
                            onPageSizeChanged: (s) => controller.teamPageSize.value = s,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_shell_controller.dart';
import '../widgets/section_card.dart';
import '../widgets/paged_data_table.dart';

class AdminAttendanceView extends GetView<AdminShellController> {
  const AdminAttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.of(context).size.width >= 1024;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
             children: [
               _buildHeaderSection(theme, isWide),

              const SizedBox(height: 24),
              _buildFiltersSection(theme),



               Expanded(
                child: _buildTableSection(theme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(ThemeData theme, bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isWide)
          Row(
            children: [
              Text('Attendance (Company)', style: theme.textTheme.headlineSmall),
              const Spacer(),
              _buildActionButtons(),
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Attendance (Company)', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 12),
              _buildActionButtons(),
            ],
          ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.lock_clock_outlined, size: 16),
          label: const Text('Lock Day'),
        ),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.rule_folder_outlined, size: 16),
          label: const Text('Policies'),
        ),
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add_task, size: 16),
          label: const Text('Approve Pending'),
        ),
      ],
    );
  }

  Widget _buildFiltersSection(ThemeData theme) {
    return SectionCard(
      title: 'Filters',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 280,
            child: TextField(
              controller: Get.find<AdminShellController>().globalSearchCtrl,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search employee, dept, shift...',
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              onSubmitted: (_) => Get.find<AdminShellController>().applyGlobalSearch("search"),
            ),
          ),
          _buildFilterDropdown('All Status', [
            'All Status',
            'Present',
            'Late',
            'Half Day',
            'Absent',
          ]),
          _buildFilterDropdown('All Shifts', [
            'All Shifts',
            'General',
            'Night',
          ]),
          _buildFilterDropdown('This Month', [
            'Today',
            'This Week',
            'This Month',
          ]),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(String value, List<String> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: value,
        isDense: true,
        underline: const SizedBox(),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (v) {},
      ),
    );
  }

  Widget _buildTableSection(ThemeData theme) {
    return SectionCard(
      title: "Today's Attendance",
      trailing: Wrap(
        spacing: 5,
        children: [
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Refresh'),
          ),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download_outlined, size: 16),
            label: const Text('Export'),
          ),
        ],
      ),

      child: _buildDataTable(),
    );
  }

  Widget _buildDataTable() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Table Header Styling
          Container(
            height: 0,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: const [
                  Expanded(flex: 2, child: Text('Employee', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(flex: 1, child: Text('Dept', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(flex: 2, child: Text('Shift', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(flex: 1, child: Text('Check-in', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(flex: 1, child: Text('Check-out', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(flex: 1, child: Text('Breaks', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(flex: 1, child: Text('Total', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(flex: 1, child: Text('Status', style: TextStyle(fontWeight: FontWeight.w600))),
                  Expanded(flex: 1, child: Text('Location', style: TextStyle(fontWeight: FontWeight.w600))),
                ],
              ),
            ),
          ),

          // Table Content
          Expanded(
            child: _buildScrollableTable(),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableTable() {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        child: SizedBox(
          width: 1200,
          height: 800,// Fixed width for horizontal scrolling
          child: PagedDataTable(
            columns: const [
              DataColumn(label: SizedBox(width: 150, child: Text('Employee'))),
              DataColumn(label: SizedBox(width: 80, child: Text('Dept'))),
              DataColumn(label: SizedBox(width: 120, child: Text('Shift'))),
              DataColumn(label: SizedBox(width: 80, child: Text('Check-in'))),
              DataColumn(label: SizedBox(width: 80, child: Text('Check-out'))),
              DataColumn(label: SizedBox(width: 80, child: Text('Breaks'))),
              DataColumn(label: SizedBox(width: 80, child: Text('Total'))),
              DataColumn(label: SizedBox(width: 100, child: Text('Status'))),
              DataColumn(label: SizedBox(width: 80, child: Text('Location'))),
            ],
            rowsBuilder: (page, pageSize) {
              final start = (page - 1) * pageSize;
              return List<DataRow>.generate(pageSize, (i) {
                final idx = start + i + 1;
                final isLate = idx % 4 == 0;
                final isHalfDay = idx % 7 == 0;
                final status = isHalfDay ? 'Half Day' : (isLate ? 'Late' : 'On Time');
                final isEven = i.isEven;

                return DataRow(
                  color: WidgetStateProperty.resolveWith(
                        (states) => isEven ? Colors.grey.shade50 : Colors.white,
                  ),
                  cells: [
                    DataCell(_buildEmployeeCell(idx)),
                    const DataCell(Text('Ops', style: TextStyle(fontWeight: FontWeight.w500))),
                    const DataCell(Text('9:30–18:30', style: TextStyle(fontWeight: FontWeight.w500))),
                    DataCell(Text(
                      idx.isEven ? '09:22' : '—',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: idx.isEven ? Colors.green.shade700 : Colors.grey.shade500,
                      ),
                    )),
                    DataCell(Text(
                      idx.isEven ? '—' : '18:41',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: !idx.isEven ? Colors.blue.shade700 : Colors.grey.shade500,
                      ),
                    )),
                    const DataCell(Text('2 (00:30)', style: TextStyle(fontWeight: FontWeight.w500))),
                    const DataCell(Text('08:11', style: TextStyle(fontWeight: FontWeight.w600))),
                    DataCell(_buildStatusBadge(status)),
                    DataCell(Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.green.shade700),
                        const SizedBox(width: 4),
                        const Text('HQ-1', style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    )),
                  ],
                );
              });
            },
            totalRows: 120,
            initialPage: Get.find<AdminShellController>().teamPage.value,
            pageSize: Get.find<AdminShellController>().teamPageSize.value,
            onPageChanged: (p) => Get.find<AdminShellController>().teamPage.value = p,
            onPageSizeChanged: (s) => Get.find<AdminShellController>().teamPageSize.value = s,
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeCell(int index) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.blue.shade50,
          child: Text(
            'E${index % 10}',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Employee $index',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              'EMP${1000 + index}',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case 'Late':
        backgroundColor = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
        break;
      case 'Half Day':
        backgroundColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        break;
      default:
        backgroundColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
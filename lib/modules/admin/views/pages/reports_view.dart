import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_shell_controller.dart';
import '../widgets/section_card.dart';

class AdminReportsView extends StatefulWidget {
  const AdminReportsView({super.key});

  @override
  State<AdminReportsView> createState() => _AdminReportsViewState();
}

class _AdminReportsViewState extends State<AdminReportsView> {
  late final AdminShellController c;

  late DateTime _now;
  late Map<String, DateTimeRange> _ranges;
  String _selectedKey = 'This Month';
  late DateTimeRange _selectedRange;

  @override
  void initState() {
    super.initState();
    c = Get.find<AdminShellController>();

    _now = DateTime.now();
    final startOfMonth = DateTime(_now.year, _now.month, 1);
    final startOfWeek = _now.subtract(Duration(days: _now.weekday - 1));

    _ranges = {
      'This Week': DateTimeRange(start: startOfWeek, end: _now),
      'Last 7 Days': DateTimeRange(start: _now.subtract(const Duration(days: 6)), end: _now),
      'This Month': DateTimeRange(start: startOfMonth, end: _now),
    };

    _selectedRange = _ranges[_selectedKey]!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & MIS Export'),
        actions: [
          IconButton(
            tooltip: 'Pick date range',
            icon: const Icon(Icons.date_range_outlined),
            onPressed: () async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(_now.year - 3),
                lastDate: DateTime(_now.year + 1),
                initialDateRange: _selectedRange,
                builder: (ctx, child) => Theme(data: Theme.of(ctx), child: child!),
              );
              if (picked != null) {
                setState(() {
                  _selectedKey = 'Custom';
                  _selectedRange = picked;
                });
              }
            },
          ),
          IconButton(
            tooltip: 'Columns',
            icon: const Icon(Icons.view_week_outlined),
            onPressed: _openColumnsSheet,
          ),
          const SizedBox(width: 4),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => c.exportCompanyMIS(_selectedRange),
        icon: const Icon(Icons.download_outlined),
        label: const Text('Export XLSX'),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ========== FILTERS ==========
            SectionCard(
              title: 'Filters',
              trailing: FilledButton.tonalIcon(
                onPressed: _openColumnsSheet,
                icon: const Icon(Icons.tune),
                label: const Text('Columns'),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Quick ranges + custom chip
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final k in _ranges.keys)
                        ChoiceChip(
                          label: Text(k),
                          selected: _selectedKey == k,
                          onSelected: (_) {
                            setState(() {
                              _selectedKey = k;
                              _selectedRange = _ranges[k]!;
                            });
                          },
                        ),
                      ChoiceChip(
                        label: Text(
                          'Custom: ${_fmtDate(_selectedRange.start)} – ${_fmtDate(_selectedRange.end)}',
                          overflow: TextOverflow.ellipsis,
                        ),
                        selected: _selectedKey == 'Custom',
                        onSelected: (_) async {
                          final picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(_now.year - 3),
                            lastDate: DateTime(_now.year + 1),
                            initialDateRange: _selectedRange,
                            builder: (ctx, child) => Theme(data: Theme.of(ctx), child: child!),
                          );
                          if (picked != null) {
                            setState(() {
                              _selectedKey = 'Custom';
                              _selectedRange = picked;
                            });
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Export row (responsive)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.icon(
                        onPressed: () => c.exportCompanyMIS(_selectedRange),
                        icon: const Icon(Icons.file_download_outlined),
                        label: const Text('Export XLSX'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          // Hook your PDF export
                          Get.snackbar('Export', 'PDF export coming soon');
                        },
                        icon: const Icon(Icons.picture_as_pdf_outlined),
                        label: const Text('Export PDF'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ========== REPORT LIST ==========
            SectionCard(
              title: 'Report Builder',
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 15,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: cs.outlineVariant.withOpacity(.6)),
                itemBuilder: (_, i) => _ReportCard(
                  index: i,
                  range: _selectedRange,
                  onExportRow: () => Get.snackbar('Export', 'Row ${i + 1} exported'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openColumnsSheet() {
    final options = const [
      'Name',
      'Employee Code',
      'Date',
      'In Time',
      'Out Time',
      'Work Hrs',
      'Break',
      'Overtime',
      'Status',
      'Location',
    ];

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(ctx).viewInsets.bottom + 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Select Columns', style: Theme.of(ctx).textTheme.titleMedium),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: options.map((col) {
                  // You can wire these to real state if needed
                  return FilterChip(
                    label: Text(col),
                    selected: ['Name', 'Work Hrs', 'Break', 'Status'].contains(col),
                    onSelected: (_) {},
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close),
                      label: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.check),
                      label: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

/* ----------------------- Polished Report Card ----------------------- */

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.index,
    required this.range,
    this.onExportRow,
  });

  final int index;
  final DateTimeRange range;
  final VoidCallback? onExportRow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final name = 'Employee ${index + 1}';
    final code = 'EMP${(index + 1).toString().padLeft(4, '0')}';
    const work = '08:14';
    const brk = '00:38';
    const status = 'On Time';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row (name + export)
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: onExportRow,
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('Export'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${_fmtDate(range.start)} – ${_fmtDate(range.end)}',
              style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 10),

            // Badges & key/value chips (responsive)
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _KVChip(k: 'Code', v: code),
                _Pill(label: 'Work', value: work),
                _Pill(label: 'Break', value: brk),
                _StatusBadge(status: status),
                _KVChip(k: 'Loc', v: 'HQ-1'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

class _KVChip extends StatelessWidget {
  const _KVChip({required this.k, required this.v});
  final String k, v;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$k: ', style: const TextStyle(fontWeight: FontWeight.w700)),
          Text(v),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.value});
  final String label, value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: DefaultTextStyle(
        style: TextStyle(color: cs.onSecondaryContainer, fontWeight: FontWeight.w700),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            const SizedBox(width: 6),
            Text(value),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    late Color bg;
    late Color fg;
    late IconData icon;

    switch (status) {
      case 'On Time':
        bg = cs.secondaryContainer;
        fg = cs.onSecondaryContainer;
        icon = Icons.verified_outlined;
        break;
      case 'Late':
        bg = cs.tertiaryContainer;
        fg = cs.onTertiaryContainer;
        icon = Icons.schedule_outlined;
        break;
      default:
        bg = Color.alphaBlend(cs.error.withOpacity(.14), cs.surface);
        fg = cs.onSurface;
        icon = Icons.block_outlined;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
          Text(status, style: TextStyle(color: fg, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

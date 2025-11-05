import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_shell_controller.dart';
import '../widgets/section_card.dart';

class AdminShiftsView extends GetView<AdminShellController> {
  const AdminShiftsView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Mock list (replace with controller.shifts)
    final shifts = List.generate(
      10,
          (i) => _ShiftVm(
        name: 'General ${i + 1}',
        start: const TimeOfDay(hour: 9, minute: 30),
        end: const TimeOfDay(hour: 18, minute: 30),
        graceMins: 10,
        autoCheckout: const TimeOfDay(hour: 20, minute: 0),
        breakCount: i.isEven ? 2 : 1,
        breakPolicy: i.isEven ? 'mixed' : 'paid',
        weeklyOffs: const ['Sun'],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shifts'),
        actions: [
          IconButton(
            tooltip: 'Search',
            onPressed: () => _openSearch(context),
            icon: const Icon(Icons.search),
          ),
          IconButton(
            tooltip: 'Filters',
            onPressed: () => _openFilter(context),
            icon: const Icon(Icons.tune),
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openShiftEditor(context),
        icon: const Icon(Icons.add),
        label: const Text('New Shift'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SectionCard(
            title: 'Shift List',
            child: LayoutBuilder(
              builder: (context, c) {
                final isWide = c.maxWidth > 720;
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: shifts.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: cs.outlineVariant.withOpacity(.6),
                  ),
                  itemBuilder: (_, i) => _ShiftTile(
                    vm: shifts[i],
                    wide: isWide,
                    onEdit: () => _openShiftEditor(context, initial: shifts[i]),
                    onClone: () => Get.snackbar('Cloned', '${shifts[i].name} cloned'),
                    onDelete: () => _confirmDelete(context, shifts[i]),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // ---- dialogs/sheets ----

  void _openSearch(BuildContext context) {
    showSearch(context: context, delegate: _ShiftSearchDelegate());
  }

  void _openFilter(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Filters', style: Theme.of(ctx).textTheme.titleMedium),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                _TagChip(label: 'General'),
                _TagChip(label: 'Night'),
                _TagChip(label: 'Rotational'),
                _TagChip(label: 'With Auto-checkout'),
              ],
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
      ),
      backgroundColor: cs.surface,
    );
  }

  void _openShiftEditor(BuildContext context, { _ShiftVm? initial }) {
    final cs = Theme.of(context).colorScheme;
    final c = Get.find<AdminShellController>();

    // Local state (prefill if editing)
    final nameCtrl = TextEditingController(text: initial?.name ?? '');
    TimeOfDay start = initial?.start ?? const TimeOfDay(hour: 9, minute: 30);
    TimeOfDay end = initial?.end ?? const TimeOfDay(hour: 18, minute: 30);
    TimeOfDay? auto = initial?.autoCheckout ?? const TimeOfDay(hour: 20, minute: 0);
    int grace = initial?.graceMins ?? 10;
    int breaks = initial?.breakCount ?? 1;
    String policy = initial?.breakPolicy ?? 'paid';
    final offs = <String>{...(initial?.weeklyOffs ?? const [])};
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: cs.surface,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16, right: 16, top: 8,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: Form(
          key: formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                initial == null ? 'Create Shift' : 'Edit Shift',
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),

              // Name
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              // Start/End
              Row(
                children: [
                  Expanded(
                    child: _TimePickerFormTile(
                      label: 'Start',
                      value: start,
                      onPick: (t) => start = t,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TimePickerFormTile(
                      label: 'End',
                      value: end,
                      onPick: (t) => end = t,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Grace / Auto-checkout
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: grace.toString(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Grace (mins)'),
                      onChanged: (v) => grace = int.tryParse(v) ?? grace,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TimePickerFormTile(
                      label: 'Auto-checkout',
                      value: auto,
                      nullable: true,
                      onPick: (t) => auto = t,
                      onClear: () => auto = null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Breaks + policy
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: breaks.toString(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Break count'),
                      onChanged: (v) => breaks = int.tryParse(v) ?? breaks,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: policy,
                      items: const [
                        DropdownMenuItem(value: 'paid', child: Text('Paid')),
                        DropdownMenuItem(value: 'unpaid', child: Text('Unpaid')),
                        DropdownMenuItem(value: 'mixed', child: Text('Mixed')),
                      ],
                      onChanged: (v) => policy = v ?? policy,
                      decoration: const InputDecoration(labelText: 'Break policy'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Weekly offs
              Text('Weekly Offs', style: Theme.of(ctx).textTheme.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'].map((d) {
                  final sel = offs.contains(d);
                  return FilterChip(
                    label: Text(d),
                    selected: sel,
                    onSelected: (v) { if (v) offs.add(d); else offs.remove(d); },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.close),
                      label: const Text('Cancel'),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.check),
                      label: Text(initial == null ? 'Create' : 'Save'),
                      onPressed: () {
                        if (!formKey.currentState!.validate()) return;

                        final payload = _ShiftVm(
                          name: nameCtrl.text.trim(),
                          start: start,
                          end: end,
                          graceMins: grace,
                          autoCheckout: auto,
                          breakCount: breaks,
                          breakPolicy: policy,
                          weeklyOffs: offs.toList(),
                        );

                        // Hook to your controller:
                        // initial == null ? c.createShift(payload.toMap()) : c.updateShift(payload.toMap());
                        Get.snackbar('Saved', '${payload.name} updated');

                        Navigator.pop(ctx);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, _ShiftVm vm) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Shift?'),
        content: Text('This will remove "${vm.name}". This action cannot be undone.'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          FilledButton.tonal(
            onPressed: () {
              // call controller.deleteShift(vm)
              Get.back();
              Get.snackbar('Deleted', vm.name);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ---- TILE (beautiful + responsive) ----
class _ShiftTile extends StatelessWidget {
  const _ShiftTile({
    required this.vm,
    required this.wide,
    required this.onEdit,
    required this.onClone,
    required this.onDelete,
  });

  final _ShiftVm vm;
  final bool wide;
  final VoidCallback onEdit, onClone, onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + badges
            Row(
              children: [
                Expanded(
                  child: Text(vm.name,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                ),
                if (vm.autoCheckout != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: cs.secondaryContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text('Auto-checkout ${_fmtTime(vm.autoCheckout!)}',
                        style: TextStyle(color: cs.onSecondaryContainer, fontWeight: FontWeight.w700)),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Time row
            Row(
              children: [
                Icon(Icons.access_time, size: 18, color: cs.primary),
                const SizedBox(width: 6),
                Text('${_fmtTime(vm.start)} – ${_fmtTime(vm.end)}',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(width: 10),
                Text('• Grace ${vm.graceMins}m',
                    style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
              ],
            ),
            const SizedBox(height: 8),

            // Details row (wrap-safe)
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                _IconText(icon: Icons.free_breakfast_outlined, text: 'Breaks ${vm.breakCount}'),
                _IconText(
                  icon: Icons.policy_outlined,
                  text: 'Policy ${vm.breakPolicy}',
                ),
                if (vm.weeklyOffs.isNotEmpty)
                  _IconText(icon: Icons.event_busy_outlined, text: 'Off: ${vm.weeklyOffs.join(', ')}'),
              ],
            ),
            const SizedBox(height: 12),

            // Actions (Wrap => no overflow)
            Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton(onPressed: onEdit, child: const Text('Edit')),
                  OutlinedButton(onPressed: onClone, child: const Text('Clone')),
                  IconButton(
                    tooltip: 'Delete',
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                    color: cs.error,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---- Small UI helpers ----
class _IconText extends StatelessWidget {
  const _IconText({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: cs.primary),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Text(label, style: TextStyle(color: cs.onSurface)),
    );
  }
}

// ---- Time picker form field ----
class _TimePickerFormTile extends StatefulWidget {
  const _TimePickerFormTile({
    required this.label,
    required this.value,
    required this.onPick,
    this.nullable = false,
    this.onClear,
  });

  final String label;
  final TimeOfDay? value;
  final bool nullable;
  final ValueChanged<TimeOfDay> onPick;
  final VoidCallback? onClear;

  @override
  State<_TimePickerFormTile> createState() => _TimePickerFormTileState();
}

class _TimePickerFormTileState extends State<_TimePickerFormTile> {
  late TimeOfDay? _value = widget.value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final now = TimeOfDay.now();
        final picked = await showTimePicker(
          context: context,
          initialTime: _value ?? now,
          helpText: widget.label,
          builder: (ctx, child) => Theme(data: Theme.of(ctx), child: child!),
        );
        if (picked != null) {
          setState(() => _value = picked);
          widget.onPick(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.label,
          border: const OutlineInputBorder(),
          suffixIcon: widget.nullable && _value != null
              ? IconButton(
            tooltip: 'Clear',
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() => _value = null);
              widget.onClear?.call();
            },
          )
              : const Icon(Icons.schedule),
        ),
        child: Text(_value == null ? '—' : _fmtTime(_value!),
            style: TextStyle(color: cs.onSurface)),
      ),
    );
  }
}

// ---- Search delegate (optional) ----
class _ShiftSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
  ];

  @override
  Widget? buildLeading(BuildContext context) =>
      IconButton(onPressed: () => close(context, ''), icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) {
    return Center(child: Text('Search: $query'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: [
        ListTile(title: Text('General 1')),
        ListTile(title: Text('General 2')),
        ListTile(title: Text('Night A')),
      ],
    );
  }
}

// ---- VM / utils ----
class _ShiftVm {
  _ShiftVm({
    required this.name,
    required this.start,
    required this.end,
    required this.graceMins,
    required this.autoCheckout,
    required this.breakCount,
    required this.breakPolicy,
    required this.weeklyOffs,
  });

  final String name;
  final TimeOfDay start;
  final TimeOfDay end;
  final int graceMins;
  final TimeOfDay? autoCheckout;
  final int breakCount;
  final String breakPolicy;
  final List<String> weeklyOffs;
}

String _fmtTime(TimeOfDay t) {
  final h = t.hour.toString().padLeft(2, '0');
  final m = t.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

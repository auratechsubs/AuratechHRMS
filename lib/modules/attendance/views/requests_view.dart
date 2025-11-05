import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../shared/widgets/primary_button.dart';
import '../controllers/attendance_controller.dart';
import '../models/attendance_models.dart';

/// RequestsView नियमितीकरण अनुरोध सूची व नया अनुरोध बनाने का फॉर्म दिखाती है।
class RequestsView extends StatelessWidget {
  RequestsView({super.key});

  final Rxn<DateTime> _selectedDate = Rxn<DateTime>();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final RxString _type = 'Missed Check-in'.obs;

  @override
  Widget build(BuildContext context) {
    final AttendanceController controller = Get.find<AttendanceController>();
    return Scaffold(
      appBar: AppBar(title: Text('requests'.tr)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openRequestSheet(context, controller),
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('New request'),
      ),
      body: Obx(
        () {
          final items = controller.requests;
          if (items.isEmpty) {
            return Center(
              child: Text('No requests raised yet.',
                  style: Theme.of(context).textTheme.bodyMedium),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final request = items[index];
              return _buildRequestCard(context, request);
            },
          );
        },
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, RegularizationRequest request) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = switch (request.status) {
      'pending' => colorScheme.tertiary,
      'approved' => colorScheme.secondary,
      'rejected' => colorScheme.error,
      _ => colorScheme.outline,
    };
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat('dd MMM, yyyy').format(request.date),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Chip(
                label: Text(request.status.toUpperCase()),
                backgroundColor: statusColor.withOpacity(0.15),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Type: ${request.type}'),
          Text(
              'From ${DateFormat.Hm().format(request.fromTime)} to ${DateFormat.Hm().format(request.toTime)}'),
          const SizedBox(height: 8),
          Text('Reason: ${request.reason}'),
          if (request.approverNote != null)
            Text('Manager: ${request.approverNote!}'),
        ],
      ),
    );
  }

  Future<void> _openRequestSheet(
      BuildContext context, AttendanceController controller) async {
    _selectedDate.value = DateTime.now();
    _fromController.text = '09:30';
    _toController.text = '18:30';
    _reasonController.clear();
    Get.bottomSheet(
      ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Raise request',
                    style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 16),
                _dateField(context),
                const SizedBox(height: 12),
                Obx(
                  () => DropdownButtonFormField<String>(
                    initialValue: _type.value,
                    items: const [
                      DropdownMenuItem(
                          value: 'Missed Check-in', child: Text('Missed Check-in')),
                      DropdownMenuItem(
                          value: 'Missed Check-out', child: Text('Missed Check-out')),
                      DropdownMenuItem(value: 'Late', child: Text('Late arrival')),
                    ],
                    onChanged: (value) {
                      if (value != null) _type.value = value;
                    },
                    decoration: const InputDecoration(labelText: 'Issue type'),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _timeField(context, 'From', _fromController)),
                    const SizedBox(width: 12),
                    Expanded(child: _timeField(context, 'To', _toController)),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _reasonController,
                  decoration: const InputDecoration(
                    labelText: 'Reason',
                    hintText: 'Describe why adjustment is needed',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: 'Submit',
                  icon: Icons.send,
                  onPressed: () async {
                    final date = _selectedDate.value ?? DateTime.now();
                    final fromParts = _fromController.text.split(':');
                    final toParts = _toController.text.split(':');
                    final from = DateTime(date.year, date.month, date.day,
                        int.parse(fromParts[0]), int.parse(fromParts[1]));
                    final to = DateTime(date.year, date.month, date.day,
                        int.parse(toParts[0]), int.parse(toParts[1]));
                    await controller.raiseRegularization(
                      date: date,
                      type: _type.value,
                      from: from,
                      to: to,
                      reason: _reasonController.text,
                    );
                    Get.back<void>();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _dateField(BuildContext context) {
    return Obx(
      () => TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Date',
          hintText: _selectedDate.value != null
              ? DateFormat('dd MMM yyyy').format(_selectedDate.value!)
              : 'Select date',
        ),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: _selectedDate.value ?? DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 30)),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            _selectedDate.value = picked;
          }
        },
      ),
    );
  }

  Widget _timeField(
      BuildContext context, String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(labelText: label),
      onTap: () async {
        final initial = controller.text.split(':');
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(
            hour: int.parse(initial[0]),
            minute: int.parse(initial[1]),
          ),
        );
        if (time != null) {
          controller.text =
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
        }
      },
    );
  }
}

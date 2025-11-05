import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_shell_controller.dart';
import '../widgets/section_card.dart';

class AdminHolidaysView extends GetView<AdminShellController> {
  const AdminHolidaysView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Holidays heading
          Text(
            'Holidays',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 20),
          // Button row below heading
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.upload_file_outlined),
                label: const Text('Import CSV'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => _openHolidayEditor(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Holiday'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          // Holiday list in cards with SectionCard wrapper
          Expanded(
            child: SectionCard(
              title: 'Holiday List',
              child: ListView.separated(
                itemCount: 12,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) => Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  shadowColor: theme.colorScheme.primary.withOpacity(0.15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 18),
                    child: Row(
                      children: [
                        // Holiday details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Holiday ${i + 1}',
                                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today_outlined, size: 18, color: theme.colorScheme.primary),
                                  const SizedBox(width: 8),
                                  Text(
                                    '2025-12-${10 + i}',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, size: 18, color: theme.colorScheme.primary),
                                  const SizedBox(width: 8),
                                  Text('Region: All', style: theme.textTheme.bodySmall),
                                  const SizedBox(width: 24),
                                  Icon(Icons.repeat_outlined, size: 18, color: theme.colorScheme.primary),
                                  const SizedBox(width: 8),
                                  Text('Recurring: Yes', style: theme.textTheme.bodySmall),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Delete button on right
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.delete_outline, size: 28, color: theme.colorScheme.error),
                          tooltip: 'Delete holiday',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openHolidayEditor(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Holiday', style: TextStyle(fontWeight: FontWeight.w700)),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Date (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                items: const [
                  DropdownMenuItem(value: 'All', child: Text('All Regions')),
                  DropdownMenuItem(value: 'IN-North', child: Text('India North')),
                ],
                onChanged: (v) {},
                decoration: const InputDecoration(
                  labelText: 'Region',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile.adaptive(
                value: true,
                onChanged: (_) {},
                title: const Text('Recurring annually'),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

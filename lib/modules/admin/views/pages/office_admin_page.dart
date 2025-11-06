import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../attendance/controllers/attendance_geo_controller.dart';

class OfficeAdminPage extends StatefulWidget {
  const OfficeAdminPage({super.key});

  @override
  State<OfficeAdminPage> createState() => _OfficeAdminPageState();
}

class _OfficeAdminPageState extends State<OfficeAdminPage> {
  final nameCtrl = TextEditingController();
  final latCtrl = TextEditingController();
  final lonCtrl = TextEditingController();
  final radiusCtrl = TextEditingController(text: '50');

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AttendanceGeoController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Offices')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _rowText('Name', nameCtrl),
            const SizedBox(height: 8),
            _rowText('Latitude', latCtrl, hint: 'e.g. 28.6139'),
            const SizedBox(height: 8),
            _rowText('Longitude', lonCtrl, hint: 'e.g. 77.2090'),
            const SizedBox(height: 8),
            _rowText('Radius (m)', radiusCtrl),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                final name = nameCtrl.text.trim();
                final lat = double.tryParse(latCtrl.text.trim());
                final lon = double.tryParse(lonCtrl.text.trim());
                final r = int.tryParse(radiusCtrl.text.trim()) ?? 50;
                if (name.isEmpty || lat == null || lon == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter valid name/lat/lon')),
                  );
                  return;
                }
                c.addOffice(

                  OfficeLocation(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
                    latitude: lat,
                    longitude: lon,
                    radiusM: r,
                  ),
                );
                nameCtrl.clear();
                latCtrl.clear();
                lonCtrl.clear();
                radiusCtrl.text = '50';
              },
              child: const Text('Add Office'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                final list = c.offices;
                if (list.isEmpty) return const Center(child: Text('No offices added.'));
                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final o = list[i];
                    return ListTile(
                      leading: const Icon(Icons.business),
                      title: Text(o.name),
                      subtitle: Text('(${o.latitude}, ${o.longitude}) • radius ${o.radiusM} m'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => c.removeOffice(o.id),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowText(String label, TextEditingController ctrl, {String? hint}) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
    );
  }
}

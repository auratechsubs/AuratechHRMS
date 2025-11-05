import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_shell_controller.dart';

class AdminPoliciesView extends GetView<AdminShellController> {
  const AdminPoliciesView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: ListView(
        children: [
          Text(
            'Policies',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: .2,
            ),
          ),
          const SizedBox(height: 18),

          // Card: Late & Half-day
          Card(
            margin: const EdgeInsets.only(bottom: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Late & Half-day', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  // Late cutoff time
                  Text(
                    'Late cutoff (Half-day if later)',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.schedule_outlined, color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      FilledButton.tonal(
                        onPressed: () async {
                          final t = await showTimePicker(context: context, initialTime: c.lateCutoff.value);
                          if (t != null) c.lateCutoff.value = t;
                        },
                        child: Obx(() => Text(_fmt(c.lateCutoff.value))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Grace minutes
                  Text(
                    'Grace (mins)',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.timelapse_outlined, color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 70, // Fixed small width for field
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.all(8),
                          ),
                          controller: TextEditingController(text: c.graceMinutes.value.toString()),
                          onSubmitted: (s) {
                            final v = int.tryParse(s);
                            if (v != null) c.graceMinutes.value = v;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Divider(),
                  // Auto-checkout time
                  Text(
                    'Auto-checkout time',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.logout, color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      FilledButton.tonal(
                        onPressed: () async {
                          final t = await showTimePicker(context: context, initialTime: c.autoCheckout.value);
                          if (t != null) c.autoCheckout.value = t;
                        },
                        child: Obx(() => Text(_fmt(c.autoCheckout.value))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: c.savePolicies,
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Card: Devices & Verification
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Devices & Verification', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    value: c.faceEnabled.value,
                    onChanged: (v) => c.faceEnabled.value = v,
                    title: const Text('Face recognition required'),
                    secondary: Icon(Icons.face_retouching_natural, color: theme.colorScheme.primary),
                  ),
                  SwitchListTile(
                    value: c.fingerprintEnabled.value,
                    onChanged: (v) => c.fingerprintEnabled.value = v,
                    title: const Text('Fingerprint required'),
                    secondary: Icon(Icons.fingerprint, color: theme.colorScheme.primary),
                  ),
                  SwitchListTile(
                    value: c.geoFenceEnabled.value,
                    onChanged: (v) => c.geoFenceEnabled.value = v,
                    title: const Text('Geo-fence (100m radius)'),
                    secondary: Icon(Icons.location_on, color: theme.colorScheme.primary),
                  ),
                  SwitchListTile(
                    value: c.qrStationEnabled.value,
                    onChanged: (v) => c.qrStationEnabled.value = v,
                    title: const Text('QR station mode'),
                    secondary: Icon(Icons.qr_code_2, color: theme.colorScheme.primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_shell_controller.dart';
import '../widgets/section_card.dart';

class AdminSettingsView extends GetView<AdminShellController> {
  const AdminSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Mock controllers (wire to your real controller/state if needed)
    final companyCtrl = TextEditingController(text: 'Auratech');
    final tzCtrl = TextEditingController(text: 'Asia/Kolkata');
    final locCtrl = TextEditingController(text: 'HQ-1, Warehouse-2');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            tooltip: 'Save',
            onPressed: () {
              // Hook: controller.saveSettings(...)
              Get.snackbar('Saved', 'Settings updated successfully');
            },
            icon: const Icon(Icons.save_outlined),
          ),
          const SizedBox(width: 4),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Hook: controller.saveSettings(...)
          Get.snackbar('Saved', 'Settings updated successfully');
        },
        icon: const Icon(Icons.check),
        label: const Text('Save'),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ---------- Company Profile ----------

            CompanyProfileSection(companyCtrl: companyCtrl,locCtrl: locCtrl,tzCtrl: tzCtrl,onOpenBrandAssets: (){},onUploadLogo: (){},),


             const SizedBox(height: 16),

            // ---------- Integrations ----------
            SectionCard(
              title: 'Integrations',
              child: Column(
                children: [
                  _SwitchTile(
                    title: 'Email reports',
                    subtitle: 'Get weekly/monthly MIS reports in your inbox',
                    value: true,
                    icon: Icons.email_outlined,
                    onChanged: (v) {
                      // controller.setEmailReports(v)
                    },
                  ),
                  const Divider(height: 12),
                  _SwitchTile(
                    title: 'Slack / Teams alerts',
                    subtitle: 'Real-time alerts for attendance events',
                    value: false,
                    icon: Icons.chat_bubble_outline,
                    onChanged: (v) {
                      // controller.setChatAlerts(v)
                    },
                  ),
                  const Divider(height: 12),
                  _SwitchTile(
                    title: 'S3 / Drive storage',
                    subtitle: 'Backup exports & documents to cloud storage',
                    value: false,
                    icon: Icons.cloud_outlined,
                    onChanged: (v) {
                      // controller.setCloudBackup(v)
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- Appearance & Language ----------
            SectionCard(
              title: 'Appearance & Language',
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.dark_mode_outlined),
                    title: const Text('Theme'),
                    subtitle: const Text('Choose light/dark or follow system'),
                    trailing: Obx(() {
                      final mode = controller.themeMode.value;
                      return DropdownButton<ThemeMode>(
                        value: mode,
                        onChanged: (m) {
                          if (m != null) {
                            controller.switchTheme(m);
                            Get.changeThemeMode(m);
                          }
                        },
                        items: const [
                          DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                          DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                          DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                        ],
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.translate_outlined),
                    title: const Text('Language'),
                    subtitle: const Text('App interface language'),
                    trailing: Obx(() {
                      final loc = controller.locale.value;
                      return DropdownButton<Locale>(
                        value: loc,
                        onChanged: (l) {
                          if (l != null) {
                            controller.switchLocale(l);
                            Get.updateLocale(l);
                          }
                        },
                        items: const [
                          DropdownMenuItem(value: Locale('en', 'US'), child: Text('English')),
                          DropdownMenuItem(value: Locale('hi', 'IN'), child: Text('हिंदी')),
                          DropdownMenuItem(value: Locale('ar', 'SA'), child: Text('العربية')),
                          DropdownMenuItem(value: Locale('es', 'ES'), child: Text('Español')),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- Notifications Preferences ----------
            SectionCard(
              title: 'Notifications',
              child: Column(
                children: [
                  _CheckTile(
                    title: 'Daily attendance summary',
                    value: true,
                    onChanged: (v) {},
                  ),
                  _CheckTile(
                    title: 'Late / Missed punch alerts',
                    value: true,
                    onChanged: (v) {},
                  ),
                  _CheckTile(
                    title: 'Export completion alerts',
                    value: false,
                    onChanged: (v) {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- Danger Zone ----------
            SectionCard(
              title: 'Danger Zone',
              child: Container(
                decoration: BoxDecoration(
                  color: Color.alphaBlend(cs.error.withOpacity(.06), cs.surface),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cs.error.withOpacity(.35)),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: cs.error),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Reset all settings to defaults. This action cannot be undone.',
                        style: TextStyle(color: cs.onSurface),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.tonal(
                      onPressed: () {
                        // controller.resetSettings()
                        Get.snackbar('Reset', 'Settings restored to defaults');
                      },
                      style: FilledButton.styleFrom(
                        foregroundColor: cs.error,
                      ),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Small tag chip for previewing locations
  Widget _tag(String t, ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Text(t, style: TextStyle(color: cs.onSurface)),
    );
  }
}

/* -------------------------- Smaller UI pieces -------------------------- */

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final IconData icon;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: cs.primary.withOpacity(.10),
        child: Icon(icon, color: cs.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}

class _CheckTile extends StatelessWidget {
  const _CheckTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}





/// Drop-in replacement for your "Company Profile" section.
/// Usage:
/// CompanyProfileSection(
///   companyCtrl: companyCtrl,
///   tzCtrl: tzCtrl,
///   locCtrl: locCtrl,
/// )
class CompanyProfileSection extends StatelessWidget {
  const CompanyProfileSection({
    super.key,
    required this.companyCtrl,
    required this.tzCtrl,
    required this.locCtrl,
    this.onUploadLogo,
    this.onOpenBrandAssets,
  });

  final TextEditingController companyCtrl;
  final TextEditingController tzCtrl;
  final TextEditingController locCtrl;
  final VoidCallback? onUploadLogo;
  final VoidCallback? onOpenBrandAssets;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return _SectionCard(
      title: 'Company Profile',
      trailing: OutlinedButton.icon(
        onPressed: onOpenBrandAssets ?? () {},
        icon: const Icon(Icons.folder_open_outlined),
        label: const Text('Brand Assets'),
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final isWide = c.maxWidth >= 760;

          // --- Row 1: Logo + Company name + Upload button ---
          final logoRow = Wrap(
            spacing: 16,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Logo tile
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cs.outlineVariant),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.apartment_outlined, size: 28, color: cs.onSurfaceVariant),
              ),

              // Name field expands
              SizedBox(
                width: isWide ? c.maxWidth - 56 - 16 - 160 : c.maxWidth - 56 - 16,
                child: TextFormField(
                  controller: companyCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Company name',
                    hintText: 'Enter company display name',
                    helperText: 'This appears on reports & emails',
                  ),
                ),
              ),

              if (isWide)
                SizedBox(
                  width: 160,
                  child: OutlinedButton.icon(
                    onPressed: onUploadLogo ??
                            () => Get.snackbar('Logo', 'Logo picker not wired'),
                    icon: const Icon(Icons.upload_outlined),
                    label: const Text('Upload Logo'),
                  ),
                ),
            ],
          );

          // On narrow width, move upload button under field
          final uploadBtnNarrow = (!isWide)
              ? Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: onUploadLogo ??
                        () => Get.snackbar('Logo', 'Logo picker not wired'),
                icon: const Icon(Icons.upload_outlined),
                label: const Text('Upload Logo'),
              ),
            ),
          )
              : const SizedBox.shrink();

          // --- Row 2: Time zone + Locations ---
          final tzLocRow = _TwoCol(
            left: TextFormField(
              controller: tzCtrl,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Time zone',
                hintText: 'e.g., Asia/Kolkata',
                prefixIcon: Icon(Icons.schedule_outlined),
                helperText: 'Used for attendance, exports & reminders',
              ),
            ),
            right: TextFormField(
              controller: locCtrl,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Locations',
                hintText: 'Comma-separated (HQ-1, Warehouse-2)',
                prefixIcon: Icon(Icons.location_city_outlined),
                helperText: 'Shown in filters and reports',
              ),
            ),
          );

          // --- Row 3: Quick location chips ---
          final chips = Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _Tag('HQ-1'),
              _Tag('Warehouse-2'),
              _Tag('Remote'),
            ],
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              logoRow,
              uploadBtnNarrow,
              const SizedBox(height: 16),
              tzLocRow,
              const SizedBox(height: 12),
              chips,
            ],
          );
        },
      ),
    );
  }
}

/* ----------------- Small building blocks (clean & minimal) ----------------- */

class _TwoCol extends StatelessWidget {
  const _TwoCol({required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final isWide = c.maxWidth >= 760;
        if (!isWide) {
          return Column(
            children: [
              left,
              const SizedBox(height: 12),
              right,
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: left),
            const SizedBox(width: 16),
            Expanded(child: right),
          ],
        );
      },
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.text);
  final String text;

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
      child: Text(text, style: TextStyle(color: cs.onSurface)),
    );
  }
}

/// Lightweight SectionCard (mirrors your existing one). If you already
/// have a `SectionCard`, delete this and use yours.
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 14),
            // Divider
            Divider(height: 1, color: cs.outlineVariant.withOpacity(.6)),
            const SizedBox(height: 14),
            // Body
            child,
          ],
        ),
      ),
    );
  }
}

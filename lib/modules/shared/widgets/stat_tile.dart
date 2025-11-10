import 'package:flutter/material.dart';

/// StatTile कॉम्पोनेन्ट KPI दिखाने के लिए कार्ड प्रदान करता है।
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.badge,
    this.color,
  });

  final String title;
  final String value;
  final IconData? icon;
  final String? badge;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final background = color ?? colorScheme.secondaryContainer;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: background.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: colorScheme.onSecondaryContainer),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badge!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onTertiary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(color: colorScheme.primary),
          ),
        ],
      ),
    );
  }
}

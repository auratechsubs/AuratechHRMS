import 'package:flutter/material.dart';

enum KpiColor { primary, warning, error, info }

class KpiCard extends StatelessWidget {
  const KpiCard({super.key, required this.colorKey, required this.label, required this.value});
  final KpiColor colorKey;
  final String label;
  final String value;

  Color _map(BuildContext ctx) {
    final cs = Theme.of(ctx).colorScheme;
    switch (colorKey) {
      case KpiColor.primary: return cs.primary;
      case KpiColor.warning: return const Color(0xFFFFB020);
      case KpiColor.error:   return cs.error;
      case KpiColor.info:    return const Color(0xFF3B82F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _map(context);
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Stack(children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(.12), color.withOpacity(.04)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: theme.textTheme.labelMedium?.copyWith(color: theme.hintColor)),
            const SizedBox(height: 8),
            Text(value, style: theme.textTheme.headlineSmall?.copyWith(color: color, fontWeight: FontWeight.w800)),
          ]),
        ),
      ]),
    );
  }
}

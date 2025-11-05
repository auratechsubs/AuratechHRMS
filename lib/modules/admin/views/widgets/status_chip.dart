import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isBad = text.toLowerCase().contains('late') || text.toLowerCase().contains('half');
    final color = isBad ? t.colorScheme.error : t.colorScheme.primary;
    return Chip(
      label: Text(text, style: t.textTheme.labelSmall?.copyWith(color: color)),
      side: BorderSide(color: color.withOpacity(.5)),
      backgroundColor: color.withOpacity(.06),
      visualDensity: VisualDensity.compact,
    );
  }
}

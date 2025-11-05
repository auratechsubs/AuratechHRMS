import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    this.trailing,
    required this.child,
    this.width,
    this.padding,
    this.constraints,
  });

  final String title;
  final Widget? trailing;
  final Widget child;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final header = LayoutBuilder(
      builder: (ctx, c) {
        final isNarrow = c.maxWidth < 360;
        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: theme.textTheme.titleMedium),
              if (trailing != null) ...[
                const SizedBox(height: 8),
                Align(alignment: Alignment.centerLeft, child: trailing!),
              ],
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: Text(title, style: theme.textTheme.titleMedium, overflow: TextOverflow.ellipsis)),
            if (trailing != null) Flexible(child: Align(alignment: Alignment.centerRight, child: trailing!)),
          ],
        );
      },
    );

    Widget cardContent = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header,
        const SizedBox(height: 12),
        Flexible(
          child: child,
        ),
      ],
    );

    if (constraints != null) {
      cardContent = ConstrainedBox(
        constraints: constraints!,
        child: cardContent,
      );
    }

    final card = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),side: BorderSide(color: theme.dividerColor)),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: cardContent,
      ),
    );

    if (width != null) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width!),
        child: card,
      );
    }
    return card;
  }
}
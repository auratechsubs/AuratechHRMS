import 'package:flutter/material.dart';

class SearchFilterRow extends StatelessWidget {
  const SearchFilterRow({
    super.key,
    required this.searchCtrl,
    required this.onSearch,
    this.rightChildren = const [],
  });

  final TextEditingController searchCtrl;
  final ValueChanged<String> onSearch;
  final List<Widget> rightChildren;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, c) {
        final isNarrow = c.maxWidth < 560;
        if (isNarrow) {
          // Stack items vertically on very small widths
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _searchField(),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.start,
                children: rightChildren,
              ),
            ],
          );
        }
        // Wide: keep a single row
        return Row(
          children: [
            Expanded(child: _searchField()),
            const SizedBox(width: 12),
            Wrap(spacing: 8, runSpacing: 8, children: rightChildren),
          ],
        );
      },
    );
  }

  Widget _searchField() {
    return TextField(
      controller: searchCtrl,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: 'Search by name/code',
      ),
      onSubmitted: onSearch,
    );
  }
}

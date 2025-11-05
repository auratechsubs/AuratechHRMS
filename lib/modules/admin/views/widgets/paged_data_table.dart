import 'package:flutter/material.dart';

typedef RowsBuilder = List<DataRow> Function(int page, int pageSize);

class PagedDataTable extends StatefulWidget {
  const PagedDataTable({
    super.key,
    required this.columns,
    required this.rowsBuilder,
    required this.totalRows,
    this.initialPage = 1,
    this.pageSize = 10,
    this.pageSizes = const [10, 20, 50, 100],
    this.onPageChanged,
    this.onPageSizeChanged,
    this.showPaginationControls = true,
  });

  final List<DataColumn> columns;
  final RowsBuilder rowsBuilder;
  final int totalRows;
  final int initialPage;
  final int pageSize;
  final List<int> pageSizes;
  final ValueChanged<int>? onPageChanged;
  final ValueChanged<int>? onPageSizeChanged;
  final bool showPaginationControls;

  @override
  State<PagedDataTable> createState() => _PagedDataTableState();
}

class _PagedDataTableState extends State<PagedDataTable> {
  late int _page = widget.initialPage;
  late int _pageSize = widget.pageSize;

  @override
  Widget build(BuildContext context) {
    final rows = widget.rowsBuilder(_page, widget.pageSize);
    final totalPages = (widget.totalRows / _pageSize).ceil();
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Data Table
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 20,
            horizontalMargin: 16,
            headingRowHeight: 56,
            dataRowMinHeight: 48,
            dataRowMaxHeight: 56,
            headingTextStyle: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
            dataTextStyle: theme.textTheme.bodyMedium,
            border: TableBorder(
              horizontalInside: BorderSide(
                color: theme.dividerColor.withOpacity(0.3),
                width: 0.5,
              ),
            ),
            columns: widget.columns,
            rows: rows,
          ),
        ),

        // Pagination Controls
        if (widget.showPaginationControls) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: _buildPaginationControls(theme, totalPages),
          ),
        ],
      ],
    );
  }

  Widget _buildPaginationControls(ThemeData theme, int totalPages) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 500;

        if (isNarrow) {
          // Mobile layout
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Rows per page:', style: theme.textTheme.bodySmall),
                  const SizedBox(width: 8),
                  _buildPageSizeDropdown(theme),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageNavigation(theme, totalPages),
              ),
            ],
          );
        } else {
          // Desktop layout
          return Row(
            children: [
              Text('Rows per page:', style: theme.textTheme.bodySmall),
              const SizedBox(width: 8),
              _buildPageSizeDropdown(theme),
              const Spacer(),
              Text(
                'Page $_page of $totalPages',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              ..._buildPageNavigation(theme, totalPages),
            ],
          );
        }
      },
    );
  }

  Widget _buildPageSizeDropdown(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: _pageSize,
          isDense: true,
          iconSize: 16,
          style: theme.textTheme.bodySmall,
          items: widget.pageSizes.map((s) {
            return DropdownMenuItem<int>(
              value: s,
              child: Text('$s'),
            );
          }).toList(),
          onChanged: (s) {
            if (s == null) return;
            setState(() {
              _pageSize = s;
              _page = 1;
            });
            widget.onPageSizeChanged?.call(s);
          },
        ),
      ),
    );
  }

  List<Widget> _buildPageNavigation(ThemeData theme, int totalPages) {
    return [
      IconButton(
        onPressed: _page > 1 ? () => _goToPage(1) : null,
        icon: const Icon(Icons.first_page),
        iconSize: 20,
        tooltip: 'First page',
      ),
      IconButton(
        onPressed: _page > 1 ? _prev : null,
        icon: const Icon(Icons.chevron_left),
        iconSize: 20,
        tooltip: 'Previous page',
      ),
      if (MediaQuery.of(context).size.width < 500) ...[
        const SizedBox(width: 8),
        Text(
          '$_page / $totalPages',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
      ],
      IconButton(
        onPressed: _page < totalPages ? _next : null,
        icon: const Icon(Icons.chevron_right),
        iconSize: 20,
        tooltip: 'Next page',
      ),
      IconButton(
        onPressed: _page < totalPages ? () => _goToPage(totalPages) : null,
        icon: const Icon(Icons.last_page),
        iconSize: 20,
        tooltip: 'Last page',
      ),
    ];
  }

  void _prev() {
    setState(() => _page--);
    widget.onPageChanged?.call(_page);
  }

  void _next() {
    setState(() => _page++);
    widget.onPageChanged?.call(_page);
  }

  void _goToPage(int page) {
    setState(() => _page = page);
    widget.onPageChanged?.call(_page);
  }
}
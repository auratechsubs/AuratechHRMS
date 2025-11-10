import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/leave_controller.dart';
import '../models/leave_models.dart';
import 'new_leave_page.dart';

class LeaveListPage extends GetView<LeaveController> {
  const LeaveListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaves'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const NewLeavePage()),
        icon: const Icon(Icons.add),
        label: const Text('New Leave'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final items = controller.requests;
          if (items.isEmpty) {
            return _empty(context);
          }
          // Group by month (optional)
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) => _LeaveCard(req: items[i]),
          );
        }),
      ),
    );
  }

  Widget _empty(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_busy, size: 64, color: cs.outline),
          const SizedBox(height: 12),
          Text('No leaves yet', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to apply a new leave.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _LeaveCard extends StatelessWidget {
  const _LeaveCard({required this.req});
  final LeaveRequest req;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: cs.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: cs.outlineVariant.withOpacity(0.25)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Top Row: Icon + Duration + Dates ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: req.type.color(cs).withOpacity(0.15),
                  child: Icon(req.type.icon, color: req.type.color(cs), size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${req.totalDays} ${req.totalDays == 1 ? "Day" : "Days"}',
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cs.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        req.from == req.to
                            ? _fmt(req.from)
                            : '${_fmt(req.from)} → ${_fmt(req.to)}',
                        style: textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _StatusChip(status: req.status),
              ],
            ),

            const SizedBox(height: 14),

            // --- Leave Cause ---
            Text(
              req.cause,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              req.type.label,
              style: textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),

            const Divider(height: 26, thickness: 0.4),

            // --- Footer Row: Metadata (type, createdAt) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(req.type.icon, size: 14, color: req.type.color(cs)),
                    const SizedBox(width: 6),
                    Text(
                      req.type.label,
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: req.type.color(cs),
                      ),
                    ),
                  ],
                ),
                Text(
                  _fmt(req.createdAt),
                  style: textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} ${_monthShort(d.month)} ${d.year}';
  String _monthShort(int m) => const [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ][m - 1];
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final LeaveStatus status;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: status.chipColor(cs),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: status.textColor(cs).withOpacity(.25)),
      ),
      child: Row(
        children: [
          Icon(
            switch (status) {
              LeaveStatus.pending => Icons.hourglass_bottom_rounded,
              LeaveStatus.approved => Icons.check_circle_outline_rounded,
              LeaveStatus.declined => Icons.cancel_outlined,
            },
            size: 14,
            color: status.textColor(cs),
          ),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              color: status.textColor(cs),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

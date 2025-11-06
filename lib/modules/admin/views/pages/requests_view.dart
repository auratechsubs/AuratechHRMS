import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_shell_controller.dart';

// ====== SCREEN ======
class AdminRequestsView extends GetView<AdminShellController> {
  const AdminRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // mock data
    final items = List.generate(
      20,
          (i) => _ReqItem(
        id: 'REQ-${1000 + i}',
        emp: 'User ${i + 1}',
        type: i.isEven ? 'Missed Check-out' : 'Late Explanation',
        date: DateTime.now().subtract(Duration(days: i)),
        reason: 'Network issue / Meeting / Field visit',
        status: i % 3 == 0 ? 'Approved' : (i % 3 == 1 ? 'Pending' : 'Rejected'),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Approvals')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {},
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: cs.outlineVariant.withOpacity(.6),
            ),
            itemBuilder: (_, i) {
              final r = items[i];
              return RequestRow(
                item: r,
                onReview: () => _openRequest(context, r),
                onApprove: () => controller.approveRequest(r.id),
                onReject: () =>
                    controller.rejectRequest(r.id, reason: 'Policy violation'),
              );
            },
          ),
        ),
      ),
    );
  }

  void _openRequest(BuildContext context, _ReqItem r) {
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: cs.surface,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Review Request — ${r.id}',
                        style: theme.textTheme.titleMedium),
                  ),
                  StatusBadge(status: r.status),
                ],
              ),
              const SizedBox(height: 12),
              _KeyVal('Employee', r.emp),
              _KeyVal('Type', r.type),
              _KeyVal('Date', _fmt(r.date)),
              const SizedBox(height: 12),
              Text('Claimed correction:', style: theme.textTheme.labelLarge),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: const Text(
                  'System: In 10:54, Out 20:05\n'
                      'Claimed: In 09:40, Out 19:10\n'
                      'Note: Meeting with client',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: Get.find<AdminShellController>().decisionNoteCtrl,
                decoration: const InputDecoration(
                  labelText: 'Decision note (optional)',
                ),
                minLines: 1,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.close),
                      label: const Text('Reject'),
                      onPressed: () {
                        final note =
                        Get.find<AdminShellController>().decisionNoteCtrl.text.trim();
                        Get.find<AdminShellController>()
                            .rejectRequest(r.id, reason: note.isEmpty ? 'Policy violation' : note);
                        Navigator.pop(ctx);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text('Approve'),
                      onPressed: () {
                        Get.find<AdminShellController>().approveRequest(r.id);
                        Navigator.pop(ctx);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ],
          ),
        );
      },
    );
  }
}

// ====== RESPONSIVE ROW WIDGET (NO OVERFLOW) ======
class RequestRow extends StatelessWidget {
  const RequestRow({
    super.key,
    required this.item,
    required this.onReview,
    required this.onApprove,
    required this.onReject,
  });

  final _ReqItem item;
  final VoidCallback onReview;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTight = constraints.maxWidth < 420; // phone / narrow

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: avatar + title/date + (status on wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: cs.primary.withOpacity(.12),
                    child: Text(
                      item.emp[0],
                      style: TextStyle(
                        color: cs.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title + date in one line, will ellipsize
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.type,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _fmt(item.date),
                              style: TextStyle(color: cs.onSurfaceVariant),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item.emp} — ${item.reason}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (!isTight) ...[
                    const SizedBox(width: 8),
                    StatusBadge(status: item.status),
                  ],
                ],
              ),

              if (isTight) ...[
                const SizedBox(height: 8),
                StatusBadge(status: item.status),
              ],

              const SizedBox(height: 8),

              // Actions: Wrap ensures no overflow; it will break into lines
              Align(
                alignment: Alignment.centerRight,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: onReview,
                        child: const Text('Review'),
                      ),
                      FilledButton(
                        onPressed: onApprove,
                        child: const Text('Approve'),
                      ),
                      // Optional: a compact overflow menu for very tight layouts
                      if (isTight)
                        PopupMenuButton<String>(
                          onSelected: (v) {
                            if (v == 'reject') onReject();
                            if (v == 'review') onReview();
                          },
                          itemBuilder: (ctx) => const [
                            PopupMenuItem(value: 'review', child: Text('Review')),
                            PopupMenuItem(value: 'reject', child: Text('Reject')),
                          ],
                          icon: const Icon(Icons.more_horiz),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ====== SMALL UI PARTS ======
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    late Color bg, fg;
    late IconData icon;

    switch (status) {
      case 'Approved':
        bg = cs.secondaryContainer;
        fg = cs.onSecondaryContainer;
        icon = Icons.verified_outlined;
        break;
      case 'Rejected':
        bg = Color.alphaBlend(cs.error.withOpacity(.14), cs.surface);
        fg = cs.onSurface;
        icon = Icons.block_outlined;
        break;
      default:
        bg = cs.tertiaryContainer;
        fg = cs.onTertiaryContainer;
        icon = Icons.hourglass_bottom_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(color: fg, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _KeyVal extends StatelessWidget {
  const _KeyVal(this.k, this.v);
  final String k, v;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(k, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }
}

// ====== MODEL ======
class _ReqItem {
  _ReqItem({
    required this.id,
    required this.emp,
    required this.type,
    required this.date,
    required this.reason,
    required this.status,
  });

  final String id, emp, type, reason, status;
  final DateTime date;
}

// ====== UTILS ======
String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';
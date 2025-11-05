import 'package:flutter/material.dart';

class Performance extends StatefulWidget {
  const Performance({super.key});
  @override
  State<Performance> createState() => _PerformanceState();
}

class _PerformanceState extends State<Performance> {
  final Color maroon = const Color(0xFF7A1029);

  @override
  Widget build(BuildContext context) {
    final muted = Colors.black.withOpacity(.55);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          'Performance Reviews',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      backgroundColor: const Color(0xFFF7F7F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Evaluate and track employee performance',
              style: TextStyle(color: muted),
            ),
            const SizedBox(height: 16),

            // KPI row
            Row(
              children: const [
                Expanded(
                  child: _KpiCard(
                    title: 'Average Rating',
                    value: '4.5/5.0',
                    subtitle: 'Overall Performance',
                    icon: Icons.star_border_rounded,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _KpiCard(
                    title: 'Reviews Completed',
                    value: '12',
                    subtitle: 'This Year',
                    icon: Icons.event_available,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const _KpiCard(
              title: 'Goals Achieved',
              value: '85%',
              subtitle: 'Target Completion',
              icon: Icons.flag_outlined,
            ),
            const SizedBox(height: 16),

            // New Review button (right aligned like screenshot)
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorScheme.of(context).primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  _toast(context, 'Start new review');
                },
                icon: const Icon(Icons.add),
                label: const Text('New Review'),
              ),
            ),
            const SizedBox(height: 12),

            // Performance Reviews section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black.withOpacity(.08)),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle('Performance Reviews'),
                  const SizedBox(height: 8),

                  // Review card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black.withOpacity(.08)),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // left: employee + chip + meta
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Rahul Sharma',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      _chip('submitted'),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Q3 2024 • Reviewed by John Manager',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // right: rating
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                                Text(
                                  '4.5',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'out of 5',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'KPI Performance',
                            style: TextStyle(
                              color: Colors.black.withOpacity(.6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // KPI bars
                        _kpiRow('Code Quality', 95, 90, maroon),
                        _kpiRow('Project Delivery', 88, 85, maroon),
                        _kpiRow('Team Collaboration', 85, 90, maroon),

                        const SizedBox(height: 12),
                        // View details button (ghost)
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.remove_red_eye_outlined),
                            label: const Text('View Details'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black87,
                              side: BorderSide(
                                color: Colors.black.withOpacity(.2),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () {
                              _toast(context, 'Open review details');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _kpiRow(String title, int scored, int target, Color maroon) {
    final pct = (scored / target).clamp(0.0, 2.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 13.5, color: Colors.black87),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text(
                  '$scored/$target (${(pct * 100).round()}%)',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  minHeight: 8,
                  value: pct > 1 ? 1 : pct,
                  color: maroon,
                  backgroundColor: Colors.black.withOpacity(.1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _chip(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFE6F4EA),
      borderRadius: BorderRadius.circular(999),
    ),
    child: const Text(
      'submitted',
      style: TextStyle(
        color: Color(0xFF2E7D32),
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
    ),
  );

  void _toast(BuildContext ctx, String msg) =>
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(msg)));
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  final String title, value, subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.black.withOpacity(.08)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, color: Colors.black87),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Colors.black.withOpacity(.65)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.black.withOpacity(.55)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 6, top: 4),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
    ),
  );
}

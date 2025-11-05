import 'package:flutter/material.dart';

class Payroll extends StatefulWidget {
  const Payroll({super.key});
  @override
  State<Payroll> createState() => _PayrollState();
}

class _PayrollState extends State<Payroll> {
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
        title: const Text('Payroll',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      backgroundColor: const Color(0xFFF7F7F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Manage salaries and compliance', style: TextStyle(color: muted)),
            const SizedBox(height: 16),

            // KPI row
            Row(
              children: const [
                Expanded(
                  child: _MoneyCard(
                    title: 'Current Month',
                    value: '₹65,880',
                    subtitle: 'Net Salary',
                    icon: Icons.attach_money_rounded,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _MoneyCard(
                    title: 'YTD Earnings',
                    value: '₹6,58,800',
                    subtitle: 'Year to Date',
                    icon: Icons.trending_up_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const _MoneyCard(
              title: 'Tax Deducted',
              value: '₹80,000',
              subtitle: 'Total TDS (YTD)',
              icon: Icons.receipt_long_outlined,
            ),

            const SizedBox(height: 16),

            // Payslip History panel
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black.withOpacity(.08)),
              ),
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 8),
                    child: Text('Payslip History',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 18)),
                  ),
                  _PayslipTile(
                    monthLabel: 'October 2024',
                    status: 'paid',
                    employee: 'Rahul Sharma • EMP001',
                    gross: '₹80,000',
                    net: '₹65,880',
                  ),
                  SizedBox(height: 10),
                  _PayslipTile(
                    monthLabel: 'October 2024',
                    status: 'paid',
                    employee: 'Priya Patel • EMP002',
                    gross: '₹65,000',
                    net: '₹54,528',
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

class _MoneyCard extends StatelessWidget {
  const _MoneyCard({
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
                  Text('\$  $title',
                      style: TextStyle(color: Colors.black.withOpacity(.65))),
                  const SizedBox(height: 4),
                  Text(value,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 18)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(color: Colors.black.withOpacity(.55))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PayslipTile extends StatelessWidget {
  const _PayslipTile({
    required this.monthLabel,
    required this.status,
    required this.employee,
    required this.gross,
    required this.net,
  });

  final String monthLabel, status, employee, gross, net;

  @override
  Widget build(BuildContext context) {
    final maroon = const Color(0xFF7A1029);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border:
        Border.all(color: Colors.black.withOpacity(.1)),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // top row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(monthLabel,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 16)),
                        const SizedBox(width: 8),
                        _paidChip(),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(employee,
                        style: TextStyle(
                            color: Colors.black.withOpacity(.6),
                            fontSize: 13)),
                  ],
                ),
              ),
              // amounts block
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text('Gross  ',
                          style: TextStyle(
                              color: Colors.black.withOpacity(.6))),
                      Text(gross,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('Net Pay  ',
                          style: TextStyle(
                              color: Colors.black.withOpacity(.6))),
                      Text(net,
                          style: TextStyle(
                              fontWeight: FontWeight.w800, color: maroon)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // actions row
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Open payslip view')));
                },
                icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                label: const Text('View'),
                style: OutlinedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Download PDF')));
                },
                icon: const Icon(Icons.download_outlined, size: 18),
                label: const Text('PDF'),
                style: OutlinedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _paidChip() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFE6F4EA),
      borderRadius: BorderRadius.circular(999),
    ),
    child: const Text('paid',
        style: TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.w700,
            fontSize: 12)),
  );
}

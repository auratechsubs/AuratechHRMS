import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Interns extends StatefulWidget {
  const Interns({super.key});
  @override
  State<Interns> createState() => _InternsState();
}

class _InternsState extends State<Interns> {
  final TextEditingController _search = TextEditingController();
  final List<_Intern> _all = const [
    _Intern(
      name: 'Suman Kumari',
      code: 'INT001',
      college: 'IIT Delhi',
      degree: 'B.Tech Computer Science',
      project: 'Mobile App Development',
      email: 'ananya.singh@college.edu',
      stipend: 15000,
      performance: 0.85,
      active: true,
    ),
    _Intern(
      name: 'Sohil Khan',
      code: 'INT002',
      college: 'NIT Trichy',
      degree: 'B.Tech Information Technology',
      project: 'Cloud Migration Project',
      email: 'vikram.reddy@college.edu',
      stipend: 15000,
      performance: 0.92,
      active: true,
    ),
  ];

  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maroon = const Color(0xFF7A1029);
    final muted = Colors.black.withOpacity(.55);
    final list = _all.where((i) {
      final q = _query.toLowerCase();
      if (q.isEmpty) return true;
      return i.name.toLowerCase().contains(q) ||
          i.code.toLowerCase().contains(q) ||
          i.college.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          'Interns',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      backgroundColor: const Color(0xFFF7F7F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Manage internship programs',
                style: TextStyle(color: muted, fontSize: 14)),
            const SizedBox(height: 14),

            // search + add button
            Row(
              children: [
                Expanded(
                  child: CupertinoSearchTextField(
                    controller: _search,
                    placeholder: 'Search by name, code, or college...',
                    onChanged: (v) => setState(() => _query = v),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    style: const TextStyle(fontSize: 15),
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorScheme.of(context).primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                  onPressed: () {
                    _showSnack(context, 'Add Intern tapped');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Intern'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // cards
            ...List.generate(list.length, (i) {
              final it = list[i];
              return Padding(
                padding: EdgeInsets.only(bottom: i == list.length - 1 ? 0 : 14),
                child: _InternCard(
                  data: it,
                  maroon: maroon,
                  muted: muted,
                  onConvert: () {
                    _confirmConvert(context, it.name);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _confirmConvert(BuildContext context, String name) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Convert to Employee?'),
        content: Text('Do you want to convert $name to an employee?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Convert')),
        ],
      ),
    );
    if (ok == true) {
      _showSnack(context, 'Converted $name to Employee');
    }
  }

  void _showSnack(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}

class _InternCard extends StatelessWidget {
  const _InternCard({
    required this.data,
    required this.maroon,
    required this.muted,
    required this.onConvert,
  });

  final _Intern data;
  final Color maroon;
  final Color muted;
  final VoidCallback onConvert;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      surfaceTintColor: Colors.white,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.black.withOpacity(.06)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // name + chip
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(data.code,
                          style: TextStyle(color: Colors.black.withOpacity(.6))),
                    ],
                  ),
                ),
                if (data.active)
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8EDFF),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text('active',
                        style: TextStyle(
                            color: Color(0xFF2563EB),
                            fontWeight: FontWeight.w700,
                            fontSize: 12)),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // college + degree
            Text(data.college,
                style:
                const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            Text(data.degree, style: TextStyle(color: Colors.black54)),

            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 14),
                children: [
                  const TextSpan(text: 'Project: '),
                  TextSpan(
                      text: data.project,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // performance bar
            Row(
              children: [
                const Text('Performance', style: TextStyle(fontSize: 13.5)),
                const Spacer(),
                Text('${(data.performance * 100).round()}%',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: data.performance,
                color: ColorScheme.of(context).primary,
                backgroundColor: Colors.black.withOpacity(.1),
              ),
            ),

            const SizedBox(height: 12),

            // contact / stipend
            Text(data.email, style: TextStyle(color: Colors.black.withOpacity(.7))),
            const SizedBox(height: 4),
            Text('Stipend: ₹${data.stipend.toStringAsFixed(0)}/month',
                style: TextStyle(color: Colors.black.withOpacity(.7))),

            const SizedBox(height: 14),

            // CTA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onConvert,
                icon: const Icon(Icons.person_add_alt_1_rounded),
                label: const Text('Convert to Employee'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorScheme.of(context).primary,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Intern {
  final String name;
  final String code;
  final String college;
  final String degree;
  final String project;
  final String email;
  final double stipend;
  final double performance;
  final bool active;

  const _Intern({
    required this.name,
    required this.code,
    required this.college,
    required this.degree,
    required this.project,
    required this.email,
    required this.stipend,
    required this.performance,
    required this.active,
  });
}

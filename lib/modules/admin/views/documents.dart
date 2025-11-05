import 'package:flutter/material.dart';

class Documents extends StatefulWidget {
  const Documents({super.key});
  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  final _docTypes = const [
    'Offer Letter',
    'Appointment Letter',
    'Experience Letter',
    'Relieving Letter',
    'Internship Certificate',
  ];

  String? _selected;

  @override
  Widget build(BuildContext context) {
    final maroon = const Color(0xFF7A1029);
    final panelBorder = Colors.black.withOpacity(.08);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text('Documents', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      backgroundColor: const Color(0xFFF7F7F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Manage HR documents and templates',
                style: TextStyle(color: Colors.black.withOpacity(.55))),
            const SizedBox(height: 16),

            // big panel
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: panelBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // panel title
                  Row(
                    children: [
                      const Icon(Icons.add, size: 20),
                      const SizedBox(width: 6),
                      const Text('Generate New Document',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 18),

                  const Text('Document Type',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: _selected,
                        items: _docTypes
                            .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                            .toList(),
                        onChanged: (v) => setState(() => _selected = v),
                        decoration: InputDecoration(
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        hint: const Text('Select document type'),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorScheme.of(context).primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (_selected == null) {
                            _toast(context, 'Please select a document type.');
                          } else {
                            _toast(context, 'Generating $_selected…');
                          }
                        },
                        icon: const Icon(Icons.description_outlined),
                        label: const Text('Generate Document'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // grid of templates
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: const [
                      _TemplateTile(title: 'Offer Letter', subtitle: 'Auto-generated template', iconBg: Color(0xFFFCE7F3)),
                      _TemplateTile(title: 'Appointment Letter', subtitle: 'Auto-generated template', iconBg: Color(0xFFEFF6FF)),
                      _TemplateTile(title: 'Experience Letter', subtitle: 'Auto-generated template', iconBg: Color(0xFFEFF6FF)),
                      _TemplateTile(title: 'Relieving Letter', subtitle: 'Auto-generated template', iconBg: Color(0xFFFCE7F3)),
                      _TemplateTile(title: 'Internship Certificate', subtitle: 'Auto-generated template', iconBg: Color(0xFFEFF6FF)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toast(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _TemplateTile extends StatelessWidget {
  const _TemplateTile({
    required this.title,
    required this.subtitle,
    required this.iconBg,
  });

  final String title;
  final String subtitle;
  final Color iconBg;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Open "$title" template')));
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            border:
            Border.all(color: Colors.black.withOpacity(.08)),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.description, size: 18, color: Colors.black87),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14.5)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: TextStyle(
                            color: Colors.black.withOpacity(.55), fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

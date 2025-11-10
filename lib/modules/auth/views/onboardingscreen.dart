import 'package:attendence_management_software/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Onboardingscreen extends StatelessWidget {
  const Onboardingscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance Onboarding',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2B6CB0), // primary/700
        brightness: Brightness.light,
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2B6CB0),
        brightness: Brightness.dark,
        fontFamily: 'Inter',
      ),
      home: const OnboardingScreen(),
    );
  }
}

/// Data model for each page
class _OBPage {
  final String title;
  final String subtitle;
  final String image; // asset or network
  final List<Color> gradient;

  const _OBPage({
    required this.title,
    required this.subtitle,
    required this.image,
    this.gradient = const [Color(0xFFFFB020), Color(0xFF2B6CB0)],
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pc;
  int _index = 0;

  final pages = const [
    _OBPage(
      title: 'Efficient HR Management\nin One Place',
      subtitle:
          'Manage attendance, shifts, and requests with ease. Everything your team needs in a single app.',
      image: 'assets/icons/attendenceappsplashiamge1.png',
      gradient: [Color(0xFF00A370), Color(0xFF00A389)],
    ),
    _OBPage(
      title: 'Organize Departments\nand Payroll',
      subtitle:
          'Control work schedules, holidays, and payroll exports. One click reports for managers.',
      image:
          'assets/icons/attendenceappsplashiamge2.png',
      gradient: [Color(0xFF00A389), Color(0xFF2B6CB0)],
    ),
    _OBPage(
      title: 'Optimize Schedules\nand Approvals',
      subtitle:
          'Approve regularizations, track breaks, and ensure timely check-ins with geo-fence rules.',
      image:
          'assets/icons/attendenceappsplashiamge3.png',
      gradient: [Color(0xFF2B6CB0), Color(0xFFFFB020)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pc = PageController();
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  void _next() {
    if (_index < pages.length - 1) {
      _pc.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  void _prev() {
    if (_index > 0) {
      _pc.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _skip() => _finish();

  void _finish() {
     Get.offAllNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // --- Top gradient header + phone mock ---
            PageView.builder(
              controller: _pc,
              itemCount: pages.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) {
                final p = pages[i];
                return Column(
                  children: [
                    // Header/hero area
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: p.gradient,
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            child:  _PhoneMock(imageUrl: p.image),
                          ),
                        ),
                      ),
                    ),
                    // Curved sheet (kept empty here; the actual sheet is overlaid below)
                    const SizedBox(height: 220),
                  ],
                );
              },
            ),

            // --- Curved Bottom Sheet (fixed) ---
            Align(
              alignment: Alignment.bottomCenter,
              child: _CurvedSheet(
                height: 300,
                child: _SheetContent(
                  page: pages[_index],
                  index: _index,
                  total: pages.length,
                  onNext: _next,
                  onPrev: _prev,
                  onSkip: _skip,
                ),
              ),
            ),

            // --- Top-right Skip ---
            Positioned(
              right: 12,
              top: 12,
              child: TextButton(onPressed: _skip, child: const Text('Skip')),
            ),
          ],
        ),
      ),
    );
  }
}

/// phone-like rounded image preview
class _PhoneMock extends StatelessWidget {
  const _PhoneMock({required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AspectRatio(
      aspectRatio: 12 / 16.5,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.35), width: 2),
          image: DecorationImage(
            // image: NetworkImage(imageUrl),
            image: AssetImage(imageUrl),
            fit: BoxFit.fill,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}

/// Curved sheet using ClipPath
class _CurvedSheet extends StatelessWidget {
  const _CurvedSheet({required this.child, this.height = 300});

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipPath(
      clipper: _TopCurveClipper(),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final curveHeight = 42.0;
    final p = Path()
      ..moveTo(0, curveHeight)
      ..quadraticBezierTo(
        size.width * 0.5,
        -curveHeight,
        size.width,
        curveHeight,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Dots + title + subtitle + nav buttons
class _SheetContent extends StatelessWidget {
  const _SheetContent({
    required this.page,
    required this.index,
    required this.total,
    required this.onNext,
    required this.onPrev,
    required this.onSkip,
  });

  final _OBPage page;
  final int index;
  final int total;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Dots indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              total,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: i == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: i == index ? cs.primary : cs.outlineVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),

          // Titles
          Column(
            children: [
              const SizedBox(height: 6),
              Text(
                page.title,
                textAlign: TextAlign.center,
                style: tt.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: .2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                page.subtitle,
                textAlign: TextAlign.center,
                style: tt.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
            ],
          ),

          // Buttons row
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: index == 0 ? onSkip : onPrev,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: cs.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(index == 0 ? 'Skip' : 'Back'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: onNext,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(index == total - 1 ? 'Get Started' : 'Continue'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

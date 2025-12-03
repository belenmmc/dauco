import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A widget that provides the app's consistent gradient background
/// with decorative elements for all pages
class AppBackground extends StatelessWidget {
  final Widget child;
  final bool showDecorations;

  const AppBackground({
    super.key,
    required this.child,
    this.showDecorations = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 203, 220, 238), // Darker light blue
            Color.fromARGB(255, 176, 196, 222), // Medium blue
            Color.fromARGB(255, 97, 135, 174), // Dark blue
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: showDecorations
          ? Stack(
              children: [
                // Background decorative organic shapes - Even more shapes with softer borders!
                Positioned(
                  top: -120,
                  right: -80,
                  child: CustomPaint(
                    size: Size(350, 280), // Bigger variation!
                    painter: OrganicShapePainter(
                      color: Colors.white
                          .withValues(alpha: 0.15), // Much more visible!
                      seed: 15,
                      complexity: 12, // More complex shape
                      irregularity: 0.4, // Less irregular for smoother curves
                      smoothness: 0.8,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -180,
                  left: -120,
                  child: CustomPaint(
                    size: Size(520, 420), // Much bigger!
                    painter: OrganicShapePainter(
                      color: const Color.fromARGB(255, 97, 135, 174)
                          .withValues(alpha: 0.18), // Much more visible!
                      seed: 73,
                      complexity: 14,
                      irregularity: 0.5,
                      smoothness: 0.9,
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: -70,
                  child: CustomPaint(
                    size: Size(120, 140), // Smaller variation!
                    painter: OrganicShapePainter(
                      color: Colors.white
                          .withValues(alpha: 0.12), // Much more visible!
                      seed: 234,
                      complexity: 8,
                      irregularity: 0.3,
                      smoothness: 0.7,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 150,
                  right: -90,
                  child: CustomPaint(
                    size: Size(280, 240), // Bigger!
                    painter: OrganicShapePainter(
                      color: const Color.fromARGB(255, 97, 135, 174)
                          .withValues(alpha: 0.14), // Much more visible!
                      seed: 456,
                      complexity: 10,
                      irregularity: 0.4,
                      smoothness: 0.8,
                    ),
                  ),
                ),
                // Additional shapes for more richness
                Positioned(
                  top: 250,
                  right: -50,
                  child: CustomPaint(
                    size: Size(90, 80), // Much smaller!
                    painter: OrganicShapePainter(
                      color: Colors.white
                          .withValues(alpha: 0.10), // Much more visible!
                      seed: 789,
                      complexity: 6,
                      irregularity: 0.2,
                      smoothness: 0.9,
                    ),
                  ),
                ),
                Positioned(
                  top: -50,
                  left: 100,
                  child: CustomPaint(
                    size: Size(160, 140), // Bigger!
                    painter: OrganicShapePainter(
                      color: const Color.fromARGB(255, 97, 135, 174)
                          .withValues(alpha: 0.11), // Much more visible!
                      seed: 321,
                      complexity: 7,
                      irregularity: 0.3,
                      smoothness: 0.8,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  left: 50,
                  child: CustomPaint(
                    size: Size(50, 60), // Tiny!
                    painter: OrganicShapePainter(
                      color: Colors.white
                          .withValues(alpha: 0.08), // Much more visible!
                      seed: 654,
                      complexity: 5,
                      irregularity: 0.2,
                      smoothness: 0.95,
                    ),
                  ),
                ),
                Positioned(
                  top: 180,
                  left: -30,
                  child: CustomPaint(
                    size: Size(200, 180), // Bigger!
                    painter: OrganicShapePainter(
                      color: const Color.fromARGB(255, 97, 135, 174)
                          .withValues(alpha: 0.09), // Much more visible!
                      seed: 987,
                      complexity: 11,
                      irregularity: 0.4,
                      smoothness: 0.85,
                    ),
                  ),
                ),
                // Even more shapes for ultra-rich background!
                Positioned(
                  top: 320,
                  left: 120,
                  child: CustomPaint(
                    size: Size(40, 50), // Very tiny!
                    painter: OrganicShapePainter(
                      color: Colors.white
                          .withValues(alpha: 0.08), // Much more visible!
                      seed: 111,
                      complexity: 6,
                      irregularity: 0.25,
                      smoothness: 0.9,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 300,
                  right: 20,
                  child: CustomPaint(
                    size: Size(140, 110), // Medium!
                    painter: OrganicShapePainter(
                      color: const Color.fromARGB(255, 97, 135, 174)
                          .withValues(alpha: 0.10), // Much more visible!
                      seed: 222,
                      complexity: 8,
                      irregularity: 0.3,
                      smoothness: 0.85,
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 50,
                  child: CustomPaint(
                    size: Size(75, 85), // Small!
                    painter: OrganicShapePainter(
                      color: Colors.white
                          .withValues(alpha: 0.07), // Much more visible!
                      seed: 333,
                      complexity: 9,
                      irregularity: 0.35,
                      smoothness: 0.8,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  right: 150,
                  child: CustomPaint(
                    size: Size(220, 260), // Huge!
                    painter: OrganicShapePainter(
                      color: const Color.fromARGB(255, 97, 135, 174)
                          .withValues(alpha: 0.12), // Much more visible!
                      seed: 444,
                      complexity: 13,
                      irregularity: 0.45,
                      smoothness: 0.9,
                    ),
                  ),
                ),
                Positioned(
                  top: 150,
                  right: -20,
                  child: CustomPaint(
                    size: Size(180, 160), // Medium-large!
                    painter: OrganicShapePainter(
                      color: Colors.white
                          .withValues(alpha: 0.11), // Much more visible!
                      seed: 555,
                      complexity: 10,
                      irregularity: 0.3,
                      smoothness: 0.85,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 100,
                  left: -20,
                  child: CustomPaint(
                    size: Size(250, 210), // Big!
                    painter: OrganicShapePainter(
                      color: const Color.fromARGB(255, 97, 135, 174)
                          .withValues(alpha: 0.08), // Much more visible!
                      seed: 666,
                      complexity: 7,
                      irregularity: 0.25,
                      smoothness: 0.95,
                    ),
                  ),
                ),
                // NEW SHAPES FOR BOTTOM RIGHT AREA!
                Positioned(
                  bottom: 80,
                  right: 30,
                  child: CustomPaint(
                    size: Size(120, 100), // Medium!
                    painter: OrganicShapePainter(
                      color: Colors.white.withValues(alpha: 0.09),
                      seed: 777,
                      complexity: 8,
                      irregularity: 0.3,
                      smoothness: 0.85,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 200,
                  right: -30,
                  child: CustomPaint(
                    size: Size(180, 160), // Medium-large!
                    painter: OrganicShapePainter(
                      color: const Color.fromARGB(255, 97, 135, 174)
                          .withValues(alpha: 0.11),
                      seed: 888,
                      complexity: 9,
                      irregularity: 0.4,
                      smoothness: 0.8,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 120,
                  child: CustomPaint(
                    size: Size(80, 70), // Small!
                    painter: OrganicShapePainter(
                      color: Colors.white.withValues(alpha: 0.07),
                      seed: 999,
                      complexity: 6,
                      irregularity: 0.25,
                      smoothness: 0.9,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 150,
                  right: 80,
                  child: CustomPaint(
                    size: Size(60, 80), // Small!
                    painter: OrganicShapePainter(
                      color: const Color.fromARGB(255, 97, 135, 174)
                          .withValues(alpha: 0.08),
                      seed: 1010,
                      complexity: 7,
                      irregularity: 0.3,
                      smoothness: 0.85,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  right: -10,
                  child: CustomPaint(
                    size: Size(140, 120), // Medium!
                    painter: OrganicShapePainter(
                      color: Colors.white.withValues(alpha: 0.10),
                      seed: 1111,
                      complexity: 10,
                      irregularity: 0.35,
                      smoothness: 0.88,
                    ),
                  ),
                ),
                // Main content
                child,
              ],
            )
          : child,
    );
  }
}

/// A custom scaffold that automatically applies the app background
class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomNavigationBar;
  final bool showDecorations;
  final bool extendBodyBehindAppBar;

  const AppScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.showDecorations = true,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: AppBackground(
        showDecorations: showDecorations,
        child: body ?? const SizedBox.shrink(),
      ),
      floatingActionButton: floatingActionButton,
      drawer: drawer,
      endDrawer: endDrawer,
      bottomNavigationBar: bottomNavigationBar,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );
  }
}

/// Custom painter for organic blob shapes
class OrganicShapePainter extends CustomPainter {
  final Color color;
  final int seed;
  final int complexity;
  final double irregularity;
  final double smoothness;

  OrganicShapePainter({
    required this.color,
    this.seed = 0,
    this.complexity = 6,
    this.irregularity = 0.5,
    this.smoothness = 0.8,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // Create ultra-smooth, pure curve organic shapes
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final baseRadius = math.min(size.width, size.height) / 3;

    // Generate many points for maximum curve smoothness
    final points = <Offset>[];
    final curveComplexity =
        math.max(complexity * 2, 16); // Double points for ultra-smooth curves
    final angleStep = (2 * math.pi) / curveComplexity;

    for (int i = 0; i < curveComplexity; i++) {
      final angle = i * angleStep;

      // Create ultra-smooth radius variations using multiple sine waves
      final wave1 = math.sin(angle * 3 + seed) * irregularity * 0.2;
      final wave2 = math.cos(angle * 2 + seed * 1.7) * irregularity * 0.15;
      final wave3 = math.sin(angle * 4 + seed * 0.3) * irregularity * 0.1;
      final wave4 = math.cos(angle * 1.5 + seed * 2.1) * irregularity * 0.08;

      final radiusVariation =
          baseRadius * (0.8 + wave1 + wave2 + wave3 + wave4);

      points.add(Offset(
        centerX + radiusVariation * math.cos(angle),
        centerY + radiusVariation * math.sin(angle),
      ));
    }

    // Create ULTRA-SMOOTH curves using maximum smoothing
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);

      for (int i = 0; i < points.length; i++) {
        final current = points[i];
        final next = points[(i + 1) % points.length];
        final prev = points[(i - 1 + points.length) % points.length];
        final nextNext = points[(i + 2) % points.length];

        // Maximum curve smoothness - like silk or liquid
        final maxSmoothness = smoothness * 0.8;

        // Create ultra-smooth control points for perfect curves
        final tangent1 = Offset(
          (next.dx - prev.dx) * maxSmoothness,
          (next.dy - prev.dy) * maxSmoothness,
        );

        final tangent2 = Offset(
          (nextNext.dx - current.dx) * maxSmoothness,
          (nextNext.dy - current.dy) * maxSmoothness,
        );

        final cp1 = Offset(
          current.dx + tangent1.dx * 0.33,
          current.dy + tangent1.dy * 0.33,
        );

        final cp2 = Offset(
          next.dx - tangent2.dx * 0.33,
          next.dy - tangent2.dy * 0.33,
        );

        // Additional ultra-smoothing for liquid-like appearance
        final distance = math.sqrt(math.pow(next.dx - current.dx, 2) +
            math.pow(next.dy - current.dy, 2));

        final smoothFactor = math.min(maxSmoothness, distance * 0.4);

        final ultraCp1 = Offset(
          current.dx +
              (next.dx - current.dx) * 0.25 +
              (prev.dy - next.dy) * smoothFactor * 0.1,
          current.dy +
              (next.dy - current.dy) * 0.25 +
              (next.dx - prev.dx) * smoothFactor * 0.1,
        );

        final ultraCp2 = Offset(
          current.dx +
              (next.dx - current.dx) * 0.75 -
              (prev.dy - next.dy) * smoothFactor * 0.1,
          current.dy +
              (next.dy - current.dy) * 0.75 -
              (next.dx - prev.dx) * smoothFactor * 0.1,
        );

        // Blend all control points for maximum smoothness
        final finalCp1 = Offset(
          (cp1.dx + ultraCp1.dx) * 0.5,
          (cp1.dy + ultraCp1.dy) * 0.5,
        );

        final finalCp2 = Offset(
          (cp2.dx + ultraCp2.dx) * 0.5,
          (cp2.dy + ultraCp2.dy) * 0.5,
        );

        // Create the smoothest possible curves - pure liquid flow
        path.cubicTo(
          finalCp1.dx,
          finalCp1.dy,
          finalCp2.dx,
          finalCp2.dy,
          next.dx,
          next.dy,
        );
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(OrganicShapePainter oldDelegate) {
    return color != oldDelegate.color ||
        seed != oldDelegate.seed ||
        complexity != oldDelegate.complexity ||
        irregularity != oldDelegate.irregularity ||
        smoothness != oldDelegate.smoothness;
  }
}

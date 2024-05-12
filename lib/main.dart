import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const MaterialApp(home: ProgressIndicatorDemo()));
}

class ProgressIndicatorDemo extends HookWidget {
  const ProgressIndicatorDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(duration: const Duration(seconds: 2));
    final animation = useAnimation(controller.drive(Tween<double>(begin: 0, end: 75)));

    useEffect(() {
      controller.forward();
      return null;
    }, const []);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.reset();
          controller.forward();
        },
      ),
      body: Center(
        child: CustomProgressIndicator(
          progress: animation,
          progressColor: Colors.blue,
          remainingColor: Colors.grey,
          strokeWidth: 8.0,
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class CustomProgressIndicator extends StatelessWidget {
  final double progress;
  final Color progressColor;
  final Color remainingColor;
  final double strokeWidth;
  final TextStyle textStyle;

  const CustomProgressIndicator({
    Key? key,
    required this.progress,
    this.progressColor = Colors.blue,
    this.remainingColor = Colors.grey,
    this.strokeWidth = 5.0,
    this.textStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: CustomPaint(
        painter: _CircularProgressPainter(
          progress: progress,
          progressColor: progressColor,
          remainingColor: remainingColor,
          strokeWidth: strokeWidth,
        ),
        child: Center(
          child: Text(
            '${progress.toInt()}%',
            style: textStyle,
          ),
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color remainingColor;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.remainingColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - strokeWidth / 2;
    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * (progress / 100);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final backgroundPaint = Paint()
      ..color = remainingColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

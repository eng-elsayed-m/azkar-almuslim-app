import 'dart:math';

import 'package:azkar/src/core/utils/configs/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

class Compass extends StatefulWidget {
  const Compass({Key? key}) : super(key: key);

  @override
  State<Compass> createState() => _CompassState();
}

class _CompassState extends State<Compass> {
  CompassEvent _compassEvent = CompassEvent.fromList([0, 10, 10]);

  String get _readout => '${_compassEvent.heading!.toStringAsFixed(0)}°';

  @override
  void initState() {
    super.initState();
    FlutterCompass.events!.listen(_onData);
  }

  void _onData(CompassEvent x) => setState(() {
        _compassEvent = x;
      });

  final TextStyle _style = TextStyle(
    color: Colors.red[50]!.withOpacity(0.9),
    fontSize: 32,
    fontWeight: FontWeight.w200,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 25),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor.withOpacity(0.5)),
      child: CustomPaint(
          foregroundPainter: CompassPainter(angle: _compassEvent.heading!),
          child: Center(child: Text(_readout, style: _style))),
    );
  }
}

class CompassPainter extends CustomPainter {
  CompassPainter({required this.angle}) : super();

  final double angle;
  double get rotation => -2 * pi * (angle / 360);

  Paint get _brush => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    Paint circle = _brush..color = Colors.indigo[400]!.withOpacity(0.6);

    Paint needle = _brush..color = Colors.red[400]!;

    double radius = min(size.width / 2.2, size.height / 2.2);
    Offset center = Offset(size.width / 2, size.height / 2);
    Offset start = Offset.lerp(Offset(center.dx, radius), center, .4)!;
    Offset end = Offset.lerp(Offset(center.dx, radius), center, 0.1)!;

    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawLine(start, end, needle);
    canvas.drawCircle(center, radius, circle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

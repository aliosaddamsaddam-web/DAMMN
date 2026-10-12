
import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const FootballGame());
}

class FootballGame extends StatelessWidget {
  const FootballGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FootballPage(),
    );
  }
}

class FootballPage extends StatefulWidget {
  const FootballPage({super.key});

  @override
  State<FootballPage> createState() => _FootballPageState();
}

class _FootballPageState extends State<FootballPage> {
  double playerX = 0;
  double playerY = 0.55;
  double ballX = 0;
  double ballY = 0.35;
  int goals = 0;
  String message = 'حرّك اللاعب وسدّد نحو المرمى!';

  void move(double dx, double dy) {
    setState(() {
      playerX = (playerX + dx).clamp(-0.85, 0.85).toDouble();
      playerY = (playerY + dy).clamp(-0.2, 0.85).toDouble();
    });
  }

  void shoot() {
    setState(() {
      final distance = math.sqrt(
        math.pow(playerX - ballX, 2) +
        math.pow(playerY - ballY, 2),
      );

      if (distance < 0.35) {
        ballX = playerX;
        ballY = -0.65;
        goals++;
        message = 'هدف رائع! ⚽';
      } else {
        ballX = (playerX * 0.5).clamp(-0.85, 0.85).toDouble();
        ballY = -0.65;
        message = 'سددت الكرة! حاول الاقتراب منها.';
      }
    });
  }

  void reset() {
    setState(() {
      playerX = 0;
      playerY = 0.55;
      ballX = 0;
      ballY = 0.35;
      goals = 0;
      message = 'بدأت مباراة جديدة!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF123B26),
      appBar: AppBar(
        title: const Text('لعبة كرة القدم ⚽'),
        centerTitle: true,
        backgroundColor: Colors.green.shade900,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'الأهداف: $goals',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;

                Offset position(double x, double y) => Offset(
                  w * (x + 1) / 2,
                  h * (y + 1) / 2,
                );

                final player = position(playerX, playerY);
                final ball = position(ballX, ballY);

                return Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: FieldPainter(),
                      ),
                    ),
                    Positioned(
                      left: w / 2 - 48,
                      top: 0,
                      child: Container(
                        width: 96,
                        height: 12,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: player.dx - 19,
                      top: player.dy - 19,
                      child: const CircleAvatar(
                        radius: 19,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 29,
                        ),
                      ),
                    ),
                    Positioned(
                      left: ball.dx - 12,
                      top: ball.dy - 12,
                      child: const Text('⚽',
                          style: TextStyle(fontSize: 25)),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 10,
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              control('↑', 0, -0.12),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              control('←', -0.12, 0),
              const SizedBox(width: 25),
              control('↓', 0, 0.12),
              const SizedBox(width: 25),
              control('→', 0.12, 0),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: shoot,
                    icon: const Icon(Icons.sports_soccer),
                    label: const Text('تسديد'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: reset,
                    child: const Text('إعادة اللعب'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget control(String label, double dx, double dy) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: () => move(dx, dy),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(58, 48),
          backgroundColor: Colors.white,
          foregroundColor: Colors.green.shade900,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class FieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final field = Paint()..color = const Color(0xFF218447);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      field,
    );

    final line = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawRect(
      Rect.fromLTWH(8, 8, size.width - 16, size.height - 16),
      line,
    );

    canvas.drawLine(
      Offset(8, size.height / 2),
      Offset(size.width - 8, size.height / 2),
      line,
    );

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      45,
      line,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.25,
        8,
        size.width * 0.5,
        size.height * 0.18,
      ),
      line,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
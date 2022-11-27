import 'dart:ui';

import 'package:chaotic_progress/chaotic_progress.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  var _showChaoticProgress = true;

  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  );

  @override
  void initState() {
    super.initState();
    _animationController
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.forward(from: 0);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          const FlutterLogo(
            size: 300,
            style: FlutterLogoStyle.horizontal,
          ),
          ChaoticProgress(
            visible: _showChaoticProgress,
            // backgroundColor: Colors.white.withOpacity(0.5),
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            alignCurve: Curves.linear,
            duration: const Duration(seconds: 4),
            shapeBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _animationController,
                builder: (_, child) {
                  return Transform.rotate(
                    angle: _animationController.value * -2 * 3.1415926,
                    child: child,
                  );
                },
                child: const Icon(
                  Icons.ac_unit,
                  color: Colors.lightBlueAccent,
                  size: 36,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() => _showChaoticProgress = !_showChaoticProgress);
        },
        child: const Text('Click'),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

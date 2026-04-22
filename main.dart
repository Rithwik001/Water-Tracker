import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WaterTracker(),
    );
  }
}

class WaterTracker extends StatefulWidget {
  const WaterTracker({super.key});

  @override
  State<WaterTracker> createState() => _WaterTrackerState();
}

class _WaterTrackerState extends State<WaterTracker> {
  int water = 0;
  final int goal = 2000;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    setState(() => water = p.getInt('water') ?? 0);
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    p.setInt('water', water);
  }

  void add(int ml) {
    setState(() => water = (water + ml).clamp(0, goal));
    _save();
  }

  void reset() {
    setState(() => water = 0);
    _save();
  }

  @override
  Widget build(BuildContext context) {
    final progress = water / goal;
    final percent = (progress * 100).toInt();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("💧 Water Tracker",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),

                const SizedBox(height: 20),

                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 140,
                      height: 140,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 10,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                    Column(
                      children: [
                        Text("$percent%",
                            style: const TextStyle(
                                fontSize: 26,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        Text("$water ml",
                            style: const TextStyle(color: Colors.white70)),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 20),
                Text("Goal: $goal ml",
                    style: const TextStyle(color: Colors.white)),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _btn("+100", () => add(100)),
                    _btn("+250", () => add(250)),
                    _btn("+500", () => add(500)),
                  ],
                ),

                const SizedBox(height: 15),

                ElevatedButton(
                  onPressed: reset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Reset"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _btn(String text, VoidCallback f) {
    return ElevatedButton(
      onPressed: f,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(text),
    );
  }
}

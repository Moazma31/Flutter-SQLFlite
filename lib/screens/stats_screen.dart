import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leitner Box Statistics'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Your Learning Progress',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            const SizedBox(height: 15),
            _buildBoxTile('Box 1: Daily Review', 'Default new cards', Colors.red.shade100, Colors.red.shade800),
            _buildBoxTile('Box 2: Every 3 Days', 'Developing mastery', Colors.orange.shade100, Colors.orange.shade800),
            _buildBoxTile('Box 3: Weekly Review', 'Solid understanding', Colors.amber.shade100, Colors.amber.shade800),
            _buildBoxTile('Box 4: Bi-weekly Review', 'Strong retention', Colors.blue.shade100, Colors.blue.shade800),
            _buildBoxTile('Box 5: Monthly Review', 'Fully Mastered! 🏆', Colors.green.shade100, Colors.green.shade800),
          ],
        ),
      ),
    );
  }

  Widget _buildBoxTile(String title, String subtitle, Color bgColor, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(fontSize: 13, color: textColor.withOpacity(0.8))),
            ],
          ),
          Icon(Icons.insights, color: textColor, size: 28),
        ],
      ),
    );
  }
}
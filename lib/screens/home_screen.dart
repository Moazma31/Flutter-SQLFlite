import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/recall_models.dart';
import 'topic_screen.dart';
import 'stats_screen.dart';
import 'help_screen.dart';
import 'profile_settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Subject> _subjects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshSubjects();
  }

  // SQLite se saare subjects load karna
  Future<void> _refreshSubjects() async {
    final data = await DBHelper.instance.getSubjects();
    setState(() {
      _subjects = data.map((item) => Subject.fromMap(item)).toList();
      _isLoading = false;
    });
  }

  // Naya Subject add karne ka dialog
  void _showAddSubjectDialog() {
    final TextEditingController nameController = TextEditingController();
    String selectedColor = '0xFF6C63FF'; // Default Purple color

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Subject'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            hintText: 'e.g., OOP, Operating Systems, DAA',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isNotEmpty) {
                await DBHelper.instance.insertSubject({
                  'name': nameController.text.trim(),
                  'color': selectedColor,
                });
                nameController.clear();
                if (mounted) Navigator.pop(context);
                _refreshSubjects(); // List ko update karna
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RecallIt 🧠',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Stats',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StatsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Help',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HelpScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileSettingsScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Dashboard Summary Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome Back! 👋',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Ready to master your subjects?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatBadge('Subjects', '${_subjects.length}', Icons.book),
                    _buildStatBadge('Streak', '1 Day 🔥', Icons.local_fire_department),
                    _buildStatBadge('System', 'Leitner 5-Box', Icons.layers),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // Subjects Section Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your Subjects',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Subjects List (SQLite se)
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _subjects.isEmpty
                ? const Center(
              child: Text(
                'No subjects yet.\nTap + to add your first subject!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _subjects.length,
              itemBuilder: (context, index) {
                final subject = _subjects[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple.shade100,
                      child: const Icon(Icons.menu_book,
                          color: Colors.deepPurple),
                    ),
                    title: Text(
                      subject.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: const Text('Tap to view topics & cards'),
                    trailing:
                    const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TopicScreen(subject: subject),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSubjectDialog,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Subject'),
      ),
    );
  }

  Widget _buildStatBadge(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
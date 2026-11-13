import 'package:flutter/material.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.deepPurpleAccent,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Moazma Imam',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Center(
            child: Text(
              'BSCS Student • COMSATS Sahiwal',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 30),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.deepPurple),
            title: const Text('Daily Study Reminders'),
            trailing: Switch(value: true, onChanged: (val) {}),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode, color: Colors.deepPurple),
            title: const Text('Dark Theme'),
            trailing: Switch(value: false, onChanged: (val) {}),
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.deepPurple),
            title: const Text('About App'),
            subtitle: const Text('RecallIt v1.0 - Leitner Flashcard System'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
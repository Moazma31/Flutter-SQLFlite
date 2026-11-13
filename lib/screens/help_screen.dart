import 'package:flutter/material.dart';


class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Use RecallIt'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🧠 Leitner Spaced Repetition Guide',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              SizedBox(height: 15),
              Text(
                '1. Add Subjects & Topics:\nOrganize your course material into specific subjects and smaller topics.\n\n'
                    '2. Create Flashcards:\nAdd questions and answers for each topic with optional hints.\n\n'
                    '3. Review Daily:\nTap the review button to test your memory. If you remember the card, it moves to a higher box with longer review intervals. If you forget, it resets to Box 1.',
                style: TextStyle(fontSize: 15, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
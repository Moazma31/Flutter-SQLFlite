import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/recall_models.dart';

class AddEditCardScreen extends StatefulWidget {
  final Topic topic;

  const AddEditCardScreen({super.key, required this.topic});

  @override
  State<AddEditCardScreen> createState() => _AddEditCardScreenState();
}

class _AddEditCardScreenState extends State<AddEditCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  final _hintController = TextEditingController();

  void _saveCard() async {
    if (_formKey.currentState!.validate()) {
      final String today = DateTime.now().toIso8601String().split('T')[0];
      await DBHelper.instance.insertCard({
        'topic_id': widget.topic.id,
        'question': _questionController.text.trim(),
        'answer': _answerController.text.trim(),
        'hint': _hintController.text.trim().isEmpty ? null : _hintController.text.trim(),
        'box_level': 1,
        'next_review_date': today,
      });
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Card: ${widget.topic.title}'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _questionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Flashcard Question',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a question' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _answerController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Flashcard Answer',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter an answer' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hintController,
                decoration: const InputDecoration(
                  labelText: 'Hint (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _saveCard,
                child: const Text('Save Flashcard', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
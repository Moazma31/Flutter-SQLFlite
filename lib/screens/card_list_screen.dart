import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/recall_models.dart';

class CardListScreen extends StatefulWidget {
  final Topic topic;

  const CardListScreen({super.key, required this.topic});

  @override
  State<CardListScreen> createState() => _CardListScreenState();
}

class _CardListScreenState extends State<CardListScreen> {
  List<FlashCard> _cards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshCards();
  }

  Future<void> _refreshCards() async {
    final data = await DBHelper.instance.getCards(widget.topic.id!);
    setState(() {
      _cards = data.map((item) => FlashCard.fromMap(item)).toList();
      _isLoading = false;
    });
  }

  void _showAddCardDialog() {
    final TextEditingController questionController = TextEditingController();
    final TextEditingController answerController = TextEditingController();
    final TextEditingController hintController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Flashcard in ${widget.topic.title}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionController,
                decoration: const InputDecoration(
                  labelText: 'Question',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: answerController,
                decoration: const InputDecoration(
                  labelText: 'Answer',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: hintController,
                decoration: const InputDecoration(
                  labelText: 'Hint (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (questionController.text.trim().isNotEmpty &&
                  answerController.text.trim().isNotEmpty) {
                final String today = DateTime.now().toIso8601String().split('T')[0];

                await DBHelper.instance.insertCard({
                  'topic_id': widget.topic.id,
                  'question': questionController.text.trim(),
                  'answer': answerController.text.trim(),
                  'hint': hintController.text.trim().isEmpty ? null : hintController.text.trim(),
                  'box_level': 1,
                  'next_review_date': today,
                });

                if (mounted) Navigator.pop(context);
                _refreshCards();
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
        title: Text(widget.topic.title),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cards.isEmpty
          ? const Center(
        child: Text(
          'No flashcards yet.\nTap + to create your first flashcard!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text('Box Level: ${card.boxLevel}'),
                        backgroundColor: Colors.deepPurple.shade50,
                        labelStyle: const TextStyle(color: Colors.deepPurple),
                      ),
                      Text(
                        'Review: ${card.nextReviewDate}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Q: ${card.question}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'A: ${card.answer}',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  if (card.hint != null && card.hint!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Hint: ${card.hint}',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.deepOrange,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddCardDialog,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Flashcard'),
      ),
    );
  }
}
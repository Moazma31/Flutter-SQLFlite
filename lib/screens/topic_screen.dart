import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/recall_models.dart';
import 'card_list_screen.dart';
import 'review_screen.dart'; // ReviewScreen import kar liya hai

class TopicScreen extends StatefulWidget {
  final Subject subject;

  const TopicScreen({super.key, required this.subject});

  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  List<Topic> _topics = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshTopics();
  }

  Future<void> _refreshTopics() async {
    final data = await DBHelper.instance.getTopics(widget.subject.id!);
    setState(() {
      _topics = data.map((item) => Topic.fromMap(item)).toList();
      _isLoading = false;
    });
  }

  void _showAddTopicDialog() {
    final TextEditingController titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Topic in ${widget.subject.name}'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            hintText: 'e.g., Inheritance, Polymorphism',
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
              if (titleController.text.trim().isNotEmpty) {
                await DBHelper.instance.insertTopic({
                  'subject_id': widget.subject.id,
                  'title': titleController.text.trim(),
                });
                titleController.clear();
                if (mounted) Navigator.pop(context);
                _refreshTopics();
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
        title: Text(widget.subject.name),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _topics.isEmpty
          ? const Center(
        child: Text(
          'No topics yet.\nTap + to add a topic!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _topics.length,
        itemBuilder: (context, index) {
          final topic = _topics[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.deepPurpleAccent,
                child: Icon(Icons.topic, color: Colors.white),
              ),
              title: Text(
                topic.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: const Text('Tap to view & manage Flashcards'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Review / Practice Button
                  IconButton(
                    icon: const Icon(Icons.play_circle_fill, color: Colors.deepPurple, size: 28),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewScreen(topic: topic),
                        ),
                      );
                    },
                    tooltip: 'Start Leitner Review',
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CardListScreen(topic: topic),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTopicDialog,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Topic'),
      ),
    );
  }
}
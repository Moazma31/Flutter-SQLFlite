import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/recall_models.dart';

class ReviewScreen extends StatefulWidget {
  final Topic topic;

  const ReviewScreen({super.key, required this.topic});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<FlashCard> _reviewCards = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _loadReviewCards();
  }

  Future<void> _loadReviewCards() async {
    final data = await DBHelper.instance.getCards(widget.topic.id!);
    final String today = DateTime.now().toIso8601String().split('T')[0];

    List<FlashCard> allCards = data.map((item) => FlashCard.fromMap(item)).toList();

    setState(() {
      _reviewCards = allCards.where((card) => card.nextReviewDate.compareTo(today) <= 0).toList();

      if (_reviewCards.isEmpty) {
        _reviewCards = allCards;
      }
      _isLoading = false;
    });
  }


  void _updateCardProgress(bool remembered) async {
    if (_reviewCards.isEmpty) return;

    final currentCard = _reviewCards[_currentIndex];
    int currentBox = currentCard.boxLevel;
    int newBox = remembered ? (currentBox < 5 ? currentBox + 1 : 5) : 1;


    int daysToAdd = 1;
    if (newBox == 2) daysToAdd = 3;
    if (newBox == 3) daysToAdd = 7;
    if (newBox == 4) daysToAdd = 14;
    if (newBox == 5) daysToAdd = 30;

    DateTime nextDate = DateTime.now().add(Duration(days: daysToAdd));
    String formattedDate = nextDate.toIso8601String().split('T')[0];


    await DBHelper.instance.updateCardBox(currentCard.id!, newBox, formattedDate);

    setState(() {
      _isFlipped = false;
      if (_currentIndex < _reviewCards.length - 1) {
        _currentIndex++;
      } else {

        _showCompletionDialog();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Review Complete! '),
        content: const Text('You have reviewed all the cards in this topic.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review: ${widget.topic.title}'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reviewCards.isEmpty
          ? const Center(
        child: Text(
          'No flashcards found for review!\nAdd some cards first.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [

            LinearProgressIndicator(
              value: (_currentIndex + 1) / _reviewCards.length,
              backgroundColor: Colors.deepPurple.shade100,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 10),
            Text(
              'Card ${_currentIndex + 1} of ${_reviewCards.length}',
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Flashcard Flip UI Card
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isFlipped = !_isFlipped;
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _isFlipped ? Colors.deepPurple.shade50 : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.deepPurple.shade200, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isFlipped ? 'ANSWER' : 'QUESTION',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade300,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _isFlipped
                            ? _reviewCards[_currentIndex].answer
                            : _reviewCards[_currentIndex].question,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: _isFlipped ? Colors.deepPurple.shade900 : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        _isFlipped ? '(Tap to flip back)' : '(Tap card to flip & see answer)',
                        style: const TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons (Remembered / Forgot)
            if (_isFlipped)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _updateCardProgress(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade100,
                        foregroundColor: Colors.red.shade800,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.close),
                      label: const Text('Forgot (Box 1)', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _updateCardProgress(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade100,
                        foregroundColor: Colors.green.shade800,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.check),
                      label: const Text('Remembered 🎉', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
            else
              const Text(
                'Tap the card first to see the answer',
                style: TextStyle(color: Colors.grey),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
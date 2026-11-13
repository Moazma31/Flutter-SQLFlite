class Subject {
  final int? id;
  final String name;
  final String color;

  Subject({this.id, required this.name, required this.color});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'color': color};
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'],
      name: map['name'],
      color: map['color'],
    );
  }
}

class Topic {
  final int? id;
  final int subjectId;
  final String title;

  Topic({this.id, required this.subjectId, required this.title});

  Map<String, dynamic> toMap() {
    return {'id': id, 'subject_id': subjectId, 'title': title};
  }

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      id: map['id'],
      subjectId: map['subject_id'],
      title: map['title'],
    );
  }
}

class FlashCard {
  final int? id;
  final int topicId;
  final String question;
  final String answer;
  final String? hint;
  final int boxLevel;
  final String nextReviewDate;

  FlashCard({
    this.id,
    required this.topicId,
    required this.question,
    required this.answer,
    this.hint,
    this.boxLevel = 1,
    required this.nextReviewDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topic_id': topicId,
      'question': question,
      'answer': answer,
      'hint': hint,
      'box_level': boxLevel,
      'next_review_date': nextReviewDate,
    };
  }

  factory FlashCard.fromMap(Map<String, dynamic> map) {
    return FlashCard(
      id: map['id'],
      topicId: map['topic_id'],
      question: map['question'],
      answer: map['answer'],
      hint: map['hint'],
      boxLevel: map['box_level'],
      nextReviewDate: map['next_review_date'],
    );
  }
}
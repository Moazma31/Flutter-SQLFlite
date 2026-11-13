import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('recall_it.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE subjects (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        color TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE topics (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subject_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        FOREIGN KEY (subject_id) REFERENCES subjects (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE cards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        topic_id INTEGER NOT NULL,
        question TEXT NOT NULL,
        answer TEXT NOT NULL,
        hint TEXT,
        box_level INTEGER DEFAULT 1,
        next_review_date TEXT NOT NULL,
        FOREIGN KEY (topic_id) REFERENCES topics (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertSubject(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('subjects', row);
  }

  Future<List<Map<String, dynamic>>> getSubjects() async {
    final db = await instance.database;
    return await db.query('subjects');
  }

  Future<int> insertTopic(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('topics', row);
  }

  Future<List<Map<String, dynamic>>> getTopics(int subjectId) async {
    final db = await instance.database;

    return await db.query(
      'topics',
      where: 'subject_id = ?',
      whereArgs: [subjectId],
    );
  }

  Future<int> insertCard(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('cards', row);
  }

  Future<List<Map<String, dynamic>>> getCards(int topicId) async {
    final db = await instance.database;

    return await db.query(
      'cards',
      where: 'topic_id = ?',
      whereArgs: [topicId],
    );
  }

  Future<int> updateCardBox(
      int cardId,
      int newBox,
      String nextDate,
      ) async {
    final db = await instance.database;

    return await db.update(
      'cards',
      {
        'box_level': newBox,
        'next_review_date': nextDate,
      },
      where: 'id = ?',
      whereArgs: [cardId],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
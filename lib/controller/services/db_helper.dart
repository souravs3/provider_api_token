import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:test_api_provider/model/attentice_model.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'attendees.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE groups(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE group_attendees(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            group_id INTEGER,
            attendee_name TEXT,
            attendee_email TEXT,
            attendee_photo TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertGroup(String name) async {
    final db = await database;
    return await db.insert('groups', {'name': name});
  }

  Future<int> insertGroupAttendee(int groupId, Attendee attendee) async {
    final db = await database;
    return await db.insert('group_attendees', {
      'group_id': groupId,
      'attendee_name': attendee.name,
      'attendee_email': attendee.email,
      'attendee_photo': attendee.photo,
    });
  }

  Future<List<Map<String, dynamic>>> getGroups() async {
    final db = await database;
    return await db.query('groups');
  }

  Future<List<Map<String, dynamic>>> getGroupAttendees(int groupId) async {
    final db = await database;
    return await db.query('group_attendees', where: 'group_id = ?', whereArgs: [groupId]);
  }
}

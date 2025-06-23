import 'package:basic_chat_app/data/models/message_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseService {
  static Database? _db;

  Future<Database> get db async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'chat.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE messages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            sender TEXT,
            receiver TEXT,
            message TEXT,
            timestamp TEXT
          )
        ''');
      },
    );
  }

  //inserMessgate
  // incoming ==> 
  // sending ==>


  Future<void> insertMessage(MessageModel message) async {
   print('Message object: $message');
  print('Message as Map: ${message.toMap()}');
    final dbClient = await db;
    await dbClient.insert('messages', message.toMap());
  }

  // user1==> realme  user2==> fcmtokensender 

  //incoming == user1 = iqoo user2== fcmtokenreciever

  Future<List<MessageModel>> getMessages(String user1, String user2) async {
     print('Getting messages between user1: $user1 and user2: $user2');
    final dbClient = await db;
    final maps = await dbClient.query(
      'messages',
      where: '(sender = ? AND receiver = ?) OR (sender = ? AND receiver = ?)',
      whereArgs: [user1, user2, user2, user1],
      orderBy: 'timestamp ASC',
    );
    return maps.map((e) => MessageModel.fromMap(e)).toList();
  }

  Future<bool> messageExists(MessageModel message) async {
  final dbClient = await db;
  final result = await dbClient.query(
    'messages',
    where: 'sender = ? AND receiver = ? AND message = ? AND timestamp = ?',
    whereArgs: [
      message.sender,
      message.receiver,
      message.message,
      message.timestamp.toIso8601String(),
    ],
  );
  return result.isNotEmpty;
}

}

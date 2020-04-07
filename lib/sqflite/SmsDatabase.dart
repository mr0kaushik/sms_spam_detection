import 'package:path/path.dart';
import 'package:sms_spam_detection/presentation/MatColor.dart';
import 'package:sms_spam_detection/sms/sms_service.dart';
import 'package:sqflite/sqflite.dart';

class SmsDatabaseProvider {
  static const int DATABASE_VERSION = 1;
  static const String DATABASE_NAME = "spam_sms.db";
  static const String TABLE_SMS_MESSAGES_NAME = "SmsMessages";

  static const String KEY_SMS_ID = "_id";
  static const String KEY_SMS_ADDRESS = "address";
  static const String KEY_SMS_THREAD_ID = "thread_id";
  static const String KEY_SMS_BODY = "body";
  static const String KEY_SMS_READ = "read";
  static const String KEY_SMS_DATE = "date";
  static const String KEY_SMS_DATE_SENT = "date_sent";
  static const String KEY_SMS_MESSAGE_KIND = "kind";
  static const String KEY_SMS_MESSAGE_TYPE = "message_type";
  static const String KEY_SMS_MESSAGE_STATE = "message_state";

  static const String TABLE_THREAD_ID_NAME = "ThreadId";
  static const String KEY_THREAD_COLOR = "color";

  SmsDatabaseProvider._();

  static final SmsDatabaseProvider db = SmsDatabaseProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getSmsDatabaseInstance();
    return _database;
  }

  Future<Database> getSmsDatabaseInstance() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, DATABASE_NAME);
    return await openDatabase(path,
        version: DATABASE_VERSION, onCreate: populateSmsDb);
  }

  void populateSmsDb(Database database, int version) async {
    await database.execute("CREATE TABLE " +
        TABLE_SMS_MESSAGES_NAME +
        "(" +
        KEY_SMS_ID +
        " INTEGER PRIMARY KEY, " +
        KEY_SMS_ADDRESS +
        " TEXT, " +
        KEY_SMS_BODY +
        " TEXT, " +
        KEY_SMS_THREAD_ID +
        " INTEGER, " +
        KEY_SMS_READ +
        " INTEGER, " +
        KEY_SMS_DATE +
        " INTEGER, " +
        KEY_SMS_DATE_SENT +
        " INTEGER, " +
        KEY_SMS_MESSAGE_KIND +
        " INTEGER, " +
        KEY_SMS_MESSAGE_TYPE +
        " INTEGER, " +
        KEY_SMS_MESSAGE_STATE +
        " INTEGER " +
        ")");

    await database.execute("CREATE TABLE " +
        TABLE_THREAD_ID_NAME +
        " ( " +
        KEY_SMS_THREAD_ID +
        " INTEGER PRIMARY KEY, " +
        KEY_SMS_ADDRESS +
        " TEXT, " +
        KEY_THREAD_COLOR +
        " INTEGER "
            ")");
  }

  addThreadToDataBase(SmsThread thread) async {
    final db = await database;
    var raw = await db.insert(
      TABLE_THREAD_ID_NAME,
      thread.toMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  updateThread(SmsThread thread) async {
    final db = await database;
    var response = await db.update(TABLE_THREAD_ID_NAME, thread.toMap,
        where: KEY_SMS_THREAD_ID + " = ?", whereArgs: [thread.id]);
    return response;
  }

  addMessageToDatabase(SmsMessage smsMessage) async {
    final db = await database;
    var raw = await db.insert(
      TABLE_SMS_MESSAGES_NAME,
      smsMessage.toMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  updateMessage(SmsMessage message) async {
    final db = await database;
    var response = await db.update(TABLE_SMS_MESSAGES_NAME, message.toMap,
        where: KEY_SMS_ID + " = ?", whereArgs: [message.id]);
    return response;
  }

  Future<int> getThreadColorById(int threadId) async {
    final db = await database;
    var response = await db.query(
      TABLE_THREAD_ID_NAME,
      where: KEY_SMS_THREAD_ID + " = ?",
      whereArgs: [threadId],
    );
    SmsThread thread = SmsThread.fromJson(response.first);
    if (response.isNotEmpty && thread.color == null) {
      int color = RandomColor.getRandomColor().value;
      thread.color = color;
      updateThread(thread);
      return color;
    }
    return response.isNotEmpty
        ? SmsThread.fromJson(response.first).color
        : null;
  }

  Future<SmsMessage> getMessageWithId(int id) async {
    final db = await database;
    var response = await db.query(TABLE_SMS_MESSAGES_NAME,
        where: KEY_SMS_ID + " = ?",
        whereArgs: [id],
        orderBy: KEY_SMS_DATE + ' DESC');
    return response.isNotEmpty ? SmsMessage.fromJson(response.first) : null;
  }

  Future<List<SmsMessage>> getMessage(String address,
      {int threadId = -1,
      bool sort = true,
      List<SmsMessageType> types = const []}) async {
    final db = await database;
    List<SmsMessage> messages = [];

    List<dynamic> whereArgs = [address];
    String where = KEY_SMS_ADDRESS + " = ?";
    if (threadId != -1) {
      where = where + " AND " + KEY_SMS_THREAD_ID + " = ?";
      whereArgs.add(threadId);
    }

    if (types != null && types.isNotEmpty) {
      List<int> ids = [];
      types.forEach((element) {
        ids.add(element.index);
      });
      where =
          where + " AND " + KEY_SMS_MESSAGE_TYPE + " IN (${ids.join(', ')})";
    }

//    print('SmsDatabaseProvider : Where : $where');

    var response = await db.query(TABLE_SMS_MESSAGES_NAME,
        where: where, whereArgs: whereArgs);
    if (response != null && response.isNotEmpty) {
      response.forEach((element) {
        messages.add(SmsMessage.fromJson(element));
      });
    }
    if (sort) {
      messages.sort((a, b) => a.compareTo(b));
    }
    return messages;
  }

  Future<List<SmsMessage>> getAllSmsMessages(
      {int threadId = -1,
      List<SmsMessageType> types = const [SmsMessageType.HAM]}) async {
    List<SmsMessage> messages = [];
    final db = await database;
    String where = '';

    if (threadId != -1) {
      where = where + KEY_SMS_THREAD_ID + " = ?";
    }

    if (types.isNotEmpty) {
      List<int> ids = [];
      types.forEach((element) {
        ids.add(element.index);
      });
      if (where.length > 1) where += ' AND ';
      where += KEY_SMS_MESSAGE_TYPE + " IN (${ids.join(', ')})";
    }

//    print('Where : ' + );

    var response;
    if (where != null && where.isNotEmpty)
      response = await db.query(TABLE_SMS_MESSAGES_NAME,
          where: where,
          groupBy: KEY_SMS_THREAD_ID,
          orderBy: KEY_SMS_DATE + ' DESC');
    else {
      response = await db.query(TABLE_SMS_MESSAGES_NAME,
          orderBy: KEY_SMS_DATE + ' DESC');
    }
    if (response != null && response.isNotEmpty) {
      response.forEach((element) {
        messages.add(SmsMessage.fromJson(element));
      });
    }
    return messages;
  }

  Future<List<SmsMessage>> getSmsMessagesByThreadId(int threadId,
      {List<SmsMessageType> types = const [
        SmsMessageType.HAM,
        SmsMessageType.SPAM,
        SmsMessageType.UNDECIDABLE
      ]}) async {
    List<SmsMessage> messages = [];
    final db = await database;
    String where = KEY_SMS_THREAD_ID + " = ? ";
    List<dynamic> whereArgs = [threadId];

    if (types.isNotEmpty) {
      List<int> ids = [];
      types.forEach((element) {
        ids.add(element.index);
      });
      if (where.length > 1) where += ' AND ';
      where += KEY_SMS_MESSAGE_TYPE + " IN (${ids.join(', ')})";
    }

    print('Where : $where');

    var response = await db.query(TABLE_SMS_MESSAGES_NAME,
        where: where, whereArgs: whereArgs, orderBy: KEY_SMS_DATE + ' DESC');

    if (response != null && response.isNotEmpty) {
      response.forEach((element) {
        messages.add(SmsMessage.fromJson(element));
      });
    }

    return messages;
  }

  Future<List<SmsMessage>> getSmsMessagesByKind(
      {int threadId = -1,
      List<SmsMessageKind> kinds = const [
        SmsMessageKind.Sent,
        SmsMessageKind.Received,
        SmsMessageKind.Draft
      ]}) async {
    List<SmsMessage> messages = [];
    final db = await database;
    String where = '';

    if (threadId != -1) {
      where = where + KEY_SMS_THREAD_ID + " = ?";
    }

    if (kinds.isNotEmpty) {
      List<int> ids = [];
      kinds.forEach((element) {
        ids.add(element.index);
      });
      if (where.length > 1) where += ' AND ';
      where += KEY_SMS_MESSAGE_KIND + " IN (${ids.join(', ')})";
    }

//    print('Where : ' + );

    var response;
    if (where != null && where.isNotEmpty)
      response = await db.query(TABLE_SMS_MESSAGES_NAME,
          where: where,
          groupBy: KEY_SMS_THREAD_ID,
          orderBy: KEY_SMS_DATE + ' DESC');
    else {
      response = await db.query(TABLE_SMS_MESSAGES_NAME,
          orderBy: KEY_SMS_DATE + ' DESC');
    }
    if (response != null && response.isNotEmpty) {
      response.forEach((element) {
        messages.add(SmsMessage.fromJson(element));
      });
    }
    return messages;
  }

  Future<SmsThread> getThreadById(int threadId) async {
    SmsThread thread = new SmsThread(threadId);
    List<SmsMessage> messages = [];
    final db = await database;
    var response = await db.query(TABLE_SMS_MESSAGES_NAME,
        where: KEY_SMS_THREAD_ID + " = ? ",
        whereArgs: [threadId],
        orderBy: KEY_SMS_DATE + ' DESC');

    if (response != null && response.isNotEmpty) {
      response.forEach((element) {
        messages.add(SmsMessage.fromJson(element));
      });
      thread.messages = messages;
      if (messages != null && messages.length > 0) {
        thread.address = messages[0].address;
      }
    }

    return thread;
  }

  Future<int> getThreadCount() async {
    final db = await database;
    var response = await db.query(TABLE_SMS_MESSAGES_NAME,
        distinct: true, columns: [KEY_SMS_THREAD_ID]);
    return response.length;
  }

  Future<int> getSmsCount() async {
    final db = await database;
    var response = await db
        .query(TABLE_SMS_MESSAGES_NAME, distinct: true, columns: [KEY_SMS_ID]);
    return response.length;
  }

  Future<int> getMaxSmsThreadId() async {
    final db = await database;
    String query =
        'SELECT MAX($KEY_SMS_THREAD_ID) FROM $TABLE_SMS_MESSAGES_NAME';
    var response = await db.rawQuery(query);
    return response.first.values.toList()[0];
  }

  Future<int> getMaxSmsId() async {
    final db = await database;
    String query = 'SELECT MAX($KEY_SMS_ID) FROM $TABLE_SMS_MESSAGES_NAME';
    var response = await db.rawQuery(query);
    return response.first.values.toList()[0];
  }

  Future<List<SmsThread>> getAllThreads(
      {List<SmsMessageType> types: const [SmsMessageType.HAM]}) async {
    List<SmsMessage> messages = await this.getAllSmsMessages(types: types);
    Map<int, List<SmsMessage>> filtered = {};
    messages.forEach((msg) {
      if (!filtered.containsKey(msg.threadId)) {
        filtered[msg.threadId] = [];
      }
      filtered[msg.threadId].add(msg);
    });
    List<SmsThread> threads = <SmsThread>[];
    for (var k in filtered.keys) {
      final thread = new SmsThread.fromMessages(filtered[k]);
      if (thread.address == null) {
        thread.address = filtered[k][0].address;
      }
      threads.add(thread);
    }
    return threads;
  }

  deleteSmsMessage(int threadId, {int id = -1}) async {
    final db = await database;
    String where = KEY_SMS_THREAD_ID + " = ? ";
    List<dynamic> whereArgs = [threadId];
    if (id != -1) {
      where += "AND " + KEY_SMS_ID + " = ? ";
      whereArgs.add(id);
    }
    return db.delete(TABLE_SMS_MESSAGES_NAME,
        where: where, whereArgs: whereArgs);
  }

  Future<int> setMessageRead(int smsId) async {
    final db = await database;
    Map<String, dynamic> map = {};
    map[KEY_SMS_READ] = 1;
    return db.update(TABLE_SMS_MESSAGES_NAME, map,
        where: KEY_SMS_ID + ' = ? ', whereArgs: [smsId]);
  }

  Future<int> setMessageState(int smsId, SmsMessageState state) async {
    final db = await database;
    Map<String, dynamic> map = {};
    map[KEY_SMS_MESSAGE_STATE] = state.index;
    return db.update(TABLE_SMS_MESSAGES_NAME, map,
        where: KEY_SMS_ID + ' = ? ', whereArgs: [smsId]);
  }

  Future<int> setThreadRead(int threadId) async {
    final db = await database;
    Map<String, dynamic> map = {};
    map[KEY_SMS_READ] = 1;
    var response = db.update(TABLE_SMS_MESSAGES_NAME, map,
        where: KEY_SMS_THREAD_ID + ' = ? ', whereArgs: [threadId]);
    return response;
  }
}

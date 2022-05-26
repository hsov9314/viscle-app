import 'package:demo_app/models/training_record.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//DAO(Data Access Object)
//Databaseへアクセスする手続きを行うクラス
class TrainingRecordDao {
  static final String databaseName = "viscle.db";
  static final String tableName = "training_record";
  Future<Database> database;

  //コンストラクタ
  TrainingRecordDao() {
    database = _openDatabaseAsync();
  }

  //データベースを開くか存在しなければ作成する関数
  //コンストラクタをasyncにすることが出来ないみたいなのでメソッド化
  Future<Database> _openDatabaseAsync() async {
    return openDatabase(
      join(await getDatabasesPath(), databaseName),
      version: 1,
    );
  }

  //データベースに記録を追加する関数
  static Future<int> insertTrainingRecord(
      Future<Database> database, TrainingRecord trainingRecord) async {
    final Database db = await database;
    int id = await db.insert("training_record", trainingRecord.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

//  static Future<void> updateTrainingRecord(
//      Future<Database> database, TrainingRecord trainingRecord) async {
//    final Database db = await database;
//    await db.update("training_record", trainingRecord.toMap(),
//        where: "id = ?", whereArgs: [trainingRecord.trainingRecordId]);
//  }

  getAllTrainingRecords() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (index) {
      print(maps[index]["training_record_item"]);
      return TrainingRecord(
          trainingRecordId: maps[index]["training_record_id"],
          trainingItemId: maps[index]["training_record_item"],
          dateMillisecondsSinceEpoch: maps[index]["date"],
          unit: maps[index]["unit"],
          weight: maps[index]["weight"],
          count: maps[index]["count"],
          time: maps[index]["time"]);
    });
  }

//  //データベースから記録のリストを取得する関数
//  static Future<List<TrainingRecord>> getAllTrainingRecords(
//      Future<Database> database) async {
//    final Database db = await database;
//    final List<Map<String, dynamic>> maps = await db.query(tableName);
//    return List.generate(maps.length, (index) {
//      return TrainingRecord(
//          dateMillisecondsSinceEpoch: maps[index]["date"],
//          //trainingName: maps[index]["training_name"],
//          unit: maps[index]["unit"],
//          weight: maps[index]["weight"],
//          count: maps[index]["count"]);
//    });
//  }
//
//  static void deleteTrainingRecord(
//      Future<Database> database, String tableName, int id) async {
//    final db = await database;
//    db.delete(tableName, where: "id = ?", whereArgs: [id]);
//  }
}

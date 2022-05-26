import 'package:demo_app/models/training_item.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TrainingItemDao {
  static final String databaseName = "viscle.db";
  static final String tableName = "training_item";
  Future<Database> database;

  //コンストラクタ
  TrainingItemDao() {
    database = _openDatabaseAsync();
  }

  Future<Database> _openDatabaseAsync() async {
    return openDatabase(
      join(await getDatabasesPath(), databaseName),
      version: 1,
    );
  }

  insertTrainingItem(TrainingItem trainingItem) async {
    final Database db = await database;
    int id = await db.insert(tableName, trainingItem.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  getAllTrainingItems() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (index) {
      return TrainingItem(
        trainingItemId: maps[index]['training_item_id'],
        trainingTypeId: maps[index]['training_type'],
        trainingPartId: maps[index]['training_part'],
        trainingName: maps[index]["training_name"],
        targetRM: maps[index]["target_rm"],
      );
    });
  }

  updateTrainingItem(TrainingItem trainingItem) async {
    final Database db = await database;
    await db.update(tableName, trainingItem.toMap(),
        where: "training_item_id = ?",
        whereArgs: [trainingItem.trainingItemId]);
  }

  deleteTrainingItem(TrainingItem trainingItem) async {
    final Database db = await database;
    var isDeleted = await db.delete(tableName,
        where: "training_item_id = ?",
        whereArgs: [trainingItem.trainingItemId]);
  }
}

import 'package:demo_app/models/training_part.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TrainingPartDao {
  static final String databaseName = "viscle.db";
  static final String tableName = "training_part";
  Future<Database> database;

  //コンストラクタ
  TrainingPartDao() {
    database = _openDatabaseAsync();
  }

  Future<Database> _openDatabaseAsync() async {
    return openDatabase(
      join(await getDatabasesPath(), databaseName),
      version: 1,
    );
  }

  getAllTrainingParts() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (index) {
      return TrainingPart(
          trainingPartId: maps[index]['training_part_id'],
          trainingPartName: maps[index]['training_part_name']);
    });
  }
}

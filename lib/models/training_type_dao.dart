import 'package:demo_app/models/training_type.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TrainingTypeDao {
  static final String databaseName = "viscle.db";
  static final String tableName = "training_type";
  Future<Database> database;

  //コンストラクタ
  TrainingTypeDao() {
    database = _openDatabaseAsync();
  }

  Future<Database> _openDatabaseAsync() async {
    return openDatabase(
      join(await getDatabasesPath(), databaseName),
      version: 1,
    );
  }

  getAllTrainingTypes() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (index) {
      return TrainingType(
          trainingTypeId: maps[index]['training_type_id'],
          trainingTypeName: maps[index]['training_type_name']);
    });
  }
}

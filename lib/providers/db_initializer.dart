import 'package:demo_app/models/training_part.dart';
import 'package:demo_app/models/training_type.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//データベースの初期化を行う関数.
//テーブルの作成や予め登録しておきたいデータの追加を記述している.
void initializeDatabase(String databaseName) async {
  openDatabase(
    join(await getDatabasesPath(), databaseName),
    onCreate: _createDatabase,
    version: 1,
  );
}

Future _createDatabase(Database db, int version) async {
  //training_type(トレーニングの種類)のテーブル作成
  String trainingTypeTableName = "training_type";
  await db.execute(
    '''
    CREATE TABLE IF NOT EXISTS training_type(
    training_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
    training_type_name TEXT UNIQUE
    )
    ''',
  );
  ["有酸素", "無酸素", "その他"].forEach((trainingTypeName) async {
    await db.insert(trainingTypeTableName,
        TrainingType(trainingTypeName: trainingTypeName).toMap());
  });

  //training_part(トレーニングの部位)のテーブル作成
  String trainingPartTableName = "training_part";
  await db.execute(
    '''
    CREATE TABLE IF NOT EXISTS training_part(
    training_part_id INTEGER PRIMARY KEY AUTOINCREMENT, 
    training_part_name TEXT UNIQUE
    )
    ''',
  );
  ["胸", "背中", "脚", "肩", "腕", "腹", "その他"].forEach((trainingPartName) async {
    await db.insert(trainingPartTableName,
        TrainingPart(trainingPartName: trainingPartName).toMap());
  });

  //training_item(トレーニングの項目)のテーブル作成
  await db.execute(
    '''
    CREATE TABLE IF NOT EXISTS training_item(
    training_item_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    training_type INTEGER NOT NULL,
    training_part INTEGER,
    training_name TEXT UNIQUE,
    target_rm REAL CHECK(target_rm > 0),
    last_used_date INTEGER,
    FOREIGN KEY(training_type) REFERENCES training_type(training_type_id),
    FOREIGN KEY(training_part) REFERENCES training_part(training_part_id)
    )
    ''',
  );

  //training_record(トレーニングの記録)のテーブル作成
  await db.execute(
    '''
    CREATE TABLE IF NOT EXISTS training_record(
    training_record_id INTEGER PRIMARY KEY AUTOINCREMENT,
    training_record_item INTEGER,
    date INTEGER,
    unit TEXT CHECK(unit = 'lbs' or unit = 'kg'),
    weight REAL CHECK(weight > 0),
    count INTEGER CHECK(count > 0),
    time INTEGER CHECK(time > 0),
    FOREIGN KEY(training_record_item) REFERENCES training_item(training_item_id) ON DELETE CASCADE
    )
    ''',
  );

  print("初期化終了");
}

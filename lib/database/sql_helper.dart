import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper{
  static Future<void> createTables(sql.Database database) async{
    await database.execute("""
      CREATE TABLE employee(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT,
      email TEXT
      )
    """);
  }

  static Future<void> createTablesAlat(sql.Database database) async{
    await database.execute('''
        CREATE TABLE alat(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          namaAlat TEXT,
          deskripsi TEXT
        )
      ''');
    }

  //     await database.execute('''
  //     CREATE TABLE alat(
  //       id INTEGER PRIMARY KEY AUTOINCREMENT,
  //       namaAlat TEXT,
  //       deskripsi TEXT,
  //       foto TEXT
  //     )
  //   ''');
  // }

  static Future<sql.Database> db() async{
    return sql.openDatabase('employee.db', version: 1,
      onCreate: (sql.Database database, int version)async{
    await createTables(database);
    await createTablesAlat(database);

    });
  }

  static Future<int> addEmployee(String name, String email) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'email': email};
    return await db.insert('employee', data);

  }


  static Future<List<Map<String, dynamic>>> getEmployee() async {
    final db = await SQLHelper.db();
    return db.query('employee');
  }
  

  static Future<int> editEmployee(int id, String name, String email) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'email': email};
    return await db.update('employee', data, where: "id = $id");
  }

  static Future<int> deleteEmployee(int id) async {
    final db = await SQLHelper.db();
    return await db.delete('employee', where: "id = $id");

  }

  static Future<int> addAlat(String name, String deskripsi) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'deskripsi': deskripsi};
    return await db.insert('alat', data);
  }

  static Future<int> editAlat(int id, String name, String deskripsi) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'deskripsi': deskripsi};
    return await db.update('alat', data, where: "id = ?", whereArgs: [id]);
  }

  static Future<void> deleteAlat(int id) async {
    final db = await SQLHelper.db();
    await db.delete('alat', where: "id = ?", whereArgs: [id]);
  }

  // static Future<int> editAlat(int id, String namaAlat, String? foto, String deskripsi) async {
  //   final db = await SQLHelper.db();
  //   final data = {'namaAlat': namaAlat, 'foto': foto, 'deskripsi': deskripsi};
  //   return await db.update('alat', data, where: "id = ?", whereArgs: [id]);
  // }

    static Future<List<Map<String, dynamic>>> getAlat() async {
    final db = await SQLHelper.db();
    return db.query('alat', orderBy: "id");
  }

}
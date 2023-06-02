import 'dart:async';
import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart';

import 'player.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();

  static Database? _db;

  DatabaseHelper._instance();

  String playerTable = "PlayerTable";
  String colId = "id";
  String colName = "name";
  String colStatus = "status";

  Future<Database?> get db async => _db ??= await _initDb();

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'player_list.db';
    final playerListDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return playerListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute("CREATE TABLE $playerTable("
        "$colId  INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$colName TEXT,"
        "$colStatus INTEGER)");
  }

  Future<List<Map<String, dynamic>>?> getPlayerMapList() async {
    Database? db = await this.db;
    final List<Map<String, Object?>>? result = await db?.query(playerTable);
    return result;
  }

  Future<List<Map<String, dynamic>>?> getSelectedPlayerMapList() async {
    Database? db = await this.db;
    final List<Map<String, Object?>>? result = await db?.query(
      playerTable,
      where: 'status = ?',
      whereArgs: [1],
    );
    return result;
  }

  Future<List<Player>> getPlayerList() async {
    final List<Map<String, dynamic>>? playerMapList = await getPlayerMapList();
    final List<Player> playerList = [];
    playerMapList?.forEach((playerMap) {
      playerList.add(Player.fromMap(playerMap));
    });

    return playerList;
  }

  Future<List<Player>> getSelectedPlayerList() async {
    final List<Map<String, dynamic>>? playerMapList =
        await getSelectedPlayerMapList();
    final List<Player> playerList = [];
    playerMapList?.forEach((playerMap) {
      playerList.add(Player.fromMap(playerMap));
    });

    return playerList;
  }

  Future<int?> inserPlayer(Player player) async {
    Database? db = await this.db;
    final int? result = await db?.insert(playerTable, player.toMap());
    return result;
  }

  Future<int?> updatePlayer(Player player) async {
    Database? db = await this.db;
    final int? result = await db?.update(
      playerTable,
      player.toMap(),
      where: "$colId = ?",
      whereArgs: [player.id],
    );
    return result;
  }

  Future<int?> deletePlayer(int? id) async {
    Database? db = await this.db;
    final int? result = await db?.delete(
      playerTable,
      where: "$colId = ?",
      whereArgs: [id],
    );
    return result;
  }
}

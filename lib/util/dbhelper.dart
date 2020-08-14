import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:simulador_rendimento/model/aplicacao.dart';


class DbHelper {
  String tblAplicacao = "aplicacao";
  String colId = "id";
  String colValorMensal = "valorMensal";
  String colValorAcumulado = "valorAcumulado";
  String colValorAtualizado = "valorAtualizado";
  String colPrazo = "prazo";

  DbHelper._internal();
  static final DbHelper _dbHelper = DbHelper._internal();


  factory DbHelper() {
    return _dbHelper;
  }


  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "aplicacao.db";
    var dbAplicacao = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbAplicacao;
  }


  // Método a ser chamado se o banco de dados não existir
  void _createDb (Database db, int newVersion) async {
    await db.execute(
      "CREATE TABLE $tblAplicacao($colId INTEGER PRIMARY KEY, $colValorMensal TEXT, " +
      "$colValorAcumulado TEXT, $colValorAtualizado TEXT, $colPrazo TEXT)"
    );
  }

  // Atributo para a referência do banco de dados
  static Database _db;


  // Getter para o atributo acima
  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }


  // Método para inserir no banco de Dados
  Future<int> insertAplicacao(Aplicacao aplicacao) async {
    Database db = await this.db;
    var result = await db.insert(tblAplicacao, aplicacao.toMap());
    return result;
  }


  // Método para recuperar todos os registros
  Future<List> getAplicacoes() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM $tblAplicacao");
    return result.toList();
  }

  
  // Método para recuperar o número de registro da tabela
  Future<int> getCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
      await db.rawQuery("select count (*) from $tblAplicacao")
    );
    return result;
  }


  // Método para atualizar um registro
  Future<int> updateAplicacao(Aplicacao aplicacao) async {
    var db = await this.db;
    var result = await db.update(tblAplicacao,
        aplicacao.toMap(),
        where: "$colId = ?",
        whereArgs: [aplicacao.id]);
    return result;
  }


  // Método para apagar um registro. Passa o id do registro a ser apagado
  Future<int> deleteAplicacao(int id) async {
    int result;
    var db = await this.db;
    result = await db.rawDelete('DELETE FROM $tblAplicacao WHERE $colId = $id');
    return result;
  }

}
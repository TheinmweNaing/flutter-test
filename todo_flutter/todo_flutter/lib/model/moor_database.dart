import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'moor_database.g.dart';

class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get date => integer().nullable()();

  TextColumn get body => text().nullable()();

  BoolColumn get favourite => boolean().withDefault(Constant(false))();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    print("file path : ${file.path}");
    return VmDatabase(file, logStatements: true);
  });
}

@UseMoor(tables: [Todos])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<Todo> insert(TodosCompanion todo) async {
    final id = await into(todos).insert(todo);
    return findById(id);
  }

  Future updateDeveloper(TodosCompanion todo) {
    return update(todos).replace(todo);
  }

  Future<void> deleteToDo(int id) async {
    await (delete(todos)..where((t) => t.id.equals(id))).go();
  }

  Future<Todo> findById(int id) {
    return (select(todos)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<List<Todo>> findFav() {
    return (select(todos)..where((t) => t.favourite)).get();
  }

  Future<List<Todo>> findDateByAsc() {
    return (select(todos)..orderBy([(t) => OrderingTerm.asc(t.date)])).get();
  }

  Future<List<Todo>> findDateByDesc() {
    return (select(todos)..orderBy([(t) => OrderingTerm.desc(t.date)])).get();
  }

  Stream<List<Todo>> findAll({String name, DateTime dateTime, bool favourite}) {
    final query = select(todos);

    if (name != null && name.isNotEmpty) {
      query.where((t) => t.body.like("%$name%"));
    }

    if (dateTime != null) {
      query.where((t) {
        int lower = new DateTime(
                dateTime.year, dateTime.month, dateTime.day, 0, 0, 0, 0, 0)
            .millisecondsSinceEpoch;
        int higher = new DateTime(
                dateTime.year, dateTime.month, dateTime.day, 23, 59, 59, 0, 0)
            .millisecondsSinceEpoch;

        return t.date.isBetween(Variable(lower), Variable(higher));
      });
    }

    //TODO
    /*if (favourite != null) {
      query.where((t) => t.favourite);
    }*/

    return query.watch();
  }
}

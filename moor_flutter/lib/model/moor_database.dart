import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'moor_database.g.dart';

class Developers extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().nullable()();

  IntColumn get age => integer().nullable()();

  TextColumn get heading => text().nullable()();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    print("file path : ${file.path}");
    return VmDatabase(file, logStatements: true);
  });
}

@UseMoor(tables: [Developers])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  //insert
  Future<Developer> insert(DevelopersCompanion dev) async {
    final id = await into(developers).insert(dev);
    return findById(id);
  }

  //update
  Future updateDeveloper(Developer dev) {
    return update(developers).replace(dev);
  }

  //findById
  Future<Developer> findById(int id) {
    return (select(developers)..where((dev) => dev.id.equals(id))).getSingle();
  }

  //delete
  Future<void> deleteDeveloper(int id) async {
    await (delete(developers)..where((dev) => dev.id.equals(id))).go();
  }

  //findAll
  Stream<List<Developer>> findAll({String name, String heading}) {
    final query = select(developers);
    if (name != null && name.isNotEmpty) {
      query.where((d) => d.name.like("$name%"));
    }

    if (heading != null && heading.isNotEmpty) {
      query.where((d) => d.heading.equals(heading));
    }
    return query.watch();
  }
}

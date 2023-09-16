import 'package:drift/drift.dart';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
// assuming that your file is called filename.dart. This will give an error at
// first, but it's needed for drift to know about the generated code
part 'model.g.dart';

// this will generate a table called "todos" for us. The rows of that table will
// be represented by a class called "Todo".
class Activity extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(Constant(DateTime.now()))();
  DateTimeColumn get time => dateTime().named('time')();
  BoolColumn get status => boolean().withDefault(const Constant(false))();
}

// This will make drift generate a class called "Category" to represent a row in
// this table. By default, "Categorie" would have been used because it only
//strips away the trailing "s" in the table name.

// this annotation tells drift to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@DriftDatabase(tables: [Activity])
class MyDatabase extends _$MyDatabase {
  // we tell the database where to store the data with this constructor
  MyDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition.
  // Migrations are covered later in the documentation.
  @override
  int get schemaVersion => 1;

  Stream<List<ActivityData>> streamTodoList(
      DateTime start, DateTime end) async* {
    // divide data by quarter
    final quarter = (select(activity)
          ..where((tbl) => tbl.time.isBetweenValues(start, end)))
        .watch();
    yield* quarter;
  }

  Future insertTodoList(String title, String description, DateTime time) async {
    await into(activity).insert(ActivityCompanion.insert(
        title: title, description: Value(description), time: time));
  }

  Future deleteTodoList(int id) {
    return (delete(activity)..where((t) => t.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

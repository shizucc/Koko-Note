import 'package:koko_note/database/model.dart';
import 'package:drift/drift.dart';
import 'dart:core';

Future<void> main() async {
  final database = MyDatabase();

  // Simple insert:
  await database.into(database.activity).insert(ActivityCompanion.insert(
      title: 'Membersihkan kost',
      description: const Value("Membersihkan kost dengan rapi"),
      time: DateTime.parse("2023-08-06 09:00:00")));

  // Simple select:
  final allCategories = await database.select(database.activity).get();
  print('Categories in database: $allCategories');
}

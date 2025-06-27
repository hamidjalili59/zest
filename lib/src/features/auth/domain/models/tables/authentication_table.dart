import 'package:drift/drift.dart' show BuildGeneralColumn, BuildIntColumn, BuildTextColumn, DateTimeColumn, IntColumn, Table, TextColumn;

class AuthenticationInfo extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get firstName => text().withLength(min: 2, max: 32)();

  TextColumn get lastName => text().withLength(min: 2, max: 32)();

  DateTimeColumn get createdAt => dateTime().nullable()();

  DateTimeColumn get updatedAt => dateTime().nullable()();
}

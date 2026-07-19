import 'package:isar_community/isar.dart';

// Generated with build_runner. Keep this part file so Isar can create helpers.
part 'note.g.dart';

@Collection()
class Note {
  Id id = Isar.autoIncrement;
  late String title;
  late String content;
  DateTime? updatedAt;
}

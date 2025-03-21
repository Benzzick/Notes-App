import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/models/note.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> getDatabase() async {
  final dbDir = await syspaths.getApplicationDocumentsDirectory();
  final dbPath = path.join(dbDir.path, 'notes.db');

  return sql.openDatabase(
    dbPath,
    version: 1,
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE notes_list (id TEXT PRIMARY KEY, title TEXT, snippet TEXT, date INTEGER)',
      );
    },
  );
}

// class Zed {
//   // Zed();
//   Zed._();
//   Zed.camp();
//   static final instance = Zed._();
// }

class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier() : super([]);

  Future<void> loadData() async {
    try {
      final db = await getDatabase();
      final table = await db.query('notes_list');

      final notes = table
          .map(
            (row) => Note(
              id: row['id'] as String,
              title: row['title'] as String,
              snippet: row['snippet'] as String,
              date: DateTime.fromMillisecondsSinceEpoch(row['date'] as int),
            ),
          )
          .toList();

      state = notes.reversed.toList();
    } catch (e) {
      state = [];
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      final db = await getDatabase();
      await db.delete(
        'notes_list',
        where: 'id = ?',
        whereArgs: [noteId],
      );

      state = state.where((note) => note.id != noteId).toList();
    } catch (e) {
      // Handle error (optional)
    }
  }

  Future<void> updateNote(Note updatedNote) async {
    try {
      final db = await getDatabase();

      final updatedRows = await db.update(
        'notes_list',
        {
          'title': updatedNote.title.trim(),
          'snippet': updatedNote.snippet.trim(),
          'date': updatedNote.date.millisecondsSinceEpoch,
        },
        where: 'id = ?',
        whereArgs: [updatedNote.id],
      );

      if (updatedRows > 0) {
        state = [
          for (final note in state)
            if (note.id == updatedNote.id) updatedNote else note,
        ];
      } else {
        throw Exception(
            'No rows updated. Note with id ${updatedNote.id} may not exist.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addNewNote(Note note) async {
    try {
      final db = await getDatabase();
      await db.insert(
        'notes_list',
        {
          'id': note.id,
          'title': note.title,
          'snippet': note.snippet,
          'date': note.date.millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      state = [note, ...state];
    } catch (e) {
      state = [...state];
    }
  }
}

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>((ref) {
  return NotesNotifier();
});

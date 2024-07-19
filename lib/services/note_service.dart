import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';

class NoteService {
  static const String _notesKey = 'notes';
  final Uuid _uuid = Uuid();

  Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesString = prefs.getString(_notesKey);
    if (notesString == null) {
      return [];
    }
    final List<dynamic> notesJson = jsonDecode(notesString);
    return notesJson.map((json) => Note.fromJson(json)).toList();
  }

  Future<void> addNote(String title, String body) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = await getNotes();
    final newNote = Note(
      id: _uuid.v4(),
      title: title,
      body: body,
    );
    notes.add(newNote);
    final notesString = jsonEncode(notes);
    await prefs.setString(_notesKey, notesString);
  }

  Future<void> updateNote(Note updatedNote) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = await getNotes();
    final index = notes.indexWhere((note) => note.id == updatedNote.id);
    if (index != -1) {
      notes[index] = updatedNote;
      final notesString = jsonEncode(notes);
      await prefs.setString(_notesKey, notesString);
    }
  }

  Future<void> deleteNote(Note note) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = await getNotes();
    notes.removeWhere((existingNote) => existingNote.id == note.id);
    final notesString = jsonEncode(notes);
    await prefs.setString(_notesKey, notesString);
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/note.dart';
import '../services/note_service.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final NoteService _noteService = NoteService();
  late Future<List<Note>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _notesFuture = _noteService.getNotes();
  }

  Future<void> _refreshNotes() async {
    setState(() {
      _notesFuture = _noteService.getNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<Note>>(
        future: _notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child:  Text('NOtes is empty'));
          } else {
            final notes = snapshot.data!;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(note.title),
                    onTap: () async {
                      final result = await GoRouter.of(context)
                          .push('/note_detail', extra: note);
                      if (result == true) {
                        _refreshNotes();
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await GoRouter.of(context).push('/note_detail');
          if (result == true) {
            _refreshNotes();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

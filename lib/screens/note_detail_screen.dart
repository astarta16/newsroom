import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/note_service.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note? note;

  const NoteDetailScreen({Key? key, this.note}) : super(key: key);

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final NoteService _noteService = NoteService();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _bodyController.text = widget.note!.body;
    }
  }

  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final body = _bodyController.text;
      if (widget.note == null) {
        await _noteService.addNote(title, body);
      } else {
        final updatedNote = Note(
          id: widget.note!.id,
          title: title,
          body: body,
        );
        await _noteService.updateNote(updatedNote);
      }
      Navigator.pop(context, true);
    }
  }

  Future<void> _deleteNote() async {
    if (widget.note != null) {
      await _noteService.deleteNote(widget.note!);
      Navigator.pop(context, true); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'ახალი ჩანაწერი' : 'ჩანაწერის რედაქტირება'),
        actions: [
          if (widget.note != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteNote,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'სათაური'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'გთხოვთ შეიყვანოთ სათაური';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(labelText: 'ტექსტი'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'გთხოვთ შეიყვანოთ ტექსტი';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveNote,
                child: const Text('შენახვა'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

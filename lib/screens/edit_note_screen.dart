import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/provider/notes.dart';

class EditNoteScreen extends ConsumerStatefulWidget {
  const EditNoteScreen({super.key, required this.note});
  final Note note;

  @override
  ConsumerState<EditNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends ConsumerState<EditNoteScreen> {
  late TextEditingController titleController;
  late TextEditingController snippetController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    snippetController = TextEditingController(text: widget.note.snippet);
  }

  @override
  void dispose() {
    titleController.dispose();
    snippetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Container(
          height: 7,
          width: 50,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(30)),
        ),
        Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Title'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: snippetController,
                maxLines: 2,
                decoration:
                    const InputDecoration(hintText: 'Snippet (Optional)'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  if (titleController.text.trim().length < 3) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          title: Text('No Title Added'),
                        );
                      },
                    );
                    return;
                  }

                  try {
                    final updatedNote = Note(
                      id: widget.note.id,
                      title: titleController.text.trim(),
                      snippet: snippetController.text.trim(),
                      date: DateTime.now(), // Update date to current if needed
                    );

                    await ref
                        .read(notesProvider.notifier)
                        .updateNote(updatedNote);

                    Navigator.pop(context);
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: Text('Failed to update note: $e'),
                        );
                      },
                    );
                  }
                },
                label: const Text('Save Note'),
                icon: const Icon(Icons.save),
              ),
            ],
          ),
        )
      ],
    );
  }
}

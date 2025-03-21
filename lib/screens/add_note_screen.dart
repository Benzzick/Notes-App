import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/provider/notes.dart';

class AddNoteScreen extends ConsumerStatefulWidget {
  const AddNoteScreen({super.key});

  @override
  ConsumerState<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends ConsumerState<AddNoteScreen> {
  final titleController = TextEditingController();
  final snippetController = TextEditingController();

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
                onPressed: () {
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
                  ref.read(notesProvider.notifier).addNewNote(Note(
                      title: titleController.text,
                      snippet: snippetController.text,
                      date: DateTime.now()));
                  Navigator.pop(context);
                },
                label: const Text('Save Note'),
                icon: const Icon(Icons.save),
              )
            ],
          ),
        )
      ],
    );
  }
}

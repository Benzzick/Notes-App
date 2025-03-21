import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/provider/notes.dart';
import 'package:notes_app/screens/add_note_screen.dart';
import 'package:notes_app/widgets/note_tile.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<void> loadNotes;

  @override
  void initState() {
    super.initState();
    loadNotes = ref.read(notesProvider.notifier).loadData();
  }

  void addNewNote() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const AddNoteScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final notesList = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            onPressed: addNewNote,
            icon: const Icon(Icons.add),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: FutureBuilder(
        future: loadNotes,
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const CircularProgressIndicator()
              : notesList.isEmpty
                  ? Center(
                      child: Text(
                        'No Note Added Yet!',
                        style: TextStyle(
                            fontSize: 30,
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                    )
                  : ListView.builder(
                      itemCount: notesList.length,
                      itemBuilder: (context, index) {
                        return NoteTile(
                          note: notesList[index],
                        );
                      },
                    );
        },
      ),
    );
  }
}

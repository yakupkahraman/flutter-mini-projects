import '/components/my_button.dart';
import '/components/note_tile.dart';
import '/models/note.dart';
import '/services/note_service.dart';
import '/pages/settings_page.dart';
import '/pages/edit_page.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note>? _searchResults;

  @override
  void initState() {
    super.initState();
    readNotes();
  }

  void readNotes() {
    context.read<NoteService>().fetchNotes();
  }

  Future<void> searchNotes(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = null;
      });
    } else {
      final results = await context.read<NoteService>().searchNotes(query);
      setState(() {
        _searchResults = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteService = context.watch<NoteService>();
    List<Note> currentNotes = noteService.currentNotes;

    currentNotes.sort(
      (a, b) =>
          (b.updatedAt ?? DateTime(0)).compareTo(a.updatedAt ?? DateTime(0)),
    );

    List<Note> displayNotes = _searchResults ?? currentNotes;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _buildFloatingActionButton(context),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          _buildSearchContainer(context),
          _buildNoteList(displayNotes, noteService),
        ],
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditPage()),
        ).then((_) {
          setState(() {
            _searchResults = null;
          });
        });
      },
      child: const Icon(HugeIcons.strokeRoundedAdd01),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      snap: true,
      floating: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      expandedHeight: 150.0,
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 2,
        titlePadding: const EdgeInsets.only(left: 25.0, bottom: 10.0),
        centerTitle: false,
        title: Text(
          "Notes",
          style: TextStyle(
            fontFamily: "MadimiOne",
            fontSize: 34,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: MyButton(
            icon: Icon(HugeIcons.strokeRoundedSettings03),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchContainer(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
        child: _buildSearchTextField(context),
      ),
    );
  }

  TextField _buildSearchTextField(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 5),
        hintText: 'Search notes...',
        prefixIcon: Icon(Icons.search),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      onChanged: searchNotes,
      onSubmitted: (value) {
        setState(() {
          _searchResults = null;
        });
      },
    );
  }

  Widget _buildNoteList(List<Note> displayNotes, NoteService noteService) {
    if (_searchResults != null && _searchResults!.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Note not found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
        ),
      );
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final note = displayNotes[index];
          return NoteTile(
            note: note,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditPage(note: note)),
              ).then((_) {
                setState(() {
                  _searchResults = null;
                });
              });
            },
            onSlidableTap: () {
              noteService.deleteNote(note.id);
            },
          );
        }, childCount: displayNotes.length),
      );
    }
  }
}

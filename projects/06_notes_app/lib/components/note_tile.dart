import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/models/note.dart';
import '/services/note_service.dart';
import 'package:provider/provider.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onSlidableTap;

  const NoteTile({
    super.key,
    required this.note,
    required this.onTap,
    required this.onSlidableTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 25, right: 25),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Dismissible(
          key: Key(note.id.toString()),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) => _handleDismissed(context),
          background: _buildDismissibleBackground(),
          child: _buildListTile(context),
        ),
      ),
    );
  }

  void _handleDismissed(BuildContext context) {
    onSlidableTap();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Note deleted'),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.blue,
          onPressed: () {
            context.read<NoteService>().addNoteWithId(
              note.id,
              note.title,
              note.content,
              note.updatedAt ?? DateTime.now(),
            );
          },
        ),
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  Widget _buildDismissibleBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.red,
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  Widget _buildListTile(BuildContext context) {
    final formattedDate = DateFormat(
      'MMMd',
    ).format(note.updatedAt ?? DateTime.now());

    return Material(
      color: Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        title: Text(
          note.title.isNotEmpty ? note.title : 'No Title',
          maxLines: 1,
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        isThreeLine: true,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.content.isNotEmpty ? note.content : 'No Content',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              formattedDate,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class StudyList extends StatelessWidget {
  final Map<String, double> studyData;
  final Function(String) onDeleteEntry;
  final Function(String, double) onRestoreEntry;

  const StudyList({
    super.key,
    required this.studyData,
    required this.onDeleteEntry,
    required this.onRestoreEntry,
  });

  @override
  Widget build(BuildContext context) {
    final sortedEntries = studyData.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    return Expanded(
      child: ListView.builder(
        itemCount: sortedEntries.length,
        itemBuilder: (context, index) {
          final entry = sortedEntries[index];
          final dateParts = entry.key.split('-');
          final date = DateTime(
            int.parse(dateParts[0]),
            int.parse(dateParts[1]),
            int.parse(dateParts[2]),
          );

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              leading: const Icon(Icons.schedule),
              title: Text(
                '${date.day}/${date.month}/${date.year}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${entry.value} hours studied'),
              trailing: IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final deletedKey = entry.key;
                  final deletedValue = entry.value;

                  onDeleteEntry(deletedKey);

                  scaffoldMessenger.clearSnackBars();
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        '$deletedValue-hour entry deleted',
                        style: const TextStyle(color: Colors.white),
                      ),
                      duration: const Duration(seconds: 5),
                      action: SnackBarAction(
                        label: 'Undo',
                        textColor: Colors.white,
                        onPressed: () {
                          onRestoreEntry(deletedKey, deletedValue);
                        },
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/study_chart.dart';
import '../components/study_list.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
} 

class _HomePageState extends State<HomePage> {
  Map<String, double> studyData = {};
  int currentWeekIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadStudyData();
  }

  Future<void> _loadStudyData() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('study_data') ?? '{}';
    setState(() {
      studyData = Map<String, double>.from(json.decode(dataString));
    });
  }

  Future<void> _saveStudyData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('study_data', json.encode(studyData));
  }

  void _showAddStudyDialog() {
    final hoursController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.grey[850],
          title: const Text('Add Daily Study Hours'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: hoursController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),

                decoration: const InputDecoration(
                  labelText: 'Hours',
                  hintText: 'e.g. 2.5',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Date: '),
                  TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setDialogState(() {
                          selectedDate = date;
                        });
                      }
                    },
                    child: Text(
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final hours = double.tryParse(hoursController.text);
                if (hours != null && hours > 0) {
                  final dateKey =
                      '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
                  setState(() {
                    studyData[dateKey] = hours;
                  });
                  _saveStudyData();
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _onPreviousWeek() {
    setState(() {
      currentWeekIndex++;
    });
  }

  void _onNextWeek() {
    if (currentWeekIndex > 0) {
      setState(() {
        currentWeekIndex--;
      });
    }
  }

  void _onDeleteEntry(String dateKey) {
    setState(() {
      studyData.remove(dateKey);
    });
    _saveStudyData();
  }

  void _onRestoreEntry(String dateKey, double hours) {
    setState(() {
      studyData[dateKey] = hours;
    });
    _saveStudyData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Study Tracker',
          style: GoogleFonts.cherryBombOne(fontSize: 34),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: StudyChart(
              studyData: studyData,
              currentWeekIndex: currentWeekIndex,
              onPreviousWeek: _onPreviousWeek,
              onNextWeek: currentWeekIndex > 0 ? _onNextWeek : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Study History',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          StudyList(
            studyData: studyData,
            onDeleteEntry: _onDeleteEntry,
            onRestoreEntry: _onRestoreEntry,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddStudyDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

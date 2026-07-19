import '/components/my_button.dart';
import '/models/note.dart';
import '/services/note_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:hugeicons/hugeicons.dart';

class EditPage extends StatefulWidget {
  final Note? note;
  const EditPage({super.key, this.note});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  FocusNode contentFocusNode = FocusNode();
  int contentLength = 0;
  int wordCount = 0;

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
      contentLength = contentController.text.length;
      wordCount = _calculateWordCount(contentController.text);
    }
  }

  int _calculateWordCount(String text) {
    if (text.isEmpty) {
      return 0;
    }
    return text.trim().split(RegExp(r'\s+')).length;
  }

  Future<void> createNote() async {
    final title =
        titleController.text.isNotEmpty ? titleController.text : 'No Title';
    final content =
        contentController.text.isNotEmpty
            ? contentController.text
            : 'No Content';

    // Save a new note.
    await context.read<NoteService>().addNote(title, content);
  }

  Future<void> updateNote() async {
    final title =
        titleController.text.isNotEmpty ? titleController.text : 'No Title';
    final content =
        contentController.text.isNotEmpty
            ? contentController.text
            : 'No Content';
    final id = widget.note!.id;

    // Save the edited note.
    await context.read<NoteService>().updateNote(id, title, content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFloatingActionButton(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: MyButton(
            icon: Icon(HugeIcons.strokeRoundedArrowLeft01, size: 30),
            onPressed: () {
              _clearTextControllers();
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(contentFocusNode);
        },
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 36),
                      _buildTitleTextField(),
                      _buildNoteInfoRow(),
                      _buildContentTextField(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        if (widget.note == null) {
          if (titleController.text.isNotEmpty ||
              contentController.text.isNotEmpty) {
            await createNote();
          }
        } else if (titleController.text != widget.note!.title ||
            contentController.text != widget.note!.content) {
          await updateNote();
        }

        _clearTextControllers();
        if (!mounted) return;
        Navigator.pop(context);
      },
      child: Icon(HugeIcons.strokeRoundedTick02),
    );
  }

  void _clearTextControllers() {
    titleController.clear();
    contentController.clear();
  }

  TextField _buildTitleTextField() {
    return TextField(
      controller: titleController,
      style: TextStyle(
        color: Theme.of(context).colorScheme.inversePrimary,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Title',
        hintStyle: TextStyle(color: Colors.grey, fontSize: 30),
      ),
    );
  }

  Row _buildNoteInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          widget.note != null
              ? DateFormat(
                'd MMM HH:mm',
              ).format(widget.note!.updatedAt ?? DateTime.now())
              : DateFormat('d MMM HH:mm').format(DateTime.now()),
          style: TextStyle(color: Colors.grey),
        ),
        VerticalDivider(color: Colors.grey, thickness: 1, width: 25),
        Text('$contentLength characters', style: TextStyle(color: Colors.grey)),
        VerticalDivider(color: Colors.grey, thickness: 1, width: 25),
        Text('$wordCount words', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  TextField _buildContentTextField() {
    return TextField(
      focusNode: contentFocusNode,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      controller: contentController,
      style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Type something here...',
        hintStyle: TextStyle(color: Colors.grey),
      ),
      onChanged: (text) {
        setState(() {
          contentLength = text.length;
          wordCount = _calculateWordCount(text);
        });
      },
    );
  }
}

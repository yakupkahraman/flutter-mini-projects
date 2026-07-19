import 'package:flutter/material.dart';
import '../models/question.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Question> questions = [
    Question(
      question: "Which language does Flutter use?",
      options: ["Java", "Dart", "Kotlin", "Swift"],
      correctAnswer: "Dart",
    ),
    Question(
      question: "What is a widget?",
      options: ["Function", "UI component", "Database", "Package"],
      correctAnswer: "UI component",
    ),
    Question(
      question: "What does state represent in Flutter?",
      options: ["UI color", "Data state", "Route", "Theme"],
      correctAnswer: "Data state",
    ),
  ];

  int currentQuestionIndex = 0;
  int score = 0;
  String? selectedAnswer;

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];
    final isLastQuestion = currentQuestionIndex == questions.length - 1;

    return Scaffold(
      appBar: AppBar(title: const Text("Quiz App"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question ${currentQuestionIndex + 1} / ${questions.length}",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Text(
              question.question,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            RadioGroup<String>(
              groupValue: selectedAnswer,
              onChanged: (value) {
                setState(() {
                  selectedAnswer = value;
                });
              },
              child: Column(
                children: question.options.map((option) {
                  return RadioListTile<String>(
                    title: Text(option),
                    value: option,
                  );
                }).toList(),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedAnswer == null
                    ? null
                    : () {
                        final isCorrect =
                            selectedAnswer == question.correctAnswer;

                        setState(() {
                          if (isCorrect) score++;
                          if (!isLastQuestion) {
                            currentQuestionIndex++;
                            selectedAnswer = null;
                          }
                        });

                        if (isLastQuestion) {
                          showResultDialog();
                        }
                      },
                child: Text(isLastQuestion ? "Finish" : "Next"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text("Quiz Finished 🎉"),
          content: Text("Your score: $score / ${questions.length}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  currentQuestionIndex = 0;
                  score = 0;
                  selectedAnswer = null;
                });
              },
              child: const Text("Restart"),
            ),
          ],
        );
      },
    );
  }
}

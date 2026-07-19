import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> board = List.filled(9, "");
  String currentPlayer = "X";
  String winner = "";
  final Color _backColor = Colors.deepOrangeAccent;
  bool _isGameOverDialogVisible = false;

  void _showGameOverDialog() {
    if (_isGameOverDialogVisible || winner.isEmpty) {
      return;
    }

    _isGameOverDialogVisible = true;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text(winner),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  board = List.filled(9, "");
                  currentPlayer = "X";
                  winner = "";
                  _isGameOverDialogVisible = false;
                });
              },
              child: const Text('Restart'),
            ),
          ],
        );
      },
    ).then((_) {
      _isGameOverDialogVisible = false;
    });
  }

  void _handleTap(int index) {
    if (board[index] != "" || winner != "") {
      return;
    }
    setState(() {
      board[index] = currentPlayer;
      if (_checkWinner()) {
        winner = "$currentPlayer won!";
      } else if (!board.contains("")) {
        winner = "It's a draw!";
      } else {
        currentPlayer = currentPlayer == "X" ? "O" : "X";
      }
    });

    if (winner.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showGameOverDialog();
        }
      });
    }
  }

  bool _checkWinner() {
    const winningCombos = [
      [0, 1, 2], // Top row
      [3, 4, 5], // Middle row
      [6, 7, 8], // Bottom row
      [0, 3, 6], // Left column
      [1, 4, 7], // Middle column
      [2, 5, 8], // Right column
      [0, 4, 8], // Crosswise
      [2, 4, 6], // Crosswise
    ];

    for (var combo in winningCombos) {
      if (board[combo[0]] == currentPlayer &&
          board[combo[1]] == currentPlayer &&
          board[combo[2]] == currentPlayer) {
        return true;
      }
    }
    return false;
  }

  void _resetGame() {
    setState(() {
      board = List.filled(9, "");
      currentPlayer = "X";
      winner = "";
      _isGameOverDialogVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'XoX',
          style: TextStyle(
            fontFamily: 'MoiraiOne',
            fontWeight: FontWeight.w900,
            fontSize: 30,
            color: const Color.fromARGB(255, 187, 220, 247),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 80.0,
              ),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                ),
                itemCount: 9,
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () => _handleTap(index),
                      child: Card(
                        color: _backColor,
                        child: Center(
                          child: Text(
                            board[index],
                            style: const TextStyle(
                                fontFamily: 'MoiraiOne',
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ));
                },
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(_backColor)),
                onPressed: _resetGame,
                child: Text(
                  'Restart',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../components/dialog_component.dart';

class SinglePLayerPlayGameScreen extends StatefulWidget {
  final bool isSoundAllow;
  final int difficultyLevel;
  SinglePLayerPlayGameScreen(
      {super.key, required this.isSoundAllow, required this.difficultyLevel});

  @override
  State<SinglePLayerPlayGameScreen> createState() =>
      _SinglePLayerPlayGameScreenState();
}

class _SinglePLayerPlayGameScreenState
    extends State<SinglePLayerPlayGameScreen> {
  List<String> displayXO = ["", "", "", "", "", "", "", "", ""];
  List<int> indexList = [];
  bool xTurn = true; // Player's turn
  String winner = "";
  int xCount = 0;
  int oCount = 0;
  bool freezeGame = false;
  List<int> winnerPattern = [];
  final _audioPlayer = AudioPlayer();
  bool isDelayed = false;
  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(milliseconds: 1000));

  @override
  void dispose() {
    _audioPlayer.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Scoreboard
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text("Player X",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.white)),
                        const SizedBox(height: 10),
                        Text("$xCount",
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(color: Colors.white)),
                      ],
                    ),
                    Column(
                      children: [
                        Text("Computer O",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.white)),
                        const SizedBox(height: 10),
                        Text("$oCount",
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
              // Game Board
              Expanded(
                flex: 3,
                child: AbsorbPointer(
                  absorbing: freezeGame || isDelayed,
                  child: GridView.builder(
                    itemCount: displayXO.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _playerMove(index),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                width: 5,
                                color: Theme.of(context).primaryColor),
                            color: winnerPattern.contains(index)
                                ? Theme.of(context).primaryColorDark
                                : Theme.of(context).primaryColorLight,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            displayXO[index],
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Reset Button
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    freezeGame
                        ? const SizedBox()
                        : Text(
                            xTurn ? "Player X turn" : "Computer thinking..",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.white),
                          ),
                    const SizedBox(height: 10),
                    freezeGame
                        ? ElevatedButton(
                            onPressed: _clearBoard,
                            child: const Text("Play Again!"),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Handle Player's Move
  void _playerMove(int index) async {
    if (!indexList.contains(index)) {
      if (widget.isSoundAllow) {
        _audioPlayer.stop();
        await _audioPlayer.play(AssetSource('audios/write.mp3'));
      }
      setState(() {
        displayXO[index] = "X";
        indexList.add(index);
        if (indexList.length >= 5) _checkWinner();
        xTurn = false;
        if (!freezeGame) _computerMove();
      });
    }
  }

  /// Computer's Move using Minimax
  void _computerMove() async {
    if (freezeGame || indexList.length == 9) return;

    await Future.delayed(const Duration(seconds: 2), () async {
      if (widget.isSoundAllow) {
        _audioPlayer.stop();
        await _audioPlayer.play(AssetSource('audios/write.mp3'));
      }
      int bestMove;
      /// *** For Easy Mode *** ///
      if (widget.difficultyLevel == 0) {
        if (Random().nextBool()) {
          // 50% chance for random move
          bestMove = _findRandomMove();
        } else {
          // 50% chance for strategic move
          bestMove = _findStrategicMove();
        }
        /// *** For Medium Mode *** ///
      } else if (widget.difficultyLevel == 1) {
        if (Random().nextInt(100) < 80) {
          // 80% chance for strategic move
          bestMove = _findStrategicMove();

        } else {
          // 20% chance for random move
          bestMove = _findRandomMove();
        }
        /// *** For Hard Mode *** ///
      } else {
        bestMove = _findBestMove();
      }

      setState(() {
        displayXO[bestMove] = "O";
        indexList.add(bestMove);
        xTurn = true;
        if (indexList.length >= 5) _checkWinner();
      });
    });
  }

  /// Find a Random Move
  int _findRandomMove() {
    List<int> availableMoves = [];
    for (int i = 0; i < displayXO.length; i++) {
      if (displayXO[i] == "") {
        availableMoves.add(i);
      }
    }
    return availableMoves[Random().nextInt(availableMoves.length)];
  }

  /// Find a Strategic Move
  int _findStrategicMove() {
    // Try to win or block opponent
    for (int i = 0; i < displayXO.length; i++) {
      if (displayXO[i] == "") {
        displayXO[i] = "O";
        if (_evaluateBoard() == "O") {
          displayXO[i] = "";
          return i;
        }
        displayXO[i] = "X";
        if (_evaluateBoard() == "X") {
          displayXO[i] = "";
          return i;
        }
        displayXO[i] = "";
      }
    }
    // Otherwise, return random move
    return _findRandomMove();
  }

  /// Find Best Move (Minimax)
  int _findBestMove() {
    int bestScore = -1000;
    int bestMove = -1;

    for (int i = 0; i < displayXO.length; i++) {
      if (displayXO[i] == "") {
        displayXO[i] = "O";
        int score = _minimax(false);
        displayXO[i] = "";
        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }
    return bestMove;
  }

  /// Minimax Algorithm
  int _minimax(bool isMaximizing) {
    String result = _evaluateBoard();
    if (result == "O") return 10;
    if (result == "X") return -10;
    if (!displayXO.contains("")) return 0;

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < displayXO.length; i++) {
        if (displayXO[i] == "") {
          displayXO[i] = "O";
          int score = _minimax(false);
          displayXO[i] = "";
          bestScore = max(bestScore, score);
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < displayXO.length; i++) {
        if (displayXO[i] == "") {
          displayXO[i] = "X";
          int score = _minimax(true);
          displayXO[i] = "";
          bestScore = min(bestScore, score);
        }
      }
      return bestScore;
    }
  }

  /// Evaluate Board for Minimax
  String _evaluateBoard() {
    const winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var pattern in winPatterns) {
      if (displayXO[pattern[0]] != "" &&
          displayXO[pattern[0]] == displayXO[pattern[1]] &&
          displayXO[pattern[1]] == displayXO[pattern[2]]) {
        return displayXO[pattern[0]];
      }
    }
    return "";
  }

  /// Check Winner
  void _checkWinner() {
    winner = _evaluateBoard();
    if (winner != "") {
      freezeGame = true;
      _updateWinnerResult(winner);
    } else if (!displayXO.contains("")) {
      freezeGame = true;
      winner = "Draw";
      showResult();
    }
  }

  /// Update Scores
  void _updateWinnerResult(String winner) async {
    _confettiController.play();
    if (widget.isSoundAllow) {
      _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audios/winner.mp3'));
    }
    if (winner == "X") xCount++;
    if (winner == "O") oCount++;
    showResult();
  }

  /// Clear Board
  void _clearBoard() {
    setState(() {
      displayXO = ["", "", "", "", "", "", "", "", ""];
      indexList = [];
      winnerPattern = [];
      winner = "";
      freezeGame = false;
      xTurn = true;
    });
  }

  /// Show Result Dialog
  void showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ConfettiWidget(
          confettiController: _confettiController,
          emissionFrequency: 0.6,
          blastDirectionality: BlastDirectionality.explosive,
          child: CustomDialogBox(
            title: winner == "Draw" ? winner : "Winner",
            descriptions: winner == "Draw"
                ? "Nobody Wins!"
                : winner == "X"
                    ? "Player X has won!"
                    : "Computer O has won!",
            text: "Okay",
            didwin: winner != "Draw",
          ),
        );
      },
    );
  }
}

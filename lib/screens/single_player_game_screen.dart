import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe_game/constant/app_strings.dart';
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
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title:  const Text(AppStrings.quitGameText),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text(AppStrings.yes),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text(AppStrings.no),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: Scaffold(
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
                          Text(AppStrings.playerX,
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
                          Text(AppStrings.computer,
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
                              xTurn ? "${AppStrings.playerX} ${AppStrings.turn}" : AppStrings.computerThinking,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                      const SizedBox(height: 10),
                      freezeGame
                          ? ElevatedButton(
                              onPressed: _clearBoard,
                              child: const Text(AppStrings.playAgain),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
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
        await _audioPlayer.play(AssetSource(AppStrings.writeAudioPath));
      }
      setState(() {
        displayXO[index] = AppStrings.x;
        indexList.add(index);
        if (indexList.length >= 5) _checkWinner();
        xTurn = false;
        isDelayed=true;
        if (!freezeGame) _computerMove();
      });
    }
  }

  /// Computer's Move using Minimax
  void _computerMove() async {
    if (freezeGame || indexList.length == 9) return;

    await Future.delayed(const Duration(milliseconds: 1000), () async {
      if (widget.isSoundAllow) {
        _audioPlayer.stop();
        await _audioPlayer.play(AssetSource(AppStrings.writeAudioPath));
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
        displayXO[bestMove] = AppStrings.o;
        indexList.add(bestMove);
        xTurn = true;
        isDelayed=false;
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
        displayXO[i] = AppStrings.o;
        if (_evaluateBoard() == AppStrings.o) {
          displayXO[i] = "";
          return i;
        }
        displayXO[i] = AppStrings.x;
        if (_evaluateBoard() == AppStrings.x) {
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
        displayXO[i] = AppStrings.o;
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
    if (result == AppStrings.o) return 10;
    if (result == AppStrings.x) return -10;
    if (!displayXO.contains("")) return 0;

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < displayXO.length; i++) {
        if (displayXO[i] == "") {
          displayXO[i] = AppStrings.o;
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
          displayXO[i] = AppStrings.x;
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
  //
  // /// Check Winner
  // void _checkWinner() async{
  //   winner = _evaluateBoard();
  //   if (winner != "") {
  //     freezeGame = true;
  //     _updateWinnerResult(winner);
  //   } else if (!displayXO.contains("")) {
  //     freezeGame = true;
  //     winner = AppStrings.draw;
  //     if(widget.isSoundAllow){
  //       /// Here we are Playing draw sound effect and stopping  previous sounds
  //       _audioPlayer.stop();
  //       await _audioPlayer.play(AssetSource(AppStrings.drawAudioPath));
  //     }
  //     showResult();
  //
  //   }
  // }
  /// ***** Check Winner Function ******* ///
  void _checkWinner() async {
    /// Here we are checking the first Row for winner
    if (displayXO[0] == displayXO[1] &&
        displayXO[1] == displayXO[2] &&
        displayXO[0] != "") {
      winner = displayXO[0];

      /// Calling _updateWinnerResult for Win Count Increment
      _updateWinnerResult(winner);

      /// Here we are creating  pattern by adding all index's of the match winner
      winnerPattern.addAll([0, 1, 2]);
      /// Here we are freezing the game as soon as anyOne wins
      freezeGame = true;

      /// Here we are checking the Second Row for winner
    } else if (displayXO[3] == displayXO[4] &&
        displayXO[4] == displayXO[5] &&
        displayXO[3] != "") {
      winner = displayXO[3];

      /// Calling _updateWinnerResult for Win Count Increment
      _updateWinnerResult(winner);

      /// Here we are creating  pattern by adding all index's of the match winner
      winnerPattern.addAll([3, 4, 5]);
      /// Here we are freezing the game as soon as anyOne wins
      freezeGame = true;

      /// Here we are checking the Third Row for winner
    } else if (displayXO[6] == displayXO[7] &&
        displayXO[7] == displayXO[8] &&
        displayXO[6] != "") {
      winner = displayXO[6];

      /// Calling _updateWinnerResult for Win Count Increment
      _updateWinnerResult(winner);

      /// Here we are creating  pattern by adding all index's of the match winner
      winnerPattern.addAll([6, 7, 8]);
      /// Here we are freezing the game as soon as anyOne wins
      freezeGame = true;

      /// Here we are checking the First Column for winner
    } else if (displayXO[0] == displayXO[3] &&
        displayXO[3] == displayXO[6] &&
        displayXO[0] != "") {
      winner = displayXO[0];

      /// Calling _updateWinnerResult for Win Count Increment
      _updateWinnerResult(winner);

      /// Here we are creating  pattern by adding all index's of the match winner
      winnerPattern.addAll([0, 3, 6]);
      /// Here we are freezing the game as soon as anyOne wins
      freezeGame = true;

      /// Here we are checking the Second Column for winner
    } else if (displayXO[1] == displayXO[4] &&
        displayXO[4] == displayXO[7] &&
        displayXO[1] != "") {
      winner = displayXO[1];

      /// Calling _updateWinnerResult for Win Count Increment
      _updateWinnerResult(winner);

      /// Here we are creating  pattern by adding all index's of the match winner
      winnerPattern.addAll([1, 4, 7]);
      /// Here we are freezing the game as soon as anyOne wins
      freezeGame = true;

      /// Here we are checking the Third Column for winner
    } else if (displayXO[2] == displayXO[5] &&
        displayXO[5] == displayXO[8] &&
        displayXO[2] != "") {
      winner = displayXO[2];

      /// Calling _updateWinnerResult for Win Count Increment
      _updateWinnerResult(winner);

      /// Here we are creating  pattern by adding all index's of the match winner
      winnerPattern.addAll([2, 5, 8]);
      /// Here we are freezing the game as soon as anyOne wins
      freezeGame = true;

      /// Here we are checking the Left to Right Diagonal for winner
    } else if (displayXO[0] == displayXO[4] &&
        displayXO[4] == displayXO[8] &&
        displayXO[0] != "") {
      winner = displayXO[0];

      /// Calling _updateWinnerResult for Win Count Increment
      _updateWinnerResult(winner);

      /// Here we are creating  pattern by adding all index's of the match winner
      winnerPattern.addAll([0, 4, 8]);
      /// Here we are freezing the game as soon as anyOne wins
      freezeGame = true;

      /// Here we are checking the Right to Left Diagonal for winner
    } else if (displayXO[2] == displayXO[4] &&
        displayXO[4] == displayXO[6] &&
        displayXO[2] != "") {
      winner = displayXO[2];

      /// Calling _updateWinnerResult for Win Count Increment
      _updateWinnerResult(winner);

      /// Here we are creating  pattern by adding all index's of the match winner
      winnerPattern.addAll([2, 4, 6]);
      /// Here we are freezing the game as soon as anyOne wins
      freezeGame = true;
      /// Here we are checking The Draw (means nobody wins)
    } else if (indexList.length == 9) {
      winner = AppStrings.draw;

      if(widget.isSoundAllow){
        /// Here we are Playing draw sound effect and stopping  previous sounds
        _audioPlayer.stop();
        await _audioPlayer.play(AssetSource(AppStrings.drawAudioPath));
      }

      ///Here We are Calling showResult function  to display result of our game
      showResult();

      /// Here we are freezing the game as soon as anyOne wins
      freezeGame = true;
    }
    setState(() {});
  }
  /// Update Scores
  void _updateWinnerResult(String winner) async {
    _confettiController.play();
    if (widget.isSoundAllow) {
      _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(AppStrings.winAudioPath));
    }
    if (winner == AppStrings.x) xCount++;
    if (winner == AppStrings.o) oCount++;
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
      isDelayed=false;
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
            title: winner == AppStrings.draw ? winner : AppStrings.winner,
            descriptions: winner == AppStrings.draw
                ? AppStrings.nobodyWin
                : winner == AppStrings.x
                    ? AppStrings.playerXWon
                    : AppStrings.computerWon,
            text: AppStrings.okay,
            didwin: winner != AppStrings.draw,
          ),
        );
      },
    );
  }
}

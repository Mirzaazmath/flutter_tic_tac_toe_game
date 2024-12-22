import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe_game/constant/app_strings.dart';

import '../components/dialog_component.dart';

class PlayGameScreen extends StatefulWidget {
  bool isSoundAllow;
   PlayGameScreen({super.key,required this.isSoundAllow});

  @override
  State<PlayGameScreen> createState() => _PlayGameScreenState();
}

class _PlayGameScreenState extends State<PlayGameScreen> {
  /// Here we are Creating a List Variable to Hold the value of our Board
  List<String> displayXO = [
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  ];

  /// Here we have creating a indexList variable to store index's of our board to avoid overrides
  List<int> indexList = [];

  /// Here we are creating a bool variable to handle the turns of Players
  bool xTurn = true;

  /// Here we are Creating a variable to store and handle the winner
  String winner = "";

  /// Here we are Creating the two variable on int to store handle the winner results
  int xCount = 0;
  int oCount = 0;

  /// Here we are Creating a variable to freeze the game as soon as anyone wins
  bool freezeGame = false;

  /// Here we are Creating a List Variable to store and handle the winner pattern
  List<int> winnerPattern = [];

  /// Here we are Instance or Object of audio Player to play music
  final _audioPlayer = AudioPlayer();

  /// Here we are Creating a bool Variable to delay some time for player turn
  bool isDelayed = false;

  /// Here we are Creating a ConfettiController to handle confetti effect for win
  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(milliseconds: 1000));

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    /// Here we are disposing the controllers instance if we are not using this screen
    /// to avoid memory leaks
    _audioPlayer.dispose();
    _confettiController.dispose();
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
                /// ***** Score Board Area ******* ///
                Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              AppStrings.playerX,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "$xCount",
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(color: Colors.white),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                            AppStrings.playerO,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "$oCount",
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(color: Colors.white),
                            )
                          ],
                        )
                      ],
                    )),

                /// ***** Game Board Area ******* ///
                Expanded(
                    flex: 3,
                    child: AbsorbPointer(
                      absorbing: freezeGame || isDelayed,
                      child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: displayXO.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                _tapped(index);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        width: 5,
                                        color: Theme.of(context).primaryColor),
                                    color: winnerPattern.contains(index)
                                        ? Theme.of(context).primaryColorDark
                                        : Theme.of(context).primaryColorLight),
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
                          }),
                    )),

                /// ***** End Game  Area ******* ///
                Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        freezeGame
                            ? const SizedBox()
                            : Text(
                                "${AppStrings.player}  ${isDelayed ? AppStrings.dot : xTurn ? AppStrings.xTurn :  AppStrings.oTurn}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(color: Colors.white),
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                            child: freezeGame
                                ? ElevatedButton(
                                    onPressed: _clearBoard,
                                    child: const Text(
                                      AppStrings.playAgain,
                                    ),
                                  )
                                : const SizedBox()),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ***** Tapped on Box ******* ///
  void _tapped(int index) async {
    /// Here we are checking the index contains in the list or not
    if (!indexList.contains(index)) {

      /// Here we are Playing Write sound effect and stopping  previous sounds
      if(widget.isSoundAllow){
        _audioPlayer.stop();
        await _audioPlayer.play(AssetSource(AppStrings.writeAudioPath));
      }



      /// if Not
      setState(() {
        /// Here we are checking whose turn is this and also whether the container is empty or not
        /// if True
        if (xTurn && displayXO[index] == "") {
          /// Here we are setting the X Value to the list Index of values
          displayXO[index] = AppStrings.x;
        } else {
          /// if false
          /// Here we are setting the O Value to the list Index of values
          displayXO[index] = AppStrings.o;
        }
        isDelayed = true;

        /// Here we are changing the turns on the players
        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            xTurn = !xTurn;
            isDelayed = false;
          });
        });

        /// Here we are adding the index to our index list to avoid overrides
        indexList.add(index);
      });
    } else {}

    /// Here we are adding one to minimize the use of check Winner function call
    /// because at least there should be five move hit to check the winner
    if (indexList.length > 4) {
      /// Here we are calling the _checkWinner function to check who is the winner
      _checkWinner();
    }
  }

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

      /// Here we are checking the Second Row for winner
    } else if (displayXO[3] == displayXO[4] &&
        displayXO[4] == displayXO[5] &&
        displayXO[3] != "") {
      winner = displayXO[3];

      /// Calling _updateWinnerResult for Win Count Increment
      _updateWinnerResult(winner);

      /// Here we are creating  pattern by adding all index's of the match winner
      winnerPattern.addAll([3, 4, 5]);

      /// Here we are checking the Third Row for winner
    } else if (displayXO[6] == displayXO[7] &&
        displayXO[7] == displayXO[8] &&
        displayXO[6] != "") {
      winner = displayXO[6];

      /// Calling _updateWinnerResult for Win Count Increment
      _updateWinnerResult(winner);

      /// Here we are creating  pattern by adding all index's of the match winner
      winnerPattern.addAll([6, 7, 8]);

      /// Here we are checking the First Column for winner
    } else if (displayXO[0] == displayXO[3] &&
        displayXO[3] == displayXO[6] &&
        displayXO[0] != "") {
      winner = displayXO[0];

      /// Calling _updateWinnerResult for Win Count Increment
      _updateWinnerResult(winner);

      /// Here we are creating  pattern by adding all index's of the match winner
      winnerPattern.addAll([0, 3, 6]);

      /// Here we are checking the Second Column for winner
    } else if (displayXO[1] == displayXO[4] &&
        displayXO[4] == displayXO[7] &&
        displayXO[1] != "") {
      winner = displayXO[1];

      /// Calling _updateWinnerResult for Win Count Increment
      _updateWinnerResult(winner);

      /// Here we are creating  pattern by adding all index's of the match winner
      winnerPattern.addAll([1, 4, 7]);

      /// Here we are checking the Third Column for winner
    } else if (displayXO[2] == displayXO[5] &&
        displayXO[5] == displayXO[8] &&
        displayXO[2] != "") {
      winner = displayXO[2];

      /// Calling _updateWinnerResult for Win Count Increment
      _updateWinnerResult(winner);

      /// Here we are creating  pattern by adding all index's of the match winner
      winnerPattern.addAll([2, 5, 8]);

      /// Here we are checking the Left to Right Diagonal for winner
    } else if (displayXO[0] == displayXO[4] &&
        displayXO[4] == displayXO[8] &&
        displayXO[0] != "") {
      winner = displayXO[0];

      /// Calling _updateWinnerResult for Win Count Increment
      _updateWinnerResult(winner);

      /// Here we are creating  pattern by adding all index's of the match winner
      winnerPattern.addAll([0, 4, 8]);

      /// Here we are checking the Right to Left Diagonal for winner
    } else if (displayXO[2] == displayXO[4] &&
        displayXO[4] == displayXO[6] &&
        displayXO[2] != "") {
      winner = displayXO[2];

      /// Calling _updateWinnerResult for Win Count Increment
      _updateWinnerResult(winner);

      /// Here we are creating  pattern by adding all index's of the match winner
      winnerPattern.addAll([2, 4, 6]);

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

  /// ***** Update Winner Result Function ******* ///
  /// Here we are Incrementing the winner count
  void _updateWinnerResult(String winner) async {
    _confettiController.play();

  if(widget.isSoundAllow){
    /// Here we are Playing winner sound effect and stopping  previous sounds
    _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(AppStrings.winAudioPath));
  }

    /// Here we are freezing the game as soon as anyOne wins
    freezeGame = true;
    if (winner == AppStrings.x) {
      xCount++;

      /// Increase X win Counts
    } else {
      oCount++;

      /// Increase O win Counts
    }

    ///Here We are Calling showResult function  to display result of our game
    showResult();
  }

  /// ***** Update Winner Result Function ******* ///
  void _clearBoard() {
    setState(() {
      /// Here we are Loping and clearing the board
      for (int i = 0; i < 9; i++) {
        displayXO[i] = "";
      }

      /// Here we are Clearing our winner also
      winner = "";

      /// Here we are clearing our indexList also
      indexList = [];

      /// Here we are unFreezing the game
      freezeGame = false;

      /// Here we are again setting the Turn to X
      xTurn = true;

      /// Here we are clearing our winnerPattern  also
      winnerPattern = [];
    });
  }

  /// ***** Show Result Function ******* ///
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
              descriptions:
                  winner == AppStrings.draw ? AppStrings.nobodyWin : "${AppStrings.player} $winner ${AppStrings.hasWon}",
              text: AppStrings.okay,
              didwin: winner != "" && winner != AppStrings.draw,
            ),
          );
        });
  }
}

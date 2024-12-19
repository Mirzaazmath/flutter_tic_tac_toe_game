import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PlayGameScreen extends StatefulWidget {
  const PlayGameScreen({super.key});

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
  final audioPlayer = AudioPlayer();

  /// Here we are Creating a bool Variable to delay some time for player turn
  bool isDelayed = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    /// Here we are disposing the audioPlayer instance if we are not using this screen
    /// to avoid memory leaks
    audioPlayer.dispose();
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
              Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Player X",
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
                            "Player O",
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
              Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      freezeGame ?const SizedBox(): Text("Player  ${isDelayed?"...": xTurn?"X turn":"O turn"}",style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),),
                     const  SizedBox(height: 10,),
                      Center(
                          child: freezeGame
                              ? ElevatedButton(
                                  onPressed: _clearBoard,
                                  child: const Text(
                                    "Play Again!",
                                  ),
                                )
                              : const SizedBox()),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _tapped(int index) async {
    /// Here we are checking the index contains in the list or not
    if (!indexList.contains(index)) {
      audioPlayer.stop();
      await audioPlayer.play(AssetSource('audios/write.mp3'));

      /// if Not
      setState(() {
        /// Here we are checking whose turn is this and also whether the container is empty or not
        /// if True
        if (xTurn && displayXO[index] == "") {
          /// Here we are setting the X Value to the list Index of values
          displayXO[index] = "X";
        } else {
          /// if false
          /// Here we are setting the X Value to the list Index of values
          displayXO[index] = "O";
        }
        isDelayed = true;

        /// Here we are changing the turns on the players
        Future.delayed(const Duration(milliseconds: 1200), () {
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

  void _checkWinner() {
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
      winner = "Draw";

      /// Here we are freezing the game as soon as anyOne wins
      freezeGame = true;
    }
    setState(() {});
  }

  /// Here we are Incrementing the winner count
  void _updateWinnerResult(String winner) {
    /// Here we are freezing the game as soon as anyOne wins
    freezeGame = true;
    if (winner == "X") {
      xCount++;

      /// Increase X win Counts
    } else {
      oCount++;

      /// Increase O win Counts
    }
  }

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
}

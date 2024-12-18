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
  /// Here we have created a indexList variable to store index's of our board to avoid overrides
  List<int> indexList = [];

  /// Here we are Creating a Bool Variable to handle the turns of Players
  bool xTurn = true;
  int newVal = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(flex: 1, child: Container()),
              /// ***** Game Board Area ******* ///
              Expanded(
                  flex: 3,
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
                                color: Theme.of(context).primaryColorLight),
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
                      })),
              Expanded(flex: 1, child: Container()),
            ],
          ),
        ),
      ),
    );
  }

  void _tapped(int index) {
    /// Here we are checking the index contains in the list or not
    if (!indexList.contains(index)) {
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
        /// Here we are changing the turns on the players
        xTurn = !xTurn;
        /// Here we are adding the index to our index list to avoid overrides
        indexList.add(index);
      });
    } else {}
    /// Here we are adding one to minimize the use of check Winner function call
    /// because at least there should be five move hit to check the winner
   if(indexList.length>4){
     /// Here we are calling the _checkWinner function to check who is the winner
     _checkWinner();
   }
  }

  void _checkWinner(){

  }
}

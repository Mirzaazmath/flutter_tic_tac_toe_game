import 'package:flutter/material.dart';

class PlayGameScreen extends StatelessWidget {
  const PlayGameScreen({super.key});

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
                  child: Container()),
              Expanded(
                  flex: 3,
                  child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 9,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                                border: Border.all(width: 5,color: Theme.of(context).primaryColor),
                                color: Theme.of(context).primaryColorLight),
                            alignment: Alignment.center,
                            child:  Text("X",style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
                          ),
                        );
                      })),
              Expanded(
                  flex: 1,
                  child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}

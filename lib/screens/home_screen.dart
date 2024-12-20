import 'package:flutter/material.dart';
import 'package:tic_tac_toe_game/components/setting_dailog.dart';
import 'package:tic_tac_toe_game/screens/play_game_screen.dart';
import 'package:tic_tac_toe_game/utils/animation_utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// **** Settings Section  **** ///
            ShowUpAnimation(
              delay: 200,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: IconButton.outlined(
                  style: IconButton.styleFrom(side: BorderSide(color: Theme.of(context).primaryColorLight)),
                    onPressed: (){
                      showSetting(context);
                    }, icon: Icon(Icons.settings,color: Theme.of(context).primaryColorLight,)),
              ),
            ),
            const  Spacer(),
            /// **** Custom Logo Section  **** ///
            ShowUpAnimation(
              delay: 300,
              child: Center(
                child: Container(
                  height: 200,
                  width: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Theme.of(context).primaryColorLight,width: 2)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Tic",style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white),),
                      Text("Tac",style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white),),
                      Text("Toe",style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white),)
                    ],

                  ),
                ),
              ),
            ),
         const  Spacer(),
            /// **** Multi-Player Button Section  **** ///
          ShowUpAnimation(
            delay: 400,
            child: Center(
              child: ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const PlayGameScreen()));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColorLight,
                      minimumSize: const Size(250, 55)),
                      child:  Text("Multi-Player",style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).primaryColorDark),)),
            ),
          ),
           const  SizedBox(height: 30,),
            /// **** Single-Player Button Section  **** ///
            ShowUpAnimation(
              delay: 500,
              child: Center(
                child: ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColorLight,minimumSize: const Size(250, 55)),
                    child:  Text("Single-Player",style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).primaryColorDark),)),
              ),
            ),
            const  Spacer(),
          ],
        ),

      ),
    );
  }
  /// **** Setting Dialog Section  **** ///
  void showSetting(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const SettingDialogBox();
        });
  }
}

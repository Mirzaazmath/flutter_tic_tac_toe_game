import 'package:flutter/material.dart';
import 'package:tic_tac_toe_game/screens/splash_Screen.dart';
import 'package:tic_tac_toe_game/utils/theme_color_utils.dart';

void main(){
  runApp(const MyApp());

}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Coiny",

        primaryColor:themeList[5].primaryColor,
        primaryColorLight: themeList[5].primaryColorLight,
        primaryColorDark: themeList[5].primaryColorDark
      ),
      home: const SplashScreen(),
    );
  }
}

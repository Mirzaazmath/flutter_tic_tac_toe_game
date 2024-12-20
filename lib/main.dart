import 'package:flutter/material.dart';
import 'package:tic_tac_toe_game/screens/splash_Screen.dart';

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
        primaryColor: const Color(0xffFF4b4b),
        primaryColorLight:const  Color(0xffffca27),
        primaryColorDark: const Color(0xff4169e8)
      ),
      home: const SplashScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tic_tac_toe_game/screens/splash_Screen.dart';
import 'package:tic_tac_toe_game/utils/theme_color_utils.dart';

void main(){
  runApp( MyApp());

}
class MyApp extends StatefulWidget {


  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {


  late Color  color1;

  late Color  color2;

  late Color  color3;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setColor(0);
  }

  void setColor(index){
    setState(() {
      color1=themeList[index].primaryColor;
      color2=themeList[index].primaryColorLight;
      color3=themeList[index].primaryColorDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Coiny",

        primaryColor: color1,
        primaryColorLight: color2,
        primaryColorDark:color3,
      ),
      home: SplashScreen(newColorIndex: (newIndex){
        setColor(newIndex);
      },),
    );
  }
}

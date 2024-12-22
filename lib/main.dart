import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe_game/constant/app_strings.dart';
import 'package:tic_tac_toe_game/screens/splash_Screen.dart';
import 'package:tic_tac_toe_game/utils/theme_color_utils.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final int? theme = prefs.getInt(AppStrings.spTheme);
  runApp(MyApp( colorIndex: theme??0,));

}
class MyApp extends StatefulWidget {
  int colorIndex;
  MyApp({required this.colorIndex});

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
    setColor(widget.colorIndex);
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
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: AppStrings.fontFamily,
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

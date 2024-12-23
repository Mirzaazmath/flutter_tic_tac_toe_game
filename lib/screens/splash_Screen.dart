import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tic_tac_toe_game/constant/app_strings.dart';
import 'package:tic_tac_toe_game/screens/home_screen.dart';


class SplashScreen extends StatefulWidget {
  Function(int) newColorIndex;
   SplashScreen({super.key,required this.newColorIndex});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
/// Here we are Creating a Key variable to access the animated List
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ///  Here we are creating a list variable to hold all letters of our App Name
  final List<String> _data = [];
  /// Here we are Creating a variable to hold our app Name
  String appName = AppStrings.appName;
  @override
  void initState() {
    super.initState();
    /// Here we are calling a loadItems Function to perform animation
    _loadItems();// Start loading items automatically
    /// Here we are calling the splash Screen Logic function
    _splashScreenLogic();
  }
/// *** Load Items Functions *** ///
  void _loadItems() async {
    /// Here we are iterating the loop with our appName so we can get all letter that we want to display and animate
    for (int i = 0; i < appName.length; i++) {
      /// Here we are delaying some time in every loop to handle animation
      await Future.delayed(
          const  Duration(milliseconds: 200)); // Simulate a delay
      /// Here we are calling the _addItem function after delay in every loop
      _addItem();
    }
  }
/// *** Add Items Function *** ///
  void _addItem() {
    /// Here we are getting index based on _data list length
    final index = _data.length;
    /// Here we are adding Single Letter of our app name with index
    _data.add(appName[index]);
    /// Here we are notifying our animated List that we have inserted some value by using the key
    /// this will build that element in the list
    _listKey.currentState?.insertItem(index);
  }
  /// *** Splash Screen Function *** ///
  void _splashScreenLogic()  {
    /// Here we are simple waiting for 3.5 seconds and performing navigation
    Future.delayed(const Duration(milliseconds: 3500), (){
      /// Navigating with pushReplacement
      /// Wrapping with Showcase
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> ShowCaseWidget(
        onFinish: (){
          // Todo : Need to Implement Logic here
          print("ShowCase Completed");
        },

        builder: (context)=> HomeScreen(newColorIndex: widget.newColorIndex))));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      /// **** Animated List for Animating the app Name **** ///
      body: Stack(
        alignment: Alignment.center,
        children: [Center(
          child: SizedBox(
            height: 100,
            child: AnimatedList(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                padding: const EdgeInsets.all(20),
                key: _listKey,
                initialItemCount: _data.length,
                itemBuilder: (context, index, animation) {
                  return RotationTransition(
                    turns: animation,
                    child: Text(
                      _data[index],
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  );
                }),
          ),
        ),
          Positioned(bottom: 20,
              child: Center(child: Text(
                AppStrings.developerBranding,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white),)))
      ]),
    );
  }
}

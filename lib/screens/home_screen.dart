import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe_game/components/setting_dailog.dart';
import 'package:tic_tac_toe_game/constant/app_strings.dart';
import 'package:tic_tac_toe_game/screens/play_game_screen.dart';
import 'package:tic_tac_toe_game/screens/single_player_game_screen.dart';
import 'package:tic_tac_toe_game/utils/animation_utils.dart';
import 'package:showcaseview/showcaseview.dart';

class HomeScreen extends StatefulWidget {
  Function(int) newColorIndex;
  HomeScreen({super.key, required this.newColorIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey _singlePlayerKey = GlobalKey();
  GlobalKey _multiPlayerKey = GlobalKey();
  GlobalKey _settingKey = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        Future.delayed(const Duration(milliseconds: 850), (){
        /// Starting the ShowCase
          ShowCaseWidget.of(context).startShowCase([_singlePlayerKey, _multiPlayerKey, _settingKey]);
        }),);
  }

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
                child: Showcase(
                  overlayOpacity: 0.7,
                  targetShapeBorder: const CircleBorder(),
                  key: _settingKey,
                  title: 'Settings',
                  description: 'Tap here to see all Settings',
                  child: IconButton.outlined(
                      style: IconButton.styleFrom(
                          side: BorderSide(
                              color: Theme.of(context).primaryColorLight)),
                      onPressed: () {
                        showSetting(context);
                      },
                      icon: Icon(
                        Icons.settings,
                        color: Theme.of(context).primaryColorLight,
                      )),
                ),
              ),
            ),
            const Spacer(),

            /// **** Custom Logo Section  **** ///
            ShowUpAnimation(
              delay: 300,
              child: Center(
                child: Container(
                  height: 200,
                  width: 160,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Theme.of(context).primaryColorLight,
                          width: 2)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.tic,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(color: Colors.white),
                      ),
                      Text(
                        AppStrings.tac,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(color: Colors.white),
                      ),
                      Text(
                        AppStrings.toe,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),

            /// **** Multi-Player Button Section  **** ///
            ShowUpAnimation(
              delay: 400,
              child: Center(
                child: Showcase(
                  overlayOpacity: 0.7,
                  targetShapeBorder: const CircleBorder(),
                  key: _multiPlayerKey,
                  title: 'Multi-Player',
                  description: 'Tap to play with your Friends!',
                  child: ElevatedButton(
                      onPressed: () async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        final bool? sound = prefs.getBool(AppStrings.spSound);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PlayGameScreen(
                                  isSoundAllow: sound ?? true,
                                )));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColorLight,
                          minimumSize: const Size(250, 55)),
                      child: Text(
                        AppStrings.multiPlayer,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Theme.of(context).primaryColorDark),
                      )),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),

            /// **** Single-Player Button Section  **** ///
            ShowUpAnimation(
              delay: 500,
              child: Center(
                child: Showcase(
                  overlayOpacity: 0.7,
                  targetShapeBorder: const CircleBorder(),
                  key: _singlePlayerKey,
                  title: 'Single Player',
                  description: 'Tap to play with computer!',
                  child: ElevatedButton(
                      onPressed: () async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        final bool? sound = prefs.getBool(AppStrings.spSound);
                        final String? mode = prefs.getString(AppStrings.spMode);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SinglePLayerPlayGameScreen(
                                  isSoundAllow: sound ?? true,
                                  difficultyLevel: mode == AppStrings.hard
                                      ? 2
                                      : mode == AppStrings.medium
                                          ? 1
                                          : 0,
                                )));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColorLight,
                          minimumSize: const Size(250, 55)),
                      child: Text(
                        AppStrings.singlePlayer,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Theme.of(context).primaryColorDark),
                      )),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  /// **** Setting Dialog Section  **** ///
  void showSetting(context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? sound = prefs.getBool(AppStrings.spSound);
    final int? theme = prefs.getInt(AppStrings.spTheme);
    final String? mode = prefs.getString(AppStrings.spMode);

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SettingDialogBox(
            isSoundAllow: sound ?? true,
            colorThemeIndex: theme ?? 0,
            newColorIndex: widget.newColorIndex,
            selectedDifficultyLevel: mode ?? AppStrings.easy,
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe_game/utils/theme_color_utils.dart';

// Setting DIALOG CLASS
class SettingDialogBox extends StatefulWidget {
  bool isSoundAllow;
  int colorThemeIndex;
  String selectedDifficultyLevel;
  Function(int) newColorIndex;
  SettingDialogBox({
    super.key,
    required this.isSoundAllow,
    required this.colorThemeIndex,
    required this.newColorIndex,
    required this.selectedDifficultyLevel,
  });

  @override
  _SettingDialogBoxState createState() => _SettingDialogBoxState();
}

class _SettingDialogBoxState extends State<SettingDialogBox> {


  // List of items in our dropdown menu
  var items = [
    'Easy',
    'Medium',
    'Hard',
  ];
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: const EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Sound", style: Theme.of(context).textTheme.titleLarge),
                  Switch(
                      activeColor: Theme.of(context).primaryColor,
                      value: widget.isSoundAllow,
                      onChanged: (value) async {
                        setState(() {
                          widget.isSoundAllow = value;
                        });
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setBool('sound', value);
                      })
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Modes", style: Theme.of(context).textTheme.titleLarge),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Theme.of(context).primaryColorDark)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        padding: EdgeInsets.zero,
                        borderRadius: BorderRadius.circular(20),
                        // Initial Value
                        value:widget.selectedDifficultyLevel,
                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),
                        // Array list of items
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(
                              items,
                              style: TextStyle(
                                  color: items == "Easy"
                                      ? Colors.green
                                      : items == "Medium"
                                          ? Colors.orange
                                          : Colors.red),
                            ),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) async {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString('mode', newValue!);
                          setState(() {
                            widget.selectedDifficultyLevel = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Theme(
                data: ThemeData(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text("Theme",
                      style: Theme.of(context).textTheme.titleLarge),
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: Theme.of(context).primaryColor),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(15),
                      child: Wrap(spacing: 10, runSpacing: 20, children: [
                        for (int i = 0; i < themeList.length; i++) ...[
                          GestureDetector(
                            onTap: () async {
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setInt('theme', i);
                              widget.newColorIndex(i);
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  widget.colorThemeIndex = i;
                                });
                              });
                            },
                            child: Container(
                              height: 30,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    width: 2,
                                    color: widget.colorThemeIndex == i
                                        ? Colors.black
                                        : Colors.grey.shade300),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                        color: themeList[i].primaryColor,
                                        border: Border.all(),
                                        shape: BoxShape.circle),
                                  ),
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                        color: themeList[i].primaryColorLight,
                                        border: Border.all(),
                                        shape: BoxShape.circle),
                                  ),
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                        color: themeList[i].primaryColorDark,
                                        border: Border.all(),
                                        shape: BoxShape.circle),
                                  )
                                ],
                              ),
                            ),
                          )
                        ]
                      ]),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColorLight,
                      minimumSize: const Size(250, 55)),
                  child: Text(
                    "Close",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Theme.of(context).primaryColorDark),
                  )),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColorDark,
              radius: 50,
              child: const Icon(
                Icons.settings_outlined,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

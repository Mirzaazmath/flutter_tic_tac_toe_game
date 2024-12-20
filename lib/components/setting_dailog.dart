import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Setting DIALOG CLASS
class SettingDialogBox extends StatefulWidget {
  bool isSoundAllow;
   SettingDialogBox({super.key,required this.isSoundAllow});

  @override
  _SettingDialogBoxState createState() => _SettingDialogBoxState();
}

class _SettingDialogBoxState extends State<SettingDialogBox> {
  //bool isSoundAllow = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsFlutterBinding.ensureInitialized();
    // getSettingValueFromLocalStorage();
  }
  // void getSettingValueFromLocalStorage() async{
  //   // Obtain shared preferences.
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final bool? sound = prefs.getBool('sound');
  //   setState(() {
  //     isSoundAllow=sound ?? true;
  //   });
  // }


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
                      onChanged: (value) async{

                        setState(() {
                          widget.isSoundAllow = value;
                        });
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('sound', value);
                      })
                ],
              ),
              Theme(
                data: ThemeData(
                  dividerColor: Colors.transparent
                ),
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
                      border: Border.all(color: Theme.of(context).primaryColor)

                     ),
                    )
                  ],
                ),
              ),
             const  SizedBox(height: 20,),
              ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColorLight,minimumSize: const Size(250, 55)),
                  child:  Text("Close",style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).primaryColorDark),)),
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
              backgroundColor: Theme.of(context).primaryColorLight,
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

import 'package:flutter/material.dart';


// CUSTOM DAILOG CLASS
class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, text;
  final bool didwin;
  final bool? isAlert;


  const CustomDialogBox({  required this.title, required this.descriptions, required this.text,required this.didwin ,this.isAlert});

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
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
  contentBox(context){

    return Stack(
      children: <Widget>[
        Container(
          padding: const  EdgeInsets.only(left: Constants.padding,top: Constants.avatarRadius
              + Constants.padding, right: Constants.padding,bottom: Constants.padding
          ),
          margin:const  EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow:const  [
                BoxShadow(color: Colors.black,offset: Offset(0,10),
                    blurRadius: 10
                ),
              ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(widget.title,style:  TextStyle(fontSize: 22,fontWeight: FontWeight.w600,color:widget.didwin? Colors.green:Colors.red,),),
              const   SizedBox(height: 15,),
              Text(widget.descriptions,style:  const TextStyle(fontSize: 16,color:Colors.black,),textAlign: TextAlign.center,),
              const SizedBox(height: 22,),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: widget.didwin? Colors.green:Colors.red
                    ),
                    alignment: Alignment.center,
                    child: Text(widget.text,style:const  TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),)),
              )
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
              backgroundColor: widget.didwin? Colors.green:Colors.red,
              radius: 50,child: Icon( widget.didwin? Icons.check_circle_outline_outlined:Icons.cancel_outlined,size: 60,color: Colors.white,),
            ),

          ),
        ),
      ],
    );
  }
}
class Constants{
  Constants._();
  static const double padding =20;
  static const double avatarRadius =45;
}
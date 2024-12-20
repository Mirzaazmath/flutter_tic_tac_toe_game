import 'package:flutter/material.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const  Spacer(),
            Center(
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
         const  Spacer(),
          ElevatedButton(
                  onPressed: (){},
                  style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColorLight,
                  minimumSize: const Size(200, 40)),
                  child:const  Text("Multi-Player",)),
           const  SizedBox(height: 20,),

            ElevatedButton(
                onPressed: (){},
                style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColorLight,minimumSize: const Size(200, 40)),
                child:const  Text("Single-Player",)),
            const  Spacer(),
          ],
        ),

      ),
    );
  }
}

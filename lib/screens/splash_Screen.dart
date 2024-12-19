import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> _data = [];
  String appName = "Tic Tac Toe";
  @override
  void initState() {
    super.initState();
    _loadItems(); // Start loading items automatically
  }

  void _loadItems() async {
    for (int i = 0; i < appName.length; i++) {
      await Future.delayed(
          const  Duration(milliseconds: 200)); // Simulate a delay
      _addItem();
    }
  }

  void _addItem() {
    final index = _data.length;
    _data.add(appName[index]);
    _listKey.currentState?.insertItem(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';    

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  void goToTimer() {
    // Navigate to TimerView
    context.push('/timer');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: goToTimer, child: const Text('Go to Timer'))
          ],
        ),
      )
    );
  }
}

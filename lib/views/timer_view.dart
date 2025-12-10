import 'package:flutter/material.dart';
import 'package:time_keeper/components/timer/my_timer.dart';

class TimerView extends StatefulWidget {
  const TimerView({super.key});

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
Color bgColor = Colors.green;
  final int time = 60 * 20;
  final int timeLimit = 5;

  void onElapsedTimeChanged(int elapsedTime) {
    if (elapsedTime >= timeLimit) {
      setState(() {
        bgColor = Colors.redAccent;
      });
    } else {
      setState(() {
        bgColor = Colors.green;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: MyTimer(
          duration: time,
          onElapsedTimeChanged: onElapsedTimeChanged,
          timeLimit: timeLimit,
        ),
      ),
    );
  }
}
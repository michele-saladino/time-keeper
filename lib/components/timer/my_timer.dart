import 'package:flutter/material.dart';
import 'package:time_keeper/components/shared/number_scroll.dart';
import 'package:go_router/go_router.dart';
import 'package:time_keeper/components/timer/water_glasses.dart';


class MyTimer extends StatefulWidget {
  const MyTimer({super.key, this.duration = 60, required this.timeLimit, this.onElapsedTimeChanged});

  // Duration of the timer in seconds
  final int duration;
  final int timeLimit;
  final Function(int elapsedTime)? onElapsedTimeChanged;

  @override
  State<MyTimer> createState() => _MyTimerState();
}

class _MyTimerState extends State<MyTimer> {
  late int remainingTime;
  bool isRunning = true;
  int numberOfGlasses = 0;

  final int glassInterval = 60*30; // seconds

  @override
  void initState() {
    super.initState();
    remainingTime = widget.duration;
    // Start the timer countdown
    _startTimer();
    // Start the glass timer
    _startGlassTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (remainingTime > 0 && isRunning) {
        setState(() {
          remainingTime--;
        });
        if (widget.onElapsedTimeChanged != null) {
          widget.onElapsedTimeChanged!(widget.duration - remainingTime);
        }
        _startTimer();
      }
    });
  }

  void _startGlassTimer() {
    Future.delayed(Duration(seconds: glassInterval), () {
      addGlass();
      _startGlassTimer();
    });
  }

  void _pauseTimer() {
    if (isRunning) {
      setState(() {
        isRunning = false;
      });
    } else {
      setState(() {
        isRunning = true;
      });
      _startTimer();
    }
  }

  void _resetTimer() {
    setState(() {
      remainingTime = widget.duration;
      isRunning = true;
    });
    _startTimer();
  }

  void removeGlass() {
    if (numberOfGlasses > 0) {
      setState(() {
        numberOfGlasses--;
      });
    }
  }

  void addGlass() {
    setState(() {
      numberOfGlasses++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: remainingTime > widget.timeLimit ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            height: 60,
            child: Center(
              child: 
              !isRunning ?
              Text(
                'LOOK\nOUTSIDE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              )
              :
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                        child: NumberScroll(value: remainingTime ~/ 60, style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                      const SizedBox(width: 4.0),
                      SizedBox(
                        width: 12,
                        child: Text(
                          ':',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      SizedBox(
                        width: 40,
                        child: NumberScroll(value: remainingTime % 60, style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),  
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  WaterGlasses(numberOfGlasses: numberOfGlasses, removeGlass: removeGlass,),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                ElevatedButton(
                onPressed: _pauseTimer,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                ),
                child: Icon(isRunning ? Icons.pause : Icons.play_arrow),
                ),
              const SizedBox(height: 8.0),
              ElevatedButton(onPressed: _resetTimer, style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                ),child: const Icon(Icons.refresh),),
              const SizedBox(height: 8.0),
              ElevatedButton(onPressed: (){
                context.pop();
              }, style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                ),child: const Icon(Icons.home),),
            ],
          )
        ],
      ),
    );
  }
}
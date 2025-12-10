import 'package:flutter/material.dart';
import 'package:time_keeper/components/timer/my_timer.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(210, 150),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setAlwaysOnTop(true);
  });

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.green;
    final int time = 60 * 20;
    final int timeLimit = 5;

    void onElapsedTimeChanged(int elapsedTime) {
      if (elapsedTime >= timeLimit) {
        bgColor = Colors.redAccent;
      } else {
        bgColor = Colors.green;
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: MyTimer(duration: time, onElapsedTimeChanged: onElapsedTimeChanged, timeLimit: timeLimit),
        ),
      ),
    );
  }
}

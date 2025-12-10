import 'package:go_router/go_router.dart';
import 'package:time_keeper/views/home_view.dart';
import 'package:time_keeper/views/timer_view.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(path: '/timer', builder: (context, state) => const TimerView()),
  ],
);

import 'package:flutter/material.dart';
import 'package:quan_ly_hoc_tap/features/auth/presentation/screens/login_screen.dart';
import 'package:quan_ly_hoc_tap/features/auth/presentation/screens/register_screen.dart';
import 'package:quan_ly_hoc_tap/features/auth/presentation/screens/welcome_screen.dart';

import 'package:quan_ly_hoc_tap/features/documents/presentation/screens/document_screen.dart';
import 'package:quan_ly_hoc_tap/features/groups/presentation/screens/group_list_screen.dart';
import 'package:quan_ly_hoc_tap/features/profile/presentation/screens/profile_screen.dart';
import 'package:quan_ly_hoc_tap/features/schedule/presentation/screens/smart_timetable_screen.dart';
import 'package:quan_ly_hoc_tap/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:quan_ly_hoc_tap/features/dashboard/presentation/screens/main_screen.dart';
import 'package:quan_ly_hoc_tap/features/study_session/presentation/screens/pomodoro_screen.dart';
import 'route_names.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.welcome:
        return MaterialPageRoute(builder: (_) => WelcomeScreen());

      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case RouteNames.main:
        return MaterialPageRoute(builder: (_) => const MainScreen());

      case RouteNames.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());

      case RouteNames.schedule:
        return MaterialPageRoute(builder: (_) => const SmartTimetableScreen());

      case RouteNames.study:
      case RouteNames.pomodoro:
        return MaterialPageRoute(builder: (_) => const PomodoroScreen());

      case RouteNames.documents:
        return MaterialPageRoute(builder: (_) => const DocumentScreen());

      case RouteNames.groups:
      case RouteNames.groupList:
        return MaterialPageRoute(builder: (_) => const GroupListScreen());

      case RouteNames.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }

  static Route<dynamic> generateRouteWithArgs(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case RouteNames.scheduleDetail:
        if (args is Map<String, dynamic>) {
          final scheduleId = args['scheduleId'] as String?;
          // Return schedule detail screen with scheduleId
          return MaterialPageRoute(
            builder:
                (_) => Scaffold(
                  body: Center(child: Text('Schedule Detail: $scheduleId')),
                ),
          );
        }
        break;

      case RouteNames.documentDetail:
        if (args is Map<String, dynamic>) {
          final documentId = args['documentId'] as String?;
          // Return document detail screen with documentId
          return MaterialPageRoute(
            builder:
                (_) => Scaffold(
                  body: Center(child: Text('Document Detail: $documentId')),
                ),
          );
        }
        break;

      case RouteNames.groupDetail:
        if (args is Map<String, dynamic>) {
          final groupId = args['groupId'] as String?;
          // Return group detail screen with groupId
          return MaterialPageRoute(
            builder:
                (_) => Scaffold(
                  body: Center(child: Text('Group Detail: $groupId')),
                ),
          );
        }
        break;

      case RouteNames.groupChat:
        if (args is Map<String, dynamic>) {
          final groupId = args['groupId'] as String?;
          // Return group chat screen with groupId
          return MaterialPageRoute(
            builder:
                (_) =>
                    Scaffold(body: Center(child: Text('Group Chat: $groupId'))),
          );
        }
        break;
    }

    // Fallback to regular route generation
    return generateRoute(settings);
  }
}

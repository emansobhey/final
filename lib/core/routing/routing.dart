import 'package:flutter/material.dart';
import 'package:gradprj/core/routing/routes.dart';
import 'package:gradprj/cubit/transcription_cubit.dart';
import 'package:gradprj/views/getStarted/screens/get_started.dart';
import 'package:gradprj/views/home/ui/screens/note_page.dart';
import 'package:gradprj/views/home/ui/screens/about.dart';
import 'package:gradprj/views/home/ui/screens/home.dart';
import 'package:gradprj/views/home/ui/screens/recording_screen.dart';
import 'package:gradprj/views/home/ui/screens/user_account.dart';
import 'package:gradprj/views/login/ui/screen/forget_password.dart';
import 'package:gradprj/views/login/ui/screen/login.dart';
import 'package:gradprj/views/sing_up/ui/screen/sing_up.dart';

import '../../test.dart' show AskQuestionScreen, QuestionPage;

class Routing {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.getStarted:
        return MaterialPageRoute(
            builder: (context) => const GetStartedScreen());
      case Routes.login:
        return MaterialPageRoute(builder: (context) => const Login());
      case Routes.singUp:
        return MaterialPageRoute(builder: (context) => const SignUp());
      case Routes.home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());

      case Routes.recording:
        return MaterialPageRoute(builder: (context) => const RecordingScreen());

      case Routes.forget_password:
        return MaterialPageRoute(
            builder: (context) => const ResetPasswordPage());
      case Routes.userProfile:
        return MaterialPageRoute(builder: (context) => ProfilePage());

      case Routes.about:
        return MaterialPageRoute(builder: (context) => about());
      // case Routes.AskQuestionScreen:
      //   return MaterialPageRoute(builder: (context) => QuestionPage());

      default:
        return MaterialPageRoute(builder: (context) => const NoRouteScreen());

    }
  }
}

class BlocProvider {}

class NoRouteScreen extends StatelessWidget {
  const NoRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("No Route Founde"),
      ),
    );
  }
}

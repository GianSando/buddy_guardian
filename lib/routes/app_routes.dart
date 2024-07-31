import 'package:buddy_guardian/routes/routes.dart';
import 'package:buddy_guardian/screens/login_and_register/login/login_page.dart';
import 'package:buddy_guardian/screens/splash_screen.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> get appRoutes {
  return {
    Routes.splash: (context) => const SplashScreen(),
    Routes.login: (context) => const LoginPage(),
  };
}

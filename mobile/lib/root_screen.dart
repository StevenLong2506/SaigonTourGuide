import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saigon_tour_guide/provider/auth_provider.dart';
import 'package:saigon_tour_guide/screen/login_screen.dart';
import 'package:saigon_tour_guide/screen/main_shell.dart';
import 'package:saigon_tour_guide/screen/onboarding_screen.dart';
import 'package:saigon_tour_guide/screen/splash_screen.dart';

class RootScreen extends StatelessWidget{
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, auth, _) {
      if (auth.loading) return const SplashScreen();
      if (auth.user == null) return const LoginScreen();
      if(auth.user!.interests.isEmpty && !auth.skippedOnboarding) return const OnboardingScreen();
      return const MainShell();
    });
  }
}
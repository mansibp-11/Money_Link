import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'onboarding_screen.dart';
import 'dashboard.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'loan_recommendations.dart';
import 'loan_eligibility.dart';
import 'loan_calculator.dart';
import 'firebase_options.dart';
import 'bank_selection_page.dart';
import 'loan_status_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance Recommender App',
      theme: ThemeData(
        primaryColor: Colors.cyan,
        colorScheme: const ColorScheme.light(
          primary: Colors.cyan,
          secondary: Colors.purpleAccent,
        ),
      ),
      // 🟢 Initial screen
      home: const OnboardingScreen(),

      // ✅ Named routes
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/dashboard': (context) => const Dashboard(),
        '/loan_recommendation': (context) => const LoanRecommendationPage(),
        '/loan_eligibility': (context) => const LoanEligibility(),
        '/loan_calculator': (context) => const LoanCalculator(),
      },
    );
  }
}

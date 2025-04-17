import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bank_selection_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loan Application App',
      theme: ThemeData(
        primaryColor: Colors.cyan,
        colorScheme: ColorScheme.light(
          primary: Colors.cyan,
          secondary: Colors.purpleAccent,
        ),
      ),
      home: const LoanRecommendationPage(),
    );
  }
}

class LoanRecommendationPage extends StatelessWidget {
  const LoanRecommendationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffea8aea), Color(0xff59e6ed)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Explore Loan Services",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: loanServices.length,
                    itemBuilder: (context, index) {
                      final loan = loanServices[index];
                      return loanServiceCard(
                        context,
                        loan["title"]!,
                        loan["icon"]!,
                        loan["color"]!,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget loanServiceCard(BuildContext context, String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BankSelectionPage(
              loanTitle: title,
              loanColor: color,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// Loan services data
final List<Map<String, dynamic>> loanServices = [
  {"title": "Home Loan", "icon": Icons.home, "color": Colors.orange},
  {"title": "Student Loan", "icon": Icons.school, "color": Colors.pink},
  {"title": "Business Loan", "icon": Icons.business, "color": Colors.blue},
  {"title": "Commercial Loan", "icon": Icons.apartment, "color": Colors.yellow},
  {"title": "Personal Loan", "icon": Icons.person, "color": Colors.pinkAccent},
  {"title": "Investment Loan", "icon": Icons.trending_up, "color": Colors.lightBlue},
  {"title": "Car Loan", "icon": Icons.directions_car, "color": Colors.amber},
  {"title": "Gold Loan", "icon": Icons.monetization_on, "color": Colors.purple},
  {"title": "Medical Loan", "icon": Icons.local_hospital, "color": Colors.blue},
  {"title": "Wedding Loan", "icon": Icons.favorite, "color": Colors.orangeAccent},
];

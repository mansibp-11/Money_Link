import 'package:flutter/material.dart';
import 'package:moneylink/loan_recommendations.dart';

class LoanEligibility extends StatefulWidget {
  const LoanEligibility({super.key});

  @override
  State<LoanEligibility> createState() => _LoanEligibilityState();
}

class _LoanEligibilityState extends State<LoanEligibility> {
  final TextEditingController incomeController = TextEditingController();
  final TextEditingController expensesController = TextEditingController();
  String eligibilityMessage = "";

  void checkEligibility() {
    double income = double.tryParse(incomeController.text) ?? 0;
    double expenses = double.tryParse(expensesController.text) ?? 0;
    double savings = income - expenses;

    if (savings > 5000) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoanRecommendationPage()),
      );
    } else {
      setState(() {
        eligibilityMessage = "Sorry, you are not eligible for a loan.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Loan Eligibility",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0061A8),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffea8aea), Color(0xff59e6ed)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Check Your Loan Eligibility",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: incomeController,
                label: "Monthly Income (₹)",
                icon: Icons.attach_money,
                color: const Color(0xFFAAE3E2),
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: expensesController,
                label: "Monthly Expenses (₹)",
                icon: Icons.money_off,
                color: const Color(0xFF0061A8),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: checkEligibility,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0061A8),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Check Eligibility",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                eligibilityMessage,
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        prefixIcon: Icon(icon, color: color),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: 3),
        ),
      ),
    );
  }
}

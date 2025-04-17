import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class LoanCalculator extends StatefulWidget {
  const LoanCalculator({super.key});

  @override
  _LoanCalculatorState createState() => _LoanCalculatorState();
}

class _LoanCalculatorState extends State<LoanCalculator> {
  double _loanAmount = 500000;
  double _interestRate = 9.5;
  double _loanTerm = 5;
  double _monthlyEMI = 0.0;
  double _totalInterest = 0.0;

  void _calculateLoan() {
    double P = _loanAmount;
    double r = _interestRate / (12 * 100);
    int n = (_loanTerm * 12).toInt();

    if (P > 0 && r > 0 && n > 0) {
      _monthlyEMI = (P * r * pow(1 + r, n)) / (pow(1 + r, n) - 1);
      _totalInterest = (_monthlyEMI * n) - P;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Loan EMI Calculator"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffea8aea),
              Color(0xff59e6ed)
            ], // Pink to Blue Gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "EMI Calculator",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),
              const SizedBox(height: 20),
              _buildSlider("Loan Amount (₹)", _loanAmount, 50000, 5000000, 100,
                  (val) => setState(() => _loanAmount = val)),
              _buildSlider("Interest Rate (%)", _interestRate, 1, 20, 19,
                  (val) => setState(() => _interestRate = val)),
              _buildSlider("Loan Tenure (Years)", _loanTerm, 1, 30, 29,
                  (val) => setState(() => _loanTerm = val)),
              const SizedBox(height: 20),
              SizedBox(height: 250, child: _buildPieChart()),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Monthly EMI: ₹${_monthlyEMI.toStringAsFixed(2)}",
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max,
      int divisions, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ${value.toStringAsFixed(0)}",
          style: const TextStyle(
              color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: value.toStringAsFixed(0),
          onChanged: onChanged,
          activeColor: Colors.deepPurpleAccent,
          inactiveColor: Colors.grey,
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            color: Colors.blueAccent,
            value: _loanAmount,
            title: "Principal",
            radius: 50,
            titleStyle: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          PieChartSectionData(
            color: Color(0xffe6722f),
            value: _totalInterest,
            title: "Interest",
            radius: 50,
            titleStyle: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: _calculateLoan,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          ),
          child: const Text("Calculate",
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: _showReportDialog,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xfff4882f),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          ),
          child: const Text("View Report",
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ],
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Loan EMI Report"),
          content: Text(
            "Loan Amount: ₹${_loanAmount.toStringAsFixed(0)}\n"
            "Interest Rate: ${_interestRate.toStringAsFixed(2)}%\n"
            "Loan Tenure: ${_loanTerm.toStringAsFixed(0)} years\n"
            "Monthly EMI: ₹${_monthlyEMI.toStringAsFixed(2)}\n"
            "Total Interest: ₹${_totalInterest.toStringAsFixed(2)}",
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close")),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loan_status_page.dart';

class LoanApplicationForm extends StatefulWidget {
  final String loanTitle;
  final Color loanColor;

  const LoanApplicationForm({
    Key? key,
    required this.loanTitle,
    required this.loanColor,
  }) : super(key: key);

  @override
  _LoanApplicationFormState createState() => _LoanApplicationFormState();
}

class _LoanApplicationFormState extends State<LoanApplicationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _incomeController = TextEditingController();
  String? _employmentStatus;
  String? _loanTerm;
  bool _agreeToTerms = false;
  String _loanStatus = 'Pending';

  final List<String> employmentStatuses = [
    'Employed',
    'Self-employed',
    'Unemployed',
  ];

  final List<String> loanTerms = ['6 months', '1 year', '2 years', '5 years'];

  String _getUsernameFromEmail(String? email) {
    if (email == null) return 'User';
    return email.split('@')[0];
  }

  Future<void> submitApplication() async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You must be logged in.")),
        );
        return;
      }

      final applicationData = {
        'userId': user.uid,
        'username': _getUsernameFromEmail(user.email),
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'loanAmount': _amountController.text,
        'monthlyIncome': _incomeController.text,
        'employmentStatus': _employmentStatus,
        'loanTerm': _loanTerm,
        'agreedToTerms': _agreeToTerms,
        'loanType': widget.loanTitle,
        'status': _loanStatus,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('loan_applications')
          .add(applicationData);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StatusPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Check if user is logged in
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Apply for ${widget.loanTitle}'),
          backgroundColor: widget.loanColor,
        ),
        body: const Center(child: Text("Please log in to apply.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Apply for ${widget.loanTitle}'),
        backgroundColor: widget.loanColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email Address'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your email' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your phone number' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Loan Amount'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter loan amount' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _incomeController,
                  decoration:
                      const InputDecoration(labelText: 'Monthly Income'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty
                      ? 'Please enter your monthly income'
                      : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _employmentStatus,
                  onChanged: (value) => setState(() => _employmentStatus = value),
                  decoration: const InputDecoration(labelText: 'Employment Status'),
                  items: employmentStatuses
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  validator: (value) =>
                      value == null ? 'Please select employment status' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _loanTerm,
                  onChanged: (value) => setState(() => _loanTerm = value),
                  decoration: const InputDecoration(labelText: 'Loan Term'),
                  items: loanTerms
                      .map((term) => DropdownMenuItem(
                            value: term,
                            child: Text(term),
                          ))
                      .toList(),
                  validator: (value) =>
                      value == null ? 'Please select a loan term' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) =>
                          setState(() => _agreeToTerms = value!),
                    ),
                    const Text('I agree to the terms and conditions'),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (!_agreeToTerms) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Terms and Conditions"),
                            content: const Text(
                                "You must agree to the terms and conditions before applying."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        );
                      } else {
                        await submitApplication();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.loanColor,
                  ),
                  child: const Text('Submit Application'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'loan_application_form.dart'; // Import the correct file for LoanApplicationForm

class BankSelectionPage extends StatelessWidget {
  final String loanTitle;
  final Color loanColor;

  const BankSelectionPage({
    Key? key,
    required this.loanTitle,
    required this.loanColor,
  }) : super(key: key);

  // Use const to make the list a compile-time constant
  final List<String> banks = const [
    'State Bank of India',
    'HDFC Bank',
    'ICICI Bank',
    'Axis Bank',
    'Punjab National Bank',
    'Bank of Baroda',
    'Kotak Mahindra Bank',
    'Canara Bank',
    'Union Bank of India',
    'IDFC FIRST Bank',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Bank for $loanTitle'),
        backgroundColor: loanColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: banks.length,
        itemBuilder: (context, index) {
          final bank = banks[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.account_balance),
              title: Text(bank),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoanApplicationForm(
                      loanTitle: '$loanTitle via $bank',
                      loanColor: loanColor,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

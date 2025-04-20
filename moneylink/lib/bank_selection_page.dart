import 'package:flutter/material.dart';
import 'loan_application_form.dart';

class BankSelectionPage extends StatelessWidget {
  final String loanTitle;
  final Color loanColor;

  const BankSelectionPage({
    Key? key,
    required this.loanTitle,
    required this.loanColor,
  }) : super(key: key);

  final List<Map<String, String>> banks = const [
    {'name': 'State Bank of India', 'logo': 'sbi.png'},
    {'name': 'HDFC Bank', 'logo': 'hdfc.png'},
    {'name': 'ICICI Bank', 'logo': 'icici.png'},
    {'name': 'Axis Bank', 'logo': 'axis.png'},
    {'name': 'Punjab National Bank', 'logo': 'pnb.png'},
    {'name': 'Bank of Baroda', 'logo': 'bob.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Bank for $loanTitle'),
        backgroundColor: loanColor,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDA70D6), Color(0xFF00BFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: banks.length,
          itemBuilder: (context, index) {
            final bank = banks[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.white.withOpacity(0.9),
              elevation: 6,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                leading: CircleAvatar(
                backgroundImage: AssetImage('assets/icons/${bank['logo']}'), // ✅ fixed
                radius: 24,
                backgroundColor: Colors.transparent,
                ),

                title: Text(
                  bank['name']!,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoanApplicationForm(
                        loanTitle: '$loanTitle via ${bank['name']}',
                        loanColor: loanColor,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

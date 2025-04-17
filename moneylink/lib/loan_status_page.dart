import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loan_application_form.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Loan Status'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDA70D6), Color(0xFF00BFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('loan_applications')
                  .where(
                    'userId',
                    isEqualTo: user?.uid,
                  ) // filtering by current user
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'You have no loan applications yet.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            }

            final loans = snapshot.data!.docs;

            return ListView.builder(
              itemCount: loans.length,
              itemBuilder: (context, index) {
                final loan = loans[index].data() as Map<String, dynamic>;

                // Extract timestamp
                final timestamp = (loan['timestamp'] as Timestamp?)?.toDate();
                final formattedDate =
                    timestamp != null
                        ? '${timestamp.day}/${timestamp.month}/${timestamp.year}'
                        : '';

                // Determine status icon and color
                IconData statusIcon;
                Color statusColor;

                switch (loan['status']) {
                  case 'Approved':
                    statusIcon = Icons.check_circle;
                    statusColor = Colors.green;
                    break;
                  case 'Rejected':
                    statusIcon = Icons.cancel;
                    statusColor = Colors.red;
                    break;
                  default:
                    statusIcon = Icons.hourglass_empty;
                    statusColor = Colors.orange;
                }

                return Card(
                  color: Colors.white.withOpacity(0.9),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(statusIcon, color: statusColor, size: 36),
                    title: Text(
                      '${loan['loanType']} - ₹${loan['loanAmount']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      'Applied on: $formattedDate',
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: Text(
                      loan['status'],
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  String selectedFilter = 'All';
  final List<String> statusOptions = ['All', 'Pending', 'Approved', 'Rejected'];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = FirebaseAuth.instance.currentUser?.uid;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Filter by status:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // 🔽 Filter ChoiceChips
            Wrap(
              spacing: 8,
              children: statusOptions.map((status) {
                return ChoiceChip(
                  label: Text(status),
                  selected: selectedFilter == status,
                  onSelected: (_) {
                    setState(() {
                      selectedFilter = status;
                    });
                  },
                  selectedColor: Colors.deepPurple,
                  labelStyle: TextStyle(
                    color: selectedFilter == status ? Colors.white : Colors.black,
                  ),
                  backgroundColor: Colors.white,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // 📑 Loan List Section
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('loan_applications')
                    .where('userId', isEqualTo: userId)
                    .orderBy('timestamp', descending: true)
                    .limit(5)
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

                  final loans = snapshot.data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .where((loan) =>
                          selectedFilter == 'All' ||
                          loan['status'] == selectedFilter)
                      .toList();

                  if (loans.isEmpty) {
                    return const Center(
                      child: Text(
                        'No applications for this status.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: loans.length,
                    itemBuilder: (context, index) {
                      final loan = loans[index];
                      final loanType = loan['loanType'] ?? 'Unknown';
                      final amount = loan['loanAmount'] ?? '0';
                      final status = loan['status'] ?? 'Pending';
                      final timestamp = (loan['timestamp'] as Timestamp?)?.toDate();
                      final formattedDate = timestamp != null
                          ? '${timestamp.day}/${timestamp.month}/${timestamp.year}'
                          : 'No date';

                      IconData statusIcon;
                      Color statusColor;

                      switch (status) {
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Icon(statusIcon, color: statusColor, size: 36),
                          title: Text(
                            '$loanType - ₹$amount',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            'Applied on: $formattedDate\nStatus: $status',
                            style: const TextStyle(fontSize: 14),
                          ),
                          trailing: Text(
                            status,
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
          ],
        ),
      ),
    );
  }
}

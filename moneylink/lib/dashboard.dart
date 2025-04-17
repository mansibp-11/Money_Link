import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moneylink/loan_calculator.dart';
import 'package:moneylink/loan_eligibility.dart';
import 'package:moneylink/loan_recommendations.dart' as loan;
import 'loan_status_page.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      drawer: _buildSidebar(context, user),
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDA70D6), Color(0xFF00BFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/images/profile.jpg"),
                  radius: 24,
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hi, sneha@gmail.com 👋", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text("Welcome back!", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                _buildShortcut(context, Icons.edit, 'Apply Loan', Colors.purpleAccent, loan.LoanRecommendationPage()),
                _buildShortcut(context, Icons.calendar_today, 'Check Status', Colors.blueAccent, const StatusPage()),
                _buildShortcut(context, Icons.calculate, 'Calculator', Colors.green, const LoanCalculator()),
                _buildShortcut(context, Icons.check_circle, 'Eligibility', Colors.orange, const LoanEligibility()),
                _buildShortcut(context, Icons.recommend, 'Recommendations', Colors.teal, loan.LoanRecommendationPage()),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Recent Loan Applications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            const Expanded(child: RecentLoansSection()),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcut(BuildContext context, IconData icon, String title, Color color, Widget page) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, User? user) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          _buildSidebarHeader(user),
          const Divider(),
          _buildSidebarItem(Icons.check_circle, "Loan Eligibility", context, const LoanEligibility()),
          _buildSidebarItem(Icons.money, "Loan Recommendations", context, loan.LoanRecommendationPage()),
          _buildSidebarItem(Icons.calculate, "Loan Calculator", context, const LoanCalculator()),
          const Spacer(),
          _buildSidebarItem(Icons.logout, "Logout", context, null),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, BuildContext context, Widget? page) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        if (page != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        }
      },
    );
  }

  Widget _buildSidebarHeader(User? user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const CircleAvatar(radius: 30, backgroundImage: AssetImage("assets/images/profile.jpg")),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(user?.displayName ?? user?.email ?? "User", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text("Priority Account", style: TextStyle(fontSize: 14, color: Colors.grey)),
          ]),
        ],
      ),
    );
  }
}

class RecentLoansSection extends StatelessWidget {
  const RecentLoansSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('loan_applications')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text('No recent loans found.',
                  style: TextStyle(color: Colors.white)));
        }

        final loans = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: loans.length,
          itemBuilder: (context, index) {
            final loan = loans[index].data() as Map<String, dynamic>;

            // Extract timestamp safely
            final timestamp = (loan['timestamp'] as Timestamp?)?.toDate();
            final formattedDate = timestamp != null
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
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: Icon(
                  statusIcon,
                  color: statusColor,
                  size: 36,
                ),
                title: Text(
                  '${loan['loanType']} - ₹${loan['amount']}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                  'Name: ${loan['name']}',
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      loan['status'],
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedDate,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// Placeholder pages (to prevent errors)
class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Loan Status Page")),
    );
  }
}

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Help Page")),
    );
  }
}

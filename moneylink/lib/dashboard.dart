import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moneylink/loan_calculator.dart';
import 'package:moneylink/loan_eligibility.dart';
import 'package:moneylink/loan_recommendations.dart' as loan;
import 'loan_status_page.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);


  String _getUsernameFromEmail(String? email) {
    if (email == null) return 'User';
    return email.split('@')[0];
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final username = _getUsernameFromEmail(user?.email);
    final userId = FirebaseAuth.instance.currentUser?.uid;

   // Inside your build method:
return Scaffold(
  drawer: _buildSidebar(context, user),
  appBar: AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: const Text(
      'Dashboard',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    actions: const [
      Padding(
        padding: EdgeInsets.only(right: 16.0),
        child: Icon(Icons.notifications_none, color: Colors.white),
      ),
    ],
  ),
  extendBodyBehindAppBar: true,
  body: Container(
  width: double.infinity,
  height: double.infinity,
  decoration: const BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xffea8aea), Color(0xff59e6ed)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  child: SafeArea(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 30), // ⬅️ Added bottom padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage("assets/images/profile.jpg"),
                  radius: 24,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    Text(
                      "Hi, ${_getUsernameFromEmail(user?.email)} 👋",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Welcome back!",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
              children: [
                _buildShortcut(context, "Check Status", "assets/icons/status.png", const StatusPage()),
                _buildShortcut(context, "Calculator", "assets/icons/calculator.jpg", const LoanCalculator()),
                _buildShortcut(context, "Eligibility", "assets/icons/eligibility.png", const LoanEligibility()),
                _buildShortcut(context, "Recommendation", "assets/icons/apply.png", loan.LoanRecommendationPage()),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Recent Loan Applications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),
            const RecentLoansSection(),
          ],
        ),
      ),
    ),
  ),
),

);

  }

  Widget _buildShortcut(BuildContext context, String title, String iconPath, Widget page) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Colors.white, Colors.white70],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Image.asset(iconPath, width: 30, height: 30),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, User? user) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
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
    leading: Icon(icon, color: Colors.deepPurple),
    title: Text(title),
    onTap: () async {
      Navigator.pop(context); // Close the sidebar

      if (title == 'Logout') {
        // Sign out the user
        await FirebaseAuth.instance.signOut();
        // Navigate to login screen
        Navigator.pushReplacementNamed(context, '/login');
      } else if (page != null) {
        // Navigate to other pages in the sidebar
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
          const CircleAvatar(radius: 24, backgroundImage: AssetImage("assets/images/profile.jpg")),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              _getUsernameFromEmail(user?.email),
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const Text("Priority Account", style: TextStyle(fontSize: 13, color: Colors.grey)),
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
    
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Text("No user signed in", style: TextStyle(color: Colors.white));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('loan_applications')
          .where('userId', isEqualTo: userId)  // Query by email instead of userId
          .orderBy('timestamp', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text(
            "No recent loan applications found.",
            style: TextStyle(color: Colors.white70),
          );
        }

        final loans = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        return Column(
          children: loans.map((loan) {
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
                statusColor = const Color.fromARGB(255, 0, 59, 2);
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
              color: Colors.white.withOpacity(0.1),
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: Icon(statusIcon, color: statusColor),
                title: Text(
                  '$loanType - ₹$amount',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Applied on: $formattedDate\nStatus: $status',
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: Text(
                  status,
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

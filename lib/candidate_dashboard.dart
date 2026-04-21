import 'package:flutter/material.dart';
import 'models/user_model.dart';
import 'post_job.dart';

class CandidateDashboard extends StatelessWidget {
  const CandidateDashboard({
    super.key,
    this.isAdminView = false,
  });

  final bool isAdminView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: isAdminView
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.blue),
                onPressed: () => Navigator.pop(context),
              )
            : const Icon(Icons.menu, color: Colors.blue),
        title: Text(
          isAdminView ? 'Candidate Dashboard (Admin)' : 'Smart Hire',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: const Icon(Icons.notifications, color: Colors.blue),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder<String>(
              valueListenable: currentUserName,
              builder: (context, name, _) {
                return Text(
                  isAdminView ? 'Welcome Admin!' : 'Welcome $name!',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              isAdminView
                  ? "Here's the candidate pipeline overview for admin review."
                  : "Here's what's happening with your job search.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Stats Row
            Row(
              children: [
                _buildStatCard(
                    'APPLIED JOBS', '12', Icons.description, Colors.blue),
                const SizedBox(width: 16),
                _buildStatCard('INTERVIEWS', '4', Icons.videocam, Colors.green),
              ],
            ),
            const SizedBox(height: 24),

            // Profile Completion Card
            if (!isAdminView) _buildProfileCompletionCard(),
            if (isAdminView) _buildAdminCandidateInsightCard(),
            if (isAdminView) const SizedBox(height: 16),
            if (isAdminView)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PostJobPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.campaign_outlined),
                  label: const Text('Post Job'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E6AFB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 32),

            // Recommended Header
            if (!isAdminView) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recommended for you',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Recommended List
              _buildRecommendedJob(
                'Senior Product Designer',
                'TechFlow Inc. • Remote',
                const Color(0xFF1A3D37),
                false,
              ),
              _buildRecommendedJob(
                'Frontend Developer',
                'Stripeify • New York',
                const Color(0xFFC19A6B),
                true,
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (index) {
          if (!isAdminView) {
            return;
          }

          if (index == 0) {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          }
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: isAdminView
            ? const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.groups_outlined), label: 'Candidates'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.how_to_reg_outlined),
                    label: 'Shortlisted'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.analytics_outlined), label: 'Analytics'),
              ]
            : const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: 'Search'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.bookmark), label: 'Saved'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Profile'),
              ],
      ),
    );
  }

  Widget _buildStatCard(
      String label, String count, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 16),
            Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(count,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCompletionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Profile Completion',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('85%',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.85,
              minHeight: 8,
              backgroundColor: Color(0xFFF0F0F0),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Almost there! Complete your portfolio and skills section to stand out to more recruiters.',
            style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: const Text('Complete Profile'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedJob(
      String title, String subtitle, Color logoBg, bool isSaved) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: logoBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                const Icon(Icons.work_outline, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                Text(subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          Icon(
            isSaved ? Icons.bookmark : Icons.bookmark_border,
            color: isSaved ? Colors.blue : Colors.grey[300],
          ),
        ],
      ),
    );
  }

  Widget _buildAdminCandidateInsightCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Admin Insight',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          const Text(
            'Use this view to review candidate activity and shortlisted matches from bulk upload.',
            style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildMiniPill('Shortlisted', Colors.green),
              const SizedBox(width: 8),
              _buildMiniPill('Under Review', Colors.orange),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMiniPill(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'admin_resume upload.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Admin Portal',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              onPressed: () {}),
          const CircleAvatar(radius: 15, backgroundColor: Colors.blue),
          const SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome back, Admin',
                style: TextStyle(color: Colors.grey)),
            const Text('Hiring Overview',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 25),

            // Metrics Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.2,
              children: [
                _buildStatCard(
                    'Total Jobs', '12', Icons.work_outline, Colors.blue),
                _buildStatCard('New Resumes', '85', Icons.description_outlined,
                    Colors.orange),
                _buildStatCard(
                    'Shortlisted', '24', Icons.star_outline, Colors.green),
                _buildStatCard(
                    'Rejected', '08', Icons.cancel_outlined, Colors.red),
              ],
            ),

            const SizedBox(height: 30),
            const Text('Bulk Resume Upload',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            // Upload Box
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminResumeUpload(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.cloud_upload_outlined,
                        color: Colors.blue, size: 40),
                    const SizedBox(height: 10),
                    const Text('Upload resumes to start AI parsing.',
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminResumeUpload(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E6AFB)),
                      child: const Text('Select Files',
                          style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
            const Text('Recent Activity',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildStatusItem(
                'john_doe_cv.pdf', 'PARSING...', 0.75, Colors.blue),
            _buildStatusItem('alex_chen.pdf', 'COMPLETE', 1.0, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 10),
          Text(count,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildStatusItem(
      String name, String status, double progress, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.description_outlined),
        title: Text(name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: LinearProgressIndicator(
            value: progress, color: color, backgroundColor: Colors.grey[100]),
        trailing: Text(status,
            style: TextStyle(
                color: color, fontSize: 10, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

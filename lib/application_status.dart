import 'package:flutter/material.dart';
import 'candidate_dashboard.dart';
import 'models/applied_jobs.dart';

class ApplicationStatusPage extends StatefulWidget {
  const ApplicationStatusPage({super.key});

  @override
  State<ApplicationStatusPage> createState() => _ApplicationStatusPageState();
}

class _ApplicationStatusPageState extends State<ApplicationStatusPage> {
  int _selectedIndex = 2;

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const CandidateDashboard(),
        ),
      );
    }
  }

  String _formatRelativeTime(DateTime time) {
    final duration = DateTime.now().difference(time);
    if (duration.inMinutes < 60) return '${duration.inMinutes}m ago';
    if (duration.inHours < 24) return '${duration.inHours}h ago';
    return '${duration.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1, // Set to 'Active' by default
      child: Scaffold(
        backgroundColor:
            const Color(0xFFF8F9FA), // Slightly off-white background
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Smart Hire',
            style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black87),
              onPressed: () {},
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.blue,
            indicatorWeight: 3,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Active'),
              Tab(text: 'Archived'),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Text(
                'Application Status',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<List<AppliedJob>>(
                valueListenable: appliedJobsNotifier,
                builder: (context, appliedJobs, _) {
                  if (appliedJobs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No applied jobs yet. Apply to a job to see it here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: appliedJobs.length,
                    itemBuilder: (context, index) {
                      final job = appliedJobs[index];
                      return StatusCard(
                        title: job.title,
                        company: job.company,
                        location: job.location,
                        status: 'Applied',
                        statusColor: Colors.blue,
                        updateTime:
                            'Applied ${_formatRelativeTime(job.appliedAt)}',
                        logoColor: Colors.blue.shade50,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onNavItemTapped,
          selectedItemColor: Colors.blue[700],
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: 'HOME'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'SEARCH'),
            BottomNavigationBarItem(icon: Icon(Icons.work), label: 'APPLIED'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: 'PROFILE'),
          ],
        ),
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final String title, company, location, status, updateTime;
  final Color statusColor, logoColor;

  const StatusCard({
    super.key,
    required this.title,
    required this.company,
    required this.location,
    required this.status,
    required this.statusColor,
    required this.updateTime,
    required this.logoColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: logoColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: const Icon(Icons.business, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text('$company · $location',
                        style:
                            TextStyle(color: Colors.grey[500], fontSize: 13)),
                  ],
                ),
              ),
              Icon(Icons.more_vert, color: Colors.blue[400], size: 20),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 4, backgroundColor: statusColor),
                  const SizedBox(width: 8),
                  Text(status,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.black54)),
                ],
              ),
              Text(updateTime,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }
}

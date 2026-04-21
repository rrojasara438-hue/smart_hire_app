import 'package:flutter/material.dart';
import 'application_status.dart';
import 'models/applied_jobs.dart';

class JobListingPage extends StatefulWidget {
  const JobListingPage({super.key});

  @override
  State<JobListingPage> createState() => _JobListingPageState();
}

class _JobListingPageState extends State<JobListingPage> {
  int _selectedIndex = 0;

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 2) {
      // Navigate to the application status page from the "Applied" tab
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ApplicationStatusPage(),
        ),
      );
      return;
    }

    // TODO: Replace with real navigation for other tabs
    final tabs = ['Jobs', 'Saved', 'Applied', 'Profile'];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected tab: ${tabs[index]}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black54),
        title: const Text(
          'Smart Hire',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: ValueListenableBuilder<List<AppliedJob>>(
              valueListenable: appliedJobsNotifier,
              builder: (context, appliedJobs, _) {
                bool isApplied(String title, String company) {
                  return appliedJobs.any(
                    (j) => j.title == title && j.company == company,
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    JobCard(
                      title: 'Senior Product Designer',
                      company: 'Design Inc.',
                      location: 'Mavdi,Rajkot Gujarat',
                      description:
                          'We are looking for a visionary designer to lead our creative team and shape the future of ou...',
                      salary: '2 LPA - 3 LPA',
                      imageUrl:
                          'https://images.unsplash.com/photo-1497366216548-37526070297c?q=80&w=400',
                      isApplied:
                          isApplied('Senior Product Designer', 'Design Inc.'),
                    ),
                    JobCard(
                      title: 'Frontend Engineer',
                      company: 'TechFlow',
                      location: 'Remote',
                      description:
                          'Expertise in React and Tailwind CSS required for building highly scalable and performant ...',
                      salary: '8 LPA',
                      imageUrl:
                          'https://images.unsplash.com/photo-1587620962725-abab7fe55159?q=80&w=400',
                      isApplied: isApplied('Frontend Engineer', 'TechFlow'),
                    ),
                    JobCard(
                      title: 'Growth Marketing Manager',
                      company: 'Scalr.io',
                      location: 'Sheetal park, Rajkot',
                      description:
                          'Join our growth team to drive user acquisition and retention through data-driven...',
                      salary: '12 LPA',
                      imageUrl:
                          'https://images.unsplash.com/photo-1522071820081-009f0129c71c?q=80&w=400',
                      isApplied:
                          isApplied('Growth Marketing Manager', 'Scalr.io'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.work_outline), label: 'JOBS'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border), label: 'SAVED'),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline), label: 'APPLIED'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'PROFILE'),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          _filterChip('All Jobs', isActive: true),
          const SizedBox(width: 8),
          _filterChip('Remote'),
          const SizedBox(width: 8),
          _filterChip('Full-time'),
        ],
      ),
    );
  }

  Widget _filterChip(String label, {bool isActive = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue[600] : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: isActive ? Colors.white : Colors.black54,
              size: 18,
            )
          ],
        ),
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final String title, company, location, description, salary, imageUrl;
  final bool isApplied;

  const JobCard({
    super.key,
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    required this.salary,
    required this.imageUrl,
    this.isApplied = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(imageUrl,
                height: 160, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('$company • $location',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                const SizedBox(height: 12),
                Text(description,
                    style: TextStyle(color: Colors.grey[600], height: 1.4)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(salary,
                          style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold)),
                    ),
                    ElevatedButton(
                      onPressed: isApplied
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JobDetailsPage(
                                    title: title,
                                    company: company,
                                    location: location,
                                    description: description,
                                    salary: salary,
                                    imageUrl: imageUrl,
                                  ),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isApplied ? Colors.grey[400] : Colors.blue[600],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: Text(
                        isApplied ? 'Applied' : 'Apply Now',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class JobDetailsPage extends StatelessWidget {
  final String title, company, location, description, salary, imageUrl;

  const JobDetailsPage({
    super.key,
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    required this.salary,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(imageUrl,
                height: 220, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('$company • $location',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  const SizedBox(height: 16),
                  Text('Salary: $salary',
                      style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  const Text('Job Description',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(description,
                      style: TextStyle(color: Colors.grey[700], height: 1.4)),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        applyForJob(
                          AppliedJob(
                            title: title,
                            company: company,
                            location: location,
                            description: description,
                            salary: salary,
                            imageUrl: imageUrl,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Applied successfully')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Apply Now',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

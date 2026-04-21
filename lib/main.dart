import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'create_account.dart';
import 'candidate_login.dart';
import 'models/user_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final bool isAndroidPlatform =
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  if (isAndroidPlatform) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(const SmartHireApp());
}

class SmartHireApp extends StatelessWidget {
  const SmartHireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Smart Hire",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        '/create-account': (context) => const CreateAccountScreen(),
        '/login': (context) => const CandidateLogin(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final Map<String, List<_HiringGroup>> _hiringData = {
    "Job Titles": const [
      _HiringGroup(
        title: "Software Engineer",
        subtitle: "Backend, Mobile, and Full Stack roles",
        openings: 24,
      ),
      _HiringGroup(
        title: "Product Designer",
        subtitle: "UI/UX and interaction design roles",
        openings: 11,
      ),
      _HiringGroup(
        title: "Data Analyst",
        subtitle: "Business analytics and reporting roles",
        openings: 9,
      ),
    ],
    "Skills": const [
      _HiringGroup(
        title: "Flutter",
        subtitle: "Cross-platform app development",
        openings: 18,
      ),
      _HiringGroup(
        title: "Python",
        subtitle: "Automation, API, and data projects",
        openings: 27,
      ),
      _HiringGroup(
        title: "React",
        subtitle: "Frontend web application roles",
        openings: 21,
      ),
    ],
    "Companies": const [
      _HiringGroup(
        title: "TechFlow Inc",
        subtitle: "Product and engineering teams hiring",
        openings: 14,
      ),
      _HiringGroup(
        title: "ScaleUp AI",
        subtitle: "AI, data, and backend opportunities",
        openings: 10,
      ),
      _HiringGroup(
        title: "DesignHub Labs",
        subtitle: "Design and brand roles open",
        openings: 7,
      ),
    ],
  };

  void _openCategoryHiring(BuildContext context, String category) {
    if (!isUserRegistered.value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please create account first")),
      );
      Navigator.pushNamed(context, '/create-account');
      return;
    }

    final groups = _hiringData[category] ?? const <_HiringGroup>[];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryHiringPage(
          category: category,
          groups: groups,
        ),
      ),
    );
  }

  void _showSearchCategorySheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ListTile(
                  title: Text(
                    "Browse Open Hiring",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.work_outline),
                  title: const Text("Job Title Wise Hiring"),
                  onTap: () {
                    Navigator.pop(context);
                    _openCategoryHiring(context, "Job Titles");
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.psychology_outlined),
                  title: const Text("Skill Wise Hiring"),
                  onTap: () {
                    Navigator.pop(context);
                    _openCategoryHiring(context, "Skills");
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.apartment_outlined),
                  title: const Text("Company Wise Hiring"),
                  onTap: () {
                    Navigator.pop(context);
                    _openCategoryHiring(context, "Companies");
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Hire"),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE CARD
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  image: NetworkImage(
                      "https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg?auto=compress&cs=tinysrgb&w=1200"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black54],
                  ),
                ),
                child: const Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Chip(
                      label: Text("Smart Hire AI Match: 98%"),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// TITLE
            const Text(
              "Find Your Dream Job",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Let our advanced AI match you with the perfect role based on your unique skills and career passion.",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            /// GET STARTED BUTTON
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Get Started"),
                    onPressed: () {
                      /// GO TO CREATE ACCOUNT
                      Navigator.pushNamed(context, '/create-account');
                    },
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.play_circle_outline),
                  onPressed: () {},
                )
              ],
            ),

            const SizedBox(height: 20),

            /// SEARCH BOX
            TextField(
              readOnly: true,
              onTap: () => _showSearchCategorySheet(context),
              decoration: InputDecoration(
                hintText: "Job titles, skills, or companies",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            const SizedBox(height: 25),

            /// FEATURED OPPORTUNITIES
            Row(
              children: const [
                Expanded(
                  child: Text(
                    "Featured Opportunities",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Text(
                  "See all",
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),

            const SizedBox(height: 15),

            /// JOB CARD 1
            jobCard(
              "Senior Product Designer",
              "TechFlow Inc • Remote",
              "\$140K - \$180K",
              context,
            ),

            const SizedBox(height: 10),

            /// JOB CARD 2
            jobCard(
              "Backend Engineer (Go)",
              "ScaleUp AI • Hybrid",
              "\$160K - \$210K",
              context,
            ),
          ],
        ),
      ),

      /// BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Explore",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: "Jobs",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  /// JOB CARD WIDGET
  Widget jobCard(
      String title, String company, String salary, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.work_outline),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    company,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  salary,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text("Apply"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/create-account');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryHiringPage extends StatelessWidget {
  final String category;
  final List<_HiringGroup> groups;

  const CategoryHiringPage({
    super.key,
    required this.category,
    required this.groups,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$category Hiring"),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final group = groups[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(group.subtitle),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Chip(
                        label: Text("${group.openings} Open"),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/create-account');
                        },
                        child: const Text("Apply"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: groups.length,
      ),
    );
  }
}

class _HiringGroup {
  final String title;
  final String subtitle;
  final int openings;

  const _HiringGroup({
    required this.title,
    required this.subtitle,
    required this.openings,
  });
}

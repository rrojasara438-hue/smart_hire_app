import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'candidate_dashboard.dart';
import 'job_listing.dart';

class ResumeUploadPage extends StatefulWidget {
  const ResumeUploadPage({super.key});

  @override
  State<ResumeUploadPage> createState() => _ResumeUploadPageState();
}

class _ResumeUploadPageState extends State<ResumeUploadPage> {
  int _selectedIndex = 2;
  String? _pickedFileName;

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CandidateDashboard()),
      );
      return;
    }

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const JobListingPage()),
      );
      return;
    }
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: false,
    );

    if (result == null || result.files.isEmpty) return;

    final pickedFileName = result.files.single.name;
    if (!mounted) return;

    setState(() {
      _pickedFileName = pickedFileName;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected file: $_pickedFileName')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Resume Upload',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Header Logo/Icon
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.description,
                        color: Colors.blue, size: 40),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Smart Hire',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Let our AI analyze your skills and match you with the perfect role.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Upload Box (Dashed Area)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.3),
                  width: 1.5,
                  style: BorderStyle
                      .solid, // Use dotted_border package for true dots
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue[50],
                    child: const Icon(Icons.cloud_upload,
                        color: Colors.blue, size: 30),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Drag & drop resume here',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'PDF, DOCX up to 5MB',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _pickPdf,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      minimumSize: const Size(200, 48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      shadowColor: Colors.blue.withOpacity(0.4),
                    ),
                    child: const Text('Browse Files',
                        style: TextStyle(color: Colors.white)),
                  ),
                  if (_pickedFileName != null) ...[
                    const SizedBox(height: 12),
                    Text('Selected: $_pickedFileName',
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Info Alert Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50]?.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info, color: Colors.blue, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        const Text('Ready for upload',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        const Text(
                            'Select a file to begin the parsing process.',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black54)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Upload Tips
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Upload Tips',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                _buildTipRow('Use a clean, single-column layout'),
                const SizedBox(height: 12),
                _buildTipRow('Include relevant keywords for your industry'),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.work_outline), label: 'Jobs'),
          BottomNavigationBarItem(
              icon: Icon(Icons.file_upload), label: 'Upload'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildTipRow(String tip) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: Colors.blue, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            tip,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

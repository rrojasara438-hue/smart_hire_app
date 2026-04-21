import 'package:flutter/material.dart';

class CandidateManagementScreen extends StatelessWidget {
  const CandidateManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Candidates',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF6366F1),
        elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Stats Cards - Mobile Stacked
          _buildStatCard('Total Applications', '1,240', Colors.blue),
          SizedBox(height: 12),
          _buildStatCard('Shortlisted', '450', Color(0xFF10B981)),
          SizedBox(height: 12),
          _buildStatCard('Interviews', '84', Color(0xFFF59E0B)),
          SizedBox(height: 12),
          _buildStatCard('Hired', '78/100', Color(0xFF8B5CF6)),
          
          SizedBox(height: 24),
          
          // Table Header
          Row(
            children: [
              Expanded(flex: 4, child: Text('Candidates', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700]))),
              Expanded(child: Text('Exp', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700]))),
              Expanded(child: Text('Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700]))),
            ],
          ),
          SizedBox(height: 16),
          
          // Candidates List
          _buildCandidateRowMobile('Sarah Chen', 'Male', '5 yrs', Colors.orange, 'Shortlisted', true),
          _buildCandidateRowMobile('Ali Johnson', 'Female', '3 yrs', Colors.green, 'Interview', false),
          _buildCandidateRowMobile('Marcus Reed', 'Male', '8 yrs', Colors.blue, 'Hired', false),
          _buildCandidateRowMobile('Lena Schmitt', 'Female', '4 yrs', Colors.red, 'Rejected', true),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildCandidateRowMobile(String name, String gender, String exp, Color statusColor, String status, bool hasFlag) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Name & Gender
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFF6366F1).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person, color: Color(0xFF6366F1), size: 20),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      Text(gender, style: TextStyle(fontSize: 13, color: Colors.grey[500])),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            // Experience & Status
            Row(
              children: [
                Expanded(child: Text('Exp: $exp', style: TextStyle(fontWeight: FontWeight.w500))),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: statusColor)),
                ),
                if (hasFlag) ...[
                  SizedBox(width: 8),
                  Icon(Icons.flag, color: Colors.red[400], size: 16),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TemplateOne extends StatelessWidget {
  final Map<String, dynamic> data;

  const TemplateOne({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // الجانب الأيسر (السايد بار الملون)
          Container(
            width: 140,
            color: const Color(0xFF6C7AB5),
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 40),
                
                _buildSidebarSection("CONTACT", ""),
                _buildContactItem(Icons.phone, data['phone'] ?? ""),
                _buildContactItem(Icons.email, data['email'] ?? ""),
                _buildContactItem(Icons.location_on, data['address'] ?? ""),
                
                const SizedBox(height: 30),
                _buildSidebarSection("PROFILE", data['summary'] ?? ""),
                
                const SizedBox(height: 30),
                _buildSidebarSection("SKILLS", data['skills']), 
              ],
            ),
          ),
          
          // الجانب الأيمن (المحتوى الأساسي)
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (data['name'] ?? "YOUR NAME").toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold, 
                      color: Color(0xFF6C7AB5),
                    ),
                  ),
                  Text(
                    (data['job_title'] ?? "Job Title").toUpperCase(),
                    style: const TextStyle(fontSize: 14, color: Colors.black54, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 30),
                  
                  _buildMainSection("WORK EXPERIENCE", data['experience']),
                  const SizedBox(height: 20),
                  _buildMainSection("EDUCATION", data['education']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 9),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarSection(String title, dynamic content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
        const Divider(color: Colors.white54, thickness: 1),
        const SizedBox(height: 5),
        if (content is String && content.isNotEmpty)
          Text(content, style: const TextStyle(color: Colors.white, fontSize: 10, height: 1.4))
        else if (content is List)
          ...content.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text("• ${item.toString()}", style: const TextStyle(color: Colors.white, fontSize: 10)),
          )).toList(),
      ],
    );
  }

  Widget _buildMainSection(String title, dynamic content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C7AB5))),
        const Divider(color: Color(0xFF6C7AB5), thickness: 1),
        const SizedBox(height: 8),
        if (content is String && content.isNotEmpty)
          Text(content, style: const TextStyle(fontSize: 11, color: Colors.black87))
        else if (content is List)
          ...content.map((item) {
            if (item is Map) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['role'] ?? '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    Text("${item['company'] ?? ''} | ${item['years'] ?? ''}", style: const TextStyle(fontSize: 10, color: Colors.black54)),
                  ],
                ),
              );
            }
            return Text("• ${item.toString()}", style: const TextStyle(fontSize: 11));
          }).toList(),
      ],
    );
  }
}
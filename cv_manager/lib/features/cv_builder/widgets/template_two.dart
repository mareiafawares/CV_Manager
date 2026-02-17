import 'package:flutter/material.dart';

class TemplateTwo extends StatelessWidget {
  final Map<String, dynamic> data;

  const TemplateTwo({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        color: const Color(0xFFF3E5F5), 
        child: Column(
          children: [
           
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              color: const Color(0xFF7E57C2), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (data['name'] ?? "MAJIDA ZUUR").toUpperCase(),
                    style: const TextStyle(
                      fontSize: 28, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    (data['job_title'] ?? "Job Title").toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Container(
                    width: 150,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("PROFILE"),
                        Text(
                          data['summary'] ?? "Professional summary details...",
                          style: const TextStyle(fontSize: 10, height: 1.5),
                        ),
                        const SizedBox(height: 30),
                        _buildSectionTitle("CONTACT"),
                        _buildContactItem(Icons.phone, data['phone'] ?? ""),
                        _buildContactItem(Icons.email, data['email'] ?? ""),
                      ],
                    ),
                  ),
                  
                
                  Container(width: 1, color: Colors.purple.withOpacity(0.2)),
                  
                  
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMainSection("Education", data['education']),
                          const SizedBox(height: 25),
                          
                          _buildMainSection("Skills", data['skills']),
                          const SizedBox(height: 25),
                          _buildMainSection("Work Experience", data['experience']),
                        ],
                      ),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF7E57C2),
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 12, color: const Color(0xFF7E57C2)),
          const SizedBox(width: 5),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 9))),
        ],
      ),
    );
  }


  Widget _buildMainSection(String title, dynamic content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF7E57C2)),
        ),
        const Divider(color: Color(0xFF7E57C2), thickness: 1.5),
        const SizedBox(height: 5),
        
        if (content is String)
          Text(content, style: const TextStyle(fontSize: 11, height: 1.4))
        else if (content is List)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: content.map((item) {
              if (item is Map) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['role'] ?? item['degree'] ?? '', 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                      Text("${item['company'] ?? item['school'] ?? ''} | ${item['years'] ?? ''}",
                          style: const TextStyle(fontSize: 10, color: Colors.black54)),
                    ],
                  ),
                );
              }
              return Text("• ${item.toString()}", style: const TextStyle(fontSize: 11, height: 1.4));
            }).toList(),
          )
        else
          const Text("No details provided", style: TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
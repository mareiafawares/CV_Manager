import 'package:flutter/material.dart';

class TemplateThree extends StatelessWidget {
  final Map<String, dynamic> data;

  const TemplateThree({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // الجانب الأيسر (البرتقالي)
          Container(
            width: 150,
            color: const Color(0xFFD35400),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  (data['name'] ?? "ANGELA GEEN").toUpperCase(),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  (data['job_title'] ?? "IT DEVELOPER").toUpperCase(),
                  style: const TextStyle(fontSize: 11, color: Colors.white70),
                ),
                const SizedBox(height: 30),
                
                _buildSidebarSection("RELEVANT SKILLS", data['skills']),
                
                const Spacer(),
                _buildContactInfo(Icons.phone, data['phone'] ?? ""),
                _buildContactInfo(Icons.email, data['email'] ?? ""),
              ],
            ),
          ),

          // الجانب الأيمن (المحتوى الأساسي)
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderTitle("WORK EXPERIENCES"),
                  const SizedBox(height: 10),
                  _buildContentBody(data['experience']),
                  
                  const SizedBox(height: 25),
                  _buildHeaderTitle("EDUCATIONS"),
                  const SizedBox(height: 10),
                  _buildContentBody(data['education']),
                  
                  const SizedBox(height: 25),
                  _buildHeaderTitle("CERTIFICATIONS"),
                  const SizedBox(height: 10),
                  _buildContentBody("• Certified Info Security Manager\n• Certified Data Professional"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      color: const Color(0xFFFFE0B2),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFD35400)),
      ),
    );
  }

  Widget _buildSidebarSection(String title, dynamic content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
        const Divider(color: Colors.white54),
        if (content is String)
          Text(content, style: const TextStyle(color: Colors.white, fontSize: 10, height: 1.5))
        else if (content is List)
          ...content.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text("• ${item.toString()}",
                    style: const TextStyle(color: Colors.white, fontSize: 10)),
              )).toList(),
      ],
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 12, color: Colors.white70),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 9))),
        ],
      ),
    );
  }

  Widget _buildContentBody(dynamic content) {
    if (content == null) return const SizedBox.shrink();

    if (content is String) {
      return Text(content, style: const TextStyle(fontSize: 11, color: Colors.black87, height: 1.4));
    }

    if (content is List) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: content.map((item) {
          if (item is Map) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['role'] ?? item['degree'] ?? '', 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text("${item['company'] ?? item['school'] ?? ''} | ${item['years'] ?? ''}",
                      style: const TextStyle(fontSize: 10, color: Colors.black54)),
                  if (item['description'] != null)
                    Text(item['description'], style: const TextStyle(fontSize: 10, height: 1.3)),
                ],
              ),
            );
          }
          return Text("• ${item.toString()}", style: const TextStyle(fontSize: 11));
        }).toList(),
      );
    }
    return const SizedBox.shrink();
  }
}
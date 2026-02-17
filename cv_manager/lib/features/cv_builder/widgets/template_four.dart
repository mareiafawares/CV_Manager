import 'package:flutter/material.dart';

class TemplateFour extends StatelessWidget {
  final Map<String, dynamic> data;

  const TemplateFour({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        color: const Color(0xFFFDF5E6), 
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              color: const Color(0xFF3E2723), 
              width: double.infinity,
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    (data['name'] ?? "JOHN DAVIS").toUpperCase(),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    data['job_title'] ?? "Professional Title",
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle("ABOUT ME"),
                          Text(data['summary'] ?? "Professional summary...", style: const TextStyle(fontSize: 11)),
                          const SizedBox(height: 25),
                          
                          _buildSectionTitle("SKILLS"),
                          _buildDynamicList(data['skills']),
                          
                          const SizedBox(height: 25),
                          _buildSectionTitle("INTEREST"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildHobbyIcon(Icons.sports_soccer, "Sports"),
                              _buildHobbyIcon(Icons.book, "Reading"),
                              _buildHobbyIcon(Icons.travel_explore, "Travel"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  Container(width: 1, color: Colors.black12),
                  
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle("CONTACT"),
                          _buildContactRow(Icons.location_on, data['address'] ?? ""),
                          _buildContactRow(Icons.phone, data['phone'] ?? ""),
                          _buildContactRow(Icons.email, data['email'] ?? ""),
                          const SizedBox(height: 25),
                          
                          _buildSectionTitle("EDUCATION"),
                          _buildDynamicContent(data['education']),
                          
                          const SizedBox(height: 25),
                          _buildSectionTitle("WORK EXPERIENCE"),
                          _buildDynamicContent(data['experience']),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF3E2723))),
        const Divider(color: Colors.black26, thickness: 1),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDynamicList(dynamic content) {
    if (content == null) return const SizedBox.shrink();
    if (content is String) return Text(content, style: const TextStyle(fontSize: 11));
    
    if (content is List) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: content.map((item) => Text("• ${item.toString()}", style: const TextStyle(fontSize: 11))).toList(),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildDynamicContent(dynamic content) {
    if (content == null) return const SizedBox.shrink();
    if (content is String) return Text(content, style: const TextStyle(fontSize: 11));

    if (content is List) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: content.map((item) {
          if (item is Map) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['role'] ?? item['degree'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                  Text("${item['company'] ?? item['school'] ?? ''} | ${item['years'] ?? ''}", 
                      style: const TextStyle(fontSize: 10, color: Colors.black54)),
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

  Widget _buildContactRow(IconData icon, String text) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF3E2723)),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 10))),
        ],
      ),
    );
  }

  Widget _buildHobbyIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF3E2723)),
        Text(label, style: const TextStyle(fontSize: 9)),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'add_cv_screen.dart';

class TemplateSelectionScreen extends StatelessWidget {
  final bool isDark;
  const TemplateSelectionScreen({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> templates = [
      {"name": "Pamela Miller Style", "image": "asset/temp1.png"},
      {"name": "Arthur Lilienthal Style", "image": "asset/temp2.png"},
      {"name": "Creative Director Dark", "image": "asset/temp3.png"},
      {"name": "Karen Richard Modern", "image": "asset/temp4.png"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          "Select a Professional Design",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF9587D3), Color(0xFF6A5AE0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 10,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 18,
          mainAxisSpacing: 25,
        ),
        itemCount: templates.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCVScreen(isDark: isDark, templateId: index + 1),
                ),
              );
            },
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6A5AE0).withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        )
                      ],
                      image: DecorationImage(
                        image: AssetImage(templates[index]["image"]!),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  templates[index]["name"]!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
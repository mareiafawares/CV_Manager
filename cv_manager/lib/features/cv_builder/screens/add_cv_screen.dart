import 'dart:ui';
import 'package:cv_manager/core/constants/app_colors.dart';
import 'package:cv_manager/features/cv_builder/screens/cv_preview_screen.dart';
import 'package:flutter/material.dart';

class AddCVScreen extends StatefulWidget {
  final bool isDark;
  final int templateId;
  final Map<String, dynamic>? existingData;
  final String? docId;

  const AddCVScreen({
    super.key,
    required this.isDark,
    required this.templateId,
    this.existingData,
    this.docId,
  });

  @override
  State<AddCVScreen> createState() => _AddCVScreenState();
}

class _AddCVScreenState extends State<AddCVScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool isPublic = true;

  List<Map<String, TextEditingController>> _experienceFields = [];
  List<TextEditingController> _skillControllers = [];

  @override
  void initState() {
    super.initState();
    _addNewExperience();
    _addNewSkill();
  }

  void _addNewExperience() {
    setState(() {
      _experienceFields.add({
        'company': TextEditingController(),
        'role': TextEditingController(),
        'years': TextEditingController(),
      });
    });
  }

  void _addNewSkill() {
    setState(() {
      _skillControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Template ${widget.templateId} Details",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: widget.isDark
                ? [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)]
                : [const Color(0xFF6A5AE0), const Color(0xFF9587D3), const Color(0xFF00E5FF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("PERSONAL INFO"),
                _buildGlassInput("Full Name", Icons.person, _nameController),
                const SizedBox(height: 15),
                _buildGlassInput("Job Title", Icons.work, _jobController),
                const SizedBox(height: 15),
                _buildGlassInput("Phone Number", Icons.phone, _phoneController),
                const SizedBox(height: 15),
                _buildGlassInput("Email Address", Icons.email, _emailController),
                const SizedBox(height: 15),
                _buildGlassInput("Address", Icons.location_on, _addressController),
                const SizedBox(height: 15),
                _buildGlassInput("Professional Summary", Icons.description, _summaryController, maxLines: 3),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionTitle("WORK EXPERIENCE"),
                    IconButton(
                      onPressed: _addNewExperience,
                      icon: const Icon(Icons.add_circle, color: Colors.cyanAccent),
                    )
                  ],
                ),
                ..._experienceFields.asMap().entries.map((entry) {
                  int index = entry.key;
                  var controllers = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _buildDynamicCard(
                      index: index,
                      onDelete: () => setState(() => _experienceFields.removeAt(index)),
                      children: [
                        _buildGlassInput("Company", Icons.business, controllers['company']!),
                        const SizedBox(height: 10),
                        _buildGlassInput("Your Role", Icons.assignment_ind, controllers['role']!),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 20),
                _buildSectionTitle("SKILLS"),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ..._skillControllers.asMap().entries.map((entry) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: _buildGlassInput("Skill", Icons.bolt, entry.value),
                      );
                    }),
                    ActionChip(
                      backgroundColor: Colors.cyanAccent.withOpacity(0.2),
                      label: const Icon(Icons.add, color: Colors.cyanAccent),
                      onPressed: _addNewSkill,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                _buildSectionTitle("WHO CAN SEE THIS?"),
                _buildPrivacyOption(),
                const SizedBox(height: 40),
                _buildSaveButton(),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: const TextStyle(color: Colors.cyanAccent, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.5));
  }

  Widget _buildGlassInput(String hint, IconData icon, TextEditingController controller, {int maxLines = 1}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFF9587D3)),
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(18),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicCard({required int index, required VoidCallback onDelete, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("# ${index + 1}", style: const TextStyle(color: Colors.white38)),
              if (index != 0)
                IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_sweep, color: Colors.redAccent, size: 20)),
            ],
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildPrivacyOption() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => isPublic = true),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: isPublic ? AppColors.primaryBlue.withOpacity(0.5) : AppColors.glassWhite,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isPublic ? AppColors.primaryBlue : AppColors.glassBorder,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Icon(Icons.public, color: isPublic ? Colors.white : Colors.white70),
                  const SizedBox(height: 5),
                  const Text("Public", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const Text("Visible to everyone", style: TextStyle(color: Colors.white60, fontSize: 10)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => isPublic = false),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: !isPublic ? AppColors.primaryBlue.withOpacity(0.5) : AppColors.glassWhite,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: !isPublic ? AppColors.primaryBlue : AppColors.glassBorder,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Icon(Icons.lock_outline, color: !isPublic ? Colors.white : Colors.white70),
                  const SizedBox(height: 5),
                  const Text("Private", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const Text("Only you can see it", style: TextStyle(color: Colors.white60, fontSize: 10)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CVPreviewScreen(
              templateId: widget.templateId,
              isPublic: isPublic,
              docId: widget.docId,
              userData: {
                'name': _nameController.text,
                'jobTitle': _jobController.text,
                'summary': _summaryController.text,
                'phone': _phoneController.text,
                'email': _emailController.text,
                'address': _addressController.text,
                'skills': _skillControllers.map((c) => c.text).toList(),
                'experience': _experienceFields
                    .map((e) => {
                          'company': e['company']!.text,
                          'role': e['role']!.text,
                          'years': e['years']!.text,
                        })
                    .toList(),
              },
            ),
          ),
        );
      },
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [Color(0xFF9587D3), Color(0xFF6A5AE0)],
          ),
        ),
        child: const Center(
          child: Text(
            "GENERATE PREVIEW",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
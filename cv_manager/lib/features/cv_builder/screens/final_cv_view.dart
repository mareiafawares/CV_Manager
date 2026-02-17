import 'package:cv_manager/features/cv_builder/widgets/template_four.dart';
import 'package:cv_manager/features/cv_builder/widgets/template_one.dart';
import 'package:cv_manager/features/cv_builder/widgets/template_three.dart';
import 'package:cv_manager/features/cv_builder/widgets/template_two.dart';
import 'package:flutter/material.dart';

class FinalCVView extends StatelessWidget {
  final Map<String, dynamic> data;

  const FinalCVView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
   
    int templateId = data['templateId'] ?? 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(data['name'] ?? 'CV Preview'),
      ),
      body: SingleChildScrollView(
        child: _buildTemplate(templateId),
      ),
    );
  }

  
  Widget _buildTemplate(int templateId) {
    switch (templateId) {
      case 1:
        return TemplateOne(data: data); 
      case 2:
        return TemplateTwo(data: data);
      case 3:
        return TemplateThree(data: data);
      case 4:
        return TemplateFour(data: data);
      default:
        return TemplateOne(data: data);
    }
  }
}
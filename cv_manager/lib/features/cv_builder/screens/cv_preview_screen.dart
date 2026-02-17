
import 'dart:typed_data';
import 'package:cv_manager/services/share/pdf_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cv_manager/features/cv_builder/widgets/template_one.dart';
import 'package:cv_manager/features/cv_builder/widgets/template_two.dart';
import 'package:cv_manager/features/cv_builder/widgets/template_three.dart';
import 'package:cv_manager/features/cv_builder/widgets/template_four.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';

class CVPreviewScreen extends StatefulWidget {
  final int templateId;
  final Map<String, dynamic> userData;
  final String? docId;
  final bool isPublic;

  const CVPreviewScreen({
    super.key,
    required this.templateId,
    required this.userData,
    required this.isPublic,
    this.docId,
  });

  @override
  State<CVPreviewScreen> createState() => _CVPreviewScreenState();
}

class _CVPreviewScreenState extends State<CVPreviewScreen> {
  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> _saveCVToFirebase(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final dataToSave = {
        ...widget.userData,
        'templateId': widget.templateId,
        'isPublic': widget.isPublic, 
        'userId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      };

      if (widget.docId != null) {
        await FirebaseFirestore.instance.collection('cvs').doc(widget.docId).update(dataToSave);
      } else {
        await FirebaseFirestore.instance.collection('cvs').add(dataToSave);
      }

      if (!mounted) return;
      _showSuccessDialog(context);

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Final CV Preview", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
            onPressed: () async {
              final Uint8List? imageBytes = await screenshotController.capture(
                pixelRatio: 1.5
              );

              if (imageBytes != null) {
                final pdf = pw.Document();
                final image = pw.MemoryImage(imageBytes);

                pdf.addPage(
                  pw.Page(
                    margin: const pw.EdgeInsets.all(20), 
                    pageFormat: PdfPageFormat.a4,
                    build: (pw.Context context) {
                      return pw.Center(
                        child: pw.Image(
                          image, 
                          fit: pw.BoxFit.contain, 
                        ),
                      );
                    },
                  ),
                );

                await Printing.layoutPdf(onLayout: (format) async => pdf.save());
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("CANCEL ❌", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A5AE0),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => _saveCVToFirebase(context),
                child: const Text("CONFIRM ✅", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Center(
          child: Screenshot(
            controller: screenshotController,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 5))
                ],
              ),
              child: _buildTemplate(), 
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 80),
                const SizedBox(height: 20),
                const Text(
                  "Done Successfully!", 
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Your CV has been saved. You can find it on your home screen now.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A5AE0),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text("GO TO HOME", style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTemplate() {
    switch (widget.templateId) {
      case 1: return TemplateOne(data: widget.userData);
      case 2: return TemplateTwo(data: widget.userData);
      case 3: return TemplateThree(data: widget.userData);
      case 4: return TemplateFour(data: widget.userData);
      default: return TemplateOne(data: widget.userData);
    }
  }
}
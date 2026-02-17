import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  static Future<void> generateAndPrintPdf(Map<String, dynamic> userData, int templateId) async {
    final pdf = pw.Document();

    
    final arabicFont = pw.Font.ttf(await rootBundle.load("assets/fonts/Amiri-Regular.ttf"));

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: arabicFont), 
        textDirection: pw.TextDirection.rtl, 
        build: (pw.Context context) {
         
          if (templateId == 1) {
            return _buildModernTheme(userData, arabicFont);
          } else if (templateId == 2) {
            return _buildClassicTheme(userData, arabicFont);
          } else {
            return _buildMinimalTheme(userData, arabicFont);
          }
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  
  static List<pw.Widget> _buildModernTheme(Map<String, dynamic> userData, pw.Font font) {
    return [
      pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.all(20),
        color: PdfColors.blue800,
        child: pw.Column(
          children: [
            pw.Text(userData['name'] ?? "", style: pw.TextStyle(font: font, fontSize: 26, color: PdfColors.white)),
            pw.Text(userData['phone'] ?? "", style: pw.TextStyle(font: font, fontSize: 14, color: PdfColors.blue100)),
          ],
        ),
      ),
      pw.SizedBox(height: 20),
      _sectionTitle("الملخص المهني", PdfColors.blue800, font),
      pw.Text(userData['summary'] ?? "", style: pw.TextStyle(font: font, fontSize: 12)),
    ];
  }


  static List<pw.Widget> _buildClassicTheme(Map<String, dynamic> userData, pw.Font font) {
    return [
      pw.Center(
        child: pw.Text(userData['name'] ?? "", style: pw.TextStyle(font: font, fontSize: 28, fontWeight: pw.FontWeight.bold)),
      ),
      pw.Divider(thickness: 1.5),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          pw.Text(userData['phone'] ?? "", style: pw.TextStyle(font: font, fontSize: 10)),
          pw.Text(userData['email'] ?? "", style: pw.TextStyle(font: font, fontSize: 10)),
        ],
      ),
      pw.SizedBox(height: 30),
      _sectionTitle("التعليم", PdfColors.black, font),
      pw.Text(userData['education'] ?? "", style: pw.TextStyle(font: font, fontSize: 12)),
    ];
  }

 
  static List<pw.Widget> _buildMinimalTheme(Map<String, dynamic> userData, pw.Font font) {
    return [
      pw.Text(userData['name'] ?? "", style: pw.TextStyle(font: font, fontSize: 22, color: PdfColors.grey800)),
      pw.SizedBox(height: 10),
      pw.Bullet(text: "الهاتف: ${userData['phone']}"),
      pw.Bullet(text: "الإيميل: ${userData['email']}"),
      pw.SizedBox(height: 20),
      pw.Text(userData['summary'] ?? "", style: pw.TextStyle(font: font, fontSize: 11)),
    ];
  }

  static pw.Widget _sectionTitle(String title, PdfColor color, pw.Font font) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 10),
      padding: const pw.EdgeInsets.only(right: 5),
      decoration: pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(color: color, width: 4))),
      child: pw.Text(title, style: pw.TextStyle(font: font, fontSize: 18, color: color, fontWeight: pw.FontWeight.bold)),
    );
  }
}
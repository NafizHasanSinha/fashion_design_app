import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class AiDressGeneratorScreen extends StatefulWidget {
  final String fittedFor;
  final String fabricAndDesign;
  final String colorPalette;

  const AiDressGeneratorScreen({
    super.key,
    this.fittedFor = 'Man (18+, 40"/32"/18.0")',
    this.fabricAndDesign = 'Silk, Striped Pattern, Fit-and-Flare Fit',
    this.colorPalette = 'Ivory White + Copper Bronze (Soft Pastel)',
  });

  @override
  State<AiDressGeneratorScreen> createState() => _AiDressGeneratorScreenState();
}

class _AiDressGeneratorScreenState extends State<AiDressGeneratorScreen> {
  late String _imageUrl;
  bool _isLoading = true;
  bool _isExporting = false; // Show a loader while exporting
  int _randomSeed = Random().nextInt(10000);

  @override
  void initState() {
    super.initState();
    _generateDressImage();
  }

  void _generateDressImage() {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    String prompt =
        "High fashion photography, a highly detailed realistic dress design. "
        "Style: ${widget.fabricAndDesign}. "
        "Colors: ${widget.colorPalette}. "
        "Target body: ${widget.fittedFor}. "
        "Studio lighting, 8k resolution, highly detailed fashion editorial.";

    String encodedPrompt = Uri.encodeComponent(prompt);

    _imageUrl =
        'https://image.pollinations.ai/prompt/$encodedPrompt?width=768&height=1024&seed=$_randomSeed&nologo=true';

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _regenerateDesign() {
    setState(() {
      _randomSeed = Random().nextInt(10000);
      _generateDressImage();
    });
  }

  // --- Main image export logic ---
  Future<void> _exportAsImage() async {
    if (!mounted) return;
    setState(() => _isExporting = true);
    try {
      // 1. Download image bytes from the URL
      final response = await http.get(Uri.parse(_imageUrl));
      if (response.statusCode == 200) {
        // 2. Find the local cache directory and create the file
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/AI_Dress_Design_$_randomSeed.jpg');

        // 3. Write the bytes to the file
        await file.writeAsBytes(response.bodyBytes);

        // 4. Show the share/download prompt to the user
        await Share.shareXFiles([
          XFile(file.path),
        ], text: 'Check out my AI Dress Design!');
      } else {
        throw Exception("Failed to download image from server");
      }
    } catch (e) {
      _showErrorSnackBar("Failed to export image: $e");
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  // --- Main PDF export logic ---
  Future<void> _exportAsPdf() async {
    if (!mounted) return;
    setState(() => _isExporting = true);
    try {
      // 1. Download image data
      final response = await http.get(Uri.parse(_imageUrl));
      if (response.statusCode == 200) {
        final pdf = pw.Document();

        // 2. Build the PDF page layout using the downloaded image
        final image = pw.MemoryImage(response.bodyBytes);
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "AI Dress Generation Specs Sheet",
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text("Fitted For: ${widget.fittedFor}"),
                  pw.Text("Fabric & Design: ${widget.fabricAndDesign}"),
                  pw.Text("Color Palette: ${widget.colorPalette}"),
                  pw.SizedBox(height: 20),
                  pw.Expanded(
                    child: pw.Center(
                      child: pw.Image(image, fit: pw.BoxFit.contain),
                    ),
                  ),
                ],
              );
            },
          ),
        );

        // 3. Temporarily save the PDF file to storage
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/AI_Dress_Design_$_randomSeed.pdf');
        await file.writeAsBytes(await pdf.save());

        // 4. Offer the user a sharing option
        await Share.shareXFiles([
          XFile(file.path),
        ], text: 'Exported PDF Blueprint');
      } else {
        throw Exception("Failed to prepare PDF asset");
      }
    } catch (e) {
      _showErrorSnackBar("Failed to export PDF: $e");
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  // Open a bottom sheet to ask the user whether they want an image or PDF
  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E232D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Export Options",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.image, color: Colors.blueAccent),
                title: const Text(
                  "Save/Share as Image",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _exportAsImage();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.picture_as_pdf,
                  color: Colors.redAccent,
                ),
                title: const Text(
                  "Save/Share as PDF",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _exportAsPdf();
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151923),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '3D AI Dress Generation',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!_isLoading)
            _isExporting
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.ios_share, color: Colors.white),
                    onPressed: _showExportOptions,
                  ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Image display container
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E232D),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade800),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _isLoading
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Colors.blueAccent,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'AI is crafting your design...',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : Image.network(
                          _imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.blueAccent,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                    size: 50,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Failed to load generated design.',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 2. Rendering blueprint
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E232D),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.tune, color: Colors.orangeAccent, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Rendering Blueprints',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildBlueprintText('Fitted For:', widget.fittedFor),
                  _buildBlueprintText(
                    'Fabric & Design:',
                    widget.fabricAndDesign,
                  ),
                  _buildBlueprintText('Color Palette:', widget.colorPalette),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Buttons (Edit Style & Regenerate)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                    label: const Text(
                      'Edit Style',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey.shade700),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _regenerateDesign,
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.blueAccent,
                      size: 18,
                    ),
                    label: const Text(
                      'Regenerate',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey.shade700),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildBlueprintText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: Colors.grey),
          children: [
            TextSpan(text: '$title '),
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

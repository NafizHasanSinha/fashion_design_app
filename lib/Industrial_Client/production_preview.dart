import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'ai_service.dart'; // Import AiImageService to get color names

class ThreeDProductionPreviewScreen extends StatefulWidget {
  final String? generatedImageUrl;

  // Fields to receive dynamic specifications
  final String targetAge;
  final String fabric;
  final String pattern;
  final String sleeve;
  final String neckline;
  final String fit;
  final String length;
  final Color primaryColor;
  final Color secondaryColor;

  const ThreeDProductionPreviewScreen({
    super.key,
    this.generatedImageUrl,
    required this.targetAge,
    required this.fabric,
    required this.pattern,
    required this.sleeve,
    required this.neckline,
    required this.fit,
    required this.length,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  State<ThreeDProductionPreviewScreen> createState() =>
      _ThreeDProductionPreviewScreenState();
}

class _ThreeDProductionPreviewScreenState
    extends State<ThreeDProductionPreviewScreen>
    with SingleTickerProviderStateMixin {
  final Color scaffoldBg = const Color(0xFF0B121E);
  final Color darkCardBg = const Color(0xFF131C2E);
  final Color lightCardBg = Colors.white;
  final Color accentOrange = const Color(0xFFFF6B00);
  final Color accentCyan = const Color(0xFF00A3C4);

  final Color textMuted = const Color(0xFF64748B);
  final Color textDark = const Color(0xFF1E293B);
  final Color borderMuted = const Color(0xFF1E293B);
  final Color rowDividerColor = const Color(0xFFF1F5F9);

  final Map<String, bool> _hoverStates = {};
  bool _isExporting = false;

  Future<Uint8List?> _fetchImageBytes() async {
    if (widget.generatedImageUrl == null) return null;
    try {
      final response = await http.get(Uri.parse(widget.generatedImageUrl!));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      debugPrint("Error fetching image bytes: $e");
    }
    return null;
  }

  Future<void> _downloadImage() async {
    if (widget.generatedImageUrl == null) {
      _showSnackBar("No image available to download", isError: true);
      return;
    }

    setState(() => _isExporting = true);
    try {
      final bytes = await _fetchImageBytes();
      if (bytes == null) throw Exception("Failed to load image bytes");

      final directory = await getTemporaryDirectory();
      final filePath =
          '${directory.path}/AI_Dress_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      _showSnackBar("Image ready to share!");

      await Share.shareXFiles([
        XFile(filePath),
      ], text: 'Check out my AI Generated Dress Design!');
    } catch (e) {
      _showSnackBar("Failed to download image: $e", isError: true);
    } finally {
      setState(() => _isExporting = false);
    }
  }

  // Dynamic PDF generation function
  Future<void> _exportPdf() async {
    if (widget.generatedImageUrl == null) {
      _showSnackBar("No design available to export as PDF", isError: true);
      return;
    }

    setState(() => _isExporting = true);
    try {
      final bytes = await _fetchImageBytes();
      final pdf = pw.Document();

      final String pColorName = AiImageService.getColorName(
        widget.primaryColor,
      );
      final String sColorName = AiImageService.getColorName(
        widget.secondaryColor,
      );

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(24),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "CLO 3D Production Design Report",
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text("Generated via AI Dress Studio Render Engine - 2026"),
                  pw.Divider(),
                  pw.SizedBox(height: 16),
                  bytes != null
                      ? pw.Container(
                          height: 300,
                          width: double.infinity,
                          child: pw.Image(
                            pw.MemoryImage(bytes),
                            fit: pw.BoxFit.contain,
                          ),
                        )
                      : pw.Text("Image could not be loaded into PDF"),
                  pw.SizedBox(height: 24),
                  pw.Text(
                    "Garment Production Specifications:",
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 12),
                  pw.Bullet(text: "Target Demographic: ${widget.targetAge}"),
                  pw.Bullet(text: "Fabric Base: ${widget.fabric}"),
                  pw.Bullet(text: "Texture Pattern: ${widget.pattern}"),
                  pw.Bullet(text: "Sleeve Specification: ${widget.sleeve}"),
                  pw.Bullet(text: "Neckline Structure: ${widget.neckline}"),
                  pw.Bullet(text: "Fitting Standard: ${widget.fit}"),
                  pw.Bullet(text: "Length Group: ${widget.length}"),
                  pw.Bullet(text: "Primary Color Theme: $pColorName"),
                  pw.Bullet(text: "Secondary Accent Theme: $sColorName"),
                ],
              ),
            );
          },
        ),
      );

      final directory = await getTemporaryDirectory();
      final filePath =
          '${directory.path}/Dress_Production_Report_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      _showSnackBar("PDF Report generated successfully!");

      await Share.shareXFiles([
        XFile(filePath),
      ], text: 'My AI Dress CAD Production PDF Report');
    } catch (e) {
      _showSnackBar("Failed to export PDF: $e", isError: true);
    } finally {
      setState(() => _isExporting = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : accentCyan,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: darkCardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: textMuted,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Text(
                  "Export & Download Design",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accentOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.image, color: accentOrange),
                  ),
                  title: const Text(
                    "Save as Image (PNG)",
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "Download high-res rendering texture",
                    style: TextStyle(color: textMuted, fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _downloadImage();
                  },
                ),
                const Divider(color: Color(0xFF1E293B)),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accentCyan.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.picture_as_pdf, color: accentCyan),
                  ),
                  title: const Text(
                    "Export Specification Report (PDF)",
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "Generate CAD spec sheet with preview",
                    style: TextStyle(color: textMuted, fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _exportPdf();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 850;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: darkCardBg,
        elevation: 0,
        title: const Text(
          "CLO 3D Production Preview",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeaderTitleAndSubtitle(),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: _buildExportButton(),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: _buildHeaderTitleAndSubtitle()),
                            const SizedBox(width: 24),
                            _buildExportButton(),
                          ],
                        ),
                  const SizedBox(height: 24),
                  isMobile
                      ? Column(
                          children: [
                            _buildLiveCanvasArea(isMobile),
                            const SizedBox(height: 24),
                            _buildSpecsSidebar(),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildLiveCanvasArea(isMobile),
                            ),
                            const SizedBox(width: 24),
                            Expanded(flex: 2, child: _buildSpecsSidebar()),
                          ],
                        ),
                ],
              ),
            ),
            if (_isExporting)
              Container(
                color: Colors.black.withValues(alpha: 0.6),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: accentOrange),
                      const SizedBox(height: 16),
                      const Text(
                        "Processing File Export Request...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderTitleAndSubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Garment Simulation & CAD Render",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Real-time fabric drape and fitting preview simulation studio.",
          style: TextStyle(color: textMuted, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildExportButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentOrange,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: _showExportOptions,
      icon: const Icon(Icons.download_rounded, color: Colors.white, size: 18),
      label: const Text(
        "Export CAD / Design",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLiveCanvasArea(bool isMobile) {
    return Container(
      height: isMobile ? 360 : 520,
      width: double.infinity,
      decoration: BoxDecoration(
        color: darkCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderMuted, width: 1.5),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: widget.generatedImageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      widget.generatedImageUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: accentOrange),
                              const SizedBox(height: 16),
                              const Text(
                                "Rendering Fabric Simulation Physics...",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.broken_image_outlined,
                                color: Colors.redAccent,
                                size: 48,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Simulation texture failed to load.",
                                style: TextStyle(
                                  color: textMuted,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.layers_clear_outlined,
                          color: textMuted,
                          size: 54,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "No Preview Generated Yet",
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "Go back to Design Studio to trigger full CAD AI render.",
                            style: TextStyle(color: textMuted, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: scaffoldBg.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderMuted),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCanvasControlIcon(Icons.zoom_in, 'zoom_in'),
                  _buildCanvasControlIcon(Icons.zoom_out, 'zoom_out'),
                  _buildCanvasControlIcon(Icons.rotate_left, 'rot_left'),
                  _buildCanvasControlIcon(Icons.refresh, 'reset_view'),
                  _buildCanvasControlIcon(Icons.visibility, 'toggle_mesh'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Specification table (now shows the data sent by the user!)
  Widget _buildSpecsSidebar() {
    final String pColorName = AiImageService.getColorName(widget.primaryColor);
    final String sColorName = AiImageService.getColorName(
      widget.secondaryColor,
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: lightCardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Garment Specification",
            style: TextStyle(
              color: textDark,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Rendering the dynamic row data
          _buildRowData('Target Age', widget.targetAge, false),
          _buildRowData('Fabric selection', widget.fabric, false),
          _buildRowData('Pattern Type', widget.pattern, false),
          _buildRowData('Sleeve Style', widget.sleeve, false),
          _buildRowData('Neckline Style', widget.neckline, false),
          _buildRowData('Fit Specification', widget.fit, false),
          _buildRowData('Garment Length', widget.length, false),
          _buildRowData('Primary Color', pColorName, false),
          _buildRowData('Accent Color', sColorName, false, isLast: true),
          const SizedBox(height: 24),
          customExportActionButton(
            "Download Image Pattern",
            Icons.image_outlined,
            _downloadImage,
            accentCyan,
          ),
          const SizedBox(height: 12),
          customExportActionButton(
            "Export PDF Spec Sheet",
            Icons.picture_as_pdf_outlined,
            _exportPdf,
            accentOrange,
          ),
        ],
      ),
    );
  }

  Widget customExportActionButton(
    String title,
    IconData icon,
    VoidCallback action,
    Color color,
  ) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: Icon(icon, color: color),
        onPressed: action,
        label: Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildRowData(
    String leftLabel,
    String rightValue,
    bool isColor, {
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: rowDividerColor, width: 1.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              leftLabel,
              style: TextStyle(
                color: textMuted,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            rightValue,
            style: TextStyle(
              color: textDark,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCanvasControlIcon(IconData icon, String id) {
    return _buildHoverableWidget(
      id: id,
      builder: (isHovered) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Icon(
            icon,
            color: isHovered ? Colors.white : textMuted,
            size: 18,
          ),
        );
      },
    );
  }

  Widget _buildHoverableWidget({
    required String id,
    required Widget Function(bool isHovered) builder,
  }) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverStates[id] = true),
      onExit: (_) => setState(() => _hoverStates[id] = false),
      child: builder(_hoverStates[id] ?? false),
    );
  }
}

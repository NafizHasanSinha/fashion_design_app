import 'package:flutter/material.dart';

class ThreeDProductionPreviewScreen extends StatefulWidget {
  final String? generatedImageUrl; // AI dynamic image URL receiver token

  const ThreeDProductionPreviewScreen({super.key, this.generatedImageUrl});

  @override
  State<ThreeDProductionPreviewScreen> createState() =>
      _ThreeDProductionPreviewScreenState();
}

// এখানে `extends State<ThreeDProductionPreviewScreen>` মিস হওয়ার কারণেই সব এরর আসছিল
class _ThreeDProductionPreviewScreenState
    extends State<ThreeDProductionPreviewScreen>
    with SingleTickerProviderStateMixin {
  // --- Color Palette ---
  final Color scaffoldBg = const Color(0xFF0B121E);
  final Color darkCardBg = const Color(0xFF131C2E);
  final Color lightCardBg = Colors.white;
  final Color accentOrange = const Color(0xFFFF6B00);
  final Color accentCyan = const Color(0xFF00A3C4);

  final Color textMuted = const Color(0xFF64748B);
  final Color textDark = const Color(0xFF1E293B);
  final Color borderMuted = const Color(0xFF1E293B);
  final Color rowDividerColor = const Color(0xFFF1F5F9);

  // Hover state tracking map
  final Map<String, bool> _hoverStates = {};

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 850; // Dynamic mobile boundary trigger

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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(), // Safe scrolling flow control
          padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- ১. Responsive Header Panel Grid System ---
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

              // --- Layout Grid Core System ---
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
      ),
    );
  }

  // Header Typography Builder Component
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

  // Header Export Button Action Builder Component
  Widget _buildExportButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentOrange,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {
        // CAD design export action handler
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exporting CAD Simulation Data...')),
        );
      },
      icon: const Icon(Icons.download_rounded, color: Colors.white, size: 18),
      label: const Text(
        "Export CAD",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ২. LIVE CANVAS RENDER AREA - Adaptive grid setup
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
          // Dynamic Network Image Renderer Selector
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

          // Canvas Control Action Floating Board (withValues ফিক্সড)
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: scaffoldBg.withValues(
                  alpha: 0.85,
                ), // Deprecated withOpacity ফিক্সড
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

  // --- Specifications Sidebar Table ---
  Widget _buildSpecsSidebar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: lightCardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ), // Deprecated withOpacity ফিক্সড
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
          _buildRowData('Simulation Engine', 'CLO 3D Virtual Tailor', false),
          _buildRowData('Fit Specs', 'Standard Customized Fit', false),
          _buildRowData(
            'Resolution Quality',
            '8K Photorealistic Render',
            false,
          ),
          _buildRowData(
            'Texture Quality',
            'Ultra High Definition',
            false,
            isLast: true,
          ),
          const SizedBox(height: 24),

          // Modify Pattern Spec Button Wrapper
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: accentOrange, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: Icon(Icons.edit_note_rounded, color: accentOrange),
              onPressed: () {
                // ইউজার এই এডিট অপশনটি প্রেস করলে পপ হয়ে সরাসরি আগের এডিটিং উইন্ডোতে ব্যাক করবে
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      "Returned to Studio Panel. Modify options and click 'GENERATE PREVIEW' again.",
                    ),
                    backgroundColor: accentOrange,
                    duration: const Duration(seconds: 4),
                  ),
                );
              },
              label: Text(
                "Change & Edit Design",
                style: TextStyle(
                  color: accentOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowData(
    String leftLabel,
    String rightValue,
    bool isColor, {
    Color? colorVal,
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
          Row(
            children: [
              if (isColor && colorVal != null) ...[
                Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    color: colorVal,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
              ],
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

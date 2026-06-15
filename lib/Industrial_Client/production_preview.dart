import 'package:flutter/material.dart';
import 'industrial_overlays.dart'; // The industrial_overlays.dart file is imported here

class ThreeDProductionPreviewScreen extends StatefulWidget {
  const ThreeDProductionPreviewScreen({super.key});

  @override
  State<ThreeDProductionPreviewScreen> createState() =>
      _ThreeDProductionPreviewScreenState();
}

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
    // মোবাইল বা ছোট স্ক্রিন ডিটেকশন
    final bool isMobile = screenWidth < 750;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          // ফিক্স ১: স্ক্রিন সাইজ অনুযায়ী প্যাডিং অ্যাডাপ্ট করবে
          padding: EdgeInsets.all(isMobile ? 16.0 : 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, isMobile),
              SizedBox(height: isMobile ? 24 : 36),
              LayoutBuilder(
                builder: (context, constraints) {
                  // ট্যাবলেট ও ডেস্কটপের জন্য সাইড-বাই-সাইড ভিউ
                  if (constraints.maxWidth > 1000) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: _build3DModelRenderCanvas(isMobile),
                        ),
                        const SizedBox(width: 32),
                        Expanded(flex: 4, child: _buildSidebarCards()),
                      ],
                    );
                  } else {
                    // মোবাইল ও ছোট ট্যাবলেটের জন্য ওপরে-নিচে (Stack) ভিউ
                    return Column(
                      children: [
                        _build3DModelRenderCanvas(isMobile),
                        const SizedBox(height: 24),
                        _buildSidebarCards(),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Top Header Section ---
  // ফিক্স ২: মোবাইলে হেডার বাটনগুলোকে নিচে একটি আলাদা সারিতে (Row) নামিয়ে আনা হয়েছে যেন ওভারফ্লো না হয়
  Widget _buildHeader(BuildContext context, bool isMobile) {
    final titleSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: accentOrange.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'INDUSTRIAL MODE',
            style: TextStyle(
              color: accentOrange,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '3D Production Preview',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 20 : 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Text(
            'Validate specifications before export',
            style: TextStyle(color: textMuted, fontSize: isMobile ? 12 : 14),
          ),
        ),
      ],
    );

    final actionButtons = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          // 1. MODIFY Button
          _buildHoverableWidget(
            id: 'btn_modify',
            builder: (isHovered) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: isHovered
                    ? Matrix4.diagonal3Values(1.03, 1.03, 1.03)
                    : Matrix4.identity(),
                child: OutlinedButton.icon(
                  onPressed: () => EditDesignDialog.show(context),
                  icon: Icon(
                    Icons.edit_outlined,
                    color: isHovered ? Colors.white : textMuted,
                    size: 16,
                  ),
                  label: Text(
                    'MODIFY',
                    style: TextStyle(
                      color: isHovered ? Colors.white : textMuted,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isHovered ? Colors.white38 : borderMuted,
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: isHovered
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.transparent,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),

          // 2. INDUSTRIAL Button
          _buildHoverableWidget(
            id: 'btn_industrial',
            builder: (isHovered) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: isHovered
                    ? Matrix4.diagonal3Values(1.03, 1.03, 1.03)
                    : Matrix4.identity(),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: accentOrange.withValues(
                        alpha: isHovered ? 0.6 : 0.2,
                      ),
                      blurRadius: isHovered ? 20 : 8,
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () => IndustrialFeaturesDialog.show(context),
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                  label: const Text(
                    'INDUSTRIAL',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentOrange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),

          // 3. Share Icon Button
          _buildHoverableWidget(
            id: 'btn_share',
            builder: (isHovered) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isHovered ? Colors.white38 : borderMuted,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: isHovered
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.transparent,
                ),
                child: Icon(
                  Icons.share_outlined,
                  color: isHovered ? Colors.white : textMuted,
                  size: 18,
                ),
              );
            },
          ),
          const SizedBox(width: 8),

          // 4. EXPORT Button
          _buildHoverableWidget(
            id: 'btn_export',
            builder: (isHovered) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: isHovered
                    ? Matrix4.diagonal3Values(1.03, 1.03, 1.03)
                    : Matrix4.identity(),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: accentCyan.withValues(
                        alpha: isHovered ? 0.6 : 0.2,
                      ),
                      blurRadius: isHovered ? 20 : 8,
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () => ExportDesignDialog.show(context),
                  icon: const Icon(
                    Icons.file_download_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                  label: const Text(
                    'EXPORT',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentCyan,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [titleSection, const SizedBox(height: 16), actionButtons],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: titleSection),
        const SizedBox(width: 20),
        actionButtons,
      ],
    );
  }

  // --- 3D Model Render Canvas ---
  // ফিক্স ৩: মোবাইলের ক্ষেত্রে ক্যানভাসের হাইট কমানো হয়েছে এবং কন্ট্রোল বার ওভারফ্লো রোধ করতে Wrap/Scroll ব্যবহার করা হয়েছে
  Widget _build3DModelRenderCanvas(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 28),
      decoration: BoxDecoration(
        color: darkCardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderMuted),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '3D MODEL RENDER',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCanvasControlIcon(
                        Icons.zoom_out,
                        'canvas_zoom_out',
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '100%',
                        style: TextStyle(
                          fontSize: 12,
                          color: textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildCanvasControlIcon(Icons.zoom_in, 'canvas_zoom_in'),
                      const SizedBox(width: 8),
                      Container(height: 14, width: 1, color: borderMuted),
                      const SizedBox(width: 8),
                      _buildCanvasControlIcon(
                        Icons.refresh_rounded,
                        'canvas_refresh',
                      ),
                      const SizedBox(width: 8),
                      _buildCanvasControlIcon(
                        Icons.fullscreen_rounded,
                        'canvas_fullscreen',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            height: isMobile ? 320 : 520, // রেসপন্সিভ হাইট
            width: double.infinity,
            decoration: BoxDecoration(
              color: scaffoldBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderMuted),
            ),
            child: Center(
              child: Opacity(
                opacity: 0.15,
                child: Container(
                  width: isMobile ? 140 : 220,
                  height: isMobile ? 220 : 320,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: isMobile ? 90 : 140,
                        height: 2,
                        color: scaffoldBg,
                      ),
                      SizedBox(height: isMobile ? 25 : 40),
                      Container(
                        width: isMobile ? 90 : 140,
                        height: 2,
                        color: scaffoldBg,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Right Side Light/White Sidebar Cards ---
  Widget _buildSidebarCards() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: lightCardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Design Specifications',
                style: TextStyle(
                  color: textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildSpecificationRow('Fabric', 'Cotton', 'row_fabric'),
              _buildSpecificationRow('Pattern', 'solid', 'row_pattern'),
              _buildSpecificationRow(
                'Primary Color',
                '#1a1a2e',
                'row_p_color',
                isColor: true,
                colorVal: const Color(0xFF1A1A2E),
              ),
              _buildSpecificationRow(
                'Secondary Color',
                '#16213e',
                'row_s_color',
                isColor: true,
                colorVal: const Color(0xFF16213E),
              ),
              _buildSpecificationRow('Sleeve Length', 'Short', 'row_sleeve'),
              _buildSpecificationRow('Neckline', 'Round', 'row_neckline'),
              _buildSpecificationRow('Fit', 'Regular', 'row_fit'),
              _buildSpecificationRow(
                'Length',
                'Regular',
                'row_length',
                isLast: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: lightCardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Body Measurements',
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecificationRow(
    String label,
    String value,
    String id, {
    bool isColor = false,
    Color? colorVal,
    bool isLast = false,
  }) {
    return _buildHoverableWidget(
      id: id,
      builder: (isHovered) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: isHovered ? const Color(0xFFF8FAFC) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border(
              bottom: BorderSide(
                color: isLast ? Colors.transparent : rowDividerColor,
                width: 1.5,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: textMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
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
                    value,
                    style: TextStyle(
                      color: textDark,
                      fontSize: 14,
                      fontWeight: isHovered ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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

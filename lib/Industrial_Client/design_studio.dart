import 'package:flutter/material.dart';
// Check and ensure the correct import path for your project setup
import 'production_preview.dart';

class ProductionDesignSystemScreen extends StatefulWidget {
  const ProductionDesignSystemScreen({super.key});

  @override
  State<ProductionDesignSystemScreen> createState() =>
      _ProductionDesignSystemScreenState();
}

class _ProductionDesignSystemScreenState
    extends State<ProductionDesignSystemScreen>
    with SingleTickerProviderStateMixin {
  // --- Color Palette ---
  final Color scaffoldBg = const Color(0xFF0B121E);
  final Color cardBg = const Color(0xFF131C2E);
  final Color accentOrange = const Color(0xFFFF6B00);
  final Color textMuted = const Color(0xFF64748B);
  final Color borderMuted = const Color(0xFF1E293B);

  // --- State Management Variables ---
  String selectedTab = 'FABRIC & PATTERN';

  // Tab 1: Fabric & Pattern
  String selectedFabric = 'Cotton';
  String selectedPattern = 'Solid';

  // Tab 2: Colors
  Color selectedPrimaryColor = const Color(0xFF1A1A2E);
  Color selectedSecondaryColor = const Color(0xFF16213E);

  // Tab 3: Style & Fit
  String selectedSleeveLength = 'Short';
  String selectedNecklineStyle = 'Round';
  String selectedFitSpecification = 'Regular';

  // Tab 4: Details
  String selectedGarmentLength = 'Regular';

  // Map to track hover states for modern UX interactions
  final Map<String, bool> _hoverStates = {};

  // Pre-defined manufacturing color palette
  final List<Color> colorPalette = [
    const Color(0xFF1A1A2E),
    const Color(0xFF243B55),
    const Color(0xFF144272),
    const Color(0xFF5B3294),
    const Color(0xFFE94560),
    const Color(0xFFFF6B00),
    const Color(0xFFFFB100),
    const Color(0xFFE8E288),
    const Color(0xFFFFFFFF),
    const Color(0xFF2C3E50),
    const Color(0xFFE74C3C),
    const Color(0xFFE67E22),
    const Color(0xFFF1C40F),
    const Color(0xFF2ECC71),
    const Color(0xFF9B59B6),
    const Color(0xFF34495E),
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 650;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          // ফিক্স ১: মোবাইলের জন্য প্যাডিং কমিয়ে ২০ করা হয়েছে যাতে স্ক্রিন স্পেস বাঁচে
          padding: EdgeInsets.all(isMobile ? 20.0 : 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopHeader(context, isMobile),
              SizedBox(height: isMobile ? 24 : 40),
              LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive Design Breakdown
                  if (constraints.maxWidth > 1000) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: _buildConfigurationPanel(isMobile),
                        ),
                        const SizedBox(width: 32),
                        Expanded(flex: 4, child: _buildLiveRenderPanel()),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildConfigurationPanel(isMobile),
                        const SizedBox(height: 32),
                        _buildLiveRenderPanel(),
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
  // ফিক্স ২: মোবাইলে টাইটেল এবং বাটন পাশাপাশি না রেখে Column এর মাধ্যমে ওপরে-নিচে রাখা হয়েছে
  Widget _buildTopHeader(BuildContext context, bool isMobile) {
    final Widget headerTextContent = Column(
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
        const Text(
          'Production Design System',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24, // মোবাইলের জন্য সামান্য ছোট সাইজ
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Configure garment specifications for industrial production',
          style: TextStyle(color: textMuted, fontSize: 13),
        ),
      ],
    );

    final Widget previewButton = _buildHoverableWidget(
      id: 'gen_preview_btn',
      builder: (isHovered) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: isHovered
              ? Matrix4.diagonal3Values(1.03, 1.03, 1.03)
              : Matrix4.identity(),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: accentOrange.withValues(alpha: isHovered ? 0.6 : 0.3),
                blurRadius: isHovered ? 20 : 10,
                spreadRadius: isHovered ? 2 : 0,
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ThreeDProductionPreviewScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 18,
            ),
            label: const Text(
              'GENERATE PREVIEW',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentOrange,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );
      },
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerTextContent,
          const SizedBox(height: 20),
          previewButton,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: headerTextContent),
        const SizedBox(width: 24),
        previewButton,
      ],
    );
  }

  // --- Main Configuration Management Panel ---
  Widget _buildConfigurationPanel(bool isMobile) {
    // ফিক্স ৩: মোবাইলে ৪টি ট্যাব পাশাপাশি আটবে না, তাই Horizontal Scrollable Row করা হয়েছে
    final Widget tabListWidget = Row(
      children: [
        _buildTabItem('FABRIC & PATTERN', Icons.layers_outlined, isMobile),
        _buildTabItem('COLORS', Icons.palette_outlined, isMobile),
        _buildTabItem('STYLE & FIT', Icons.content_cut_outlined, isMobile),
        _buildTabItem('DETAILS', Icons.info_outline, isMobile),
      ],
    );

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMobile
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: IntrinsicHeight(child: tabListWidget),
                )
              : tabListWidget,
          Padding(
            padding: EdgeInsets.all(isMobile ? 20.0 : 32.0),
            child: _buildActiveTabContent(isMobile),
          ),
        ],
      ),
    );
  }

  // --- Dynamic Body Content Based On Active Tab Selection ---
  Widget _buildActiveTabContent(bool isMobile) {
    switch (selectedTab) {
      case 'FABRIC & PATTERN':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('FABRIC SELECTION'),
            const SizedBox(height: 16),
            _buildGridOptions(
              items: [
                'Cotton',
                'Silk',
                'Linen',
                'Wool',
                'Polyester',
                'Denim',
                'Leather',
                'Velvet',
                'Satin',
                'Chiffon',
              ],
              selectedValue: selectedFabric,
              onSelect: (val) => setState(() => selectedFabric = val),
              isMobile: isMobile,
            ),
            const SizedBox(height: 36),
            _buildSectionTitle('PATTERN TYPE'),
            const SizedBox(height: 16),
            _buildGridOptions(
              items: [
                'Solid',
                'Stripes',
                'Polka Dots',
                'Floral',
                'Geometric',
                'Abstract',
                'Plaid',
                'Paisley',
              ],
              selectedValue: selectedPattern,
              onSelect: (val) => setState(() => selectedPattern = val),
              isMobile: isMobile,
            ),
          ],
        );

      case 'COLORS':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('PRIMARY COLOR SPECIFICATION'),
            const SizedBox(height: 16),
            _buildColorGrid(
              selectedColor: selectedPrimaryColor,
              onColorSelect: (color) =>
                  setState(() => selectedPrimaryColor = color),
            ),
            const SizedBox(height: 36),
            _buildSectionTitle('SECONDARY COLOR (ACCENTS)'),
            const SizedBox(height: 16),
            _buildColorGrid(
              selectedColor: selectedSecondaryColor,
              onColorSelect: (color) =>
                  setState(() => selectedSecondaryColor = color),
            ),
          ],
        );

      case 'STYLE & FIT':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('SLEEVE LENGTH'),
            const SizedBox(height: 16),
            _buildGridOptions(
              items: ['Sleeveless', 'Short', 'Three Quarter', 'Long'],
              selectedValue: selectedSleeveLength,
              onSelect: (val) => setState(() => selectedSleeveLength = val),
              isMobile: isMobile,
            ),
            const SizedBox(height: 36),
            _buildSectionTitle('NECKLINE STYLE'),
            const SizedBox(height: 16),
            _buildGridOptions(
              items: ['Round', 'V Neck', 'Square', 'Boat', 'Collar'],
              selectedValue: selectedNecklineStyle,
              onSelect: (val) => setState(() => selectedNecklineStyle = val),
              isMobile: isMobile,
            ),
            const SizedBox(height: 36),
            _buildSectionTitle('FIT SPECIFICATION'),
            const SizedBox(height: 16),
            _buildGridOptions(
              items: ['Slim', 'Regular', 'Loose', 'Oversized'],
              selectedValue: selectedFitSpecification,
              onSelect: (val) => setState(() => selectedFitSpecification = val),
              isMobile: isMobile,
            ),
          ],
        );

      case 'DETAILS':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('GARMENT LENGTH'),
            const SizedBox(height: 16),
            _buildGridOptions(
              items: ['Crop', 'Regular', 'Long', 'Maxi'],
              selectedValue: selectedGarmentLength,
              onSelect: (val) => setState(() => selectedGarmentLength = val),
              isMobile: isMobile,
            ),
            const SizedBox(height: 36),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: accentOrange.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SYSTEM RECOMMENDATIONS',
                    style: TextStyle(
                      color: accentOrange,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRecommendationBullet(
                    'Subject Round face structure, optimal neckline: round',
                  ),
                  _buildRecommendationBullet(
                    'Body metrics indicate regular fit recommended',
                  ),
                  _buildRecommendationBullet(
                    'Material analysis: Silk + solid compatibility verified',
                  ),
                ],
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  // --- Right Side Live Render Metadata Panel ---
  Widget _buildLiveRenderPanel() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'LIVE RENDER',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 300, // মোবাইলের সুবিধার্থে হাইট সামান্য কমানো হয়েছে
            width: double.infinity,
            decoration: BoxDecoration(
              color: scaffoldBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderMuted),
            ),
            child: Center(
              child: Container(
                width: 80,
                height: 2,
                color: textMuted.withValues(alpha: 0.3),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildMetadataRow('FABRIC:', selectedFabric.toUpperCase()),
          _buildMetadataRow('PATTERN:', selectedPattern.toUpperCase()),
          _buildMetadataRow('SLEEVE:', selectedSleeveLength.toUpperCase()),
          _buildMetadataRow('NECKLINE:', selectedNecklineStyle.toUpperCase()),
          _buildMetadataRow('FIT:', selectedFitSpecification.toUpperCase()),
          _buildMetadataRow('LENGTH:', selectedGarmentLength.toUpperCase()),
        ],
      ),
    );
  }

  // --- Helper Layout and UI Components ---
  Widget _buildTabItem(String title, IconData icon, bool isMobile) {
    bool isSelected = selectedTab == title;

    Widget content = _buildHoverableWidget(
      id: title,
      builder: (isHovered) {
        return GestureDetector(
          onTap: () => setState(() => selectedTab = title),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: isMobile
                  ? 24
                  : 0, // মোবাইলে স্ক্রোলের সুবিধার জন্য হরিজন্টাল প্যাডিং
            ),
            decoration: BoxDecoration(
              color: isSelected ? accentOrange : Colors.transparent,
              border: Border(
                bottom: BorderSide(
                  color: isSelected ? Colors.transparent : borderMuted,
                ),
                right: BorderSide(color: borderMuted),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? Colors.white
                      : (isHovered ? Colors.white : textMuted),
                  size: 18,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isHovered ? Colors.white : textMuted),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // মোবাইলে Expanded সরালে আইটেমগুলো নিজস্ব জায়গা নিয়ে স্ক্রোল করতে পারবে
    return isMobile ? content : Expanded(child: content);
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: textMuted,
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildGridOptions({
    required List<String> items,
    required String selectedValue,
    required Function(String) onSelect,
    required bool isMobile,
  }) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: items.map((item) {
        bool isSelected = selectedValue == item;
        return _buildHoverableWidget(
          id: item,
          builder: (isHovered) {
            return GestureDetector(
              onTap: () => onSelect(item),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                // ফিক্স ৪: মোবাইলের স্ক্রিন উইডথ অনুযায়ী আইটেম সাইজ যেন অটো এডজাস্ট হয়
                width: isMobile
                    ? (MediaQuery.of(context).size.width - 64) / 2
                    : 135,
                padding: const EdgeInsets.symmetric(vertical: 18),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? accentOrange
                        : (isHovered
                              ? textMuted.withValues(alpha: 0.6)
                              : borderMuted),
                    width: isSelected ? 1.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: accentOrange.withValues(alpha: 0.25),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isHovered ? Colors.white : textMuted),
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildColorGrid({
    required Color selectedColor,
    required Function(Color) onColorSelect,
  }) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: colorPalette.map((color) {
        bool isSelected = selectedColor == color;
        String colorKey = color.toARGB32().toString();
        return _buildHoverableWidget(
          id: colorKey,
          builder: (isHovered) {
            return GestureDetector(
              onTap: () => onColorSelect(color),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width:
                    44, // মোবাইলে গ্রিড সুন্দর দেখানোর জন্য সামান্য সাইজ অপ্টিমাইজেশন
                height: 44,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? accentOrange
                        : (isHovered ? Colors.white54 : Colors.transparent),
                    width: isSelected ? 2.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: accentOrange.withValues(alpha: 0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildRecommendationBullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              color: accentOrange,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
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

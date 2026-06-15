import 'package:flutter/material.dart';
import 'preview.dart';

class DesignStudioScreen extends StatefulWidget {
  const DesignStudioScreen({super.key});

  @override
  State<DesignStudioScreen> createState() => _DesignStudioScreenState();
}

class _DesignStudioScreenState extends State<DesignStudioScreen> {
  int _activeTabIndex = 0;
  String _selectedFabric = 'Cotton';
  String _selectedPattern = 'Solid';
  int _selectedPrimaryColorIndex = 0;
  int _selectedSecondaryColorIndex = 1;
  String _selectedSleeveLength = 'Short';
  String _selectedNeckline = 'Round';
  final String _selectedFit = 'Regular';
  String _selectedGarmentLength = 'Regular';

  final Color backgroundColor = const Color(0xFFF4F6F9);
  final Color primaryDarkColor = const Color(0xFF111827);
  final Color subtitleColor = const Color(0xFF718096);
  final Color cardBgColor = Colors.white;
  final Color unselectedBorderColor = const Color(0xFFE2E8F0);

  final List<Color> _colorSwatches = [
    const Color(0xFF16192E),
    const Color(0xFF1E293B),
    const Color(0xFF0F4C81),
    const Color(0xFF583D8A),
    const Color(0xFFE04A66),
    const Color(0xFFF9690E),
    const Color(0xFFF9A825),
    const Color(0xFFE6E29B),
    const Color(0xFFFFFFFF),
    const Color(0xFF334155),
    const Color(0xFFEF5350),
    const Color(0xFFED7E43),
    const Color(0xFFFDD835),
    const Color(0xFF2ECC71),
    const Color(0xFF6A1B9A),
  ];

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder ব্যবহার করা হয়েছে যাতে প্রতিবার রান বা রি-স্টার্টে নিখুঁত স্ক্রিন সাইজ পাওয়া যায়
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double screenWidth = constraints.maxWidth;
            final bool isLargeScreen = screenWidth > 950;
            final bool isMobile = screenWidth < 650;

            return SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // হেডার সেকশন: মোবাইলের জন্য Column এবং ওয়েবের জন্য Row অটো হ্যান্ডেল করবে
                      isMobile
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildHeaderTitle(),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: _buildPreviewButton(),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: _buildHeaderTitle()),
                                const SizedBox(width: 16),
                                _buildPreviewButton(),
                              ],
                            ),
                      const SizedBox(height: 32),

                      // মেইন কন্টেন্ট স্প্লিট
                      isLargeScreen
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: _buildCustomizerPanelCard(isMobile),
                                ),
                                const SizedBox(width: 32),
                                Expanded(
                                  flex: 4,
                                  child: _buildLivePreviewCard(),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _buildCustomizerPanelCard(isMobile),
                                const SizedBox(height: 32),
                                _buildLivePreviewCard(),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Design Studio',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: primaryDarkColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Customize your garment design',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: subtitleColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewButton() {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ThreeDPreviewScreen()),
        );
      },
      label: const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
      icon: const Text(
        'Preview Design',
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDarkColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    );
  }

  Widget _buildCustomizerPanelCard(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSegmentedTabBar(isMobile),
          Padding(
            padding: EdgeInsets.all(isMobile ? 16.0 : 28.0),
            child: IndexedStack(
              index: _activeTabIndex,
              children: [
                _buildFabricAndPatternTab(isMobile),
                _buildColorsTab(),
                _buildStyleAndFitTab(isMobile),
                _buildDetailsTab(isMobile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedTabBar(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: unselectedBorderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildTabItem(0, Icons.layers_outlined, 'Fabric', isMobile),
          _buildTabItem(1, Icons.palette_outlined, 'Colors', isMobile),
          _buildTabItem(2, Icons.architecture_outlined, 'Style', isMobile),
          _buildTabItem(3, Icons.info_outline, 'Details', isMobile),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, IconData icon, String label, bool isMobile) {
    final bool isActive = _activeTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTabIndex = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 14 : 20),
          decoration: BoxDecoration(
            color: isActive ? primaryDarkColor : Colors.transparent,
            borderRadius: index == 0
                ? const BorderRadius.only(topLeft: Radius.circular(16))
                : (index == 3
                      ? const BorderRadius.only(topRight: Radius.circular(16))
                      : null),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : subtitleColor,
                size: 18,
              ),
              if (!isMobile) ...[
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: isActive ? Colors.white : subtitleColor,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVariantSelectionSection(
    String title,
    List<String> options,
    String currentSelection,
    Function(String) onSelected,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: primaryDarkColor,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: isMobile ? 8 : 12,
          runSpacing: isMobile ? 8 : 12,
          children: options.map((item) {
            final bool isSelected = item == currentSelection;
            return InkWell(
              onTap: () => onSelected(item),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 24,
                  vertical: isMobile ? 12 : 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? primaryDarkColor
                        : unselectedBorderColor,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    color: primaryDarkColor,
                    fontSize: 14,
                    fontWeight: isSelected
                        ? FontWeight.w700
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFabricAndPatternTab(bool isMobile) {
    return Column(
      children: [
        _buildVariantSelectionSection(
          'Select Fabric',
          ['Cotton', 'Silk', 'Linen', 'Wool', 'Polyester'],
          _selectedFabric,
          (val) => setState(() => _selectedFabric = val),
          isMobile,
        ),
        const SizedBox(height: 32),
        _buildVariantSelectionSection(
          'Pattern',
          ['Solid', 'Stripes', 'Polka Dots', 'Floral'],
          _selectedPattern,
          (val) => setState(() => _selectedPattern = val),
          isMobile,
        ),
      ],
    );
  }

  Widget _buildStyleAndFitTab(bool isMobile) {
    return Column(
      children: [
        _buildVariantSelectionSection(
          'Sleeve Length',
          ['Sleeveless', 'Short', 'Long'],
          _selectedSleeveLength,
          (val) => setState(() => _selectedSleeveLength = val),
          isMobile,
        ),
        const SizedBox(height: 32),
        _buildVariantSelectionSection(
          'Neckline Style',
          ['Round', 'V Neck', 'Collar'],
          _selectedNeckline,
          (val) => setState(() => _selectedNeckline = val),
          isMobile,
        ),
      ],
    );
  }

  Widget _buildDetailsTab(bool isMobile) {
    return _buildVariantSelectionSection(
      'Garment Length',
      ['Crop', 'Regular', 'Long'],
      _selectedGarmentLength,
      (val) => setState(() => _selectedGarmentLength = val),
      isMobile,
    );
  }

  Widget _buildColorsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Primary Color',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: primaryDarkColor,
          ),
        ),
        const SizedBox(height: 16),
        _buildColorGrid(
          _selectedPrimaryColorIndex,
          (idx) => setState(() => _selectedPrimaryColorIndex = idx),
        ),
        const SizedBox(height: 32),
        Text(
          'Secondary Color (Accents)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: primaryDarkColor,
          ),
        ),
        const SizedBox(height: 16),
        _buildColorGrid(
          _selectedSecondaryColorIndex,
          (idx) => setState(() => _selectedSecondaryColorIndex = idx),
        ),
      ],
    );
  }

  Widget _buildColorGrid(int selectedIndex, Function(int) onColorSelected) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(_colorSwatches.length, (index) {
        final bool isSelected = selectedIndex == index;
        return GestureDetector(
          onTap: () => onColorSelected(index),
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: _colorSwatches[index],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? primaryDarkColor : Colors.transparent,
                width: isSelected ? 3 : 1,
              ),
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : null,
          ),
        );
      }),
    );
  }

  Widget _buildLivePreviewCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Live Preview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryDarkColor,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 260,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF161624),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 24),
          _buildMetadataRow('Fabric:', _selectedFabric),
          _buildMetadataRow('Pattern:', _selectedPattern),
          _buildMetadataRow('Fit:', _selectedFit),
          _buildMetadataRow('Neckline:', _selectedNeckline),
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
          Text(label, style: TextStyle(color: subtitleColor, fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              color: primaryDarkColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

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
  final String _selectedFit =
      'Regular';
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
    final bool isLargeScreen = MediaQuery.of(context).size.width > 950;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1300),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header Top Row Panel ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
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
                      ),

                      // --- Preview Design Button ---
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ThreeDPreviewScreen(),
                            ),
                          );
                        },
                        icon: const Text(
                          'Preview Design',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        label: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 16,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryDarkColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // --- Main Split Content ---
                  isLargeScreen
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 6,
                              child: _buildCustomizerPanelCard(),
                            ),
                            const SizedBox(width: 32),
                            Expanded(flex: 4, child: _buildLivePreviewCard()),
                          ],
                        )
                      : Column(
                          children: [
                            _buildCustomizerPanelCard(),
                            const SizedBox(height: 32),
                            _buildLivePreviewCard(),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomizerPanelCard() {
    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSegmentedTabBar(),
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: IndexedStack(
              index: _activeTabIndex,
              children: [
                _buildFabricAndPatternTab(),
                _buildColorsTab(),
                _buildStyleAndFitTab(),
                _buildDetailsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: unselectedBorderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildTabItem(0, Icons.layers_outlined, 'Fabric & Pattern'),
          _buildTabItem(1, Icons.palette_outlined, 'Colors'),
          _buildTabItem(2, Icons.architecture_outlined, 'Style & Fit'),
          _buildTabItem(3, Icons.info_outline, 'Details'),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, IconData icon, String label) {
    final bool isActive = _activeTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
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
                size: 20,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isActive ? Colors.white : subtitleColor,
                    fontWeight: isActive
                        ? FontWeight.w600
                        : FontWeight
                              .normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFabricAndPatternTab() {
    final List<String> fabrics = [
      'Cotton',
      'Silk',
      'Linen',
      'Wool',
      'Polyester',
    ];
    final List<String> patterns = ['Solid', 'Stripes', 'Polka Dots', 'Floral'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Select Fabric'),
        const SizedBox(height: 16),
        _buildResponsiveButtonCloud(
          fabrics,
          _selectedFabric,
          (val) => setState(() => _selectedFabric = val),
        ),
        const SizedBox(height: 32),
        _buildSectionHeader('Pattern'),
        const SizedBox(height: 16),
        _buildResponsiveButtonCloud(
          patterns,
          _selectedPattern,
          (val) => setState(() => _selectedPattern = val),
        ),
      ],
    );
  }

  Widget _buildColorsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Primary Color'),
        const SizedBox(height: 16),
        _buildColorSelectionGrid(
          _selectedPrimaryColorIndex,
          (idx) => setState(() => _selectedPrimaryColorIndex = idx),
        ),
        const SizedBox(height: 32),
        _buildSectionHeader('Secondary Color (Accents)'),
        const SizedBox(height: 16),
        _buildColorSelectionGrid(
          _selectedSecondaryColorIndex,
          (idx) => setState(() => _selectedSecondaryColorIndex = idx),
        ),
      ],
    );
  }

  Widget _buildStyleAndFitTab() {
    final List<String> sleeves = ['Sleeveless', 'Short', 'Long'];
    final List<String> necklines = ['Round', 'V Neck', 'Collar'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Sleeve Length'),
        const SizedBox(height: 16),
        _buildResponsiveButtonCloud(
          sleeves,
          _selectedSleeveLength,
          (val) => setState(() => _selectedSleeveLength = val),
        ),
        const SizedBox(height: 32),
        _buildSectionHeader('Neckline Style'),
        const SizedBox(height: 16),
        _buildResponsiveButtonCloud(
          necklines,
          _selectedNeckline,
          (val) => setState(() => _selectedNeckline = val),
        ),
      ],
    );
  }

  Widget _buildDetailsTab() {
    final List<String> lengths = ['Crop', 'Regular', 'Long'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Garment Length'),
        const SizedBox(height: 16),
        _buildResponsiveButtonCloud(
          lengths,
          _selectedGarmentLength,
          (val) => setState(() => _selectedGarmentLength = val),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: primaryDarkColor,
      ),
    );
  }

  Widget _buildResponsiveButtonCloud(
    List<String> variants,
    String currentSelection,
    Function(String) onSelected,
  ) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: variants.map((item) {
        final bool isSelected = item == currentSelection;
        return InkWell(
          onTap: () => onSelected(item),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? primaryDarkColor : unselectedBorderColor,
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
                    : FontWeight
                          .normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildColorSelectionGrid(
    int selectedIndex,
    Function(int) onColorSelected,
  ) {
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: List.generate(_colorSwatches.length, (index) {
        final Color swatchColor = _colorSwatches[index];
        final bool isSelected = selectedIndex == index;
        return GestureDetector(
          onTap: () => onColorSelected(index),
          child: Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: swatchColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? primaryDarkColor : Colors.transparent,
                width: isSelected ? 3 : 1,
              ),
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : const SizedBox.shrink(),
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
            color: Colors.black.withValues(alpha: 0.03),
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
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF161624),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 24),
          _buildMetadataRow('Fabric:', _selectedFabric),
          const SizedBox(height: 12),
          _buildMetadataRow('Pattern:', _selectedPattern),
          const SizedBox(height: 12),
          _buildMetadataRow('Fit:', _selectedFit),
          const SizedBox(height: 12),
          _buildMetadataRow('Neckline:', _selectedNeckline),
        ],
      ),
    );
  }

  Widget _buildMetadataRow(String propertyLabel, String dynamicValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          propertyLabel,
          style: TextStyle(color: subtitleColor, fontSize: 14),
        ),
        Text(
          dynamicValue,
          style: TextStyle(
            color: primaryDarkColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

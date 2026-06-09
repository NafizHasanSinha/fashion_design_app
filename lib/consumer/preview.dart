import 'package:flutter/material.dart';

class ThreeDPreviewScreen extends StatefulWidget {
  const ThreeDPreviewScreen({super.key});

  @override
  State<ThreeDPreviewScreen> createState() => _ThreeDPreviewScreenState();
}

class _ThreeDPreviewScreenState extends State<ThreeDPreviewScreen> {
  // --- কালার প্যালেট ---
  final Color backgroundColor = const Color(0xFFF4F6F9);
  final Color primaryDarkColor = const Color(0xFF111827);
  final Color subtitleColor = const Color(0xFF718096);
  final Color cardBgColor = Colors.white;
  final Color canvasBgColor = const Color(0xFFE5E9F0);
  final Color outlineBorderColor = const Color(0xFFE2E8F0);
  final Color dialogueSubColor = const Color(0xFF4A5568);

  // --- কাস্টম এক্সপোর্ট ডায়ালগ ---
  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 10,
          backgroundColor: Colors.white,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Export Design',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: primaryDarkColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose your preferred export format for production',
                  style: TextStyle(
                    fontSize: 15,
                    color: dialogueSubColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 28),
                _buildExportOption(
                  icon: Icons.description_outlined,
                  iconColor: const Color(0xFF3B82F6),
                  iconBgColor: const Color(0xFFEFF6FF),
                  title: 'DXF Format',
                  subtitle: 'For AutoCAD and industrial pattern making',
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 16),
                _buildExportOption(
                  icon: Icons.assignment_outlined,
                  iconColor: const Color(0xFF10B981),
                  iconBgColor: const Color(0xFFECFDF5),
                  title: 'JSON Format',
                  subtitle: 'Full design data with metadata',
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 16),
                _buildExportOption(
                  icon: Icons.picture_as_pdf_outlined,
                  iconColor: const Color(0xFF8B5CF6),
                  iconBgColor: const Color(0xFFF5F3FF),
                  title: 'SVG Format',
                  subtitle: 'Vector graphics for digital use',
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 32),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: primaryDarkColor.withValues(alpha: 0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExportOption({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: outlineBorderColor, width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: primaryDarkColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: dialogueSubColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- কাস্টম এডিট ডিজাইন ডায়ালগ (Default Tab: Design Options) ---
  void _showEditDesignDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return DefaultTabController(
          length: 2,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height * 0.85,
              constraints: const BoxConstraints(maxWidth: 900, maxHeight: 650),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edit Design',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primaryDarkColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Adjust any element of your design',
                              style: TextStyle(
                                fontSize: 13,
                                color: subtitleColor,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  // Tab Bar
                  Container(
                    color: const Color(0xFFF8FAFC),
                    child: TabBar(
                      tabs: const [
                        Tab(text: 'Design Options'),
                        Tab(text: 'Measurements'),
                      ],
                      labelColor: Colors.white,
                      unselectedLabelColor: const Color(0xFF475569),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(color: primaryDarkColor),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  // Tab Bar View Content
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildEditDesignOptionsTab(),
                        _buildEditMeasurementsTab(),
                      ],
                    ),
                  ),
                  // Footer Actions
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: outlineBorderColor),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFF475569),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.save_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                          label: const Text(
                            'Save Changes',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryDarkColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Edit Design -> Design Options Tab
  Widget _buildEditDesignOptionsTab() {
    final List<Color> colors = [
      const Color(0xFF1A1A2E),
      const Color(0xFF16213E),
      const Color(0xFF0F3460),
      const Color(0xFF533483),
      const Color(0xFFE94560),
      const Color(0xFFFF6B00),
      const Color(0xFFFFB100),
      const Color(0xFFE2E8F0),
      Colors.white,
      const Color(0xFF334155),
      const Color(0xFFF43F5E),
      const Color(0xFFFB923C),
      const Color(0xFFFCD34D),
      const Color(0xFF4ADE80),
      const Color(0xFF6366F1),
    ];

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Fabric & Pattern',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryDarkColor,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDropdownField('Fabric', 'Cotton', [
                'Cotton',
                'Silk',
                'Linen',
                'Wool',
                'Polyester',
              ]),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDropdownField('Pattern', 'Stripes', [
                'Solid',
                'Stripes',
                'Polka Dots',
                'Floral',
              ]),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Colors',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryDarkColor,
          ),
        ),
        const SizedBox(height: 12),
        _buildColorSelector('Primary Color', colors, colors[0]),
        const SizedBox(height: 16),
        _buildColorSelector('Secondary Color', colors, colors[1]),
        const SizedBox(height: 24),
        Text(
          'Style Options',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryDarkColor,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDropdownField('Sleeve Length', 'Short', [
                'Short',
                'Long',
                'Three-Quarter',
              ]),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDropdownField('Neckline', 'Round', [
                'Round',
                'V-Neck',
                'Collar',
              ]),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDropdownField('Fit', 'Regular', [
                'Regular',
                'Slim Fit',
                'Oversized',
              ]),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDropdownField('Length', 'Regular', [
                'Regular',
                'Long',
                'Crop',
              ]),
            ),
          ],
        ),
      ],
    );
  }

  // Edit Design -> Measurements Tab
  Widget _buildEditMeasurementsTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Adjust measurements to ensure the perfect fit. All measurements are in inches.',
            style: TextStyle(color: Color(0xFF1E40AF), fontSize: 13),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _buildSliderInputField('Shoulders', 40, 30, 50)),
            const SizedBox(width: 24),
            Expanded(child: _buildSliderInputField('Chest', 43, 35, 55)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildSliderInputField('Waist', 31, 25, 45)),
            const SizedBox(width: 24),
            Expanded(child: _buildSliderInputField('Hips', 43, 35, 55)),
          ],
        ),
      ],
    );
  }

  // --- কাস্টম ইন্ডাস্ট্রিয়াল ডায়ালগ ---
  void _showIndustrialDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.85,
            constraints: const BoxConstraints(maxWidth: 1000, maxHeight: 680),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Industrial Features',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryDarkColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Professional-grade pattern making and production controls',
                            style: TextStyle(
                              fontSize: 13,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                // Horizontal Sub-Tabs List Panel
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      _buildSubTabItem('Precise Measurements', true),
                      _buildSubTabItem('Fabric Specs', false),
                      _buildSubTabItem('Pattern Modules', false),
                      _buildSubTabItem('3D Mapping', false),
                      _buildSubTabItem('Bulk Production', false),
                      _buildSubTabItem('Supply Chain', false),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1),
                // Tab Content Area
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Color(0xFF3B82F6),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Precise measurements ensure industrial-grade pattern accuracy. All measurements are in inches and will be used for automated pattern generation and grading.',
                                style: TextStyle(
                                  color: const Color(0xFF1E40AF),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Grid Inputs
                      Row(
                        children: [
                          Expanded(
                            child: _buildIndustrialSliderRow(
                              'Bust',
                              36,
                              30,
                              50,
                            ),
                          ),
                          const SizedBox(width: 32),
                          Expanded(
                            child: _buildIndustrialSliderRow(
                              'Waist',
                              28,
                              20,
                              45,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildIndustrialSliderRow('Hip', 38, 30, 50),
                          ),
                          const SizedBox(width: 32),
                          Expanded(
                            child: _buildIndustrialSliderRow(
                              'Sleeve Length',
                              24,
                              15,
                              35,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildIndustrialSliderRow(
                              'Height',
                              66,
                              50,
                              80,
                            ),
                          ),
                          const SizedBox(width: 32),
                          Expanded(
                            child: _buildIndustrialSliderRow(
                              'Shoulder Width',
                              15,
                              10,
                              25,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Measurement Summary Footer Box
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF5FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Measurement Summary',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: primaryDarkColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildSummaryText('Body Type:', 'Balanced'),
                                _buildSummaryText('Fit Category:', 'Petite'),
                                _buildSummaryText(
                                  'Height Category:',
                                  'Regular',
                                ),
                                _buildSummaryText('Arm Length:', 'Regular'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Footer
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All industrial settings are automatically included in your export',
                        style: TextStyle(color: subtitleColor, fontSize: 13),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryDarkColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper Widgets
  Widget _buildSubTabItem(String title, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isActive ? primaryDarkColor : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? primaryDarkColor : const Color(0xFF64748B),
          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSummaryText(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: subtitleColor, fontSize: 12)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: primaryDarkColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: primaryDarkColor,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: value,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: outlineBorderColor),
            ),
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) {},
        ),
      ],
    );
  }

  Widget _buildColorSelector(
    String label,
    List<Color> colors,
    Color selectedColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: primaryDarkColor,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: colors.length,
            itemBuilder: (context, index) {
              final color = colors[index];
              final isSelected = color == selectedColor;
              return Container(
                margin: const EdgeInsets.only(right: 8),
                width: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isSelected ? primaryDarkColor : outlineBorderColor,
                    width: isSelected ? 2 : 1,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSliderInputField(
    String label,
    double value,
    double min,
    double max,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: primaryDarkColor,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: outlineBorderColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${value.toInt()}',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'inches',
              style: TextStyle(color: subtitleColor, fontSize: 13),
            ),
          ],
        ),
        Slider(value: value, min: min, max: max, onChanged: (val) {}),
      ],
    );
  }

  Widget _buildIndustrialSliderRow(
    String label,
    double value,
    double min,
    double max,
  ) {
    return Row(
      children: [
        Icon(Icons.linear_scale, size: 16, color: subtitleColor),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryDarkColor,
                  fontSize: 14,
                ),
              ),
              Slider(value: value, min: min, max: max, onChanged: (val) {}),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${value.toInt()} inches',
              style: TextStyle(color: subtitleColor, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Container(
              width: 50,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: outlineBorderColor),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${value.toInt()}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- মেইন প্রিভিউ UI স্ক্রিন বিল্ডার ---
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
                  _buildHeader(context),
                  const SizedBox(height: 32),
                  isLargeScreen
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 6, child: _build3DMockupCanvas()),
                            const SizedBox(width: 32),
                            Expanded(
                              flex: 4,
                              child: Column(
                                children: [
                                  _buildSpecificationsCard(),
                                  const SizedBox(height: 24),
                                  _buildMeasurementsCard(),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            _build3DMockupCanvas(),
                            const SizedBox(height: 32),
                            _buildSpecificationsCard(),
                            const SizedBox(height: 24),
                            _buildMeasurementsCard(),
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

  Widget _buildHeader(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 950;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: primaryDarkColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '3D Preview',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: primaryDarkColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Review your design before export',
                  style: TextStyle(fontSize: 14, color: subtitleColor),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            _buildHeaderOutlinedButton(
              Icons.edit_outlined,
              'Edit Design',
              () => _showEditDesignDialog(context),
            ),
            const SizedBox(width: 12),
            _buildHeaderOutlinedButton(
              Icons.settings_outlined,
              'Industrial',
              () => _showIndustrialDialog(context),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: outlineBorderColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.share_outlined,
                  color: primaryDarkColor,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () => _showExportDialog(context),
              icon: const Icon(
                Icons.vertical_align_bottom_sharp,
                color: Colors.white,
                size: 18,
              ),
              label: isLargeScreen
                  ? const Text(
                      'Export',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : const SizedBox.shrink(),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryDarkColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderOutlinedButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: primaryDarkColor, size: 18),
      label: Text(
        label,
        style: TextStyle(
          color: primaryDarkColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: outlineBorderColor),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _build3DMockupCanvas() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '3D Mockup',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: primaryDarkColor,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.zoom_out, color: primaryDarkColor, size: 18),
                  const SizedBox(width: 12),
                  Text(
                    '100%',
                    style: TextStyle(
                      fontSize: 13,
                      color: primaryDarkColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.zoom_in, color: primaryDarkColor, size: 18),
                  const SizedBox(width: 12),
                  Container(height: 16, width: 1, color: outlineBorderColor),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.refresh_rounded,
                    color: primaryDarkColor,
                    size: 18,
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.fullscreen_rounded,
                    color: primaryDarkColor,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 480,
            width: double.infinity,
            decoration: BoxDecoration(
              color: canvasBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    height: 280,
                    width: 240,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2E),
                      borderRadius: BorderRadius.circular(120),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: -15,
                          child: Container(
                            height: 80,
                            width: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF161622),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        Positioned(
                          right: -15,
                          child: Container(
                            height: 80,
                            width: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF161622),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 140,
                              height: 4,
                              color: const Color(0xFF26293B),
                            ),
                            const SizedBox(height: 40),
                            Container(
                              width: 140,
                              height: 4,
                              color: const Color(0xFF26293B),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatusItem('Rotation', '0°'),
                        _buildStatusItem('Zoom', '100%'),
                        _buildStatusItem('Quality', 'High'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: subtitleColor)),
        const SizedBox(height: 2),
        Text(
          val,
          style: TextStyle(
            fontSize: 13,
            color: primaryDarkColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecificationsCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Design Specifications',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: primaryDarkColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildRowData('Fabric', 'Cotton', false),
          _buildRowData('Pattern', 'Stripes', false),
          _buildRowData(
            'Primary Color',
            '#1a1a2e',
            true,
            colorVal: const Color(0xFF1A1A2E),
          ),
          _buildRowData(
            'Secondary Color',
            '#16213e',
            true,
            colorVal: const Color(0xFF16213E),
          ),
          _buildRowData('Sleeve Length', 'Short', false),
          _buildRowData('Neckline', 'Round', false),
          _buildRowData('Fit', 'Regular', false),
          _buildRowData('Length', 'Regular', false, isLast: true),
        ],
      ),
    );
  }

  Widget _buildMeasurementsCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Body Measurements',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: primaryDarkColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildRowData('Shoulders', '40"', false),
          _buildRowData('Chest', '43"', false),
          _buildRowData('Waist', '31"', false),
          _buildRowData('Hips', '43"', false, isLast: true),
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
            : Border(bottom: BorderSide(color: backgroundColor, width: 1.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(leftLabel, style: TextStyle(color: subtitleColor, fontSize: 14)),
          Row(
            children: [
              if (isColor && colorVal != null) ...[
                Container(
                  height: 14,
                  width: 14,
                  decoration: BoxDecoration(
                    color: colorVal,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                rightValue,
                style: TextStyle(
                  color: primaryDarkColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

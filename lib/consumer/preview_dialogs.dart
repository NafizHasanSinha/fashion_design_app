import 'package:flutter/material.dart';

class PreviewDialogs {
  // --- Common Color Palette ---
  static const Color primaryDarkColor = Color(0xFF111827);
  static const Color subtitleColor = Color(0xFF718096);
  static const Color outlineBorderColor = Color(0xFFE2E8F0);
  static const Color dialogueSubColor = Color(0xFF4A5568);

  // --- 1. Custom Export Dialog ---
  static void showExport(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

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
            padding: EdgeInsets.symmetric(
              horizontal: isMobile
                  ? 20
                  : 32, // মোবাইলে প্যাডিং অ্যাডাপ্টিভ করা হয়েছে
              vertical: 36,
            ),
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

  static Widget _buildExportOption({
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
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: primaryDarkColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
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

  // --- 2. Custom Edit Design Dialog ---
  static void showEditDesign(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final double screenWidth = MediaQuery.of(context).size.width;
        final double screenHeight = MediaQuery.of(context).size.height;
        final bool isMobile = screenWidth < 650;

        return DefaultTabController(
          length: 2,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            // ১ নম্বর ফিক্স: মোবাইলের জন্য উইডথ এবং হাইট রেসপন্সিভ করা হয়েছে
            child: Container(
              width: isMobile ? screenWidth * 0.95 : screenWidth * 0.75,
              height: isMobile ? screenHeight * 0.90 : screenHeight * 0.85,
              constraints: const BoxConstraints(maxWidth: 900, maxHeight: 650),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Edit Design',
                                style: const TextStyle(
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
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: const Color(0xFFF8FAFC),
                    child: const TabBar(
                      tabs: [
                        Tab(text: 'Design Options'),
                        Tab(text: 'Measurements'),
                      ],
                      labelColor: Colors.white,
                      unselectedLabelColor: Color(0xFF475569),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(color: primaryDarkColor),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildEditDesignOptionsTab(isMobile),
                        _buildEditMeasurementsTab(isMobile),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: const BoxDecoration(
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
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryDarkColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
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

  // ২ নম্বর ফিক্স: মোবাইলে ইনপুট ফিল্ডগুলো কলাম আকারে নিচে নিচে সাজানো হবে
  static Widget _buildEditDesignOptionsTab(bool isMobile) {
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
    ];

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Fabric & Pattern',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryDarkColor,
          ),
        ),
        const SizedBox(height: 16),
        if (isMobile) ...[
          _buildDropdownField('Fabric', 'Cotton', [
            'Cotton',
            'Silk',
            'Linen',
            'Wool',
            'Polyester',
          ]),
          const SizedBox(height: 16),
          _buildDropdownField('Pattern', 'Stripes', [
            'Solid',
            'Stripes',
            'Polka Dots',
            'Floral',
          ]),
        ] else
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
          style: const TextStyle(
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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryDarkColor,
          ),
        ),
        const SizedBox(height: 16),
        if (isMobile) ...[
          _buildDropdownField('Sleeve Length', 'Short', [
            'Short',
            'Long',
            'Three-Quarter',
          ]),
          const SizedBox(height: 16),
          _buildDropdownField('Neckline', 'Round', [
            'Round',
            'V-Neck',
            'Collar',
          ]),
          const SizedBox(height: 16),
          _buildDropdownField('Fit', 'Regular', [
            'Regular',
            'Slim Fit',
            'Oversized',
          ]),
          const SizedBox(height: 16),
          _buildDropdownField('Length', 'Regular', ['Regular', 'Long', 'Crop']),
        ] else ...[
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
      ],
    );
  }

  // ৩ নম্বর ফিক্স: মেজারমেন্ট স্লাইডার মোবাইলে নিচে নিচে আসবে
  static Widget _buildEditMeasurementsTab(bool isMobile) {
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
        if (isMobile) ...[
          _buildSliderInputField('Shoulders', 40, 30, 50),
          const SizedBox(height: 20),
          _buildSliderInputField('Chest', 43, 35, 55),
          const SizedBox(height: 20),
          _buildSliderInputField('Waist', 31, 25, 45),
          const SizedBox(height: 20),
          _buildSliderInputField('Hips', 43, 35, 55),
        ] else ...[
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
      ],
    );
  }

  // --- 3. Custom Industrial Dialog ---
  static void showIndustrial(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final double screenWidth = MediaQuery.of(context).size.width;
        final double screenHeight = MediaQuery.of(context).size.height;
        final bool isMobile = screenWidth < 650;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: isMobile ? screenWidth * 0.95 : screenWidth * 0.85,
            height: isMobile ? screenHeight * 0.90 : screenHeight * 0.85,
            constraints: const BoxConstraints(maxWidth: 1000, maxHeight: 680),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Industrial Features',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primaryDarkColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Professional-grade pattern making controls',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: subtitleColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
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
                        child: const Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Color(0xFF3B82F6),
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Precise measurements ensure industrial-grade pattern accuracy.',
                                style: TextStyle(
                                  color: Color(0xFF1E40AF),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // ৪ নম্বর ফিক্স: মেইন কন্টেন্টের স্লাইডার রো-গুলোকে মোবাইলের জন্য কলামে রূপান্তর
                      if (isMobile) ...[
                        _buildIndustrialSliderRow('Bust', 36, 30, 50),
                        const SizedBox(height: 16),
                        _buildIndustrialSliderRow('Waist', 28, 20, 45),
                        const SizedBox(height: 16),
                        _buildIndustrialSliderRow('Hip', 38, 30, 50),
                        const SizedBox(height: 16),
                        _buildIndustrialSliderRow('Sleeve Length', 24, 15, 35),
                        const SizedBox(height: 16),
                        _buildIndustrialSliderRow('Height', 66, 50, 80),
                        const SizedBox(height: 16),
                        _buildIndustrialSliderRow('Shoulder Width', 15, 10, 25),
                      ] else ...[
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
                              child: _buildIndustrialSliderRow(
                                'Hip',
                                38,
                                30,
                                50,
                              ),
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
                      ],
                      const SizedBox(height: 24),
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
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: primaryDarkColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // ৫ নম্বর ফিক্স: মোবাইলের সংকীর্ণ জায়গায় ওভারফ্লো এড়াতে Row এর বদলে Wrap ব্যবহার
                            Wrap(
                              spacing: 16,
                              runSpacing: 12,
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
                // ৬ নম্বর ফিক্স: বটম বারটিকে রেসপন্সিভ করা হয়েছে যাতে লেখা কেটে না যায়
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'All industrial settings are automatically included in your export',
                              style: TextStyle(
                                color: subtitleColor,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryDarkColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
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
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'All industrial settings are automatically included in your export',
                                style: TextStyle(
                                  color: subtitleColor,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
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

  // --- Shared Small Helper Widgets ---
  static Widget _buildSubTabItem(String title, bool isActive) {
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

  static Widget _buildSummaryText(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: subtitleColor, fontSize: 12)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: primaryDarkColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  static Widget _buildDropdownField(
    String label,
    String value,
    List<String> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
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
              borderSide: const BorderSide(color: outlineBorderColor),
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

  static Widget _buildColorSelector(
    String label,
    List<Color> colors,
    Color selectedColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
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

  static Widget _buildSliderInputField(
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
          style: const TextStyle(
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

  static Widget _buildIndustrialSliderRow(
    String label,
    double value,
    double min,
    double max,
  ) {
    return Row(
      children: [
        const Icon(Icons.linear_scale, size: 16, color: subtitleColor),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryDarkColor,
                  fontSize: 14,
                ),
              ),
              Slider(value: value, min: min, max: max, onChanged: (val) {}),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${value.toInt()} in',
              style: TextStyle(color: subtitleColor, fontSize: 11),
            ),
            const SizedBox(height: 4),
            Container(
              width: 44,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: Border.all(color: outlineBorderColor),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${value.toInt()}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

// =========================================================================
// 1. EDIT DESIGN DIALOG (Newly added for the MODIFY button)
// =========================================================================
class EditDesignDialog extends StatefulWidget {
  const EditDesignDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const EditDesignDialog(),
    );
  }

  @override
  State<EditDesignDialog> createState() => _EditDesignDialogState();
}

class _EditDesignDialogState extends State<EditDesignDialog> {
  String activeTab = 'Design Options';

  // Design Options States
  String selectedFabric = 'Silk';
  String selectedPattern = 'Solid';
  Color primaryColor = const Color(0xFF13192B);
  Color secondaryColor = const Color(0xFF13192B);

  String selectedSleeveLength = 'Short';
  String selectedNeckline = 'Round';
  String selectedFit = 'Regular';
  String selectedLength = 'Regular';

  // Measurements States
  double shoulders = 38;
  double chest = 43;
  double waist = 32;
  double hips = 40;

  late TextEditingController shouldersCtrl;
  late TextEditingController chestCtrl;
  late TextEditingController waistCtrl;
  late TextEditingController hipsCtrl;

  // Color Palette Grid data from screenshots
  final List<Color> colorPalette = [
    const Color(0xFF1A1A2E),
    const Color(0xFF16213E),
    const Color(0xFF0F3460),
    const Color(0xFF4E31AA),
    const Color(0xFFE94560),
    const Color(0xFFFF6B00),
    const Color(0xFFFFA900),
    const Color(0xFFF7EA9F),
    Colors.white,
    const Color(0xFF34495E),
    const Color(0xFFE74C3C),
    const Color(0xFFE67E22),
    const Color(0xFFF1C40F),
    const Color(0xFF2ECC71),
    const Color(0xFF9B59B6),
  ];

  final List<String> fabrics = [
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
  ];

  final List<String> patterns = [
    'Solid',
    'Stripes',
    'Polka Dots',
    'Floral',
    'Geometric',
    'Abstract',
    'Plaid',
    'Paisley',
  ];

  @override
  void initState() {
    super.initState();
    shouldersCtrl = TextEditingController(text: '${shoulders.round()}');
    chestCtrl = TextEditingController(text: '${chest.round()}');
    waistCtrl = TextEditingController(text: '${waist.round()}');
    hipsCtrl = TextEditingController(text: '${hips.round()}');
  }

  @override
  void dispose() {
    shouldersCtrl.dispose();
    chestCtrl.dispose();
    waistCtrl.dispose();
    hipsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
      child: Container(
        width: 750,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPopupHeader(),
            _buildCustomTabs(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: activeTab == 'Design Options'
                    ? _buildDesignOptionsTab()
                    : _buildMeasurementsTab(),
              ),
            ),
            _buildPopupFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildPopupHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Design',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Adjust any element of your design',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTabs() {
    return Row(
      children: [
        _buildTabButton('Design Options'),
        _buildTabButton('Measurements'),
      ],
    );
  }

  Widget _buildTabButton(String title) {
    bool isSelected = activeTab == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => activeTab = title),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF0F172A)
                : const Color(0xFFF8FAFC),
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? const Color(0xFF0F172A)
                    : const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF475569),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesignOptionsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fabric & Pattern',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDropdown('Fabric', selectedFabric, fabrics, (v) {
                setState(() => selectedFabric = v!);
              }),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDropdown('Pattern', selectedPattern, patterns, (v) {
                setState(() => selectedPattern = v!);
              }),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Colors',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 12),
        const Text(
          'Primary Color',
          style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
        ),
        const SizedBox(height: 8),
        _buildColorGrid(primaryColor, (c) => setState(() => primaryColor = c)),
        const SizedBox(height: 16),
        const Text(
          'Secondary Color',
          style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
        ),
        const SizedBox(height: 8),
        _buildColorGrid(
          secondaryColor,
          (c) => setState(() => secondaryColor = c),
        ),
        const SizedBox(height: 24),
        const Text(
          'Style Options',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDropdown(
                'Sleeve Length',
                selectedSleeveLength,
                ['Short', 'Long', 'Sleeveless'],
                (v) => setState(() => selectedSleeveLength = v!),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDropdown(
                'Neckline',
                selectedNeckline,
                ['Round', 'V-Neck', 'Collar'],
                (v) => setState(() => selectedNeckline = v!),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDropdown('Fit', selectedFit, [
                'Regular',
                'Slim',
                'Oversized',
              ], (v) => setState(() => selectedFit = v!)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDropdown('Length', selectedLength, [
                'Regular',
                'Long',
                'Cropped',
              ], (v) => setState(() => selectedLength = v!)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMeasurementsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: const Text(
            'Adjust measurements to ensure the perfect fit. All measurements are in inches.',
            style: TextStyle(color: Color(0xFF1E40AF), fontSize: 13),
          ),
        ),
        const SizedBox(height: 24),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.5,
          mainAxisSpacing: 20,
          crossAxisSpacing: 24,
          children: [
            _buildMeasurementField(
              'Shoulders',
              shoulders,
              30,
              50,
              shouldersCtrl,
              (v) {
                setState(() {
                  shoulders = v;
                  shouldersCtrl.text = '${v.round()}';
                });
              },
            ),
            _buildMeasurementField('Chest', chest, 35, 60, chestCtrl, (v) {
              setState(() {
                chest = v;
                chestCtrl.text = '${v.round()}';
              });
            }),
            _buildMeasurementField('Waist', waist, 24, 50, waistCtrl, (v) {
              setState(() {
                waist = v;
                waistCtrl.text = '${v.round()}';
              });
            }),
            _buildMeasurementField('Hips', hips, 30, 60, hipsCtrl, (v) {
              setState(() {
                hips = v;
                hipsCtrl.text = '${v.round()}';
              });
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildColorGrid(Color selectedColor, ValueChanged<Color> onSelected) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: colorPalette.map((color) {
        bool isSelected = selectedColor == color;
        return GestureDetector(
          onTap: () => onSelected(color),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF3B82F6)
                    : const Color(0xFFCBD5E1),
                width: isSelected ? 3 : 1,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMeasurementField(
    String label,
    double value,
    double min,
    double max,
    TextEditingController ctrl,
    ValueChanged<double> onSliderChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextField(
                  controller: ctrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'inches',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: const Color(0xFF0066FF),
          inactiveColor: const Color(0xFFE2E8F0),
          onChanged: onSliderChanged,
        ),
      ],
    );
  }

  Widget _buildPopupFooter() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFF475569),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F172A),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.save, color: Colors.white, size: 16),
            label: const Text(
              'Save Changes',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// 2. INDUSTRIAL FEATURES DIALOG
// =========================================================================
class IndustrialFeaturesDialog extends StatefulWidget {
  const IndustrialFeaturesDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const IndustrialFeaturesDialog(),
    );
  }

  @override
  State<IndustrialFeaturesDialog> createState() =>
      _IndustrialFeaturesDialogState();
}

class _IndustrialFeaturesDialogState extends State<IndustrialFeaturesDialog> {
  String activeTab = 'Precise Measurements';

  // State Management for Tab 1: Precise Measurements
  double bust = 36;
  double waist = 28;
  double hip = 38;
  double sleeveLength = 24;
  double height = 66;
  double shoulderWidth = 15;
  double armLength = 23;
  double inseam = 30;
  double neckCircumference = 14;
  double wristCircumference = 6;
  double thighCircumference = 22;

  // State Management for Tab 2: Fabric Specs
  double fabricWeight = 180;
  String selectedTexture = 'Smooth';
  String selectedDurability = 'Medium (Standard)';
  String selectedBreathability = 'High';
  double stretchPercentage = 5;
  double shrinkageRate = 3;
  double colorFastness = 4.0;

  late final TextEditingController fabricWeightController;
  late final TextEditingController stretchController;
  late final TextEditingController shrinkageController;
  late final TextEditingController threadCountController;
  final TextEditingController compositionController = TextEditingController(
    text: '100% Cotton',
  );
  final TextEditingController careController = TextEditingController(
    text: 'Machine wash cold, tumble dry low',
  );

  // State Management for Tab 5: Bulk Production
  final TextEditingController orderIdController = TextEditingController(
    text: 'ORD-1781033591485',
  );
  final TextEditingController totalQtyController = TextEditingController(
    text: '100',
  );
  final TextEditingController deadlineController = TextEditingController(
    text: '07/09/2026',
  );
  String priorityLevel = 'Standard';
  final TextEditingController fabricRollsController = TextEditingController(
    text: '5',
  );
  final TextEditingController estimatedCostController = TextEditingController(
    text: '5000',
  );

  final Map<String, TextEditingController> sizeDist = {
    'XS': TextEditingController(text: '10'),
    'S': TextEditingController(text: '20'),
    'M': TextEditingController(text: '40'),
    'L': TextEditingController(text: '20'),
    'XL': TextEditingController(text: '10'),
  };

  // State Management for Tab 6: Supply Chain
  final TextEditingController supplierNameController = TextEditingController();
  final TextEditingController supplierLocationController =
      TextEditingController();
  final TextEditingController orderDateController = TextEditingController(
    text: '06/09/2026',
  );
  final TextEditingController expectedDeliveryController =
      TextEditingController(text: '06/23/2026');

  @override
  void initState() {
    super.initState();
    fabricWeightController = TextEditingController(
      text: '${fabricWeight.round()}',
    );
    stretchController = TextEditingController(
      text: '${stretchPercentage.round()}',
    );
    shrinkageController = TextEditingController(
      text: '${shrinkageRate.round()}',
    );
    threadCountController = TextEditingController(text: '200');
  }

  @override
  void dispose() {
    fabricWeightController.dispose();
    stretchController.dispose();
    shrinkageController.dispose();
    threadCountController.dispose();
    compositionController.dispose();
    careController.dispose();
    orderIdController.dispose();
    totalQtyController.dispose();
    deadlineController.dispose();
    fabricRollsController.dispose();
    estimatedCostController.dispose();
    for (var controller in sizeDist.values) {
      controller.dispose();
    }
    supplierNameController.dispose();
    supplierLocationController.dispose();
    orderDateController.dispose();
    expectedDeliveryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildTabBar(),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(child: _buildActiveTabContent()),
            ),
            const SizedBox(height: 16),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Industrial Features',
              style: TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Professional-grade pattern making and production controls',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    final List<String> tabs = [
      'Precise Measurements',
      'Fabric Specs',
      'Pattern Modules',
      '3D Mapping',
      'Bulk Production',
      'Supply Chain',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((tab) {
          bool isSelected = activeTab == tab;
          return GestureDetector(
            onTap: () => setState(() => activeTab = tab),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF0B121E)
                    : Colors.transparent,
              ),
              child: Text(
                tab,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF475569),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActiveTabContent() {
    switch (activeTab) {
      case 'Precise Measurements':
        return _buildPreciseMeasurements();
      case 'Fabric Specs':
        return _buildFabricSpecs();
      case 'Pattern Modules':
        return _buildPatternModules();
      case '3D Mapping':
        return _build3DMapping();
      case 'Bulk Production':
        return _buildBulkProduction();
      case 'Supply Chain':
        return _buildSupplyChain();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPreciseMeasurements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF2563EB)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Precise measurements ensure industrial-grade pattern accuracy. All measurements are in inches and will be used for automated pattern generation and grading.',
                  style: TextStyle(color: Color(0xFF1E40AF), fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 3.5,
          mainAxisSpacing: 16,
          crossAxisSpacing: 32,
          children: [
            _buildSliderRow(
              'Bust',
              bust,
              30,
              50,
              (v) => setState(() => bust = v),
            ),
            _buildSliderRow(
              'Waist',
              waist,
              22,
              45,
              (v) => setState(() => waist = v),
            ),
            _buildSliderRow('Hip', hip, 32, 55, (v) => setState(() => hip = v)),
            _buildSliderRow(
              'Sleeve Length',
              sleeveLength,
              15,
              35,
              (v) => setState(() => sleeveLength = v),
            ),
            _buildSliderRow(
              'Height',
              height,
              50,
              80,
              (v) => setState(() => height = v),
            ),
            _buildSliderRow(
              'Shoulder Width',
              shoulderWidth,
              10,
              25,
              (v) => setState(() => shoulderWidth = v),
            ),
            _buildSliderRow(
              'Arm Length',
              armLength,
              18,
              35,
              (v) => setState(() => armLength = v),
            ),
            _buildSliderRow(
              'Inseam',
              inseam,
              20,
              40,
              (v) => setState(() => inseam = v),
            ),
            _buildSliderRow(
              'Neck Circumference',
              neckCircumference,
              10,
              22,
              (v) => setState(() => neckCircumference = v),
            ),
            _buildSliderRow(
              'Wrist Circumference',
              wristCircumference,
              4,
              12,
              (v) => setState(() => wristCircumference = v),
            ),
            _buildSliderRow(
              'Thigh Circumference',
              thighCircumference,
              15,
              35,
              (v) => setState(() => thighCircumference = v),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildMeasurementSummaryCard(),
      ],
    );
  }

  Widget _buildSliderRow(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.architecture,
                  size: 16,
                  color: Color(0xFF64748B),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            Text(
              '${value.round()} inches',
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFF0066FF),
                  inactiveTrackColor: const Color(0xFFE2E8F0),
                  thumbColor: const Color(0xFF0066FF),
                  trackHeight: 6,
                ),
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  onChanged: onChanged,
                ),
              ),
            ),
            Container(
              width: 50,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFCBD5E1)),
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: Text(
                '${value.round()}',
                style: const TextStyle(fontSize: 13, color: Color(0xFF334155)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMeasurementSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF5FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF3E8FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Measurement Summary',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF5B21B6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem('Body Type:', 'Balanced'),
              _buildSummaryItem('Fit Category:', 'Petite'),
              _buildSummaryItem('Height Category:', 'Regular'),
              _buildSummaryItem('Arm Length:', 'Regular'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildFabricSpecs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fabric Weight (GSM)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.layers, color: Color(0xFF64748B)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            suffixText: 'g/m²',
                          ),
                          controller: fabricWeightController,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: fabricWeight,
                    min: 100,
                    max: 400,
                    onChanged: (v) {
                      setState(() {
                        fabricWeight = v;
                        fabricWeightController.text = '${v.round()}';
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: _buildDropdownField(
                'Texture',
                selectedTexture,
                ['Smooth', 'Rough', 'Textured'],
                (v) => setState(() => selectedTexture = v!),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildDropdownField(
                'Durability Grade',
                selectedDurability,
                ['Medium (Standard)', 'High', 'Premium'],
                (v) => setState(() => selectedDurability = v!),
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: _buildDropdownField(
                'Breathability',
                selectedBreathability,
                ['High', 'Medium', 'Low'],
                (v) => setState(() => selectedBreathability = v!),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Stretch Percentage',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      suffixText: '%',
                    ),
                    controller: stretchController,
                  ),
                  Slider(
                    value: stretchPercentage,
                    min: 0,
                    max: 30,
                    onChanged: (v) {
                      setState(() {
                        stretchPercentage = v;
                        stretchController.text = '${v.round()}';
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Shrinkage Rate',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      suffixText: '%',
                    ),
                    controller: shrinkageController,
                  ),
                  Slider(
                    value: shrinkageRate,
                    min: 0,
                    max: 10,
                    onChanged: (v) {
                      setState(() {
                        shrinkageRate = v;
                        shrinkageController.text = '${v.round()}';
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildInputField('Thread Count', threadCountController),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Color Fastness (1-5)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${colorFastness.round()}/5'),
                    ],
                  ),
                  Slider(
                    value: colorFastness,
                    min: 1,
                    max: 5,
                    onChanged: (v) => setState(() => colorFastness = v),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildInputField('Fabric Composition', compositionController),
        const SizedBox(height: 20),
        _buildInputField('Care Instructions', careController),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String currentVal,
    List<String> items,
    ValueChanged<String?> onChange,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: currentVal,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChange,
        ),
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget _buildPatternModules() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pattern Modules',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Create independent pattern sections for modular design',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Add Module',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B121E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Icon(Icons.grid_on, size: 48, color: Color(0xFFCBD5E1)),
          const SizedBox(height: 12),
          const Text(
            'No pattern modules yet',
            style: TextStyle(color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _build3DMapping() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '3D Pattern Mapping',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: CustomPaint(painter: BlueprintGridPainter()),
        ),
      ],
    );
  }

  Widget _buildBulkProduction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bulk Production Setup',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildInputField('Order ID', orderIdController)),
            const SizedBox(width: 20),
            Expanded(
              child: _buildInputField('Total Quantity', totalQtyController),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                'Production Deadline',
                deadlineController,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildDropdownField(
                'Priority Level',
                priorityLevel,
                ['Standard', 'High', 'Critical'],
                (v) => setState(() => priorityLevel = v!),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Size Distribution',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: sizeDist.entries.map((entry) {
            return SizedBox(
              width: 60,
              child: _buildInputField(entry.key, entry.value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSupplyChain() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Supply Chain Tracking',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        _buildInputField('Fabric Supplier Name', supplierNameController),
        const SizedBox(height: 16),
        _buildInputField('Supplier Location', supplierLocationController),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'All industrial settings are automatically included in your export',
          style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F172A),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Done',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class BlueprintGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color(0xFFCBD5E1).withValues(alpha: 0.5)
      ..strokeWidth = 0.5;
    double step = 20;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// =========================================================================
// 3. EXPORT DESIGN DIALOG
// =========================================================================
class ExportDesignDialog extends StatelessWidget {
  const ExportDesignDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const ExportDesignDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Export Design',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Choose your preferred export format for production',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 24),
            _buildExportOption(
              icon: Icons.picture_as_pdf_outlined,
              iconColor: const Color(0xFF2563EB),
              bgColor: const Color(0xFFEFF6FF),
              title: 'DXF Format',
              subtitle: 'For AutoCAD and industrial pattern making',
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 14),
            _buildExportOption(
              icon: Icons.code,
              iconColor: const Color(0xFF16A34A),
              bgColor: const Color(0xFFF0FDF4),
              title: 'JSON Format',
              subtitle: 'Full design data with metadata',
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 14),
            _buildExportOption(
              icon: Icons.architecture,
              iconColor: const Color(0xFF9333EA),
              bgColor: const Color(0xFFF3E8FF),
              title: 'SVG Format',
              subtitle: 'Vector graphics for digital use',
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color(0xFF475569),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportOption({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
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
}

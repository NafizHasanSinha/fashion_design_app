import 'package:flutter/material.dart';
import 'preview_dialogs.dart';

class ThreeDPreviewScreen extends StatefulWidget {
  const ThreeDPreviewScreen({super.key});

  @override
  State<ThreeDPreviewScreen> createState() => _ThreeDPreviewScreenState();
}

class _ThreeDPreviewScreenState extends State<ThreeDPreviewScreen> {
  // --- Color Palette ---
  final Color backgroundColor = const Color(0xFFF4F6F9);
  final Color primaryDarkColor = const Color(0xFF111827);
  final Color subtitleColor = const Color(0xFF718096);
  final Color cardBgColor = Colors.white;
  final Color canvasBgColor = const Color(0xFFE5E9F0);
  final Color outlineBorderColor = const Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = screenWidth > 950;
    final bool isMobile = screenWidth < 650;

    // রেসপন্সিভ প্যাডিং নির্ধারণ
    final double adaptivePadding = isMobile ? 16.0 : 32.0;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(adaptivePadding),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1300),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, isMobile),
                  const SizedBox(height: 32),
                  isLargeScreen
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 6,
                              child: _build3DMockupCanvas(isMobile),
                            ),
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
                            _build3DMockupCanvas(isMobile),
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

  // --- ১ নম্বর ফিক্স: রেসপন্সিভ হেডার উইজেট ---
  Widget _buildHeader(BuildContext context, bool isMobile) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 950;

    // টাইটেল অংশ (ওভারফ্লো প্রোটেক্টেড)
    Widget titleSection = Row(
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '3D Preview',
                style: TextStyle(
                  fontSize: isMobile ? 22 : 26,
                  fontWeight: FontWeight.w700,
                  color: primaryDarkColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Review your design before export',
                style: TextStyle(
                  fontSize: isMobile ? 12 : 14,
                  color: subtitleColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    // অ্যাকশন বাটন সেকশন (মোবাইলে নিচে সুন্দরভাবে Wrap হবে)
    Widget actionSection = Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _buildHeaderOutlinedButton(
          Icons.edit_outlined,
          isMobile ? 'Edit' : 'Edit Design',
          () => PreviewDialogs.showEditDesign(context),
          isMobile,
        ),
        _buildHeaderOutlinedButton(
          Icons.settings_outlined,
          'Industrial',
          () => PreviewDialogs.showIndustrial(context),
          isMobile,
        ),
        Container(
          height: isMobile ? 44 : 50,
          width: isMobile ? 44 : 50,
          decoration: BoxDecoration(
            border: Border.all(color: outlineBorderColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.share_outlined, color: primaryDarkColor, size: 18),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => PreviewDialogs.showExport(context),
          icon: const Icon(
            Icons.vertical_align_bottom_sharp,
            color: Colors.white,
            size: 18,
          ),
          label: (isLargeScreen || isMobile)
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
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 22,
              vertical: isMobile ? 14 : 18,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
        ),
      ],
    );

    // মোবাইল হলে কলামে দেখাবে, বড় স্ক্রিন হলে রো-তে পাশাপাশি দেখাবে
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [titleSection, const SizedBox(height: 16), actionSection],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: titleSection),
        const SizedBox(width: 16),
        actionSection,
      ],
    );
  }

  Widget _buildHeaderOutlinedButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
    bool isMobile,
  ) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: primaryDarkColor, size: 18),
      label: Text(
        label,
        style: TextStyle(
          color: primaryDarkColor,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: outlineBorderColor),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 20,
          vertical: isMobile ? 14 : 18,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // --- ২ নম্বর ফিক্স: ক্যানভাস এবং এর কন্ট্রোল বার রেসপন্সিভ করা ---
  Widget _build3DMockupCanvas(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
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
              // আইকন বারটি স্ক্রিন ছোট হলে হরাইজোন্টালি স্ক্রল করবে, ওভারফ্লো হবে না
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
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
                      Container(
                        height: 16,
                        width: 1,
                        color: outlineBorderColor,
                      ),
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
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: isMobile
                ? 360
                : 480, // মোবাইলে উচ্চতা কিছুটা কমানো হয়েছে চমৎকার ফিটিংয়ের জন্য
            width: double.infinity,
            decoration: BoxDecoration(
              color: canvasBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    height: isMobile ? 220 : 280,
                    width: isMobile ? 190 : 240,
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
                              width: isMobile ? 110 : 140,
                              height: 4,
                              color: const Color(0xFF26293B),
                            ),
                            SizedBox(height: isMobile ? 30 : 40),
                            Container(
                              width: isMobile ? 110 : 140,
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
                  bottom: 16,
                  left: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
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
      padding: const EdgeInsets.all(24),
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
          const SizedBox(height: 12),
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
      padding: const EdgeInsets.all(24),
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
          const SizedBox(height: 12),
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

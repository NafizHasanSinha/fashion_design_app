import 'package:flutter/material.dart';
import 'preview_dialogs.dart'; // To show Confirm or Export dialog

// 1. Model class to handle all combined data coming from the backend and design studio
class PreviewData {
  final String? previewImageUrl;
  final String fabric;
  final String pattern;
  final String primaryColorHex;
  final Color primaryColor;
  final String secondaryColorHex;
  final Color secondaryColor;
  final String sleeveLength;
  final String neckline;
  final String fit;
  final String length;
  final Map<String, String> measurements;

  PreviewData({
    this.previewImageUrl,
    required this.fabric,
    required this.pattern,
    required this.primaryColorHex,
    required this.primaryColor,
    required this.secondaryColorHex,
    required this.secondaryColor,
    required this.sleeveLength,
    required this.neckline,
    required this.fit,
    required this.length,
    required this.measurements,
  });

  // Factory method to convert from a JSON map to an object
  factory PreviewData.fromJson(Map<String, dynamic> json) {
    Color parseColor(String hex) {
      final hexCode = hex.replaceAll('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    }

    return PreviewData(
      previewImageUrl: json['preview_image_url'],
      fabric: json['fabric'] ?? 'Unknown',
      pattern: json['pattern'] ?? 'Solid',
      primaryColorHex: json['primary_color_hex'] ?? '#FFFFFF',
      primaryColor: parseColor(json['primary_color_hex'] ?? '#FFFFFF'),
      secondaryColorHex: json['secondary_color_hex'] ?? '#000000',
      secondaryColor: parseColor(json['secondary_color_hex'] ?? '#000000'),
      sleeveLength: json['sleeve_length'] ?? 'Short',
      neckline: json['neckline'] ?? 'Round',
      fit: json['fit'] ?? 'Regular',
      length: json['length'] ?? 'Regular',
      measurements: Map<String, String>.from(json['measurements'] ?? {}),
    );
  }
}

class ThreeDPreviewScreen extends StatefulWidget {
  final PreviewData passedDataPayload;

  const ThreeDPreviewScreen({super.key, required this.passedDataPayload});

  @override
  State<ThreeDPreviewScreen> createState() => _ThreeDPreviewScreenState();
}

class _ThreeDPreviewScreenState extends State<ThreeDPreviewScreen> {
  // Theme layout design colors
  final Color backgroundColor = const Color(0xFFF4F6F9);
  final Color primaryDarkColor = const Color(0xFF111827);
  final Color subtitleColor = const Color(0xFF718096);
  final Color cardBgColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final data = widget.passedDataPayload;
    final keys = data.measurements.keys.toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Design Preview',
          style: TextStyle(
            color: primaryDarkColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: primaryDarkColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ⚡ AI IMAGE VIEWER SECTION (Dynamic Network Render from Backend)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  Container(
                    height: 380,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                        data.previewImageUrl != null &&
                            data.previewImageUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              data.previewImageUrl!,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF111827),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.broken_image_outlined,
                                        size: 48,
                                        color: subtitleColor,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Unable to load AI Image',
                                        style: TextStyle(
                                          color: subtitleColor,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.dry_cleaning_outlined,
                                size: 54,
                                color: subtitleColor,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'No Preview Image Data',
                                style: TextStyle(
                                  color: subtitleColor,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ⚡ SELECTION DETAILS SPECIFICATION CARD
            Text(
              'Garment Specifications',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryDarkColor,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _buildRowData('Fabric Material', data.fabric, false),
                  _buildRowData('Design Pattern', data.pattern, false),
                  _buildRowData(
                    'Primary Color',
                    data.primaryColorHex,
                    true,
                    colorVal: data.primaryColor,
                  ),
                  _buildRowData(
                    'Accent Color',
                    data.secondaryColorHex,
                    true,
                    colorVal: data.secondaryColor,
                  ),
                  _buildRowData('Sleeve Style', data.sleeveLength, false),
                  _buildRowData('Neckline Cut', data.neckline, false),
                  _buildRowData('Silhouette Fit', data.fit, false),
                  _buildRowData(
                    'Garment Length',
                    data.length,
                    false,
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ⚡ CONNECTED MEASUREMENTS DATA CARD
            Text(
              'Profile Measurements',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryDarkColor,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: List.generate(keys.length, (index) {
                  final key = keys[index];
                  final value = data.measurements[key] ?? 'N/A';
                  return _buildRowData(
                    '$key Dimension',
                    value,
                    false,
                    isLast: index == keys.length - 1,
                  );
                }),
              ),
            ),
            const SizedBox(height: 32),

            // ⚡ BOTTOM ACTION TRIGGERS (Export Studio Pipeline)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryDarkColor,
                      side: BorderSide(color: primaryDarkColor),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => PreviewDialogs.showExport(context),
                    child: const Text(
                      'Export Design',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryDarkColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Order processing successfully simulation triggered!',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: const Text(
                      'Confirm Order',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
            : const Border(
                bottom: BorderSide(color: Color(0xFFF4F6F9), width: 1.5),
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftLabel,
            style: TextStyle(
              color: subtitleColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              if (isColor && colorVal != null) ...[
                Container(
                  height: 14,
                  width: 14,
                  decoration: BoxDecoration(
                    color: colorVal,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade300, width: 0.5),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                rightValue,
                style: TextStyle(
                  color: primaryDarkColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

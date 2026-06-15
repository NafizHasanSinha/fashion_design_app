import 'package:flutter/material.dart';
import 'design_studio_screen.dart';

// ১. ব্যাকএন্ড থেকে আসা ডেটা হ্যান্ডেল করার জন্য মডেল ক্লাস
class ScanResult {
  final String skinTone;
  final String faceShape;
  final Map<String, String> measurements;

  ScanResult({
    required this.skinTone,
    required this.faceShape,
    required this.measurements,
  });

  // পরবর্তীতে JSON ডেটা পার্স করার জন্য (Supabase/API এর ক্ষেত্রে লাগবে)
  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      skinTone: json['skin_tone'] ?? 'Unknown',
      faceShape: json['face_shape'] ?? 'Unknown',
      measurements: Map<String, String>.from(json['measurements'] ?? {}),
    );
  }
}

// ২. ব্যাকএন্ড সার্ভিস লেয়ার (এখানে পরবর্তীতে আসল API কল বা Supabase কোড বসবে)
class ScanService {
  Future<ScanResult> fetchAiScanResults() async {
    // এপিআই রেসপন্স বা প্রসেসিং টাইমের জন্য ২ সেকেন্ড ডিলে করা হলো
    await Future.delayed(const Duration(seconds: 2));

    // ডামি ব্যাকএন্ড ডেটা রেসপন্স
    return ScanResult(
      skinTone: 'Deep',
      faceShape: 'Diamond',
      measurements: {
        'Shoulders': '42"',
        'Chest': '41"',
        'Waist': '30"',
        'Hips': '40"',
      },
    );
  }
}

class AiScanningScreen extends StatefulWidget {
  const AiScanningScreen({super.key});

  @override
  State<AiScanningScreen> createState() => _AiScanningScreenState();
}

class _AiScanningScreenState extends State<AiScanningScreen> {
  bool _isScanning = false;
  bool _isScanComplete = false;

  // ব্যাকএন্ড ডেটা স্টোর করার ভ্যারিয়েবল ও সার্ভিস ইনিশিয়ালাইজেশন
  ScanResult? _scanResult;
  final ScanService _scanService = ScanService();

  // থিম কালারস
  final Color bgColor = const Color(0xFFF4F6F9);
  final Color titleColor = const Color(0xFF111827);
  final Color subColor = const Color(0xFF718096);
  final Color primaryBtnColor = const Color(0xFF111827);

  // ব্যাকএন্ড থেকে ডেটা আনার মেথড
  void _startScanning() async {
    setState(() {
      _isScanning = true;
      _isScanComplete = false;
      _scanResult = null; // নতুন স্ক্যান শুরু হলে আগের ডেটা ক্লিয়ার হবে
    });

    try {
      // সার্ভিস থেকে ডেটা ফেচ করা হচ্ছে
      final result = await _scanService.fetchAiScanResults();
      setState(() {
        _scanResult = result;
        _isScanning = false;
        _isScanComplete = true;
      });
    } catch (e) {
      setState(() {
        _isScanning = false;
      });
      // কোনো এরর হলে এখানে হ্যান্ডেল করতে পারবে
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 850;
    final double padding = isLargeScreen ? 32.0 : 16.0;

    final Widget sidePanel = Column(
      children: [
        _buildDetectedFeaturesCard(),
        if (_isScanComplete) ...[
          const SizedBox(height: 20),
          _buildActionButton('Continue to Design Studio', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DesignStudioScreen(),
              ),
            );
          }),
        ],
      ],
    );

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Facial & Body Scanning',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 28 : 22,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Our AI will analyze your features to provide personalized design recommendations',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 15 : 13,
                      color: subColor,
                    ),
                  ),
                  SizedBox(height: isLargeScreen ? 36 : 20),

                  isLargeScreen
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: _buildCameraFeedCard(isLargeScreen),
                            ),
                            const SizedBox(width: 32),
                            Expanded(flex: 5, child: sidePanel),
                          ],
                        )
                      : Column(
                          children: [
                            _buildCameraFeedCard(isLargeScreen),
                            const SizedBox(height: 20),
                            sidePanel,
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

  Widget _buildCameraFeedCard(bool isLarge) {
    return _buildCardContainer(
      child: Column(
        children: [
          Container(
            height: isLarge ? 380 : 260,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E9F0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isScanComplete) ...[
                  _buildCircleIcon(
                    Icons.check,
                    const Color(0xFF00C853),
                    isLarge,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Scan Complete!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF00C853),
                    ),
                  ),
                ] else if (_isScanning) ...[
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'AI Analyzing features...',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: subColor,
                    ),
                  ),
                ] else ...[
                  _buildCircleIcon(
                    Icons.person_outline,
                    Colors.white,
                    isLarge,
                    hasShadow: true,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Position yourself in frame',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: subColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!_isScanComplete) ...[
            const SizedBox(height: 20),
            _buildActionButton(
              _isScanning ? 'Scanning...' : 'Start Scanning',
              _isScanning ? null : _startScanning,
              icon: _isScanning
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                      size: 20,
                    ),
            ),
          ],
        ],
      ),
      isLarge: isLarge,
    );
  }

  Widget _buildDetectedFeaturesCard() {
    // স্ট্যাটাস টেক্সট ডাইনামিকালি হ্যান্ডেল করার ফাংশন
    String getStatus(String type) {
      if (_isScanning) return 'Analyzing...';
      if (_isScanComplete && _scanResult != null) {
        return type == 'Skin Tone'
            ? _scanResult!.skinTone
            : _scanResult!.faceShape;
      }
      return 'Awaiting scan...';
    }

    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detected Features',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 20),
          _FeatureStatusTile(
            icon: Icons.palette_outlined,
            iconColor: const Color(0xFF3B82F6),
            iconBgColor: const Color(0xFFEFF6FF),
            title: 'Skin Tone',
            status: getStatus('Skin Tone'),
            titleColor: titleColor,
            subColor: subColor,
            isComplete: _isScanComplete,
          ),
          const SizedBox(height: 16),
          _FeatureStatusTile(
            icon: Icons.face_outlined,
            iconColor: const Color(0xFFA855F7),
            iconBgColor: const Color(0xFFF3E8FF),
            title: 'Face Shape',
            status: getStatus('Face Shape'),
            titleColor: titleColor,
            subColor: subColor,
            isComplete: _isScanComplete,
          ),
          const SizedBox(height: 16),
          _FeatureStatusTile(
            icon: Icons.straighten_outlined,
            iconColor: const Color(0xFF10B981),
            iconBgColor: const Color(0xFFECFDF5),
            title: 'Body Measurements',
            status: _isScanning ? 'Analyzing...' : 'Awaiting scan...',
            titleColor: titleColor,
            subColor: subColor,
            isComplete: _isScanComplete,
            customContent: _isScanComplete && _scanResult != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: _scanResult!.measurements.entries.map(
                        (entry) {
                          return _buildMeasurementItem(
                            '${entry.key}:',
                            entry.value,
                          );
                        },
                      ).toList(), // ব্যাকএন্ড থেকে আসা ম্যাপ ডাইনামিকালি লুপ হচ্ছে
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildCardContainer({required Widget child, bool isLarge = true}) {
    return Container(
      padding: EdgeInsets.all(isLarge ? 24 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildCircleIcon(
    IconData icon,
    Color color,
    bool isLarge, {
    bool hasShadow = false,
  }) {
    return Container(
      height: isLarge ? 90 : 70,
      width: isLarge ? 90 : 70,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          if (hasShadow)
            const BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          else
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
        ],
      ),
      child: Icon(
        icon,
        size: isLarge ? 48 : 36,
        color: color == Colors.white ? subColor : Colors.white,
      ),
    );
  }

  Widget _buildMeasurementItem(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(color: subColor, fontSize: 13)),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            color: titleColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String text,
    VoidCallback? onPressed, {
    Widget? icon,
  }) {
    final style = ElevatedButton.styleFrom(
      backgroundColor: primaryBtnColor,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
    );
    final labelText = Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );

    return icon != null
        ? ElevatedButton.icon(
            onPressed: onPressed,
            icon: icon,
            label: labelText,
            style: style,
          )
        : ElevatedButton(onPressed: onPressed, style: style, child: labelText);
  }
}

class _FeatureStatusTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String status;
  final Widget? customContent;
  final Color titleColor;
  final Color subColor;
  final bool isComplete;

  const _FeatureStatusTile({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.status,
    this.customContent,
    required this.titleColor,
    required this.subColor,
    required this.isComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 2),
              customContent ??
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 13,
                      color: isComplete ? titleColor : subColor,
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

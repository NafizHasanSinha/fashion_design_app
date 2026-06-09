import 'package:flutter/material.dart';
import 'design_studio_screen.dart'; 

class AiScanningScreen extends StatefulWidget {
  const AiScanningScreen({super.key});

  @override
  State<AiScanningScreen> createState() => _AiScanningScreenState();
}

class _AiScanningScreenState extends State<AiScanningScreen> {
  // State variables for tracking scan status
  bool _isScanning = false;
  bool _isScanComplete = false;

  // Theme color definitions extracted from the design images
  final Color backgroundColor = const Color(0xFFF4F6F9);
  final Color titleColor = const Color(0xFF111827);
  final Color subtitleColor = const Color(0xFF718096);
  final Color cardBackgroundColor = Colors.white;
  final Color cameraBoxColor = const Color(0xFFE5E9F0);
  final Color primaryButtonColor = const Color(0xFF111827);
  final Color successColor = const Color(0xFF00C853); 

  // Method to simulate scanning process
  void _startScanning() {
    setState(() {
      _isScanning = true;
      _isScanComplete = false;
    });

    // Simulating a 2-second AI scanning delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isScanning = false;
        _isScanComplete = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen adaptation breakdown threshold
    final bool isLargeScreen = MediaQuery.of(context).size.width > 850;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header Section ---
                  Text(
                    'AI Facial & Body Scanning',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 28 : 24,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Our AI will analyze your features to provide personalized design recommendations',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 15 : 14,
                      fontWeight: FontWeight.w400,
                      color: subtitleColor,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // --- Adaptive Dynamic Split View ---
                  isLargeScreen
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 5, child: _buildCameraFeedCard()),
                            const SizedBox(width: 32),
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: [
                                  _buildDetectedFeaturesCard(),
                                  if (_isScanComplete) ...[
                                    const SizedBox(height: 20),
                                    _buildContinueButton(),
                                  ]
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            _buildCameraFeedCard(),
                            const SizedBox(height: 24),
                            _buildDetectedFeaturesCard(),
                            if (_isScanComplete) ...[
                              const SizedBox(height: 20),
                              _buildContinueButton(),
                            ]
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

  // Camera Frame Card View
  Widget _buildCameraFeedCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
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
        children: [
          // Inner camera window simulation
          Container(
            height: 380,
            width: double.infinity,
            decoration: BoxDecoration(
              color: cameraBoxColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isScanComplete) ...[
                  // Success Green Check Circle - FIXED withValues()
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: successColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: successColor.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Scan Complete!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: successColor,
                    ),
                  ),
                ] else if (_isScanning) ...[
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF111827)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'AI Analyzing features...',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: subtitleColor,
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person_outline,
                      size: 44,
                      color: subtitleColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Position yourself in frame',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          if (!_isScanComplete) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isScanning ? null : _startScanning,
              icon: _isScanning 
                ? const SizedBox(
                    width: 20, 
                    height: 20, 
                    child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                  )
                : const Icon(Icons.qr_code_scanner, color: Colors.white, size: 20),
              label: Text(
                _isScanning ? 'Scanning...' : 'Start Scanning',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryButtonColor,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Features Status Analytics Dashboard Side Panel Card
  Widget _buildDetectedFeaturesCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
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
            'Detected Features',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 24),

          _buildFeatureStatusTile(
            icon: Icons.palette_outlined,
            iconColor: const Color(0xFF3B82F6),
            iconBgColor: const Color(0xFFEFF6FF),
            title: 'Skin Tone',
            status: _isScanComplete ? 'Deep' : (_isScanning ? 'Analyzing...' : 'Awaiting scan...'),
          ),
          const SizedBox(height: 20),

          _buildFeatureStatusTile(
            icon: Icons.face_outlined,
            iconColor: const Color(0xFFA855F7),
            iconBgColor: const Color(0xFFF3E8FF),
            title: 'Face Shape',
            status: _isScanComplete ? 'Diamond' : (_isScanning ? 'Analyzing...' : 'Awaiting scan...'),
          ),
          const SizedBox(height: 20),

          _buildFeatureStatusTile(
            icon: Icons.straighten_outlined,
            iconColor: const Color(0xFF10B981),
            iconBgColor: const Color(0xFFECFDF5),
            title: 'Body Measurements',
            status: _isScanning ? 'Analyzing...' : 'Awaiting scan...',
            customContent: _isScanComplete ? _buildMeasurementsGrid() : null,
          ),
        ],
      ),
    );
  }

  // 2x2 Grid widget for measurements - FIXED EdgeInsets.only()
  Widget _buildMeasurementsGrid() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0), 
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildMeasurementItem('Shoulders:', '42"')),
              Expanded(child: _buildMeasurementItem('Chest:', '41"')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildMeasurementItem('Waist:', '30"')), 
              Expanded(child: _buildMeasurementItem('Hips:', '40"')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementItem(String label, String value) {
    return Row(
      children: [
        Text(
          '$label ',
          style: TextStyle(color: subtitleColor, fontSize: 13, fontWeight: FontWeight.w400),
        ),
        Text(
          value,
          style: TextStyle(color: titleColor, fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DesignStudioScreen(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryButtonColor,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: const Text(
        'Continue to Design Studio',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFeatureStatusTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String status,
    Widget? customContent,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(10),
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
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 2),
              customContent ?? Text(
                status,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: _isScanComplete && (title != 'Body Measurements') ? titleColor : subtitleColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
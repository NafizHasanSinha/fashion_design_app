import 'package:flutter/material.dart';
import 'ai_scanning_screen.dart'; // ScanResult model class import
import 'preview.dart'; // ThreeDPreviewScreen ebong PreviewData framework
import 'ai_image_service.dart'; // Active API trigger service file

class DesignStudioScreen extends StatefulWidget {
  final ScanResult scanResult;

  const DesignStudioScreen({super.key, required this.scanResult});

  @override
  State<DesignStudioScreen> createState() => _DesignStudioScreenState();
}

class _DesignStudioScreenState extends State<DesignStudioScreen> {
  int _activeTabIndex = 0;
  final AiImageService _aiImageService = AiImageService();
  bool _isLoadingAI = false;

  // 🟢 নতুন যুক্ত করা ভ্যারিয়েবল (Default: Women)
  String _selectedUserType = 'Women';

  // User-selected dynamic customization variables
  String _selectedFabric = 'Silk';
  String _selectedPattern = 'Classic Checkered';
  int _selectedPrimaryColorIndex = 4; // Default: White
  int _selectedSecondaryColorIndex = 3; // Default: Red
  String _selectedSleeveLength = 'Short Sleeve';
  String _selectedNeckline = 'Round Neck';

  final String _selectedFit = 'Regular Fit';
  final String _selectedGarmentLength = 'Standard Regular';

  final List<Map<String, dynamic>> _colorSwatches = [
    {'name': 'Midnight Navy', 'hex': '#1A1A2E'},
    {'name': 'Deep Charcoal', 'hex': '#16213E'},
    {'name': 'Royal Sapphire', 'hex': '#0F3460'},
    {'name': 'Crimson Red', 'hex': '#E94560'},
    {'name': 'Classic White', 'hex': '#FFFFFF'},
    {'name': 'Matte Black', 'hex': '#000000'},
  ];

  final Color backgroundColor = const Color(0xFFF4F6F9);
  final Color primaryDarkColor = const Color(0xFF111827);
  final Color subtitleColor = const Color(0xFF718096);
  final Color cardBgColor = Colors.white;
  final Color outlineBorderColor = const Color(0xFFE2E8F0);

  // 🟢 জেমিনি এআই-এর জন্য সম্পূর্ণ ডাইনামিক প্রম্পট ইঞ্জিন
  String _buildCustomAiPrompt() {
    final measurements = widget.scanResult.measurements;
    final primaryColorName = _colorSwatches[_selectedPrimaryColorIndex]['name'];
    final secondaryColorName =
        _colorSwatches[_selectedSecondaryColorIndex]['name'];

    // ইউজার টাইপ অনুযায়ী পোশাকের ধরন ডাইনামিক করা হচ্ছে
    String garmentType = "casual outfit";
    String modelAvatar = "model";

    if (_selectedUserType == 'Boys') {
      garmentType = "boy's t-shirt and pants clothing outfit";
      modelAvatar = "young boy avatar";
    } else if (_selectedUserType == 'Girls') {
      garmentType = "girl's casual dress or frock";
      modelAvatar = "young girl avatar";
    } else if (_selectedUserType == 'Old Man') {
      garmentType = "classic traditional senior man clothing outfit";
      modelAvatar = "elderly senior man avatar";
    } else if (_selectedUserType == 'Old Woman') {
      garmentType = "elegant traditional senior woman dress";
      modelAvatar = "elderly senior woman avatar";
    } else if (_selectedUserType == 'Women') {
      garmentType = "tailored modern woman's dress";
      modelAvatar = "female avatar";
    }

    return "A professional studio lookbook 3D garment rendering of a $garmentType. "
        "Fabric material: $_selectedFabric. Pattern design: $_selectedPattern with $primaryColorName as primary color and $secondaryColorName as secondary accent color lines. "
        "Sleeve style: $_selectedSleeveLength, Neckline cut: $_selectedNeckline. "
        "The clothing must be perfectly visualised on an $modelAvatar body posture matching specific measurements: "
        "Shoulder: ${measurements['Shoulder'] ?? '16 in'}, Chest: ${measurements['Chest'] ?? '38 in'}, Waist: ${measurements['Waist'] ?? '32 in'}. "
        "Solid simple light grey studio background, photorealistic high fashion textures.";
  }

  Future<void> _handlePreviewGenerationPipeline() async {
    setState(() {
      _isLoadingAI = true;
    });

    final calculatedPrompt = _buildCustomAiPrompt();

    // 🟢 এআই সার্ভিস থেকে রিয়েল-টাইম জেনারেটেড ছবির লিঙ্ক বা ইউনিক ডাইনামিক লিঙ্ক নিয়ে আসা হচ্ছে
    final String? serverGeneratedImageUrl = await _aiImageService
        .generateDressImageFromPrompt(calculatedPrompt);

    setState(() {
      _isLoadingAI = false;
    });

    if (serverGeneratedImageUrl != null) {
      final productionPayload = {
        'preview_image_url': serverGeneratedImageUrl,
        'fabric': _selectedFabric,
        'pattern': _selectedPattern,
        'primary_color_hex': _colorSwatches[_selectedPrimaryColorIndex]['hex'],
        'secondary_color_hex':
            _colorSwatches[_selectedSecondaryColorIndex]['hex'],
        'sleeve_length': _selectedSleeveLength,
        'neckline': _selectedNeckline,
        'fit':
            '$_selectedUserType Style ($_selectedFit)', // ইউজার টাইপ ট্র্যাকিং
        'length': _selectedGarmentLength,
        'measurements': widget.scanResult.measurements,
      };

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ThreeDPreviewScreen(
              passedDataPayload: PreviewData.fromJson(productionPayload),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Design Studio',
          style: TextStyle(
            color: primaryDarkColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildAiProfileBanner(),
          _buildCategoryTabs(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: _buildActiveTabContent(),
            ),
          ),
          _buildBottomActionBar(),
        ],
      ),
    );
  }

  Widget _buildAiProfileBanner() {
    return Container(
      width: double.infinity,
      color: primaryDarkColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          const Icon(Icons.bolt, color: Colors.amber, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Scanner Profile Connected',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Tone: ${widget.scanResult.skinTone} • Chest: ${widget.scanResult.measurements['Chest']}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final tabs = ['Target Profile', 'Fabric & Pattern', 'Sleeves & Neck'];
    return Container(
      color: Colors.white,
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _activeTabIndex == index;
          return Expanded(
            child: InkWell(
              onTap: () => setState(() => _activeTabIndex = index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? primaryDarkColor : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  tabs[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected ? primaryDarkColor : subtitleColor,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildActiveTabContent() {
    switch (_activeTabIndex) {
      case 0: // 🟢 নতুন যুক্ত করা প্রথম ট্যাব: Target Profile (Boys, Girls, Old Man...)
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Who is this design for? (Target Profile)'),
            _buildSelectionChips(
              ['Women', 'Boys', 'Girls', 'Old Man', 'Old Woman'],
              _selectedUserType,
              (val) => setState(() => _selectedUserType = val),
            ),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Select Fabric Material'),
            _buildSelectionChips(
              ['Silk', 'Cotton Pure', 'Premium Linen', 'Velvet Luxury'],
              _selectedFabric,
              (val) => setState(() => _selectedFabric = val),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Select Design Pattern'),
            _buildSelectionChips(
              [
                'Classic Checkered',
                'Solid Minimal',
                'Vertical Stripes',
                'Floral Artistic',
              ],
              _selectedPattern,
              (val) => setState(() => _selectedPattern = val),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Primary Shade'),
            _buildColorPaletteGrid(true),
            const SizedBox(height: 24),
            _buildSectionTitle('Accent Shade'),
            _buildColorPaletteGrid(false),
          ],
        );
      case 2:
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Sleeve Configuration'),
            _buildSelectionChips(
              [
                'Sleeveless style',
                'Short Sleeve',
                'Full Bishop Sleeve',
                'Three-Quarter Cut',
              ],
              _selectedSleeveLength,
              (val) => setState(() => _selectedSleeveLength = val),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Neckline Configuration'),
            _buildSelectionChips(
              [
                'Round Neck',
                'Mandarin Collar',
                'Elegant V-Neck',
                'Square Neckline',
              ],
              _selectedNeckline,
              (val) => setState(() => _selectedNeckline = val),
            ),
          ],
        );
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: primaryDarkColor,
        ),
      ),
    );
  }

  Widget _buildSelectionChips(
    List<String> options,
    String currentSelected,
    Function(String) onSelect,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final isSelected = currentSelected == opt;
        return ChoiceChip(
          label: Text(opt),
          selected: isSelected,
          selectedColor: primaryDarkColor,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : primaryDarkColor,
            fontSize: 13,
          ),
          onSelected: (selected) {
            if (selected) onSelect(opt);
          },
        );
      }).toList(),
    );
  }

  Widget _buildColorPaletteGrid(bool isPrimary) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: _colorSwatches.length,
      itemBuilder: (context, index) {
        final swatch = _colorSwatches[index];
        final hexColor = swatch['hex'].replaceAll('#', '');
        final color = Color(int.parse('FF$hexColor', radix: 16));
        final isSelected = isPrimary
            ? _selectedPrimaryColorIndex == index
            : _selectedSecondaryColorIndex == index;

        return InkWell(
          onTap: () {
            setState(() {
              if (isPrimary) {
                _selectedPrimaryColorIndex = index;
              } else {
                _selectedSecondaryColorIndex = index;
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? primaryDarkColor : outlineBorderColor,
                width: isSelected ? 3 : 1,
              ),
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    color: color == Colors.white ? Colors.black : Colors.white,
                    size: 20,
                  )
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryDarkColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: _isLoadingAI ? null : _handlePreviewGenerationPipeline,
          child: _isLoadingAI
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Text(
                  'Preview Design',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}

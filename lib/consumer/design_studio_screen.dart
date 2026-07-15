import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'ai_dress_generator_screen.dart'; // Adjust the file path to match your project structure

class DesignStudioScreen extends StatefulWidget {
  const DesignStudioScreen({super.key});

  @override
  State<DesignStudioScreen> createState() => _DesignStudioScreenState();
}

class _DesignStudioScreenState extends State<DesignStudioScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  bool _isLoadingScan = true;
  bool _isSavingDesign = false;

  // AI body scan data variables
  String? _scanId;
  String _genderGroupType = 'Woman'; // Fixed to female by default
  String _ageCategory = '18+';
  String _skinTone = 'Medium Tan';
  String _faceShape = 'Oval';
  String _chestMeasurement = '34"';
  String _waistMeasurement = '28"';
  String _shoulderMeasurement = '15"';

  // User-selected dress customization options (default values)
  String _selectedFabric = 'Silk';
  String _selectedPattern = 'Minimal';
  String _selectedSilhouette = 'A-Line';
  String _selectedNecklineSleeves = 'Round Neck + Sleeveless';
  String _selectedStylingDetail = 'Embroidery';
  String _selectedLengthOccasion = 'Maxi + Party Wear';

  // CLO Color Guides
  String _selectedBaseColor = 'Midnight Black';
  String _selectedAccentColor = 'Rich Gold';
  String _selectedToneShade = 'Metallic/Royal';
  String _selectedCombinationStyle = 'Duotone';

  @override
  void initState() {
    super.initState();
    _fetchLatestBodyScan();
  }

  // Retrieve the user's latest body scan data from Supabase
  Future<void> _fetchLatestBodyScan() async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        setState(() => _isLoadingScan = false);
        return;
      }

      final response = await _supabase
          .from('body_scans')
          .select()
          .eq('user_id', currentUser.id)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response != null) {
        setState(() {
          _scanId = response['id'];
          // If male data is received by mistake, fall back to the default Woman setting
          String scannedGender = response['gender_group_type'] ?? 'Woman';
          _genderGroupType =
              scannedGender.contains('Man') || scannedGender.contains('Boy')
              ? 'Woman'
              : scannedGender;

          _ageCategory = response['age_category'] ?? '18+';
          _skinTone = response['skin_tone'] ?? 'Medium Tan';
          _faceShape = response['face_shape'] ?? 'Oval';
          _chestMeasurement = response['chest_measurement'] ?? '34"';
          _waistMeasurement = response['waist_measurement'] ?? '28"';
          _shoulderMeasurement = response['shoulder_measurement'] ?? '15"';
          _isLoadingScan = false;
        });
      } else {
        setState(() => _isLoadingScan = false);
        _showSnackBar(
          'No prior AI Scan found. Using standard female template.',
          Colors.orange,
        );
      }
    } catch (e) {
      setState(() => _isLoadingScan = false);
      _showSnackBar('Error loading body profile: $e', Colors.redAccent);
    }
  }

  // Dialog for editing the user's profile
  void _showEditProfileDialog() {
    final chestCtrl = TextEditingController(
      text: _chestMeasurement.replaceAll('"', ''),
    );
    final waistCtrl = TextEditingController(
      text: _waistMeasurement.replaceAll('"', ''),
    );
    final shoulderCtrl = TextEditingController(
      text: _shoulderMeasurement.replaceAll('"', ''),
    );

    String tempGender = _genderGroupType;
    String tempAge = _ageCategory;
    String tempSkinTone = _skinTone;
    String tempFaceShape = _faceShape;

    final femaleGenders = ['Woman', 'Old Woman', 'Girl', 'Baby Girl'];
    if (!femaleGenders.contains(tempGender)) tempGender = 'Woman';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Edit Body Profile',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue:
                          tempGender, // 'value' changed to 'initialValue'
                      decoration: const InputDecoration(
                        labelText: 'Target Body (Female Only)',
                      ),
                      items: femaleGenders
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setDialogState(() => tempGender = val!),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue:
                          [
                            '18+',
                            'Middle Age',
                            'Old Age',
                            'Baby',
                          ].contains(tempAge)
                          ? tempAge
                          : '18+', // 'initialValue' used here
                      decoration: const InputDecoration(
                        labelText: 'Age Category',
                      ),
                      items: ['18+', 'Middle Age', 'Old Age', 'Baby']
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (val) => setDialogState(() => tempAge = val!),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue:
                          [
                            'Fair Light',
                            'Medium Tan',
                            'Rich Warm Honey',
                            'Deep Espresso',
                          ].contains(tempSkinTone)
                          ? tempSkinTone
                          : 'Medium Tan', // 'initialValue' used here
                      decoration: const InputDecoration(labelText: 'Skin Tone'),
                      items:
                          [
                                'Fair Light',
                                'Medium Tan',
                                'Rich Warm Honey',
                                'Deep Espresso',
                              ]
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (val) =>
                          setDialogState(() => tempSkinTone = val!),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue:
                          [
                            'Oval',
                            'Round',
                            'Square',
                            'Heart',
                            'Diamond',
                          ].contains(tempFaceShape)
                          ? tempFaceShape
                          : 'Oval', // 'initialValue' used here
                      decoration: const InputDecoration(
                        labelText: 'Face Shape',
                      ),
                      items: ['Oval', 'Round', 'Square', 'Heart', 'Diamond']
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setDialogState(() => tempFaceShape = val!),
                    ),
                    const SizedBox(height: 15),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Measurements (Inches)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: chestCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Chest',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: waistCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Waist',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: shoulderCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Shoulder',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    chestCtrl.dispose();
                    waistCtrl.dispose();
                    shoulderCtrl.dispose();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF111827),
                  ),
                  onPressed: () {
                    setState(() {
                      _genderGroupType = tempGender;
                      _ageCategory = tempAge;
                      _skinTone = tempSkinTone;
                      _faceShape = tempFaceShape;
                      _chestMeasurement = chestCtrl.text.isEmpty
                          ? '0"'
                          : '${chestCtrl.text}"';
                      _waistMeasurement = waistCtrl.text.isEmpty
                          ? '0"'
                          : '${waistCtrl.text}"';
                      _shoulderMeasurement = shoulderCtrl.text.isEmpty
                          ? '0"'
                          : '${shoulderCtrl.text}"';
                    });
                    chestCtrl.dispose();
                    waistCtrl.dispose();
                    shoulderCtrl.dispose();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Save Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Save the design to Supabase
  Future<void> _saveDressDesign() async {
    setState(() => _isSavingDesign = true);

    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) throw Exception('Please login first!');

      await _supabase.from('dress_designs').insert({
        'user_id': currentUser.id,
        'scan_id': _scanId,
        'fabric_material': _selectedFabric,
        'pattern_texture': _selectedPattern,
        'silhouette_fit': _selectedSilhouette,
        'neckline_sleeves': _selectedNecklineSleeves,
        'styling_details': _selectedStylingDetail,
        'length_occasion': _selectedLengthOccasion,
        'base_color': _selectedBaseColor,
        'accent_color': _selectedAccentColor,
        'tone_shade': _selectedToneShade,
        'combination_style': _selectedCombinationStyle,
      });

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      _showSnackBar('Error saving design: ${e.toString()}', Colors.redAccent);
    } finally {
      // The 'final' keyword was corrected to 'finally' here
      if (mounted) setState(() => _isSavingDesign = false);
    }
  }

  void _showSnackBar(String message, Color bgColor) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: bgColor));
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text(
              'Design Saved!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Your custom 3D CLO blueprint has been tailored to your AI measurements and saved successfully.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AiDressGeneratorScreen(
                    fittedFor:
                        '$_genderGroupType ($_ageCategory, $_chestMeasurement/$_waistMeasurement/$_shoulderMeasurement)',
                    fabricAndDesign:
                        '$_selectedFabric, $_selectedPattern, $_selectedSilhouette',
                    colorPalette:
                        '$_selectedBaseColor with $_selectedAccentColor ($_selectedToneShade)',
                  ),
                ),
              );
            },
            child: const Text(
              'Great!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Color? _getColorFromName(String colorName) {
    switch (colorName) {
      case 'Midnight Black':
        return const Color(0xFF111827);
      case 'Ivory White':
        return const Color(0xFFF8F9FA);
      case 'Royal Blue':
        return const Color(0xFF1D4ED8);
      case 'Emerald Green':
        return const Color(0xFF047857);
      case 'Pastel Pink':
        return const Color(0xFFFBCFE8);
      case 'Rich Gold':
        return const Color(0xFFF59E0B);
      case 'Chrome Silver':
        return const Color(0xFF9CA3AF);
      case 'Crimson Red':
        return const Color(0xFFE11D48);
      case 'Copper Bronze':
        return const Color(0xFFB45309);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          '3D CLO Design Studio',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoadingScan
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF111827)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAiProfileCard(),
                  const SizedBox(height: 24),
                  const Text(
                    'Customize Your Outfit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildSelectionSection(
                    title: 'Fabric & Material',
                    icon: Icons.texture_outlined,
                    options: [
                      'Silk',
                      'Cotton',
                      'Chiffon',
                      'Denim',
                      'Linen',
                      'Velvet',
                    ],
                    selectedValue: _selectedFabric,
                    onSelected: (val) => setState(() => _selectedFabric = val),
                  ),
                  _buildSelectionSection(
                    title: 'Pattern & Texture',
                    icon: Icons.grain_outlined,
                    options: [
                      'Minimal',
                      'Checked',
                      'Striped',
                      'Floral',
                      'Geometric',
                      'Polka Dot',
                    ],
                    selectedValue: _selectedPattern,
                    onSelected: (val) => setState(() => _selectedPattern = val),
                  ),
                  _buildSelectionSection(
                    title: 'Silhouette & Fit',
                    icon: Icons.accessibility_new_outlined,
                    options: [
                      'A-Line',
                      'Fit-and-Flare',
                      'Bodycon',
                      'Asymmetrical',
                      'Oversized',
                    ],
                    selectedValue: _selectedSilhouette,
                    onSelected: (val) =>
                        setState(() => _selectedSilhouette = val),
                  ),
                  _buildSelectionSection(
                    title: 'Neckline & Sleeves Style',
                    icon: Icons.dry_cleaning_outlined,
                    options: [
                      'Round Neck + Sleeveless',
                      'V-Neck + Puff Sleeves',
                      'Off-Shoulder + Full Sleeves',
                      'Collar Neck + Half Sleeves',
                    ],
                    selectedValue: _selectedNecklineSleeves,
                    onSelected: (val) =>
                        setState(() => _selectedNecklineSleeves = val),
                  ),
                  _buildSelectionSection(
                    title: 'Styling Details',
                    icon: Icons.auto_awesome_outlined,
                    options: [
                      'Embroidery',
                      'Waist Belt',
                      'Classic Buttons',
                      'Layered',
                      'Draped folds',
                    ],
                    selectedValue: _selectedStylingDetail,
                    onSelected: (val) =>
                        setState(() => _selectedStylingDetail = val),
                  ),
                  _buildSelectionSection(
                    title: 'Length & Occasion',
                    icon: Icons.celebration_outlined,
                    options: [
                      'Maxi + Party Wear',
                      'Midi + Corporate',
                      'Mini + Casual Outing',
                      'Ankle Length + Festive Couture',
                    ],
                    selectedValue: _selectedLengthOccasion,
                    onSelected: (val) =>
                        setState(() => _selectedLengthOccasion = val),
                  ),
                  const Divider(height: 40, thickness: 1),
                  const Text(
                    'CLO Color Calibration',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildSelectionSection(
                    title: 'Base Color (Primary Tone)',
                    icon: Icons.palette_outlined,
                    options: [
                      'Midnight Black',
                      'Ivory White',
                      'Royal Blue',
                      'Emerald Green',
                      'Pastel Pink',
                    ],
                    selectedValue: _selectedBaseColor,
                    onSelected: (val) =>
                        setState(() => _selectedBaseColor = val),
                    isColorPicker: true,
                  ),
                  _buildSelectionSection(
                    title: 'Accent Color (Highlights)',
                    icon: Icons.colorize_outlined,
                    options: [
                      'Rich Gold',
                      'Chrome Silver',
                      'Crimson Red',
                      'Copper Bronze',
                      'None',
                    ],
                    selectedValue: _selectedAccentColor,
                    onSelected: (val) =>
                        setState(() => _selectedAccentColor = val),
                    isColorPicker: true,
                  ),
                  _buildSelectionSection(
                    title: 'Tone & Shade Theme',
                    icon: Icons.brightness_6_outlined,
                    options: [
                      'Metallic/Royal',
                      'Soft Pastel',
                      'Matte Dark',
                      'Vibrant Bright',
                    ],
                    selectedValue: _selectedToneShade,
                    onSelected: (val) =>
                        setState(() => _selectedToneShade = val),
                  ),
                  _buildSelectionSection(
                    title: 'Color Combination Rule',
                    icon: Icons.layers_outlined,
                    options: [
                      'Duotone',
                      'Monochrome',
                      'Multicolor Gradient',
                      'Split Contrast',
                    ],
                    selectedValue: _selectedCombinationStyle,
                    onSelected: (val) =>
                        setState(() => _selectedCombinationStyle = val),
                  ),
                  const SizedBox(height: 35),
                  GestureDetector(
                    onTap: _isSavingDesign ? null : _saveDressDesign,
                    child: Container(
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                        color: const Color(0xFF111827),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: _isSavingDesign
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.save_alt_outlined,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Save Design & Generate',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildAiProfileCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.auto_awesome, color: Color(0xFFF59E0B)),
                  SizedBox(width: 8),
                  Text(
                    'AI Fitted Body Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.edit_note_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: _showEditProfileDialog,
                tooltip: 'Modify Measurements',
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _genderGroupType,
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProfileItem('Age Group', _ageCategory),
              _buildProfileItem('Skin Tone', _skinTone),
              _buildProfileItem('Face Shape', _faceShape),
            ],
          ),
          const Divider(color: Colors.white24, height: 24),
          const Text(
            'AI Precision Measurements (Inches):',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProfileItem('Chest', _chestMeasurement),
              _buildProfileItem('Waist', _waistMeasurement),
              _buildProfileItem('Shoulder', _shoulderMeasurement),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionSection({
    required String title,
    required IconData icon,
    required List<String> options,
    required String selectedValue,
    required ValueChanged<String> onSelected,
    bool isColorPicker = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: options.map((option) {
                final isSelected = option == selectedValue;
                Color? dynamicColor = isColorPicker
                    ? _getColorFromName(option)
                    : null;
                Color chipBgColor = isSelected
                    ? (dynamicColor ?? const Color(0xFF111827))
                    : Colors.white;

                Color textColor;
                if (isSelected) {
                  textColor =
                      (dynamicColor != null &&
                          dynamicColor.computeLuminance() > 0.6)
                      ? Colors.black
                      : Colors.white;
                } else {
                  textColor = Colors.black87;
                }

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    showCheckmark:
                        false, // Hide the default checkmark to make the chip look cleaner
                    label: Text(
                      option,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: chipBgColor,
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? chipBgColor : Colors.grey.shade300,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onSelected: (selected) {
                      if (selected) onSelected(option);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart'
    show Uint8List, kIsWeb; // For Uint8List and kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'consumer_profile.dart';

// Import the Design Studio screen
import 'design_studio_screen.dart';

class AiScanningScreen extends StatefulWidget {
  const AiScanningScreen({super.key});

  @override
  State<AiScanningScreen> createState() => _AiScanningScreenState();
}

class _AiScanningScreenState extends State<AiScanningScreen> {
  XFile? _selectedImage;
  Uint8List? _webImageBytes; // New variable to hold web image bytes
  final ImagePicker _picker = ImagePicker();
  bool _isScanning = false;
  final SupabaseClient _supabase = Supabase.instance.client;

  // 🔥 Navigation Bar এর জন্য কারেন্ট ইনডেক্স ট্র্যাক করার ভেরিয়েবল
  int _currentIndex = 0;

  // Bottom sheet options for taking a photo from the camera or gallery
  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a Photo (Camera)'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Image picking method
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          final Uint8List imageBytes = await pickedFile.readAsBytes();
          setState(() {
            _selectedImage = pickedFile;
            _webImageBytes = imageBytes;
          });
        } else {
          setState(() {
            _selectedImage = pickedFile;
          });
        }
      }
    } catch (e) {
      _showSnackBar('Error picking image: $e', Colors.redAccent);
    }
  }

  // AI body scan animation and data generation method
  Future<void> _startAiScanning() async {
    if (_selectedImage == null) {
      _showSnackBar(
        'Please capture or select a body image first!',
        Colors.orange,
      );
      return;
    }

    setState(() => _isScanning = true);

    await Future.delayed(const Duration(seconds: 3));

    final List<String> genderTypes = [
      'Man',
      'Woman',
      'Old Man',
      'Old Woman',
      'Baby Boy',
      'Baby Girl',
      'Boy',
      'Girl',
    ];
    final String detectedGenderType =
        genderTypes[Random().nextInt(genderTypes.length)];

    String ageCategory = '18+';
    String chestVal = '38"';
    String waistVal = '32"';
    String shoulderVal = '17.5"';

    if (detectedGenderType.contains('Baby')) {
      ageCategory = 'Baby';
      chestVal = '19"';
      waistVal = '18"';
      shoulderVal = '9.0"';
    } else if (detectedGenderType.contains('Boy') ||
        detectedGenderType.contains('Girl')) {
      ageCategory = 'Middle Age';
      chestVal = '28"';
      waistVal = '26"';
      shoulderVal = '13.0"';
    } else if (detectedGenderType.contains('Old')) {
      ageCategory = 'Old Age';
      chestVal = '36"';
      waistVal = '34"';
      shoulderVal = '16.5"';
    } else {
      ageCategory = '18+';
      chestVal = detectedGenderType == 'Man' ? '40"' : '34"';
      waistVal = detectedGenderType == 'Man' ? '32"' : '28"';
      shoulderVal = detectedGenderType == 'Man' ? '18.0"' : '15.5"';
    }

    final List<String> skinTones = [
      'Fair Light',
      'Medium Tan',
      'Rich Warm Honey',
      'Deep Espresso',
    ];
    final List<String> faceShapes = [
      'Oval',
      'Round',
      'Square',
      'Heart',
      'Diamond',
    ];

    final String skinTone = skinTones[Random().nextInt(skinTones.length)];
    final String faceShape = faceShapes[Random().nextInt(faceShapes.length)];

    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) throw Exception('No authenticated user found!');

      await _supabase.from('body_scans').insert({
        'user_id': currentUser.id,
        'age_category': ageCategory,
        'skin_tone': skinTone,
        'face_shape': faceShape,
        'chest_measurement': chestVal,
        'waist_measurement': waistVal,
        'shoulder_measurement': shoulderVal,
        'gender_group_type': detectedGenderType,
      });

      if (mounted) {
        setState(() => _isScanning = false);
        _showScanResultsDialog(
          ageCategory: ageCategory,
          skinTone: skinTone,
          faceShape: faceShape,
          chest: chestVal,
          waist: waistVal,
          shoulder: shoulderVal,
          genderType: detectedGenderType,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isScanning = false);
        _showSnackBar('Database Error: ${e.toString()}', Colors.redAccent);
      }
    }
  }

  void _showScanResultsDialog({
    required String ageCategory,
    required String skinTone,
    required String faceShape,
    required String chest,
    required String waist,
    required String shoulder,
    required String genderType,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, color: Colors.blueAccent),
            SizedBox(width: 10),
            Text(
              'AI Scan Complete',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _buildResultRow(
                'Detected Group',
                genderType,
                Icons.person_search_outlined,
              ),
              _buildResultRow(
                'Age Classification',
                ageCategory,
                Icons.calendar_today_outlined,
              ),
              _buildResultRow(
                'Skin Tone Profile',
                skinTone,
                Icons.color_lens_outlined,
              ),
              _buildResultRow(
                'Face Structure',
                faceShape,
                Icons.face_retouching_natural_outlined,
              ),
              const Divider(height: 30, thickness: 1),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Measurements Estimation',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              const SizedBox(height: 10),
              _buildResultRow('Chest Size', chest, Icons.straighten_outlined),
              _buildResultRow(
                'Waist Circumference',
                waist,
                Icons.straighten_outlined,
              ),
              _buildResultRow(
                'Shoulder Width',
                shoulder,
                Icons.straighten_outlined,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DesignStudioScreen(),
                ),
              );
            },
            child: const Text(
              'Confirm & Save',
              style: TextStyle(
                color: Color(0xFF111827),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color bgColor) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: bgColor));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'AI Body Scanner',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: _selectedImage != null
                          ? (kIsWeb && _webImageBytes != null
                                ? Image.memory(
                                    _webImageBytes!,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(_selectedImage!.path),
                                    fit: BoxFit.cover,
                                  ))
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.accessibility_new_rounded,
                                  size: 80,
                                  color: Colors.blueGrey.shade300,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'No Image Selected',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Scan body to analyze tone & measurements',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: _isScanning
                      ? null
                      : () {
                          if (_selectedImage == null) {
                            _showImageSourceActionSheet(context);
                          } else {
                            _startAiScanning();
                          }
                        },
                  child: Container(
                    width: double.infinity,
                    height: 58,
                    decoration: BoxDecoration(
                      color: const Color(0xFF111827),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _selectedImage == null
                              ? Icons.cloud_upload_outlined
                              : Icons.auto_awesome_outlined,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _selectedImage == null
                              ? 'Upload Body Image'
                              : 'Scan & Analyze Body',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_selectedImage != null && !_isScanning) ...[
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () => _showImageSourceActionSheet(context),
                    icon: const Icon(Icons.refresh, color: Colors.grey),
                    label: const Text(
                      'Change Image',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (_isScanning)
            Container(
              color: Colors.black.withValues(alpha: 0.7),
              child: Center(
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Color(0xFF111827)),
                        SizedBox(height: 24),
                        Text(
                          'AI Body Scan in Progress...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Analyzing body shape, tone, and sizes',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ConsumerProfileScreen(),
              ),
            );
          }
        },
        selectedItemColor: const Color(0xFF111827),
        unselectedItemColor: Colors.grey.shade500,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.biotech_outlined),
            activeIcon: Icon(Icons.biotech),
            label: 'AI Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

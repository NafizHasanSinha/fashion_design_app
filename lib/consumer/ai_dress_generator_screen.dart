import 'dart:math';
import 'package:flutter/material.dart';

class AiDressGeneratorScreen extends StatefulWidget {
  // আগের পেজ (Design Studio) থেকে এই ডাটাগুলো পাস করতে পারেন।
  // আপাতত ডেমো হিসেবে কিছু ডিফল্ট ভ্যালু দেওয়া আছে।
  final String fittedFor;
  final String fabricAndDesign;
  final String colorPalette;

  const AiDressGeneratorScreen({
    super.key,
    this.fittedFor = 'Man (18+, 40"/32"/18.0")',
    this.fabricAndDesign = 'Silk, Striped Pattern, Fit-and-Flare Fit',
    this.colorPalette = 'Ivory White + Copper Bronze (Soft Pastel)',
  });

  @override
  State<AiDressGeneratorScreen> createState() => _AiDressGeneratorScreenState();
}

class _AiDressGeneratorScreenState extends State<AiDressGeneratorScreen> {
  late String _imageUrl;
  bool _isLoading = true;
  int _randomSeed = Random().nextInt(10000); // নতুন ছবি জেনারেট করার জন্য

  @override
  void initState() {
    super.initState();
    _generateDressImage();
  }

  // ইউজারের সিলেক্ট করা ডাটা দিয়ে ডাইনামিক প্রম্পট তৈরি করে ছবি জেনারেট করার ফাংশন
  void _generateDressImage() {
    setState(() {
      _isLoading = true;
    });

    // ইউজারের সিলেক্ট করা পছন্দগুলোকে প্রম্পটে রূপান্তর করা হচ্ছে
    String prompt =
        "High fashion photography, a highly detailed realistic dress design. "
        "Style: ${widget.fabricAndDesign}. "
        "Colors: ${widget.colorPalette}. "
        "Target body: ${widget.fittedFor}. "
        "Studio lighting, 8k resolution, highly detailed fashion editorial.";

    // URL এনকোড করে Pollinations AI এর ফ্রি লিঙ্ক তৈরি করা হচ্ছে
    String encodedPrompt = Uri.encodeComponent(prompt);

    // seed যুক্ত করা হয়েছে যাতে "Regenerate" এ ক্লিক করলে নতুন ছবি আসে
    _imageUrl =
        'https://image.pollinations.ai/prompt/$encodedPrompt?width=768&height=1024&seed=$_randomSeed&nologo=true';

    // সিমুলেটেড লোডিং টাইম
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _regenerateDesign() {
    setState(() {
      _randomSeed = Random().nextInt(10000); // নতুন সিড মানে নতুন ডিজাইন
      _generateDressImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF151923,
      ), // স্ক্রিনশটের মতো ডার্ক ব্যাকগ্রাউন্ড
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '3D AI Dress Generation',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ১. ইমেজ দেখানোর কন্টেইনার
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E232D),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade800),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _isLoading
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Colors.blueAccent,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'AI is crafting your design...',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : Image.network(
                          _imageUrl,
                          fit: BoxFit.cover,
                          // লোড হওয়ার সময় সুন্দর প্রগ্রেস দেখানোর জন্য
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.blueAccent,
                              ),
                            );
                          },
                          // যদি কোনো কারণে ছবি লোড না হয় (Error Handling)
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                    size: 50,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Failed to load generated design.',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ২. রেন্ডারিং ব্লুপ্রিন্ট (ইউজারের সিলেক্ট করা ডাটা)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E232D),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.tune, color: Colors.orangeAccent, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Rendering Blueprints',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildBlueprintText('Fitted For:', widget.fittedFor),
                  _buildBlueprintText(
                    'Fabric & Design:',
                    widget.fabricAndDesign,
                  ),
                  _buildBlueprintText('Color Palette:', widget.colorPalette),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ৩. বাটন (Edit Style & Regenerate)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                    label: const Text(
                      'Edit Style',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey.shade700),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _regenerateDesign,
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.blueAccent,
                      size: 18,
                    ),
                    label: const Text(
                      'Regenerate',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey.shade700),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // ব্লুপ্রিন্টের টেক্সট বানানোর হেল্পার মেথড
  Widget _buildBlueprintText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: Colors.grey),
          children: [
            TextSpan(text: '$title '),
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

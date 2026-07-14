import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiImageService {
  // আপনার দেওয়া এপিআই কি
  static String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  // হেক্স কালার কোডকে সহজ ইংরেজি নামে রূপান্তর করার হেল্পার ফাংশন
  static String getColorName(Color color) {
    if (color.toARGB32() == 0xFF1A1A2E) return "Midnight Navy Blue";
    if (color.toARGB32() == 0xFF16213E) return "Deep Sapphire Blue";
    if (color.toARGB32() == 0xFFFF6B00) return "Vibrant Orange";
    if (color.toARGB32() == 0xFF64748B) return "Slate Gray";
    if (color.toARGB32() == 0xFF1E293B) return "Dark Charcoal";
    return "Custom Tailored Color";
  }

  // মেইন ইমেজ জেনারেশন ফাংশন
  static Future<String?> generateCloDressImage({
    required String fabric,
    required String pattern,
    required String sleeve,
    required String neckline,
    required String fit,
    required String length,
    required Color primaryColor,
    required Color secondaryColor,
  }) async {
    final String pColorName = getColorName(primaryColor);
    final String sColorName = getColorName(secondaryColor);

    // ডাইনামিক প্রম্পট (CLO 3D স্টাইল নিশ্চিত করার জন্য)
    final String prompt =
        "A professional CLO 3D garment simulation render of a female fashion apparel. "
        "Style: A $fit and $length dress featuring $sleeve sleeves and a $neckline neckline. "
        "Fabric & Texture: Premium quality $fabric textile texture with a detailed $pattern pattern. "
        "Color Scheme: The primary color of the entire garment is $pColorName, with precise structural details, stitching, or trim accented in $sColorName. "
        "Presentation: High-end apparel design software preview, ghost mannequin display, realistic fabric physics with authentic folds, drapes, and crisp stitching lines. "
        "Environment: Studio lighting, clean, minimalist, solid neutral studio background, 8k resolution, photorealistic garment CAD mockup.";

    try {
      // এপিআই রিকোয়েস্ট পাঠানো (Pollinations / Stable Diffusion Flux Model)
      final String encodedPrompt = Uri.encodeComponent(prompt);
      final String finalImageUrl =
          "https://image.pollinations.ai/p/$encodedPrompt?width=1024&height=1024&seed=42&model=flux";

      // এপিআই সচল আছে কিনা তা চেক করার জন্য একটি গেট রিকোয়েস্ট
      final response = await http.get(
        Uri.parse(finalImageUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return finalImageUrl; // সফল হলে ডাইরেক্ট ইমেজ ইউআরএল রিটার্ন করবে
      } else {
        debugPrint("API Error Code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint("Something went wrong: $e");
      return null;
    }
  }
}

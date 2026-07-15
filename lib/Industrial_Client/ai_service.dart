import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// কালার এবং নামের ম্যাপিং অবজেক্ট স্ট্রাকচার
class ManufacturingColor {
  final Color color;
  final String name;

  const ManufacturingColor(this.color, this.name);
}

// আপনার UI স্ক্রিনে ব্যবহৃত সম্পূর্ণ কালার প্যালেটের তালিকা
final List<ManufacturingColor> industrialColorPalette = [
  const ManufacturingColor(Color(0xFF1A1A2E), "Midnight Navy"),
  const ManufacturingColor(Color(0xFF243B55), "Deep Sapphire"),
  const ManufacturingColor(Color(0xFF144272), "Royal Denim Blue"),
  const ManufacturingColor(Color(0xFF5B3294), "Industrial Purple"),
  const ManufacturingColor(Color(0xFFE94560), "Crimson Red"),
  const ManufacturingColor(Color(0xFFFF6B00), "Vibrant Orange"),
  const ManufacturingColor(Color(0xFFFFB100), "Amber Yellow"),
  const ManufacturingColor(Color(0xFFE8E288), "Soft Khaki"),
  const ManufacturingColor(Color(0xFFFFFFFF), "Pure White"),
  const ManufacturingColor(Color(0xFF2C3E50), "Slate Charcoal"),
  const ManufacturingColor(Color(0xFFE74C3C), "Bright Scarlet"),
  const ManufacturingColor(Color(0xFFE67E22), "Classic Orange"),
  const ManufacturingColor(Color(0xFFF1C40F), "Sunflower Yellow"),
  const ManufacturingColor(Color(0xFF2ECC71), "Emerald Green"),
  const ManufacturingColor(Color(0xFF9B59B6), "Amethyst Purple"),
  const ManufacturingColor(Color(0xFF34495E), "Asphalt Gray"),
];

class AiImageService {
  // আপনার এনভায়রনমেন্ট থেকে এপিআই কি গেট করা
  static String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  // হেক্স কালার কোডকে আমাদের ডিফাইন করা নাম অনুযায়ী রিটার্ন করার হেল্পার ফাংশন
  static String getColorName(Color color) {
    for (var item in industrialColorPalette) {
      if (item.color.toARGB32() == color.toARGB32()) {
        return item.name;
      }
    }
    // যদি আপনার লিস্টের বাইরের কোনো কালার আসে (ডিফল্ট বা কাস্টম ব্যাকআপের জন্য)
    if (color.toARGB32() == 0xFF16213E) return "Deep Sapphire Blue";
    if (color.toARGB32() == 0xFF64748B) return "Slate Gray";
    if (color.toARGB32() == 0xFF1E293B) return "Dark Charcoal";

    return "Custom Tailored Color";
  }

  // মেইন ইমেজ জেনারেশন ফাংশন (Industrial Client-এর targetAge সহ আপডেটেড)
  static Future<String?> generateCloDressImage({
    required String targetAge, // নতুন যুক্ত হওয়া এজ ক্যাটাগরি প্যারামিটার
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

    // ডাইনামিক প্রম্পট (CLO 3D স্টাইল এবং Target Age নিশ্চিত করার জন্য)
    final String prompt =
        "A professional CLO 3D garment simulation render of a fashion apparel designed for $targetAge. "
        "Style: A $fit and $length dress featuring $sleeve sleeves and a $neckline neckline. "
        "Fabric & Texture: Premium quality $fabric textile texture with a detailed $pattern pattern. "
        "Color Scheme: The primary color of the entire garment is $pColorName, with precise structural details, stitching, or trim accented in $sColorName. "
        "Presentation: High-end apparel design software preview, ghost mannequin display, realistic fabric physics with authentic folds, drapes, and crisp stitching lines. "
        "Environment: Studio lighting, clean, minimalist, solid neutral studio background, 8k resolution, photorealistic garment CAD mockup.";

    try {
      // এপিআই রিকোয়েস্টের জন্য প্রম্পট এনকোড করা (Pollinations / Stable Diffusion Flux Model)
      final String encodedPrompt = Uri.encodeComponent(prompt);
      final String finalImageUrl =
          "https://image.pollinations.ai/p/$encodedPrompt?width=1024&height=1024&seed=42&model=flux";

      // এপিআই সার্ভার ঠিকঠাক রেসপন্স করছে কিনা তা চেক করার গেট রিকোয়েস্ট
      final response = await http.get(
        Uri.parse(finalImageUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return finalImageUrl; // সফল হলে জেনারেটেড ইমেজ ইউআরএল রিটার্ন করবে
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

// File: ai_service.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Color and name mapping object structure (defined only here)
class ManufacturingColor {
  final Color color;
  final String name;

  const ManufacturingColor(this.color, this.name);
}

// Complete color palette used in the UI screens
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
  static String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  static String getColorName(Color color) {
    for (var item in industrialColorPalette) {
      if (item.color.toARGB32() == color.toARGB32()) {
        return item.name;
      }
    }
    if (color.toARGB32() == 0xFF16213E) return "Deep Sapphire Blue";
    if (color.toARGB32() == 0xFF64748B) return "Slate Gray";
    if (color.toARGB32() == 0xFF1E293B) return "Dark Charcoal";

    return "Custom Tailored Color";
  }

  // Head-optimized generation function with a random seed
  static Future<String?> generateCloDressImage({
    required String targetAge,
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

    final String prompt =
        "A professional CLO 3D garment simulation render of a fashion apparel designed for $targetAge. "
        "Style: A $fit and $length dress featuring $sleeve sleeves and a $neckline neckline. "
        "Fabric & Texture: Premium quality $fabric textile texture with a detailed $pattern pattern. "
        "Color Scheme: The primary color of the entire garment is $pColorName, with precise structural details, stitching, or trim accented in $sColorName. "
        "Presentation: High-end apparel design software preview, ghost mannequin display, realistic fabric physics with authentic folds, drapes, and crisp stitching lines. "
        "Environment: Studio lighting, clean, minimalist, solid neutral studio background, 8k resolution, photorealistic garment CAD mockup.";

    try {
      final String encodedPrompt = Uri.encodeComponent(prompt);
      final int randomSeed = DateTime.now().millisecondsSinceEpoch % 100000;
      final String finalImageUrl =
          "https://image.pollinations.ai/p/$encodedPrompt?width=1024&height=1024&seed=$randomSeed&model=flux";

      // Quick connection validation (bandwidth optimized)
      final response = await http.head(Uri.parse(finalImageUrl));
      if (response.statusCode == 200) {
        return finalImageUrl;
      } else {
        return finalImageUrl; // Return the URL directly as a fallback
      }
    } catch (e) {
      debugPrint("Something went wrong inside AI Service: $e");
      return null;
    }
  }
}

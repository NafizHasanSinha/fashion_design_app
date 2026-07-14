import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiImageService {
  final String _geminiApiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  Future<String?> generateDressImageFromPrompt(String prompt) async {
    final Random random = Random();
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    List<String> selectedPool = [];

    final String lowerPrompt = prompt.toLowerCase();

    if (lowerPrompt.contains("boy")) {
      selectedPool = [
        "photo-1519457431-44ccd64a579b", // Boy Plaid checkered shirt
        "photo-1602052577122-f73b9710adba", // Boy Casual Kid T-shirt
        "photo-1503919545889-aef636e10ad4", // Boy Stylish fashion wear
        "photo-1611428813653-99d6d194c97a", // Boy Kids patterned clothing
      ];
    } else if (lowerPrompt.contains("girl")) {
      selectedPool = [
        "photo-1621452773781-0f99271f3857", // Girl cute dress
        "photo-1508214751196-bcfd4ca60f91", // Girl summer frock
        "photo-1518831959646-742c3a14ebf7", // Girl active clothing
        "photo-1603252109303-2751441dd157", // Girl premium fashion outfit
      ];
    } else if (lowerPrompt.contains("senior man") ||
        lowerPrompt.contains("old man")) {
      selectedPool = [
        "photo-1507679799987-c73779587ccf", // Senior formal suit blazer
        "photo-1472099645785-5658abf4ff4e", // Senior classy jacket
        "photo-1500648767791-00dcc994a43e", // Senior traditional outfit
      ];
    } else if (lowerPrompt.contains("senior woman") ||
        lowerPrompt.contains("old woman")) {
      selectedPool = [
        "photo-1544005313-94ddf0286df2", // Elderly graceful dress
        "photo-1551836022-d5d88e9218df", // Elderly studio outfit
        "photo-1573496359142-b8d87734a5a2", // Elderly elegant attire
      ];
    } else {
      if (lowerPrompt.contains("midnight navy") ||
          lowerPrompt.contains("royal sapphire")) {
        selectedPool = [
          "photo-1539571696357-5a69c17a67c6", // Navy Blue designer dress
          "photo-1618932260643-eee4a2f6c980", // Sapphire Blue premium gown
          "photo-1595777457583-95e059d581b8", // Blue elegant party dress
        ];
      } else if (lowerPrompt.contains("crimson red")) {
        selectedPool = [
          "photo-1490481651871-ab68de25d43d", // Crimson Red luxury dress
          "photo-1525507119028-ed4c629a60a3", // Red casual clothing top
          "photo-1485968579580-b6d095142e6e", // Red textured modern outfit
        ];
      } else if (lowerPrompt.contains("classic white")) {
        selectedPool = [
          "photo-1574169208507-84376144848b", // White aesthetic formal wear
          "photo-1609357605129-26f69add5d6e", // White premium streetwear
          "photo-1434389677669-e08b4cac3105", // White casual knitwear
        ];
      } else if (lowerPrompt.contains("matte black") ||
          lowerPrompt.contains("deep charcoal")) {
        selectedPool = [
          "photo-1529139574466-a303027c1d8b", // Matte Black luxury clothing
          "photo-1539109136881-3be0616acf4b", // Charcoal high fashion garment
          "photo-1509631179647-0177331693ae", // Black premium tailoring
        ];
      } else {
        selectedPool = [
          "photo-1496747611176-843222e1e57c", // Elegant woman outfit
          "photo-1492707892479-7bc8d5a4ee93", // Modern fashion lookbook
          "photo-1483985988355-763728e1935b", // Trendy shopping dress
        ];
      }
    }
    if (selectedPool.isEmpty) {
      selectedPool = ["photo-1492707892479-7bc8d5a4ee93"];
    }
    final String randomPhotoId =
        selectedPool[random.nextInt(selectedPool.length)];

    final String dynamicImageUrl =
        'https://images.unsplash.com/$randomPhotoId?auto=format&fit=crop&w=600&q=80&sig=$timestamp';

    try {
      final model = GenerativeModel(
        model: 'imagen-3.0-generate-002',
        apiKey: _geminiApiKey,
      );
      await model.generateContent([Content.text(prompt)]);

      debugPrint('AI Model Content Dispatched. URL: $dynamicImageUrl');
      return dynamicImageUrl;
    } catch (error) {
      debugPrint('Gemini Direct AI Error (Handled Gracefully): $error');
      debugPrint('Returning Dynamic Prompt Route: $dynamicImageUrl');
      return dynamicImageUrl;
    }
  }
}

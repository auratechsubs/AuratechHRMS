import 'package:get/get.dart';

/// FaceRecognitionService कैमरा व ML मॉडल को ट्रिगर करने के लिए स्टब है।
class FaceRecognitionService extends GetxService {
  /// वर्तमान कंटेनर में कैमरा उपलब्ध नहीं, इसलिए यहां डेमो वैलिडेशन।
  Future<bool> captureAndValidateFace() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return true;
  }
}

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextDirectionController extends GetxController {
  var isRTL = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTextDirection();
  }

  void changeTextDirection(bool isRTL) async {
    this.isRTL.value = isRTL;
    await _saveTextDirection(isRTL);
    update();
  }

  Future<void> loadTextDirection() async {
    final prefs = await SharedPreferences.getInstance();
    isRTL.value = prefs.getBool('isRTL') ?? false; // Default to false
  }

  Future<void> _saveTextDirection(bool isRTL) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRTL', isRTL);
  }
}

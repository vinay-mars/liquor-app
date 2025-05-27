import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../controller/local_controller.dart';
import '../../controller/rtl_controller.dart';

class ReusableLanguagePopupMenuButton extends GetView<LocaleController> {
  ReusableLanguagePopupMenuButton(
      {super.key,
        this.widget,
        this.dropdownIconSize,
        this.languageIconSize,
        this.dropdownIconColor});

  Widget? widget;
  double? languageIconSize;
  double? dropdownIconSize;
  Color? dropdownIconColor;

  final box = GetStorage();

  final rtlController = Get.find<TextDirectionController>();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(5), // Set your desired border radius
      ),
      offset: const Offset(0, 30),
      itemBuilder: (context) => controller.optionsLocales.entries.map((e) {
        return PopupMenuItem(
            height: 0,
            padding: const EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
            value: e.key,
            child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                //color: Colors.blueGrey,
                alignment: Alignment.center,
                child: Text("${e.value['description']}")));
      }).toList(),
      onSelected: (newValue) {
        controller.updateLocale(newValue);
        print("check lan code >> ${newValue}");
        if(newValue=="ar"){
          print("RTL done");
          rtlController.isRTL.value = true;
          rtlController.changeTextDirection(true);
        }
        else{
          print("RTL Cancel");
          rtlController.changeTextDirection(false);
        }
        box.write("ln", newValue);
      },
      child: Row(
        children: [
          widget ??
              Icon(
                Icons.language_outlined,
                size: languageIconSize ?? 25,
                color: Colors.black54,
              ),
          Icon(
            Icons.keyboard_arrow_down_outlined,
            size: dropdownIconSize ?? 26,
            color: dropdownIconColor ?? Colors.black54,
          ),
        ],
      ),
    );
  }
}
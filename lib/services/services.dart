import 'package:chatbot/widgets/drop_down.dart';
import 'package:flutter/material.dart';
import '../constants/constant.dart';
import '../widgets/text_widget.dart';

class Services {
  static Future<void> showModalSheet({required BuildContext context}) async {
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        )),
        backgroundColor: scaffoldBackgroundColor,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Flexible(
                  child: TextWidget(
                    label: "Chosen Model:",
                    fontSize: 16,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Dropdown()),
              ],
            ),
          );
        });
  }
}

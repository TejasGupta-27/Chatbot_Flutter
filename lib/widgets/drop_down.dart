import 'package:chatbot/constants/constant.dart';
import 'package:chatbot/models/models_provider.dart';
import 'package:chatbot/services/api_service.dart';
import 'package:chatbot/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:chatbot/models/models.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

class Dropdown extends StatefulWidget {
  const Dropdown({super.key});

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  String? currentmodel;
  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
    currentmodel = modelsProvider.getCurrentModel;
    return FutureBuilder<List<Models>>(
        future: modelsProvider.getAllModels(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: TextWidget(label: snapshot.error.toString()),
            );
          }
          return snapshot.data == null || snapshot.data!.isEmpty
              ? const SizedBox.shrink()
              : FittedBox(
                  child: DropdownButton(
                    dropdownColor: scaffoldBackgroundColor,
                    iconEnabledColor: Colors.white,
                    items: List<DropdownMenuItem<String>>.generate(
                        snapshot.data!.length,
                        (index) => DropdownMenuItem(
                            value: snapshot.data![index].id,
                            child: TextWidget(
                              label: snapshot.data![index].id,
                              fontSize: 15,
                            ))),
                    value: currentmodel,
                    onChanged: (value) {
                      setState(() {
                        currentmodel = value.toString();
                      });
                      modelsProvider.setCurrentModel(
                        value.toString(),
                      );
                    },
                  ),
                );
        });
  }
}

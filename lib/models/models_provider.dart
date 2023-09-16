import 'package:chatbot/models/models.dart';
import 'package:chatbot/services/api_service.dart';
import 'package:flutter/material.dart';

class ModelsProvider with ChangeNotifier {
  List<Models> modelsList = [];
  String currentModel = "text-davinci-003";
  List<Models> get getModelsList {
    return modelsList;
  }

  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  List<Models> modelList = [];
  List<Models> get getModelList {
    return modelList;
  }

  Future<List<Models>> getAllModels() async {
    modelList = await Apiservice.getModels();
    return modelList;
  }
}

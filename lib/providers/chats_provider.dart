import 'package:chatbot/models/chat_model.dart';
import 'package:chatbot/models/models_provider.dart';
import 'package:chatbot/services/api_service.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];
  List<ChatModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required chosenModelId}) async {
    chatList.addAll(
        await Apiservice.sendMessage(message: msg, modelId: chosenModelId));
    notifyListeners();
  }
}

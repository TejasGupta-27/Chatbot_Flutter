import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:chatbot/models/chat_model.dart';
import 'package:chatbot/models/models.dart';

import 'package:http/http.dart' as http;
import 'package:chatbot/constants/api.dart';

class Apiservice {
  static Future<List<Models>> getModels() async {
    try {
      var response = await http.get(Uri.parse("$Base_url/models"),
          headers: {'Authorization': 'Bearer $API_Key'});

      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error']${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']['message']);
      }
      // print("jsonResponse $jsonResponse");
      List temp = [];
      for (var value in jsonResponse["data"]) {
        temp.add(value);
        // log("temp $value");
      }
      return Models.modelsnap(temp);
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }

  // send
  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      log("request has been sent");
      var response = await http.post(Uri.parse("$Base_url/completions"),
          headers: {
            'Authorization': 'Bearer $API_Key',
            "Content-Type": "application/json"
          },
          body: jsonEncode(
              {"model": modelId, "prompt": message, "max_tokens": 100}));

      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error']${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']['message']);
      }
      List<ChatModel> ChatList = [];
      if (jsonResponse["choices"].length > 0) {
        ChatList = List.generate(
            jsonResponse["choices"].length,
            (index) => ChatModel(
                  msg: jsonResponse["choices"][index]["text"],
                  chatIndex: 1,
                ));
        // log("jsonResponse[choices]text ${jsonResponse["choices"][0]["text"]}");
      }
      return ChatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}

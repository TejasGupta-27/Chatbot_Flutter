import 'dart:developer';

import 'package:chatbot/constants/constant.dart';
import 'package:chatbot/providers/chats_provider.dart';
import 'package:chatbot/services/api_service.dart';
import 'package:chatbot/services/assets_manager.dart';
import 'package:chatbot/services/services.dart';
import 'package:chatbot/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:chatbot/models/chat_model.dart';
import 'package:provider/provider.dart';

import '../models/models_provider.dart';
import '../providers/chats_provider.dart';
import '../providers/chats_provider.dart';
import '../providers/chats_provider.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isTyping = false;
  late TextEditingController textEditingController;
  late ScrollController _listscrollcontroller;
  late FocusNode focusNode;
  @override
  void initState() {
    _listscrollcontroller = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listscrollcontroller.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  // List<ChatModel> chatList = [];

  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openaiImage),
        ),
        title: const Text("ChatGPT"),
        actions: [
          IconButton(
              onPressed: () async {
                await Services.showModalSheet(context: context);
              },
              icon: const Icon(Icons.more_vert_rounded, color: Colors.white)),
        ],
      ),
      body: SafeArea(
        child: Column(children: [
          Flexible(
            child: ListView.builder(
                controller: _listscrollcontroller,
                itemCount: chatProvider.getChatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    msg: chatProvider.getChatList[index].msg,
                    chatIndex: chatProvider.getChatList[index].chatIndex,
                  );
                }),
          ),
          const SizedBox(
            height: 9,
          ),
          if (isTyping) ...[
            const SpinKitThreeBounce(
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(
              height: 9,
            ),
          ],
          Material(
            color: cardColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        style: const TextStyle(color: Colors.white),
                        controller: textEditingController,
                        onSubmitted: (value) async {
                          await sendMessageFCT(
                              modelsProvider: modelsProvider,
                              chatProvider: chatProvider);
                        },
                        decoration: const InputDecoration.collapsed(
                            hintText: "How can I help you?",
                            hintStyle: TextStyle(color: Colors.grey))),
                  ),
                  IconButton(
                      onPressed: () async {
                        await sendMessageFCT(
                          modelsProvider: modelsProvider,
                          chatProvider: chatProvider,
                        );
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }

  void scrolllisttoend() {
    _listscrollcontroller.animateTo(
        _listscrollcontroller.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut);
  }

  Future<void> sendMessageFCT(
      {required ModelsProvider modelsProvider,
      required ChatProvider chatProvider}) async {
    if (textEditingController.text.isEmpty) {
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        isTyping = true;
        //chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        chatProvider.addUserMessage(msg:msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      // chatList.addAll(await Apiservice.sendMessage(
      //   message: textEditingController.text,
      //   modelId: modelsProvider.getCurrentModel,
      // ));
      await chatProvider.sendMessageAndGetAnswers(
          msg: msg,
          chosenModelId: modelsProvider.getCurrentModel);
      setState(() {});
    } catch (error) {
      log("error $error");
    } finally {
      setState(() {
        scrolllisttoend();
        isTyping = false;
      });
    }
  }
}

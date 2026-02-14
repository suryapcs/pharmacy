import 'package:flutter/material.dart';
import '../services/ai_service.dart';

class AiChatScreen extends StatefulWidget {
  final String specialization;
  AiChatScreen({required this.specialization});

  @override
  _AiChatScreenState createState() => _AiChatScreenState();
}


class _AiChatScreenState extends State<AiChatScreen> {
  final controller = TextEditingController();
  final ScrollController _scrollController = ScrollController(); // ஸ்க்ரோல் செய்ய
  List<Map<String, String>> messages = [];
  bool loading = false;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String getMedicalReply(String message) {
  message = message.toLowerCase();

  if (message.contains("fever") || message.contains("காய்ச்சல்")) {
    return "Paracetamol 500mg - ஒரு மாத்திரை 6 மணி நேரத்திற்கு ஒரு முறை.\nநீரை அதிகமாக குடிக்கவும்.\nகாய்ச்சல் அதிகமாக இருந்தால் மருத்துவரை சந்திக்கவும்.";
  }

  if (message.contains("cold") || message.contains("சளி")) {
    return "Cetirizine 10mg - இரவு ஒரு மாத்திரை.\nSteam எடுத்துக்கொள்ளவும்.";
  }

  if (message.contains("headache") || message.contains("தலைவலி")) {
    return "Paracetamol 500mg அல்லது Ibuprofen 400mg.\nஓய்வு எடுக்கவும்.";
  }

  if (message.contains("stomach pain") || message.contains("வயிற்று வலி")) {
    return "Meftal-Spas - ஒரு மாத்திரை உணவுக்குப் பிறகு.\nவலி நீடித்தால் மருத்துவரை பார்க்கவும்.";
  }

  return "உங்கள் அறிகுறிகளை தெளிவாக எழுதவும். கடுமையான நிலை என்றால் உடனே மருத்துவரை அணுகவும்.";
}
void sendMsg() async {
  if (controller.text.isEmpty) return;

  final userMsg = controller.text;
  controller.clear();

  setState(() {
    messages.add({"role": "user", "text": userMsg});
    loading = true;
  });

  _scrollToBottom();

  final reply = await AiService.askDoctor(userMsg);

  setState(() {
    messages.add({"role": "ai", "text": reply});
    loading = false;
  });

  _scrollToBottom();
}


// void sendMsg() async {
//   if (controller.text.isEmpty) return;

//   final userMsg = controller.text;
//   controller.clear();

//   setState(() {
//     messages.add({"role": "user", "text": userMsg});
//     loading = true;
//   });
//   _scrollToBottom();

//   await Future.delayed(Duration(milliseconds: 500));

//   final reply = getMedicalReply(userMsg);

//   setState(() {
//     messages.add({"role": "ai", "text": reply});
//     loading = false;
//   });
//   _scrollToBottom();
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI ${widget.specialization} Doctor"),
        backgroundColor: Colors.teal, // ஒரு மருத்துவ ஆப் போலத் தெரிய
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder( // ListView-க்கு பதிலாக Builder பயன்படுத்துவது சிறந்தது
              controller: _scrollController,
              padding: EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final m = messages[index];
                final isUser = m["role"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    padding: EdgeInsets.all(14),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.teal : Colors.grey.shade200,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: isUser ? Radius.circular(12) : Radius.circular(0),
                        bottomRight: isUser ? Radius.circular(0) : Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      m["text"]!,
                      style: TextStyle(color: isUser ? Colors.white : Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
          if (loading) Padding(
            padding: const EdgeInsets.all(8.0),
            child: LinearProgressIndicator(color: Colors.teal),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "உங்கள் பிரச்சனையைத் தட்டச்சு செய்யவும்...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.teal),
                  onPressed: sendMsg,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
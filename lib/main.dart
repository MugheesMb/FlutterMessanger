import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';  // NEW
import 'package:flutter/cupertino.dart';


void main() {
  runApp(
    FriendlyChatApp(),
  );
}
final ThemeData kIOSTheme = ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);
String _name = 'Mugy';

class FriendlyChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FriendlyChat',
      theme: defaultTargetPlatform == TargetPlatform.iOS // NEW
          ? kIOSTheme                                      // NEW
          : kDefaultTheme,
      home: ChatScreen(),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({required this.text , required this.animationController}); // NEW
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
      CurvedAnimation(parent: animationController, curve: Curves.easeInCubic),  // NEW
        axisAlignment: 0.0,
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
               Container(
                 margin: const EdgeInsets.only(right: 16.0),
                 child: CircleAvatar(child: Text(_name[0])),
               ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_name, style: Theme.of(context).textTheme.headline4),
            Container(
              margin: EdgeInsets.only(top: 5.0),
              child: Text(text),
            ),
            ],
        ),
      ),
      ],
      ),
      ),
    );
  }
}


class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messagess = [];      // NEW
  final _textController = TextEditingController();
  final  FocusNode _focusNode = FocusNode();
  bool _isComposing = false;
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FriendlyChat'),
        elevation:
        Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0, // NEW
      ),
      body: Container(
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, int index) => _messagess[index],
                  itemCount: _messagess.length,
                ),
              ),
              Divider(height: 1.0),
              Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS // NEW
              ? BoxDecoration(                                 // NEW
            border: Border(                              // NEW
              top: BorderSide(color: Colors.grey[200]!), // NEW
            ),                                           // NEW
          )                                              // NEW
              : null),                                         // MODIFIED
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(

        margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
           Flexible(
             child: TextField(
                controller: _textController,
               onChanged: (String text) {            // NEW
                 setState(() {                       // NEW
                   _isComposing = text.isNotEmpty;   // NEW
                 });                                 // NEW
               },
               onSubmitted: _isComposing ? _handleSubmitted : null,
                decoration: InputDecoration.collapsed(hintText: 'Send a message'),
               focusNode: _focusNode,
              ),
          ),
             Container(
               margin: EdgeInsets.symmetric(horizontal: 4.0),
               child : Theme.of(context).platform == TargetPlatform.iOS ? // MODIFIED
               CupertinoButton(                                          // NEW
                 child: Text('Send'),                                    // NEW
                 onPressed: _isComposing                                 // NEW
                     ? () =>  _handleSubmitted(_textController.text)     // NEW
                     : null,) :
               IconButton(
                   icon: const Icon(Icons.send),
                 onPressed: _isComposing                            // MODIFIED
                     ? () => _handleSubmitted(_textController.text) // MODIFIED
                     : null,
               )
             )
            ],

        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {                             // NEW
      _isComposing = false;                   // NEW
    });
    ChatMessage message = ChatMessage(    //NEW
      text: text, //NEW
      animationController: AnimationController(      // NEW
        duration: const Duration(milliseconds: 700), // NEW
        vsync: this,                                 // NEW
      ),
    );                                    //NEW
    setState(() {                         //NEW
      _messagess.insert(0, message);       //NEW
    });
    _focusNode.requestFocus();
    message.animationController.forward();
  }

  @override
  void dispose() {
    for (var message in _messagess){
      message.animationController.dispose();
    }
    super.dispose();
  }

}

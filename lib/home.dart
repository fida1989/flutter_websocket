import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:websocket_manager/websocket_manager.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final socket = WebsocketManager('wss://echo.websocket.org');
  String _message = "Message From WebSocket";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Socket Message:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              height: 20,
            ),
            Text(
              _message,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send',
        child: Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _initSocket();
    });
  }

  void _initSocket() {
    // Listen to close message
    socket.onClose((dynamic message) {
      setState(() {
        _message = "Socket Disconnected";
      });
    });
    // Listen to server messages
    socket.onMessage((dynamic message) {
      setState(() {
        _message = message.toString();
      });
    });
    // Connect to server
    socket.connect().then((value) {
      setState(() {
        _message = "Socket Connected";
      });
    });
  }

  void _sendMessage() {
    socket.send(DateTime.now().toString());
  }
}

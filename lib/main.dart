// ignore_for_file: avoid_unnecessary_containers

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:theta/theta.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var responseText = 'camera response';
  bool showStream = false;
  StreamController controller = StreamController();

  @override
  Widget build(BuildContext context) {
    Preview preview = Preview(controller);

    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                  flex: 8,
                  child: !showStream
                      ? Container(
                          child: SingleChildScrollView(
                            child: Text(responseText),
                          ),
                        )
                      : Container(
                          child: StreamBuilder(
                            stream: controller.stream,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                var imageData =
                                    Uint8List.fromList(snapshot.data);
                                return Image.memory(
                                  imageData,
                                  gaplessPlayback: true,
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        )),
              Expanded(
                flex: 1,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          var response = await ThetaBase.get('info');
                          setState(() {
                            responseText = response;
                          });
                        },
                        child: const Text('info'),
                      ),
                      OutlinedButton(
                        onPressed: () async {
                          var response =
                              await preview.getLivePreview(frames: 300);
                          setState(() {
                            showStream = true;
                          });
                        },
                        child: const Text('stream'),
                      ),
                      OutlinedButton(
                        onPressed: () async {
                          preview.stopPreview();
                          setState(() {
                            showStream = false;
                          });
                        },
                        child: const Text('stop preview'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

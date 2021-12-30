import 'dart:async';

import 'package:dio/dio.dart';
import 'package:theta/src/post_basic.dart';

// SC2 does fairly well at 250ms delay
// loses about 1 frame out of 150
// at 300ms, lost 1 frame out of 300
// at 350ms, lost 1 frame out of 300
// at 400ms, lost 1 frame out of 300

Future<void> getLivePreviewOld(StreamController controller,
    {int frames = 5, frameDelay = 34}) async {
  const livePreviewPayload = {'name': 'camera.getLivePreview'};
  Map<String, dynamic> additionalHeaders = {
    'Accept': 'multipart/x-mixed-replace'
  };
  var response = await postBasic(
      payload: livePreviewPayload,
      responseType: ResponseType.stream,
      headersAddition: additionalHeaders);

  Stream dataStream = response.data.stream;

  List<int> buffer = [];
  int startIndex = -1;
  int endIndex = -1;
  int frameCount = 0;
  bool keepRunning = true;

  // frame delay useful for testing SC2. milliseconds
  Stopwatch frameTimer = Stopwatch();
  frameTimer.start();

  StreamSubscription? subscription;
  subscription = await dataStream.listen((chunkOfStream) {
    if (frameCount > frames) {
      if (subscription != null) {
        subscription.cancel();
        keepRunning = false;
        frameTimer.stop();
        controller.close();
      }
    }
    if (keepRunning) {
      buffer.addAll(chunkOfStream);
      // print('current chunk of stream is ${chunkOfStream.length} bytes long');

      for (var i = 1; i < chunkOfStream.length; i++) {
        if (chunkOfStream[i - 1] == 0xff && chunkOfStream[i] == 0xd8) {
          startIndex = i - 1;
        }
        if (chunkOfStream[i - 1] == 0xff && chunkOfStream[i] == 0xd9) {
          endIndex = buffer.length;
        }

        if (startIndex != -1 && endIndex != -1) {
          var frame = buffer.sublist(startIndex, endIndex);
          if (frameTimer.elapsedMilliseconds > frameDelay) {
            if (frameCount > 0) {
              controller.add(frame);
              print('framecount $frameCount');
              frameTimer.reset();
            }

            frameCount++;
          }
          // print(frame);
          startIndex = -1;
          endIndex = -1;
          buffer = [];
        }
      }
    }
  });
}

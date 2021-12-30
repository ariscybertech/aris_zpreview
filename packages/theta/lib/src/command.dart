import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:theta/theta.dart';

const Map<String, dynamic> emptyBody = {};

/// baseName is 'takePicture', not 'camera.takePicture'
/// responseType default is ResponseType.json
/// use ResponseType.stream if using camara.getLivePreview
/// and the response is a stream
Future<dynamic> command(String baseName,
    {Map<String, dynamic> parameters = emptyBody,
    ResponseType responseType = ResponseType.json,
    additionalHeaders = emptyBody}) async {
  var response = await ThetaBase.post('commands/execute',
      responseType: responseType,
      additionalHeaders: additionalHeaders,
      body: {
        'name': 'camera.$baseName',
        'parameters': parameters,
      });

  return response;
}

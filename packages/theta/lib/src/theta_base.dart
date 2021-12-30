import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:theta/theta.dart';

class ThetaBase {
  static final baseUrl = 'http://192.168.1.1/osc/';
  static final contentType = 'application/json;charset=utf-8';
  static var dio = Dio();

  static Future<String> get(path) async {
    String url = '$baseUrl$path';
    try {
      var response = await dio.get(
        url,
        options: Options(
          headers: {'Content-Type': contentType, 'X-XSRF-Protected': 1},
        ),
      );
      Map<String, dynamic> responseData = response.data;
      return prettify(responseData);
    } catch (error) {
      String errorMessage = '*********************** \n'
          'Command failed.  First check if the camera is \n'
          'connected with Wi-Fi.  Try pinging the camera.\n'
          'In access point mode, the camera is always at 192.168.1.1\n'
          'verify that you do not have your home or office router on that same\n'
          'IP address if you have two network interfaces on your computer.\n'
          'details on the execution error are shown below. \n\n'
          '*********************** \n\n';
      errorMessage = errorMessage + error.toString();
      return errorMessage;
    }
  } // end get

  static const Map<String, dynamic> emptyMap = {};

  /// path is everything after osc/
  /// examples: post('state')
  static Future<dynamic> post(String path,
      {Map<String, dynamic> body = emptyMap,
      ResponseType responseType = ResponseType.json,
      additionalHeaders = emptyMap}) async {
    String url = '$baseUrl$path';
    Map<String, dynamic> headers = {
      'Content-Type': contentType,
      'X-XSRF-Protected': 1
    };

    headers.addAll(additionalHeaders);

    try {
      var response = await dio.post(
        url,
        data: jsonEncode(body),
        options: Options(
          responseType: responseType,
          headers: headers,
        ),
      );
      if (responseType == ResponseType.stream) {
        return response;
      } else {
        Map<String, dynamic> responseData = response.data;
        return prettify(responseData);
      }
    } catch (error) {
      String errorMessage = '*********************** \n'
          'Command failed.  First check if the camera is \n'
          'connected with Wi-Fi.  Try pinging the camera.\n'
          'In access point mode, the camera is always at 192.168.1.1\n'
          'verify that you do not have your home or office router on that same\n'
          'IP address if you have two network interfaces on your computer.\n'
          'details on the execution error are shown below. \n\n'
          '*********************** \n\n';
      errorMessage = errorMessage + error.toString();
      return errorMessage;
    }
  }
}

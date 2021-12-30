import 'dart:convert';

import 'package:dio/dio.dart';

const Map<String, dynamic> blankMap = {};
Future<Response<dynamic>> postBasic(
    {required Map<String, dynamic> payload,
    ResponseType responseType = ResponseType.json,
    Map<String, dynamic> headersAddition = blankMap}) async {
  var dio = Dio();
  const url = 'http://192.168.1.1/osc/commands/execute';

  Map<String, dynamic> headers = {
    'Content-Type': 'application/json;charset=utf-8',
    // I think the XSRF line is not needed and is part of the response header
    // https://developers.google.com/streetview/open-spherical-camera/guides/osc/xssxsrf
    'X-XSRF-Protected': 1
  };
  headers.addAll(headersAddition);

  Response<dynamic> response = await dio.post(url,
      data: jsonEncode(payload),
      options: Options(headers: headers, responseType: responseType));
  return response;
}

import 'dart:convert';

import 'theta_base.dart';

/// after startCapture
/// Uses state to check for the camera readiness
/// to get around a limitation in the SC2 API.
Future<String> checkForIdle() async {
  var response = await ThetaBase.post('state');
  try {
    Map<String, dynamic> responseMap = await jsonDecode(response);
    String _captureStatus = responseMap['state']['_captureStatus'];
    if (_captureStatus == 'idle' ||
        _captureStatus == 'shooting' ||
        _captureStatus == 'self-timer countdown' ||
        _captureStatus == 'bracket shooting') {
      return _captureStatus;
    }
  } catch (error) {
    return error.toString();
  }
  return 'error capture status invalid';
}

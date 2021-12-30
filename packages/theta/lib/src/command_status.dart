import 'dart:convert';

import '../theta.dart';

/// status of command. Returns "done", "inProgress", or "error"
/// example of use:
/// ```dart
/// while (await theta.commandStatus(id) != 'done') {
///   await theta.commandStatus(id);
/// ```
Future<String> commandStatus(String id) async {
  var response = await ThetaBase.post('commands/status', body: {'id': id});
  await Future.delayed(Duration(milliseconds: 100));
  Map<String, dynamic> responseMap = jsonDecode(response);

  return responseMap['state'];
}

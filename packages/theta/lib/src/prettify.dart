import 'dart:convert';

String prettify(Map<String, dynamic> data) {
  JsonEncoder encoder = JsonEncoder.withIndent('  ');
  String output = encoder.convert(data);
  return output;
}

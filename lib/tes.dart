import 'dart:convert';

import 'package:http/http.dart' as http;

void main(List<String> args) async {
  final response =
      await http.get(Uri.parse('https://paa.gunzxx.my.id/api/tourist'));

  if (response.statusCode == 200) {
    print(await jsonDecode(response.body)['data']);
  }
  print("done");
}

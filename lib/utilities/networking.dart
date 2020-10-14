import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:validator/utilities/globals.dart';

class NetworkHelper {
  NetworkHelper({this.url});

  String url;

  Map<String, String> headers = {'content-type': 'application/json; charset=utf-8'};

  Future getData(String method, dynamic params) async {
    this.url = '${Global.selectedNetworkUrl}';
    List<dynamic> lstParams = new List();
    if (params != null) {
      lstParams.add(params);
    }
    Map<String, dynamic> body = {'jsonrpc': '2.0', 'method': method, 'params': lstParams, 'id': '1'};
    http.Response response = await http.post(this.url, headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      String data = Utf8Decoder().convert(response.bodyBytes);
      return jsonDecode(data);
    } else {
      print(response.body);
    }
  }

  Future getDataFromUrl(String url) async {
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.body);
    }
  }
}

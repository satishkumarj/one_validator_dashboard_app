import 'dart:convert';

import 'package:validator/utilities/constants.dart';
import 'package:http/http.dart' as http;

class NetworkHelper {
  NetworkHelper({this.url});

  String url;

  Map<String, String> headers = {'content-type': 'application/json'};

  Future getData(String method, dynamic params) async {
    this.url = '$kOpenStakeApiUrl';
    List<dynamic> lstParams = new List();
    lstParams.add(params);
    Map<String, dynamic> body = {'jsonrpc': '2.0', 'method': method, 'params': lstParams, 'id': '1'};

    http.Response response = await http.post(this.url, headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.body);
    }
  }
}

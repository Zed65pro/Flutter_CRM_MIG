import 'dart:convert';
import 'package:http/http.dart' as http;

main() async {
  var response =
      await http.get(Uri.parse('http://192.168.12.52:8000/api/v1/services/'));
  if (response.statusCode == 200) {
    // Decode the JSON response body
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}');
  }
}

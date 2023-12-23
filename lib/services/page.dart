import 'dart:convert';

import 'package:http/http.dart' as http;

class MyPage {
  String baseUrl = "https://fo-atalian.kitra-consulting.fr/wp-json/wp/v2/pages";

  Future<List> getAllPage() async {
    try {
      var response = await http.get(Uri.parse(baseUrl));

      // print(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return Future.error("Server Error");
      }
    } catch (SocketException) {
      return Future.error("Error Fetching Data");
    }
  }

  /*
  final Dio _dio = Dio();
  Future<List> getAllPage() async {
    try {
      final response = await _dio.get(baseUrl);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.cast<Map<String, dynamic>>();
      } else {
        print('Erreur de requête : ${response.statusCode}');
        return Future.error('Erreur de requête 2 : ${response.statusCode}');
        // return [];
      }
    } catch (error) {
      // Gérer les erreurs Dio ici
      print('Erreur Dio : $error');
      return Future.error('Erreur Dio 2 : $error');
      // return [];
    }
  }
  */

}
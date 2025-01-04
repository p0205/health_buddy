
import 'dart:io';

import 'package:http/http.dart' as http;



class GetUserWeightFailure implements Exception{}

class UserDataProvider {

  final String _baseUrl;
  final http.Client _httpClient;

  UserDataProvider({http.Client? httpClient})
      : _baseUrl = _getBaseUrl(),
        _httpClient = httpClient ?? http.Client();


  static String _getBaseUrl() {
    if (Platform.isAndroid) {
      return "10.0.2.2:8080"; // Android emulator localhost
    } else{
      return "localhost:8080"; // Default for other platforms
    }
  }

  // physical Android devices
  // static String _getBaseUrl() {
  //   return "192.168.1.3:8080";
  // }

  // static String _getBaseUrl() {
  //   return "192.168.173.30:8080";
  // }

  //
  // Future<User> fetchUser(int id) async {
  //   try {
  //     // Use string interpolation correctly
  //     final uri = Uri.parse("$_baseUrl/$id");
  //     final response = await _httpClient.get(uri);
  //
  //     if (response.statusCode == 200) {
  //       return User.fromJson(json.decode(response.body));
  //     } else {
  //       throw Exception('Failed to load user: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<String> getUserWeight(int id) async {
    final uri = Uri.http(_baseUrl,"/user/${id.toString()}/weight");

    final response = await _httpClient.get(uri);

    if(response.statusCode != 200){
      throw GetUserWeightFailure();
    }
    return response.body;
  }
}
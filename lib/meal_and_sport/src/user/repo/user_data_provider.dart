
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:health_buddy/constants.dart' as Constants;

import '../model/user.dart';


class GetUserWeightFailure implements Exception{}

class UserDataProvider {

  final String _baseUrl;
  final http.Client _httpClient;

  UserDataProvider({http.Client? httpClient})
      : _baseUrl = _getBaseUrl(),
        _httpClient = httpClient ?? http.Client();


  static String _getBaseUrl() {
    if (Platform.isAndroid) {
      return Constants.BaseUrl + Constants.SportNMealPort; // Android emulator localhost
    } else{
      return "http://localhost:8080"; // Default for other platforms
    }
  }

  // physical Android devices
  // static String _getBaseUrl() {
  //   return "10.131.76.45:8080";
  // }

  // static String _getBaseUrl() {
  //   return "192.168.18.30:8080";
  // }

  //
  Future<User> fetchUser(int id) async {
    try {
      // Use string interpolation correctly
      final uri = Uri.parse("$_baseUrl/user/$id");
      final response = await _httpClient.get(uri);

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load user: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }


  Future<void> updateProfile(int id, Map<String, dynamic> updatedData) async {

    try {
      final uri = Uri.parse('$_baseUrl/user/$id');
      final response = await http.patch(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        // Parse and return the updated user data
        return;
      } else {
        // Handle server errors
        throw Exception('Failed to update profile: ${response.body}');
      }
    } catch (e) {
      // Handle any network or parsing errors
      throw Exception('Error updating profile: $e');
    }
  }

  Future<String> getUserWeight(int id) async {
    final uri = Uri.parse('$_baseUrl/user/${id.toString()}/weight');
    final response = await _httpClient.get(uri);

    if(response.statusCode != 200){
      throw GetUserWeightFailure();
    }
    return response.body;
  }


  Future<void> markFirstLogin(int userId, bool isFirstLogin) async {

    final uri = Uri.parse('$_baseUrl/user/${userId.toString()}/first-login');

    // The request payload
    final payload = jsonEncode({'isFirstLogin': isFirstLogin});

    try {
      // Send the PATCH request
      final response = await http.patch(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: payload,
      );

      if (response.statusCode == 204) {
        // Successfully updated the first login status
        print('First login status updated successfully');
      } else {
        // Handle other status codes
        print('Failed to update first login status. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any error
      print('Error updating first login status: $error');
    }
  }

  Future<String?> uploadProfileImage(File file, int userId) async{
    final uri = Uri.parse('$_baseUrl/user/uploadProfileImage/${userId.toString()}');

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
    });
    final dio = Dio();
    final response = await dio.post(
      uri.toString(),
      data: formData,
      onSendProgress: (int sent, int total) {
      },);
    if(response.statusCode == 200){
      return response.data;
    }else{
      return null;
    }
  }


}
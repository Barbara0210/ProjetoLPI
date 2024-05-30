 //in order to connect to database we have to create dio provider first
 //to post/get data from laravel databse
 //and since we use laravel sanctum  an API Token needed for getting data
 //and thus, JWT in this video

 import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

 class DioProvider{
  final Dio _dio = Dio();

  static const String baseUrl = 'http://10.0.2.2:8000/api';
//get token
Future<dynamic> getToken(String email, String password) async{
  try {
    var response = await Dio().post('http://10.0.2.2:8000/api/login',
        data: {'email': email, 'password': password});

    if(response.statusCode == 200 && response.data != ''){
      //store returned token into share preferences for get other data later
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response.data);
      return true;
    } else{
    return false; 
    }

  } catch(error){
    return error;
  }

 }

 //the url "http:127.0.0.1:8000" is a local database
 //and "/api/login" is the end point that will be set later in laravel

 //get user data

 Future<dynamic> getUser(String token) async{

try{
    var user = await Dio().get('http://10.0.2.2:8000/api/user',
        options: Options(headers:{'Authorization': 'Bearer $token'})
    );

    //if request successfully,then return user data
    if(user.statusCode == 200 && user.data != ''){
      return json.encode(user.data);
    }
}catch (error){
  return error;
}

 }


//register new user
 Future<dynamic> registerUser(String username, String email,String password) async{

try{
    var user = await Dio().post('http://10.0.2.2:8000/api/register',
           data: {'name' : username ,'email': email, 'password': password});
   

    //if register successfull return true
    if(user.statusCode == 201 && user.data != ''){
      return true;
    } else {
      return false;
    }
}catch (error){
  return error;
}

 }


//store booking details
Future<dynamic> bookAppointment(
      String date, String day, String time, int doctorId, String token) async {
    try {
      var response = await Dio().post(
        'http://10.0.2.2:8000/api/book',
        data: {
          'date': date,
          'day': day,
          'time': time,
          'doctor_id': doctorId,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data != '') {
        return response.data;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

  //retrieve booking details
Future<dynamic> getAppointments(String token) async {
  try {
    if (token.isEmpty) {
      return 'Error: No token provided';
    }

    var response = await Dio().get(
      'http://10.0.2.2:8000/api/appointments',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200 && response.data != '') {
      print('Appointments data received: ${response.data}');
      return json.encode(response.data);
    } else {
      print('Error: Unexpected response - status code ${response.statusCode}');
      return 'Error';
    }
  } catch (error) {
    print('Error: $error');
    return 'Error: $error';
  }
}

    Future<dynamic> updateAppointment(String id, String date, String day, String time) async {
    try {
      var response = await Dio().put(
        'http://10.0.2.2:8000/api/appointments/$id',
        data: {
          'date': date,
          'day': day,
          'time': time,
        },
      );

      if (response.statusCode == 200) {
        return 'Success';
      } else {
        return 'Error';
      }
    } catch (error) {
      return 'Error: $error';
    }
  }

 //store rating details
Future<dynamic> storeReviews(
    String reviews, double ratings, int appointmentId, int doctorId, String token) async {
  try {
    var response = await Dio().post(
      'http://10.0.2.2:8000/api/reviews',
      data: {
        'ratings': ratings,
        'reviews': reviews,
        'appointment_id': appointmentId, // Include appointment_id
        'doctor_id': doctorId
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    print('Response status code: ${response.statusCode}');
    print('Response data: ${response.data}');

    if (response.statusCode == 201 && response.data != '') {
      return response.statusCode;
    } else {
      return 'Error';
    }
  } catch (error) {
    print('Error in storeReviews: $error');
    return error;
  }
}
  Future<dynamic> fetchReview(int appointmentId, String token) async {
    try {
      var response = await Dio().get(
        'http://10.0.2.2:8000/api/reviews',
        queryParameters: {'appointment_id': appointmentId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return response.data[0];
      } else {
        return null;
      }
    } catch (error) {
      print('Error fetching review: $error');
      return null;
    }
  }

    Future<Map<String, dynamic>?> getLastReview(String doctorId, String token) async {
    try {
      if (token.isEmpty) {
        return Future.error('Error: No token provided');
      }

      var response = await _dio.get(
        '$baseUrl/doctors/$doctorId/latest',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data != '') {
        print('Last review data received: ${response.data}');
        return response.data;
      } else {
        print('Error: Unexpected response - status code ${response.statusCode}');
        return Future.error('Error: Unexpected response');
      }
    } catch (error) {
      print('Error: $error');
      return Future.error('Error: $error');
    }
  }
  /*
 Future<dynamic> getLastReview(String doctorId, String token) async {
    try {
      if (token.isEmpty) {
        return 'Error: No token provided';
      }

      var response = await Dio().get(
        'http://10.0.2.2:8000/api/doctors/$doctorId/reviews/latest',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data != '') {
        print('Last review data received: ${response.data}');
        return response.data;
      } else {
        print('Error: Unexpected response - status code ${response.statusCode}');
        return 'Error';
      }
    } catch (error) {
      print('Error: $error');
      return 'Error: $error';
    }
  }
*/
  

 Future<dynamic> updateReview(int reviewId, String comment, double rating, String token) async {
    try {
      var response = await Dio().put(
        'http://10.0.2.2:8000/api/reviews/$reviewId',
        data: {
          'reviews': comment,
          'ratings': rating,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('Error: Unexpected response - status code ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error: $error');
      return null;
    }
  }


  //store fav doctor
  Future<dynamic> storeFavDoc(String token, List<dynamic> favList) async {
    try {
      var response = await Dio().post('http://10.0.2.2:8000/api/fav',
          data: {
            'favList': favList,
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }


//logout
  Future<dynamic> logout(String token) async {
    try {
      var response = await Dio().post('http://10.0.2.2:8000/api/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }
 }
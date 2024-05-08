 //in order to connect to database we have to create dio provider first
 //to post/get data from laravel databse
 //and since we use laravel sanctum  an API Token needed for getting data
 //and thus, JWT in this video

 import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

 class DioProvider{

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

 }
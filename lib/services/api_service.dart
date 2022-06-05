import 'dart:convert';

import 'package:dio/dio.dart';

class ApiService{
  Dio? _dio;

  static header() => {"Content-Type": "application/json"};


  Future<dynamic> getData() async{
    _dio = Dio();
    final response = await _dio!.get("https://dummyjson.com/products");
    final data = jsonDecode(response.toString());
    return data['products'];
  }


  
}
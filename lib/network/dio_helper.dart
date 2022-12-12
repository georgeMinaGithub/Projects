
import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  // ........................   init Method ....................................

  static init()
  {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://newsapi.org/',
        receiveDataWhenStatusError: true,
      ),
    );

  }


// .................... static Future<Response> getData .......................

  // Function Get Dat
  static Future<Response> getData (
      {
        required String url,
        required Map<String,dynamic> query,
      })async
  {
    /*
    url is a Method such as   v2/top-headlines
    query write a Map such as
            country=eg&category=business&apiKey=1e2e3ea56c7743d39065949c6d8e18da
     */
    return await dio.get(url,queryParameters: query);
  }


}


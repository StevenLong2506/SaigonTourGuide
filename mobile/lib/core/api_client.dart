import 'package:dio/dio.dart';
import 'package:saigon_tour_guide/core/config.dart';
import 'package:saigon_tour_guide/core/token_storage.dart';

class ApiClient{
  final Dio dio;
  void Function()? onUnauthorized;

  ApiClient() : dio = Dio(BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      )
    ){
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async{
          final token = await TokenStorage.read();
          if(token!=null){
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (err, handler) async{
          if (err.response?.statusCode==401){
            await TokenStorage.clear();
            onUnauthorized?.call();
          }
          handler.next(err);
        },
      )
    );
  }
}

String getErrorMessage(Object err){
  if (err is DioException){
    final data = err.response?.data;
    if (data is Map && data['detail'] != null){
      final detail = data['detail'];
      if(detail is String) return detail;
      if (detail is List){
        return detail.map((d) => d is Map ? (d['msg'] ?? d.toString()) : d.toString()).join(', ');
      }
    }
  }
  return 'Đã có lỗi xảy ra';
}
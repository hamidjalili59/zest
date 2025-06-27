import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:zest/src/core/network/token_interceptor.dart';

import '../constants/app_constants.dart' show AppConstants;

class ApiClient {
  ApiClient();

  final _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      validateStatus:
          (status) => switch (status) {
            200 => true,
            201 => true,
            _ => false,
          },
    ),
  );

  Dio initDio() {
    _dio.interceptors.add(TokenInterceptor(_dio));

    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        logPrint: (message) {
          if (kDebugMode) {
            print('*** => $message');
          }
        },
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
      ),
    );
    return _dio;
  }
}

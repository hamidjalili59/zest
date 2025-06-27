import 'package:dio/dio.dart';
import 'package:zest/src/core/network/api_client.dart';
import 'package:zest/src/core/utilities/database.dart';
import 'package:zest/src/injection/injectable.dart';

class InjectableConfigure {
  Future<void> startConfiguration() async {
    getIt.registerSingleton<AppDatabase>(AppDatabase());
    getIt.registerSingleton<Dio>(Dio());
    getIt.registerSingleton<ApiClient>(ApiClient());
    getIt.get<ApiClient>().initDio();
  }
}

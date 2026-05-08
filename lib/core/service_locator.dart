import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:voucherize/main.module.dart';

final GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  if (sl.isRegistered<Dio>()) return;

  sl.registerSingleton<Dio>(Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  )..interceptors.add(LogInterceptor(requestBody: true, responseBody: true)));

  MainModule().registerStores(sl);
}

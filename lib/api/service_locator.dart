import 'package:driver/api/api_client_impl.dart';
import 'package:driver/api/base_api_client.dart';
import 'package:driver/repositories/chat_repository.dart';
import 'package:driver/services/chat_socket_service.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl=GetIt.instance;

// Custom HTTP client with timeout configuration
http.Client createHttpClient() {
  return http.Client();
}

void setupLocator(){
  sl.registerLazySingleton<http.Client>(()=>createHttpClient());
  sl.registerLazySingleton<BaseApiClient>(()=>ApiClientImp(sl()));
  sl.registerLazySingleton<ChatRepository>(()=>ChatRepository());
  sl.registerLazySingleton<ChatSocketService>(()=>ChatSocketService());
}
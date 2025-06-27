import 'package:driver/api/api_client_impl.dart';
import 'package:driver/api/base_api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl=GetIt.instance;
void setupLocator(){
  sl.registerLazySingleton<http.Client>(()=>http.Client());
  sl.registerLazySingleton<BaseApiClient>(()=>ApiClientImp(sl()));

}
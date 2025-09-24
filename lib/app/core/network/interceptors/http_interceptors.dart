import 'package:http/http.dart' as http;

abstract class HttpInterceptor {
  Future<http.BaseRequest> onRequest(http.BaseRequest request);
  Future<http.Response> onResponse(http.Response response);
  Future onError(dynamic error);
}

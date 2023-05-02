abstract class BaseApiServices {
  Future<dynamic> getData(String url);
  Future<dynamic> postData(String url, {dynamic body, dynamic headers});
}

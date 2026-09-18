import 'package:web/web.dart' as web;

class CookieHelpers {
  static void SetToken(String token){
    web.window.sessionStorage.setItem('token', token);
  }
  static String GetToken() => web.window.sessionStorage.getItem('token') ?? "null";
}
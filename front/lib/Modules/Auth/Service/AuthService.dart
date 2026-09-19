import 'package:atlas/Configurations/Configuration.dart';
import 'package:atlas/Helpers/CookieHelpers.dart';
import 'package:atlas/Helpers/FunctionResult.dart';
import 'package:atlas/Modules/Auth/Model/AuthModel.dart';

class AuthService {
  ApiClient apiClient = ApiClient();

  Future<FunctionResult> login(AuthModel model) async {
    try {
      final controller = Configuration.localSource.getController("login").path;
      final response = await apiClient.dio.post(
        controller,
        data: model.toJson(),
      );

      if (response.statusCode == 200) {
        CookieHelpers.SetToken(response.data['token']);
        return FunctionResult(true);
      } else if (response.statusCode == 403 || response.statusCode == 404)
        return FunctionResult(false, Error: "Неверный логин или пароль");
      else
        return FunctionResult(
          false,
          Error: "Упс, что-то пошло не так " + response.statusCode.toString(),
        );
    } catch (ex) {
      return FunctionResult(
        false,
        Error: "Упс, что-то пошло не так " + ex.toString(),
      );
    }
  }

  Future<FunctionResult> register(AuthModel model) async {
    try {
      final controller = Configuration.localSource
          .getController("register")
          .path;
      final response = await apiClient.dio.post(
        controller,
        data: model.toJson(),
      );

      if (response.statusCode == 200)
        return FunctionResult(true);
      else if (response.statusCode == 400)
        return FunctionResult(false, Error: "Такой пользователь уже есть");
      else
        return FunctionResult(
          false,
          Error: "Упс, что-то пошло не так " + response.statusCode.toString(),
        );
    } catch (ex) {
      return FunctionResult(
        false,
        Error: "Упс, что-то пошло не так " + ex.toString(),
      );
    }
  }
}

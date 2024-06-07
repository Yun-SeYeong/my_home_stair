
import 'package:my_home_stair/dto/response/token_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {
  Future<TokenResponse?> getTokenResponse() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');
    final String? refreshToken = prefs.getString('refreshToken');
    if (accessToken == null || refreshToken == null) {
      return null;
    }
    return TokenResponse(accessToken: accessToken, refreshToken: refreshToken);
  }

  Future<void> saveTokenResponse(TokenResponse tokenResponse) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', tokenResponse.accessToken);
    await prefs.setString('refreshToken', tokenResponse.refreshToken);
  }

  Future<void> deleteTokenResponse() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }
}
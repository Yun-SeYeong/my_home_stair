
import 'package:dio/dio.dart';
import 'package:my_home_stair/dto/request/reissue_request.dart';
import 'package:my_home_stair/dto/request/sign_in_request.dart';
import 'package:my_home_stair/dto/request/sign_up_request.dart';
import 'package:my_home_stair/dto/response/common/common_response.dart';
import 'package:my_home_stair/dto/response/member_response.dart';
import 'package:my_home_stair/dto/response/token_response.dart';
import 'package:retrofit/http.dart';

part 'auth_repository.g.dart';

@RestApi(baseUrl: "/v1/auth")
abstract class AuthRepository {
  factory AuthRepository(Dio dio, {String baseUrl}) = _AuthRepository;

  @POST("/signin")
  Future<CommonResponse<TokenResponse>> signIn(@Body() SignInRequest signInRequest);

  @POST("/signup")
  Future<CommonResponse<MemberResponse>> signUp(@Body() SignUpRequest signUpRequest);

  @POST("/reissue")
  Future<CommonResponse<TokenResponse>> reissue(@Body() ReissueRequest tokenResponse);

}
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_home_stair/dto/request/auth/reissue_request.dart';
import 'package:my_home_stair/presentation/home/home_page.dart';
import 'package:my_home_stair/presentation/login/login_page.dart';
import 'package:my_home_stair/repository/auth_repository.dart';
import 'package:my_home_stair/repository/shared_preferences_repository.dart';

class SplashPageBloc extends Bloc<SplashPageEvent, SplashPageState> {
  final BuildContext context;
  final AuthRepository _authRepository;
  final SharedPreferencesRepository _sharedPreferencesRepository;

  SplashPageBloc(this.context, this._authRepository, this._sharedPreferencesRepository)
      : super(SplashPageState()) {
    on<LoadSplashPageEvent>(_onLoadSplashPageEvent);
  }

  void _onLoadSplashPageEvent(
      LoadSplashPageEvent event, Emitter<SplashPageState> emit) async {
    try {
      await _sharedPreferencesRepository.getTokenResponse().then((value) async {
        if (value != null) {
          await _authRepository.reissue(ReissueRequest(
            accessToken: value.accessToken,
            refreshToken: value.refreshToken,
          )).then((reissueResponse) {
            _sharedPreferencesRepository
                .saveTokenResponse(reissueResponse.content);
            Navigator.popAndPushNamed(context, HomePage.route);
          });
        } else {
          Navigator.popAndPushNamed(context, LoginPage.route);
        }
      });
    } catch (error) {
      if (!context.mounted) throw Exception('Context is not mounted');
      Navigator.popAndPushNamed(context, LoginPage.route);
    }
  }
}

sealed class SplashPageEvent {
  const SplashPageEvent();
}

class LoadSplashPageEvent extends SplashPageEvent {}

class SplashPageState extends Equatable {
  @override
  List<Object> get props => [];
}

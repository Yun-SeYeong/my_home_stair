import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_home_stair/dto/request/reissue_request.dart';
import 'package:my_home_stair/repository/auth_repository.dart';
import 'package:my_home_stair/repository/shared_preferences_repository.dart';

class SplashPageBloc extends Bloc<SplashPageEvent, SplashPageState> {
  final AuthRepository _authRepository;
  final SharedPreferencesRepository _sharedPreferencesRepository;

  SplashPageBloc(this._authRepository, this._sharedPreferencesRepository)
      : super(SplashPageState()) {
    on<LoadSplashPageEvent>(_onLoadSplashPageEvent);
  }

  void _onLoadSplashPageEvent(
      LoadSplashPageEvent event, Emitter<SplashPageState> emit) async {
    try {
      await _sharedPreferencesRepository.getTokenResponse().then((value) async {
        if (value != null) {
          print('accessToken: ${value.accessToken}');
          print('refreshToken: ${value.refreshToken}');
          await _authRepository.reissue(ReissueRequest(
            accessToken: value.accessToken,
            refreshToken: value.refreshToken,
          )).then((reissueResponse) {
            _sharedPreferencesRepository
                .saveTokenResponse(reissueResponse.content);
            event.onSuccess();
          });
        } else {
          event.onFail();
        }
      });
    } catch (error) {
      event.onFail();
    }
  }
}

sealed class SplashPageEvent {
  const SplashPageEvent();
}

class LoadSplashPageEvent extends SplashPageEvent {
  final Function onSuccess;
  final Function onFail;

  LoadSplashPageEvent({required this.onFail, required this.onSuccess});
}

class SplashPageState extends Equatable {
  @override
  List<Object> get props => [];
}

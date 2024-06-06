import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_home_stair/dto/request/sign_in_request.dart';
import 'package:my_home_stair/repository/auth_repository.dart';
import 'package:my_home_stair/repository/shared_preferences_repository.dart';

class LoginBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final SharedPreferencesRepository _sharedPreferencesRepository;

  LoginBloc(this._authRepository, this._sharedPreferencesRepository)
      : super(const AuthState()) {
    on<SignInEvent>(_onSignInEvent);
    on<UpdateEmailEvent>(_onUpdateEmail);
    on<UpdatePasswordEvent>(_onUpdatePassword);
  }

  void _onSignInEvent(SignInEvent event, Emitter<AuthState> emit) async {
    if (state.isLoading) return;

    emit(state.copy(isLoading: true));
    await _authRepository
        .signIn(SignInRequest(email: state.emailText, password: state.passwordText))
    .then((value) async {
      await _sharedPreferencesRepository.saveTokenResponse(value.content);
      emit(state.copy(isError: false, isLoading: false));
      event.onSuccess();
    }).catchError((error) {
      emit(state.copy(isError: true, isLoading: false));
    });
  }

  void _onUpdateEmail(UpdateEmailEvent event, Emitter<AuthState> emit) {
    emit(state.copy(emailText: event.email, isError: false));
  }

  void _onUpdatePassword(UpdatePasswordEvent event, Emitter<AuthState> emit) {
    emit(state.copy(passwordText: event.password, isError: false));
  }
}

sealed class AuthEvent {
  const AuthEvent();
}

class SignInEvent extends AuthEvent {
  final Function onSuccess;

  const SignInEvent({required this.onSuccess});
}

class UpdateEmailEvent extends AuthEvent {
  final String email;

  const UpdateEmailEvent(this.email);
}

class UpdatePasswordEvent extends AuthEvent {
  final String password;

  const UpdatePasswordEvent(this.password);
}

class AuthState extends Equatable {
  final String emailText;
  final String passwordText;
  final bool isError;
  final bool isLoading;

  const AuthState({
    this.emailText = '',
    this.passwordText = '',
    this.isError = false,
    this.isLoading = false,
  });

  AuthState copy({
    String? emailText,
    String? passwordText,
    bool? isError,
    bool? isLoading,
  }) {
    return AuthState(
      emailText: emailText ?? this.emailText,
      passwordText: passwordText ?? this.passwordText,
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [emailText, passwordText, isError, isLoading];
}

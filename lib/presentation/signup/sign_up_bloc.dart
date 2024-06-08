import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_home_stair/dto/request/sign_up_request.dart';
import 'package:my_home_stair/repository/auth_repository.dart';

class SignUpBloc extends Bloc<SignUpPageEvent, SignUpState> {
  final BuildContext context;
  final AuthRepository _authRepository;

  SignUpBloc(this.context, this._authRepository) : super(const SignUpState()) {
    on<SignUpEvent>(_onSignUpEvent);
    on<UpdateEmailEvent>(_onUpdateEmail);
    on<UpdatePasswordEvent>(_onUpdatePassword);
    on<UpdatePasswordConfirmEvent>(_onUpdatePasswordConfirm);
  }

  Future<void> _onSignUpEvent(
      SignUpEvent event, Emitter<SignUpState> emit) async {
    if (state.isLoading) return;

    emit(state.copy(isLoading: true));
    if (state.emailText.isEmpty ||
        state.passwordText != state.passwordConfirmText) {
      emit(state.copy(
        isEmailTextError: state.emailText.isEmpty,
        isPasswordTextError: state.passwordText.isEmpty,
        isPasswordConfirmTextError:
            state.passwordText != state.passwordConfirmText,
        isLoading: false,
      ));
      return;
    }
    await _authRepository
        .signUp(SignUpRequest(
      email: state.emailText,
      password: state.passwordText,
    ))
        .then((value) {
      emit(state.copy(
        isEmailTextError: false,
        isPasswordTextError: false,
        isPasswordConfirmTextError: false,
        isLoading: false,
      ));
      Navigator.pop(context);
    }).catchError((error) {
      emit(state.copy(
        isEmailTextError: true,
        isPasswordTextError: false,
        isPasswordConfirmTextError: false,
        isLoading: false,
      ));
    });
  }

  Future<void> _onUpdateEmail(
      UpdateEmailEvent event, Emitter<SignUpState> emit) async {
    emit(state.copy(
      emailText: event.email,
      isEmailTextError: false,
    ));
  }

  Future<void> _onUpdatePassword(
      UpdatePasswordEvent event, Emitter<SignUpState> emit) async {
    emit(state.copy(
      passwordText: event.password,
      isPasswordTextError: false,
    ));
  }

  Future<void> _onUpdatePasswordConfirm(
      UpdatePasswordConfirmEvent event, Emitter<SignUpState> emit) async {
    emit(state.copy(
        passwordConfirmText: event.passwordConfirm,
        isPasswordConfirmTextError: false));
  }
}

sealed class SignUpPageEvent {
  const SignUpPageEvent();
}

class SignUpEvent extends SignUpPageEvent {}

class UpdateEmailEvent extends SignUpPageEvent {
  final String email;

  const UpdateEmailEvent({required this.email});
}

class UpdatePasswordEvent extends SignUpPageEvent {
  final String password;

  const UpdatePasswordEvent({required this.password});
}

class UpdatePasswordConfirmEvent extends SignUpPageEvent {
  final String passwordConfirm;

  const UpdatePasswordConfirmEvent({required this.passwordConfirm});
}

class SignUpState extends Equatable {
  final String emailText;
  final String passwordText;
  final String passwordConfirmText;
  final bool isEmailTextError;
  final bool isPasswordTextError;
  final bool isPasswordConfirmTextError;
  final bool isLoading;

  const SignUpState({
    this.emailText = '',
    this.passwordText = '',
    this.passwordConfirmText = '',
    this.isEmailTextError = false,
    this.isPasswordTextError = false,
    this.isPasswordConfirmTextError = false,
    this.isLoading = false,
  });

  SignUpState copy({
    String? emailText,
    String? passwordText,
    String? passwordConfirmText,
    bool? isEmailTextError,
    bool? isPasswordTextError,
    bool? isPasswordConfirmTextError,
    bool? isLoading,
  }) {
    return SignUpState(
      emailText: emailText ?? this.emailText,
      passwordText: passwordText ?? this.passwordText,
      passwordConfirmText: passwordConfirmText ?? this.passwordConfirmText,
      isEmailTextError: isEmailTextError ?? this.isEmailTextError,
      isPasswordTextError: isPasswordTextError ?? this.isPasswordTextError,
      isPasswordConfirmTextError:
          isPasswordConfirmTextError ?? this.isPasswordConfirmTextError,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        emailText,
        passwordText,
        passwordConfirmText,
        isEmailTextError,
        isPasswordTextError,
        isPasswordConfirmTextError,
        isLoading,
      ];
}

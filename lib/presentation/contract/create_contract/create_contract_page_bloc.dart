import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_home_stair/components/color_styles.dart';
import 'package:my_home_stair/dto/request/contract/contract_request.dart';
import 'package:my_home_stair/dto/request/contract/join_contract_request.dart';
import 'package:my_home_stair/dto/response/contract/contract_role.dart';
import 'package:my_home_stair/presentation/home/home_page.dart';
import 'package:my_home_stair/presentation/home/home_page_bloc.dart';
import 'package:my_home_stair/presentation/login/login_page.dart';
import 'package:my_home_stair/repository/contract_repository.dart';
import 'package:my_home_stair/repository/shared_preferences_repository.dart';

class CreateContractPageBloc
    extends Bloc<CreateContractPageEvent, CreateContractPageState> {
  final BuildContext _context;
  final ContractRepository _contractRepository;
  final SharedPreferencesRepository _sharedPreferencesRepository;

  CreateContractPageBloc(
    this._context,
    this._contractRepository,
    this._sharedPreferencesRepository,
  ) : super(const CreateContractPageState()) {
    on<NextButtonClickEvent>(_onNextButtonClicked);
    on<BackEvent>(_onBack);
    on<SelectIsNewContractEvent>(_isNewContractSelected);
    on<SelectContractRoleEvent>(_selectContractRole);
    on<SelectAddressEvent>(_selectAddress);
    on<SelectAddressDetailEvent>(_selectAddressDetail);
    on<SelectJoinCodeEvent>(_selectJoinCode);
  }

  Future<void> _onNextButtonClicked(
      NextButtonClickEvent event, Emitter<CreateContractPageState> emit) async {
    var tokenResponse = await _sharedPreferencesRepository.getTokenResponse();

    if (tokenResponse == null) {
      if (!_context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          _context, LoginPage.route, (route) => false);
      return;
    }

    switch (state.pageIndex) {
      case 0:
        emit(state.copy(pageIndex: 1, buttonText: '다음'));
        break;
      case 1:
        if (state.isContractNew) {
          emit(state.copy(pageIndex: 2, buttonText: '다음'));
        } else {
          emit(state.copy(pageIndex: 4, buttonText: '완료'));
        }
        break;
      case 2:
        if (state.address.isEmpty) {
          _showToast('주소를 입력해주세요.');
          return;
        }
        emit(state.copy(pageIndex: 3, buttonText: '완료'));
        break;
      case 3:
        if (state.addressDetail.isEmpty) {
          _showToast('상세주소를 입력해주세요.');
          return;
        }

        if (state.isLoading) {
          return;
        }

        emit(state.copy(isLoading: true));

        try {
          await _contractRepository.createContract(
            tokenResponse.accessToken,
            ContractRequest(
              address: state.address,
              addressDetail: state.addressDetail,
              contractRole: state.contractRole,
            ),
          );
          if (!_context.mounted) {
            throw Exception('Context is not mounted');
          } else {
            emit(state.copy(isLoading: false));
            Navigator.pushNamedAndRemoveUntil(
                _context, HomePage.route, (route) => false);
          }
        } catch (e) {
          _showToast('계약을 생성하는데 실패했습니다.');
          emit(state.copy(isLoading: false));
          return;
        }
        break;
      case 4:
        if (state.isLoading) {
          return;
        }

        emit(state.copy(isLoading: true));

        try {
          await _contractRepository.joinContract(
            tokenResponse.accessToken,
            JoinContractRequest(
              contractId: state.joinCode,
              contractRole: state.contractRole,
            ),
          );
          if (!_context.mounted) {
            throw Exception('Context is not mounted');
          } else {
            emit(state.copy(isLoading: false));
            Navigator.pushNamedAndRemoveUntil(
                _context, HomePage.route, (route) => false);
          }
        } catch (e) {
          _showToast('코드를 다시 확인해주세요.');
          emit(state.copy(isLoading: false));
          return;
        }
        break;
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      textColor: ColorStyles.primaryColor,
      backgroundColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  Future<void> _onBack(
      BackEvent event, Emitter<CreateContractPageState> emit) async {
    switch (state.pageIndex) {
      case 0:
        Navigator.pop(_context);
      case 1:
        emit(state.copy(pageIndex: 0, buttonText: '다음'));
        break;
      case 2:
        emit(state.copy(pageIndex: 1, buttonText: '다음'));
        break;
      case 3:
        emit(state.copy(pageIndex: 2, buttonText: '다음'));
        break;
      case 4:
        emit(state.copy(pageIndex: 1, buttonText: '다음'));
        break;
    }
  }

  Future<void> _isNewContractSelected(SelectIsNewContractEvent event,
      Emitter<CreateContractPageState> emit) async {
    emit(state.copy(isContractNew: event.isNewContract));
  }

  Future<void> _selectContractRole(SelectContractRoleEvent event,
      Emitter<CreateContractPageState> emit) async {
    emit(state.copy(contractRole: event.contractRole));
  }

  Future<void> _selectAddress(
      SelectAddressEvent event, Emitter<CreateContractPageState> emit) async {
    emit(state.copy(address: event.address));
  }

  Future<void> _selectAddressDetail(SelectAddressDetailEvent event,
      Emitter<CreateContractPageState> emit) async {
    emit(state.copy(addressDetail: event.addressDetail));
  }

  Future<void> _selectJoinCode(
      SelectJoinCodeEvent event, Emitter<CreateContractPageState> emit) async {
    emit(state.copy(joinCode: event.joinCode));
  }
}

sealed class CreateContractPageEvent {}

class NextButtonClickEvent extends CreateContractPageEvent {}

class BackEvent extends CreateContractPageEvent {}

class SelectIsNewContractEvent extends CreateContractPageEvent {
  final bool isNewContract;

  SelectIsNewContractEvent(this.isNewContract);
}

class SelectContractRoleEvent extends CreateContractPageEvent {
  final ContractRole contractRole;

  SelectContractRoleEvent(this.contractRole);
}

class SelectAddressEvent extends CreateContractPageEvent {
  final String address;

  SelectAddressEvent(this.address);
}

class SelectAddressDetailEvent extends CreateContractPageEvent {
  final String addressDetail;

  SelectAddressDetailEvent(this.addressDetail);
}

class SelectJoinCodeEvent extends CreateContractPageEvent {
  final String joinCode;

  SelectJoinCodeEvent(this.joinCode);
}

class CreateContractPageState extends Equatable {
  final bool isContractNew;
  final ContractRole contractRole;
  final int pageIndex;
  final String address;
  final String addressDetail;
  final String buttonText;
  final String joinCode;
  final bool isLoading;

  const CreateContractPageState({
    this.isContractNew = true,
    this.contractRole = ContractRole.lessee,
    this.pageIndex = 0,
    this.address = '',
    this.addressDetail = '',
    this.buttonText = '다음',
    this.joinCode = '',
    this.isLoading = false,
  });

  CreateContractPageState copy({
    bool? isContractNew,
    ContractRole? contractRole,
    int? pageIndex,
    String? address,
    String? addressDetail,
    String? buttonText,
    String? joinCode,
    bool? isLoading,
  }) {
    return CreateContractPageState(
      isContractNew: isContractNew ?? this.isContractNew,
      contractRole: contractRole ?? this.contractRole,
      pageIndex: pageIndex ?? this.pageIndex,
      address: address ?? this.address,
      addressDetail: addressDetail ?? this.addressDetail,
      buttonText: buttonText ?? this.buttonText,
      joinCode: joinCode ?? this.joinCode,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        isContractNew,
        contractRole,
        pageIndex,
        address,
        addressDetail,
        buttonText,
        joinCode,
        isLoading,
      ];
}

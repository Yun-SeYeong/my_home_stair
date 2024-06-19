import 'dart:collection';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_home_stair/dto/request/contract/contract_history_input_text_request.dart';
import 'package:my_home_stair/dto/response/auth/token_response.dart';
import 'package:my_home_stair/dto/response/contract/contract_detail_response.dart';
import 'package:my_home_stair/presentation/login/login_page.dart';
import 'package:my_home_stair/repository/contract_repository.dart';
import 'package:my_home_stair/repository/shared_preferences_repository.dart';
import 'package:web_socket_client/web_socket_client.dart';

class ContractDetailPageBloc
    extends Bloc<ContractDetailPageEvent, ContractDetailPageState> {
  final BuildContext _context;
  final SharedPreferencesRepository _sharedPreferencesRepository;
  final ContractRepository _contractRepository;

  ContractDetailPageBloc(
    this._context,
    this._sharedPreferencesRepository,
    this._contractRepository,
  ) : super(const ContractDetailPageState()) {
    on<InitStateEvent>(_initStateEvent);
    on<ContractHistoryCheckEvent>(_contractHistoryCheck);
    on<ContractHistoryUploadFileEvent>(_contractHistoryFileUpload);
    on<ContractHistoryInputTextEvent>(_contractHistoryInputText);
    on<ContractHistoryInputTextChangedEvent>(
        _onContractHistoryInputTextChanged);
    on<DisposeEvent>(_disposeEvent);
    on<RefreshEvent>(_refreshEvent);
  }

  Future<void> _refreshEvent(
    RefreshEvent event,
    Emitter<ContractDetailPageState> emit,
  ) async {
    var tokenResponse = await _sharedPreferencesRepository.getTokenResponse();

    if (tokenResponse == null) {
      if (!_context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          _context, LoginPage.route, (route) => false);
      return;
    }

    emit(state.copy(isLoading: true));
    try {
      final contractDetailResponse = await _contractRepository.getContract(
          tokenResponse.accessToken, event.contractId);
      emit(state.copy(
        contractDetail: contractDetailResponse,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copy(isLoading: false));
    }
  }

  Future<void> _initStateEvent(
    InitStateEvent event,
    Emitter<ContractDetailPageState> emit,
  ) async {
    var tokenResponse = await _sharedPreferencesRepository.getTokenResponse();

    if (tokenResponse == null) {
      if (!_context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          _context, LoginPage.route, (route) => false);
      return;
    }

    var webSocket = WebSocket(
      Uri.parse('ws://192.168.45.21:8080/contract-event/${event.contractId}'),
      headers: {'Authorization': tokenResponse.accessToken},
    )..messages.listen((message) {
        add(RefreshEvent(event.contractId));
      });

    await webSocket.connection.firstWhere((state) => state is Connected);

    add(RefreshEvent(event.contractId));
  }

  Future<void> _disposeEvent(
    DisposeEvent event,
    Emitter<ContractDetailPageState> emit,
  ) async {
    final webSocket = state.webSocket;
    if (webSocket != null) {
      webSocket.close();
    }
    emit(state.copy(webSocket: null));
  }

  Future<void> _contractHistoryCheck(
    ContractHistoryCheckEvent event,
    Emitter<ContractDetailPageState> emit,
  ) async {
    var tokenResponse = await _sharedPreferencesRepository.getTokenResponse();

    if (tokenResponse == null) {
      if (!_context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          _context, LoginPage.route, (route) => false);
      return;
    }

    final contractDetail = state.contractDetail;

    if (contractDetail == null) return;

    emit(state.copy(isLoading: true));

    await _contractRepository.contractHistoryCheck(
      tokenResponse.accessToken,
      contractDetail.id,
      event.historyId,
    );

    emit(state.copy(isLoading: false));
  }

  Future<void> _contractHistoryFileUpload(
    ContractHistoryUploadFileEvent event,
    Emitter<ContractDetailPageState> emit,
  ) async {
    final contractDetail = state.contractDetail;
    if (contractDetail == null) return;

    var pickerResult =
        await FilePicker.platform.pickFiles(allowMultiple: false);

    if (pickerResult == null) return;

    var tokenResponse = await _sharedPreferencesRepository.getTokenResponse();

    if (tokenResponse == null) {
      if (!_context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          _context, LoginPage.route, (route) => false);
      return;
    }

    emit(state.copy(isLoading: true));

    await _contractRepository.contractHistoryUploadFile(
      tokenResponse.accessToken,
      contractDetail.id,
      event.historyId,
      File(pickerResult.paths[0]!),
    );

    emit(state.copy(isLoading: false));
  }

  Future<void> _contractHistoryInputText(
    ContractHistoryInputTextEvent event,
    Emitter<ContractDetailPageState> emit,
  ) async {
    final contractDetail = state.contractDetail;
    if (contractDetail == null) return;

    var tokenResponse = await _sharedPreferencesRepository.getTokenResponse();

    if (tokenResponse == null) {
      if (!_context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          _context, LoginPage.route, (route) => false);
      return;
    }

    emit(state.copy(isLoading: true));

    await _contractRepository.contractHistoryInputText(
      tokenResponse.accessToken,
      contractDetail.id,
      event.historyId,
      ContractHistoryInputTextRequest(
        state.historyInputTextMap[event.historyId] ?? '',
      ),
    );

    emit(state.copy(isLoading: false));
  }

  Future<void> _onContractHistoryInputTextChanged(
    ContractHistoryInputTextChangedEvent event,
    Emitter<ContractDetailPageState> emit,
  ) async {
    print('event.text: ${event.text}');
    final historyInputTextMap = LinkedHashMap.of(state.historyInputTextMap);
    historyInputTextMap[event.historyId] = event.text;

    emit(state.copy(historyInputTextMap: historyInputTextMap));
  }
}

sealed class ContractDetailPageEvent {}

class RefreshEvent extends ContractDetailPageEvent {
  final String contractId;

  RefreshEvent(this.contractId);
}

class InitStateEvent extends ContractDetailPageEvent {
  final String contractId;

  InitStateEvent(this.contractId);
}
class DisposeEvent extends ContractDetailPageEvent {}

class ContractHistoryCheckEvent extends ContractDetailPageEvent {
  final String historyId;

  ContractHistoryCheckEvent(this.historyId);
}

class ContractHistoryUploadFileEvent extends ContractDetailPageEvent {
  final String historyId;

  ContractHistoryUploadFileEvent(this.historyId);
}

class ContractHistoryInputTextEvent extends ContractDetailPageEvent {
  final String historyId;

  ContractHistoryInputTextEvent(this.historyId);
}

class ContractHistoryInputTextChangedEvent extends ContractDetailPageEvent {
  final String historyId;
  final String text;

  ContractHistoryInputTextChangedEvent(this.text, this.historyId);
}

class ContractDetailPageState extends Equatable {
  final ContractDetailResponse? contractDetail;
  final bool isLoading;
  final Map<String, String> historyInputTextMap;
  final WebSocket? webSocket;

  const ContractDetailPageState({
    this.contractDetail,
    this.isLoading = false,
    this.historyInputTextMap = const {},
    this.webSocket,
  });

  ContractDetailPageState copy({
    ContractDetailResponse? contractDetail,
    bool? isLoading,
    Map<String, String>? historyInputTextMap,
    WebSocket? webSocket,
  }) {
    return ContractDetailPageState(
      contractDetail: contractDetail ?? this.contractDetail,
      isLoading: isLoading ?? this.isLoading,
      historyInputTextMap: historyInputTextMap ?? this.historyInputTextMap,
      webSocket: webSocket ?? this.webSocket,
    );
  }

  @override
  List<Object?> get props =>
      [contractDetail, isLoading, ...historyInputTextMap.values];
}

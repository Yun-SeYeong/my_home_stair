import 'dart:collection';
import 'dart:io';
import 'package:downloadsfolder/downloadsfolder.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_home_stair/components/color_styles.dart';
import 'package:my_home_stair/dto/request/contract/contract_history_input_text_request.dart';
import 'package:my_home_stair/dto/response/auth/token_response.dart';
import 'package:my_home_stair/dto/response/contract/contract_detail_response.dart';
import 'package:my_home_stair/my_home_stair.dart';
import 'package:my_home_stair/presentation/login/login_page.dart';
import 'package:my_home_stair/repository/contract_repository.dart';
import 'package:my_home_stair/repository/file_download_repository.dart';
import 'package:my_home_stair/repository/shared_preferences_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_socket_client/web_socket_client.dart';

class ContractDetailPageBloc
    extends Bloc<ContractDetailPageEvent, ContractDetailPageState> {
  final BuildContext _context;
  final SharedPreferencesRepository _sharedPreferencesRepository;
  final ContractRepository _contractRepository;
  final FileRepository _fileRepository;

  ContractDetailPageBloc(
    this._context,
    this._sharedPreferencesRepository,
    this._contractRepository,
    this._fileRepository,
  ) : super(const ContractDetailPageState()) {
    on<InitStateEvent>(_initStateEvent);
    on<ContractHistoryCheckEvent>(_contractHistoryCheck);
    on<ContractHistoryUploadFileEvent>(_contractHistoryFileUpload);
    on<ContractHistoryInputTextEvent>(_contractHistoryInputText);
    on<ContractHistoryInputTextChangedEvent>(
        _onContractHistoryInputTextChanged);
    on<DisposeEvent>(_disposeEvent);
    on<RefreshEvent>(_refreshEvent);
    on<DownloadFileEvent>(_downloadFileEvent);
    on<SetClipboardEvent>(_setClipboardEvent);
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
      Uri.parse('ws://$serverHost/contract-event/${event.contractId}'),
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

  Future<void> _downloadFileEvent(
    DownloadFileEvent event,
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

    try {
      await _fileRepository.downloadFile(
          tokenResponse.accessToken,
          contractDetail.id,
          event.historyId,
          (await getDownloadDirectory()).path);
    } catch (e) {
      print(e);
    }

    emit(state.copy(isLoading: false));
  }

  Future<void> _setClipboardEvent(
    SetClipboardEvent event,
    Emitter<ContractDetailPageState> emit,
  ) async {
    await Clipboard.setData(ClipboardData(text: event.text));
    _showToast("복사 되었습니다.");
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

class DownloadFileEvent extends ContractDetailPageEvent {
  final String historyId;

  DownloadFileEvent(this.historyId);
}

class SetClipboardEvent extends ContractDetailPageEvent {
  final String text;

  SetClipboardEvent(this.text);
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

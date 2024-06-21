import 'dart:collection';

import 'package:downloadsfolder/downloadsfolder.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_home_stair/components/color_styles.dart';
import 'package:my_home_stair/dto/response/contract/archive_file_response.dart';
import 'package:my_home_stair/dto/response/contract/contract_response.dart';
import 'package:my_home_stair/presentation/contract/contract_detail/contract_detail_page.dart';
import 'package:my_home_stair/presentation/login/login_page.dart';
import 'package:my_home_stair/repository/contract_repository.dart';
import 'package:my_home_stair/repository/file_download_repository.dart';
import 'package:my_home_stair/repository/shared_preferences_repository.dart';
import 'package:stream_transform/stream_transform.dart';

import 'home_page.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final BuildContext _context;
  final ContractRepository _contractRepository;
  final SharedPreferencesRepository _sharedPreferencesRepository;
  final FileRepository _fileRepository;
  final int defaultSize = 10;

  HomePageBloc(
    this._context,
    this._contractRepository,
    this._sharedPreferencesRepository,
    this._fileRepository,
  ) : super(const HomePageState()) {
    on<SelectBottomNavigationEvent>(_onSelectBottomNavigationEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<InitStateEvent>(_initStateEvent);
    on<LoadMoreContractsEvent>(_loadMoreContractsEvent);
    on<LoadContractDetailEvent>(_loadContractDetailEvent);
    on<SetClipboardEvent>(_setClipboardEvent);
    on<KeywordChangedEvent>(_keywordChangedEvent,
        transformer: (events, mapper) {
      return events
          .debounce(const Duration(milliseconds: 10))
          .switchMap(mapper);
    });
    on<DownloadArchiveFileEvent>(_downloadArchiveFileEvent);
  }

  Future<void> _initStateEvent(
    InitStateEvent event,
    Emitter<HomePageState> emit,
  ) async {
    var tokenResponse = await _sharedPreferencesRepository.getTokenResponse();

    if (tokenResponse == null) {
      if (!_context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          _context, LoginPage.route, (route) => false);
      return;
    }

    emit(state.copy(isLoading: true, contracts: {}));

    try {
      final contractsResponse = await _contractRepository.getContracts(
          tokenResponse.accessToken, 0, defaultSize);

      emit(state.copy(
        contracts: contractsResponse.content.toSet(),
        isLoading: false,
        page: contractsResponse.pageable.pageNumber,
      ));
    } catch (e) {
      emit(state.copy(isLoading: false));
    }
  }

  void _onSelectBottomNavigationEvent(
    SelectBottomNavigationEvent event,
    Emitter<HomePageState> emit,
  ) {
    emit(state.copy(selectedTab: event.tab));
  }

  void _onLogoutEvent(
    LogoutEvent event,
    Emitter<HomePageState> emit,
  ) {
    _sharedPreferencesRepository.deleteTokenResponse();

    Navigator.pushNamedAndRemoveUntil(
        _context, LoginPage.route, (route) => false);
  }

  Future<void> _loadMoreContractsEvent(
    LoadMoreContractsEvent event,
    Emitter<HomePageState> emit,
  ) async {
    if (state.contracts.length < defaultSize) return;

    final tokenResponse = await _sharedPreferencesRepository.getTokenResponse();

    if (tokenResponse == null) {
      if (!_context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          _context, LoginPage.route, (route) => false);
      return;
    }

    emit(state.copy(isLoading: true));

    try {
      await _contractRepository
          .getContracts(tokenResponse.accessToken, state.page + 1, defaultSize)
          .then((contractsResponse) {
        emit(state.copy(
            contracts: state.contracts.union(contractsResponse.content.toSet()),
            page: contractsResponse.content.length < defaultSize
                ? state.page
                : contractsResponse.pageable.pageNumber,
            isLoading: false));
      });
    } catch (e) {
      emit(state.copy(isLoading: false));
    }
  }

  Future<void> _loadContractDetailEvent(
    LoadContractDetailEvent event,
    Emitter<HomePageState> emit,
  ) async {
    Navigator.pushNamed(_context, ContractDetailPage.route,
        arguments: event.contractId);
  }

  Future<void> _setClipboardEvent(
    SetClipboardEvent event,
    Emitter<HomePageState> emit,
  ) async {
    await Clipboard.setData(ClipboardData(text: event.text));
    _showToast("초대 코드가 복사 되었습니다.");
  }

  Future<void> _keywordChangedEvent(
    KeywordChangedEvent event,
    Emitter<HomePageState> emit,
  ) async {
    if (event.keyword.isEmpty) {
      emit(state.copy(archiveFileResponse: [], isLoading: false));
      return;
    }

    final tokenResponse = await _sharedPreferencesRepository.getTokenResponse();

    if (tokenResponse == null) {
      if (!_context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          _context, LoginPage.route, (route) => false);
      return;
    }

    emit(state.copy(isLoading: true));

    try {
      var response = await _contractRepository.getContractFileHistories(
        tokenResponse.accessToken,
        event.keyword,
      );
      emit(state.copy(
        archiveFileResponse: response.content,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copy(isLoading: false));
      return;
    }
  }

  Future<void> _downloadArchiveFileEvent(
    DownloadArchiveFileEvent event,
    Emitter<HomePageState> emit,
  ) async {
    final tokenResponse = await _sharedPreferencesRepository.getTokenResponse();

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
        event.contractId,
        event.historyId,
        (await getDownloadDirectory()).path,
      );
      _showToast('다운로드가 완료되었습니다.');
      emit(state.copy(isLoading: false));
    } catch (e) {
      _showToast('다운로드에 실패했습니다.');
      emit(state.copy(isLoading: false));
    }
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

sealed class HomePageEvent {}

class LogoutEvent extends HomePageEvent {}

class SelectBottomNavigationEvent extends HomePageEvent {
  final HomeTab tab;

  SelectBottomNavigationEvent(this.tab);
}

class InitStateEvent extends HomePageEvent {}

class LoadMoreContractsEvent extends HomePageEvent {}

class LoadContractDetailEvent extends HomePageEvent {
  final String contractId;

  LoadContractDetailEvent(this.contractId);
}

class SetClipboardEvent extends HomePageEvent {
  final String text;

  SetClipboardEvent(this.text);
}

class KeywordChangedEvent extends HomePageEvent {
  final String keyword;

  KeywordChangedEvent(this.keyword);
}

class DownloadArchiveFileEvent extends HomePageEvent {
  final String contractId;
  final String historyId;

  DownloadArchiveFileEvent(this.contractId, this.historyId);
}

class HomePageState extends Equatable {
  final HomeTab selectedTab;
  final Set<ContractResponse> contracts;
  final List<ArchiveFileResponse> archiveFileResponse;
  final int page;
  final bool isLoading;

  const HomePageState({
    this.selectedTab = HomeTab.home,
    this.contracts = const {},
    this.archiveFileResponse = const [],
    this.page = 0,
    this.isLoading = false,
  });

  HomePageState copy(
      {HomeTab? selectedTab,
      Set<ContractResponse>? contracts,
      List<ArchiveFileResponse>? archiveFileResponse,
      int? page,
      bool? isLoading}) {
    return HomePageState(
      selectedTab: selectedTab ?? this.selectedTab,
      contracts: contracts ?? this.contracts,
      archiveFileResponse: archiveFileResponse ?? this.archiveFileResponse,
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        selectedTab,
        ...contracts,
        page,
        isLoading,
        ...archiveFileResponse,
      ];
}

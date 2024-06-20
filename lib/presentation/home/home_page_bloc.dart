import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_home_stair/components/color_styles.dart';
import 'package:my_home_stair/dto/response/contract/contract_response.dart';
import 'package:my_home_stair/presentation/contract/contract_detail/contract_detail_page.dart';
import 'package:my_home_stair/presentation/login/login_page.dart';
import 'package:my_home_stair/repository/contract_repository.dart';
import 'package:my_home_stair/repository/shared_preferences_repository.dart';

import 'home_page.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final BuildContext _context;
  final ContractRepository _contractRepository;
  final SharedPreferencesRepository _sharedPreferencesRepository;
  final int defaultSize = 10;

  HomePageBloc(
    this._context,
    this._contractRepository,
    this._sharedPreferencesRepository,
  ) : super(const HomePageState()) {
    on<SelectBottomNavigationEvent>(_onSelectBottomNavigationEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<InitStateEvent>(_initStateEvent);
    on<LoadMoreContractsEvent>(_loadMoreContractsEvent);
    on<LoadContractDetailEvent>(_loadContractDetailEvent);
    on<SetClipboardEvent>(_setClipboardEvent);
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

class HomePageState extends Equatable {
  final HomeTab selectedTab;
  final Set<ContractResponse> contracts;
  final int page;
  final bool isLoading;

  const HomePageState({
    this.selectedTab = HomeTab.home,
    this.contracts = const {},
    this.page = 0,
    this.isLoading = false,
  });

  HomePageState copy({
    HomeTab? selectedTab,
    Set<ContractResponse>? contracts,
    int? page,
    bool? isLoading,
  }) {
    return HomePageState(
      selectedTab: selectedTab ?? this.selectedTab,
      contracts: contracts ?? this.contracts,
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [selectedTab, ...contracts, page, isLoading];
}

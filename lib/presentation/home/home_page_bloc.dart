import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_home_stair/dto/response/contract/contract_response.dart';
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
  }

  Future<void> _initStateEvent(
      InitStateEvent event, Emitter<HomePageState> emit) async {
    var tokenResponse = await _sharedPreferencesRepository.getTokenResponse();

    if (tokenResponse == null) {
      if (!_context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          _context, LoginPage.route, (route) => false);
      return;
    }

    emit(state.copy(isLoading: true));

    final contractsResponse = await _contractRepository
        .getContracts(
      tokenResponse.accessToken,
      state.page,
      defaultSize,
    )
        .catchError((error) {
      emit(state.copy(isLoading: false));
      return error;
    });

    emit(state.copy(
      contracts: contractsResponse.content.toSet(),
      isLoading: false,
      page: contractsResponse.pageable.pageNumber,
    ));
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
    Navigator.pushNamedAndRemoveUntil(
        _context, LoginPage.route, (route) => false);
  }

  Future<void> _loadMoreContractsEvent(
    LoadMoreContractsEvent event,
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
    await _contractRepository
        .getContracts(
      tokenResponse.accessToken,
      state.page + 1,
      defaultSize,
    )
    .then((contractsResponse) {
      emit(state.copy(
        contracts: state.contracts.union(contractsResponse.content.toSet()),
        page: contractsResponse.content.length < defaultSize
            ? state.page
            : contractsResponse.pageable.pageNumber,
        isLoading: false,
      ));
    })
        .catchError((error) {
      emit(state.copy(isLoading: false));
      return error;
    });
  }
}

sealed class HomePageEvent {}

class LogoutEvent extends HomePageEvent {}

class SelectBottomNavigationEvent extends HomePageEvent {
  final HomeTab tab;

  SelectBottomNavigationEvent(this.tab);
}

class InitStateEvent extends HomePageEvent {}

class LoadMoreContractsEvent extends HomePageEvent {}

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

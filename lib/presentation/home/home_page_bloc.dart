import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_home_stair/presentation/login/login_page.dart';

import 'home_page.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final BuildContext context;

  HomePageBloc(this.context) : super(const HomePageState()) {
    on<SelectBottomNavigationEvent>(_onSelectBottomNavigationEvent);
    on<LogoutEvent>(_onLogoutEvent);
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
    Navigator.pushNamedAndRemoveUntil(context, LoginPage.route, (route) => false);
  }
}

sealed class HomePageEvent {}

class LogoutEvent extends HomePageEvent {}

class SelectBottomNavigationEvent extends HomePageEvent {
  final HomeTab tab;

  SelectBottomNavigationEvent(this.tab);
}

class HomePageState extends Equatable {
  final HomeTab selectedTab;

  const HomePageState({
    this.selectedTab = HomeTab.home,
  });

  HomePageState copy({
    HomeTab? selectedTab,
  }) {
    return HomePageState(
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }

  @override
  List<Object?> get props => [selectedTab];
}

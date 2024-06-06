import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_home_stair/components/color_styles.dart';
import 'package:my_home_stair/presentation/home/home_page.dart';
import 'package:my_home_stair/presentation/home/home_page_bloc.dart';
import 'package:my_home_stair/repository/auth_repository.dart';
import 'package:my_home_stair/repository/shared_preferences_repository.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'presentation/login/login_bloc.dart';
import 'presentation/login/login_page.dart';
import 'presentation/signup/sign_up_bloc.dart';
import 'presentation/signup/sign_up_page.dart';
import 'presentation/splash/splash_page.dart';
import 'presentation/splash/splash_page_bloc.dart';

final getIt = GetIt.instance;

void main() {
  // Dio 초기화
  getIt.registerSingleton<Dio>(Dio(
    BaseOptions(
      baseUrl: 'http://140.238.15.22:9000',
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  ));
  // Repository 초기화
  getIt.registerSingleton(AuthRepository(getIt<Dio>()));
  getIt.registerSingleton(SharedPreferencesRepository());
  // Bloc 초가화
  getIt.registerSingleton(LoginBloc(
    getIt<AuthRepository>(),
    getIt<SharedPreferencesRepository>(),
  ));
  getIt.registerSingleton(SignUpBloc(getIt<AuthRepository>()));
  getIt.registerSingleton(SplashPageBloc(
    getIt<AuthRepository>(),
    getIt<SharedPreferencesRepository>(),
  ));
  getIt.registerSingleton(HomePageBloc());

  runApp(const MyHomeStair());
}

class MyHomeStair extends StatelessWidget {
  const MyHomeStair({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<LoginBloc>()),
        BlocProvider(create: (context) => getIt<SignUpBloc>()),
        BlocProvider(create: (context) => getIt<SplashPageBloc>()),
        BlocProvider(create: (context) => getIt<HomePageBloc>()),
      ],
      child: MaterialApp(
          theme: ThemeData(
            primaryColor: ColorStyles.primaryColor,
            fontFamily: "Pretendard",
          ),
          initialRoute: SplashPage.route,
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case SplashPage.route:
                return _fadeTransition(const SplashPage());
              case LoginPage.route:
                return _fadeTransition(const LoginPage());
              case SignUpPage.route:
                return _fadeTransition(const SignUpPage());
              case HomePage.route:
                return _fadeTransition(const HomePage());
              default:
                return _fadeTransition(const SplashPage());
            }
          }),
    );
  }

  PageTransition<dynamic> _fadeTransition(Widget widget) {
    return PageTransition(
      child: widget,
      type: PageTransitionType.fade,
      duration: const Duration(milliseconds: 200),
    );
  }
}

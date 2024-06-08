import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_home_stair/components/color_styles.dart';
import 'package:my_home_stair/presentation/home/home_page.dart';
import 'package:my_home_stair/presentation/home/home_page_bloc.dart';
import 'package:my_home_stair/repository/auth_repository.dart';
import 'package:my_home_stair/repository/shared_preferences_repository.dart';
import 'package:nested/nested.dart';
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
  _dependencyInjection();
  runApp(const MyHomeStair());
}

class MyHomeStair extends StatefulWidget {
  const MyHomeStair({super.key});

  @override
  State<MyHomeStair> createState() => _MyHomeStairState();
}

class _MyHomeStairState extends State<MyHomeStair> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: ColorStyles.primaryColor,
          fontFamily: 'Pretendard',
        ),
        initialRoute: SplashPage.route,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case SplashPage.route:
              return _fadeTransition(_blocProvider(const SplashPage()));
            case LoginPage.route:
              return _fadeTransition(_blocProvider(const LoginPage()));
            case SignUpPage.route:
              return _fadeTransition(_blocProvider(const SignUpPage()));
            case HomePage.route:
              return _fadeTransition(_blocProvider(const HomePage()));
            default:
              return _fadeTransition(_blocProvider(const SplashPage()));
          }
        });
  }

  PageTransition<dynamic> _fadeTransition(Widget widget) {
    return PageTransition(
      child: widget,
      type: PageTransitionType.fade,
      duration: const Duration(milliseconds: 200),
    );
  }

  SingleChildWidget _blocProvider(Widget widget) {
    return MultiBlocProvider(
      providers: getIt.get<List<SingleChildWidget>>(instanceName: 'blocs'),
      child: widget,
    );
  }
}

List<SingleChildWidget> _initBlocs() {
  return [
    BlocProvider(
      create: (context) => LoginBloc(
        context,
        getIt<AuthRepository>(),
        getIt<SharedPreferencesRepository>(),
      ),
    ),
    BlocProvider(create: (context) => SignUpBloc(context, getIt<AuthRepository>())),
    BlocProvider(
      create: (context) => SplashPageBloc(
        context,
        getIt<AuthRepository>(),
        getIt<SharedPreferencesRepository>(),
      ),
    ),
    BlocProvider(create: (context) => HomePageBloc(context)),
  ];
}

void _dependencyInjection() {
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
  getIt.registerSingleton(_initBlocs(), instanceName: 'blocs');
}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_home_stair/presentation/splash/splash_page_bloc.dart';

class SplashPage extends StatefulWidget {
  static const route = "SplashPage";
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    _setTimer(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SvgPicture.asset(
            'images/My_House_Stair_Logo.svg',
            height: 120,
          )
      ),
    );
  }

  void _setTimer(BuildContext context) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      timer.cancel();
      context.read<SplashPageBloc>().add((LoadSplashPageEvent()));
    });
  }
}
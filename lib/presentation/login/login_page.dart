import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_home_stair/components/color_styles.dart';
import 'package:my_home_stair/components/my_house_stair_button.dart';
import 'package:my_home_stair/presentation/login/login_bloc.dart';
import 'package:my_home_stair/presentation/signup/sign_up_page.dart';

class LoginPage extends StatefulWidget {
  static const route = "LoginPage";

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;
    final uiState = context.watch<LoginBloc>().state;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding:
            EdgeInsets.symmetric(vertical: statusBarHeight, horizontal: 40),
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Text(
              '우리집계단',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            const Text('안심 전세 계약 플랫폼 우리집 전세 계약 단계',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: ColorStyles.greyColor,
                )),
            const SizedBox(height: 30),
            TextField(
              enabled: !uiState.isLoading,
              onChanged: (text) {
                context.read<LoginBloc>().add(UpdateEmailEvent(text));
              },
              decoration: InputDecoration(
                label: const Text('이메일'),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: ColorStyles.primaryColor, width: 1.5),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: ColorStyles.primaryColor, width: 1.5),
                ),
                enabled: true,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                error: uiState.isError ? _errorTextWidget('이메일을 확인해주세요') : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              enabled: !uiState.isLoading,
              obscureText: true,
              onChanged: (text) {
                context.read<LoginBloc>().add(UpdatePasswordEvent(text));
              },
              decoration: InputDecoration(
                label: const Text('비밀번호'),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: ColorStyles.primaryColor, width: 1.5),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: ColorStyles.primaryColor, width: 1.5),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                error:
                    uiState.isError ? _errorTextWidget('비밀번호를 확인해주세요') : null,
              ),
            ),
            const SizedBox(height: 20),
            MyHouseStairButton(
              enabled: !uiState.isLoading,
              onPressed: () {
                context.read<LoginBloc>().add(SignInEvent());
              },
              text: '로그인',
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, SignUpPage.route);
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: const Text(
                '회원가입',
                style: TextStyle(
                  color: ColorStyles.greyColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 40),
            uiState.isLoading
                ? const CircularProgressIndicator(
                    color: ColorStyles.primaryColor,
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Widget _errorTextWidget(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.red,
      ),
    );
  }
}

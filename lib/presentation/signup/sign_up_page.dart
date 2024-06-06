import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_home_stair/components/color_styles.dart';
import 'package:my_home_stair/components/my_house_stair_button.dart';
import 'package:my_home_stair/presentation/signup/sign_up_bloc.dart';

class SignUpPage extends StatefulWidget {
  static const route = "SignUpPage";

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;
    final uiState = context.watch<SignUpBloc>().state;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding:
            EdgeInsets.symmetric(vertical: statusBarHeight, horizontal: 40),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: SvgPicture.asset(
                    'images/Expand_left.svg',
                    height: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36),
            const Text(
              '회원가입',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            const Text('Email과 Password를 입력하고 회원가입을 진행해주세요.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: ColorStyles.greyColor,
                )),
            const SizedBox(height: 30),
            TextField(
              enabled: !uiState.isLoading,
              onChanged: (text) {
                context.read<SignUpBloc>().add((UpdateEmailEvent(email: text)));
              },
              decoration: InputDecoration(
                label: const Text('이메일'),
                border: const OutlineInputBorder(),
                enabled: true,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                error: uiState.isEmailTextError
                    ? _errorTextWidget('이메일을 확인해주세요')
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              enabled: !uiState.isLoading,
              obscureText: true,
              onChanged: (text) {
                context.read<SignUpBloc>().add((UpdatePasswordEvent(password: text)));
              },
              decoration: InputDecoration(
                label: const Text('비밀번호'),
                border: const OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                error: uiState.isPasswordTextError
                    ? _errorTextWidget('비밀번호를 확인해주세요')
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              enabled: !uiState.isLoading,
              obscureText: true,
              onChanged: (text) {
                context.read<SignUpBloc>().add((UpdatePasswordConfirmEvent(passwordConfirm: text)));
              },
              decoration: InputDecoration(
                label: const Text('비밀번호 확인'),
                border: const OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                error: uiState.isPasswordConfirmTextError
                    ? _errorTextWidget('비밀번호가 틀립니다.')
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            MyHouseStairButton(
              enabled: !uiState.isLoading,
              onPressed: () {
                context.read<SignUpBloc>().add(SignUpEvent(onSuccess: () {
                  Navigator.pop(context);
                }));
              },
              text: '회원가입',
            ),
            const SizedBox(height: 20),
            uiState.isLoading ? const CircularProgressIndicator(
              color: ColorStyles.primaryColor,
            ) : const SizedBox()
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_home_stair/components/color_styles.dart';
import 'package:my_home_stair/components/my_settings.dart';
import 'package:my_home_stair/components/user_email.dart';
import 'package:my_home_stair/presentation/home/home_page_bloc.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorStyles.backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const UserEmailWidget(userEmail: 'test@tet.com'),
          const SizedBox(height: 20),
          MySettingsWidget(
              goNotice: () {},
              goLogout: () {
                context.read<HomePageBloc>().add(LogoutEvent());
              },
              goPolicy: () {},
              goAppver: () {})
        ],
      ),
    );
  }
}

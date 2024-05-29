import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MySettingsWidget extends StatelessWidget {
  const MySettingsWidget({Key? key}) : super(key: key);

  Widget _buildSettingItem(String text, String iconPath) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              iconPath,
              semanticsLabel: text,

            ),
            const SizedBox(width: 10), // 텍스트와 아이콘 사이의 간격
            Text(
              text,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
                color: Color(0xFF000000),
              ),
            ),
          ],
        ),
        SvgPicture.asset(
          'images/Expand_right.svg', // 우측에 위치한 공통 아이콘
          semanticsLabel: 'Expand_right',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 0),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '설정',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 10), // 설정 제목과 첫 항목 사이의 간격
          _buildSettingItem('알림 설정', 'images/Noti.svg'),
          const SizedBox(height: 10), // 항목 사이의 간격
          _buildSettingItem('로그아웃', 'images/Logout.svg'),
          const SizedBox(height: 10),
          _buildSettingItem('약관 및 정책', 'images/Policy.svg'),
          const SizedBox(height: 10),
          _buildSettingItem('앱 버전', 'images/AppVer.svg'),
        ],
      ),
    );
  }
}

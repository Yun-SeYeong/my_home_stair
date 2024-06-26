import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_home_stair/components/color_styles.dart';

class MySettingsWidget extends StatelessWidget {
  final Function goNotice;
  final Function goLogout;
  final Function goPolicy;
  final Function goAppver;

  const MySettingsWidget({
    super.key,
    required this.goNotice,
    required this.goLogout,
    required this.goPolicy,
    required this.goAppver,
  });

  Widget _buildSettingItem(String text, String iconPath, Function onTap) {
    return InkWell(
      onTap: () => onTap(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                iconPath,
                semanticsLabel: text,
              ),
              const SizedBox(width: 15), // 텍스트와 아이콘 사이의 간격
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
      ),
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
            color: Colors.black.withOpacity(0.05),
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
          const SizedBox(height: 20), // 설정 제목과 첫 항목 사이의 간격
          _buildSettingItem('알림 설정', 'images/Noti.svg', goNotice),
          const SizedBox(height: 15), // 항목 사이의 간격
          _buildSettingItem('약관 및 정책', 'images/Policy.svg', goPolicy),
          const SizedBox(height: 15),
          _buildSettingItem('로그아웃', 'images/Logout.svg', goLogout),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'images/AppVer.svg'
                  ),
                  const SizedBox(width: 15), // 텍스트와 아이콘 사이의 간격
                  const Text(
                    '앱 버전',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                      color: Color(0xFF000000),
                    ),
                  ),
                ],
              ),
              const Text(
                '1.0.0',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                  color: Color(0xFF000000),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

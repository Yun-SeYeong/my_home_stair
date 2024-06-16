import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActionIconWidget extends StatelessWidget {
  final String description;
  final String iconpath;
  final Function onButton;

  const ActionIconWidget({
    super.key,
    required this.description,
    required this.iconpath,
    required this.onButton(),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
      children: [
        Container(
          width: 99,
          height: 140,
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
          child: InkWell(
            onTap: () {
              onButton();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // 자식들을 가운데 정렬
              children: [
                SvgPicture.asset(
                  iconpath, // 우측에 위치한 공통 아이콘
                  semanticsLabel: 'Expand_right',
                ),
                const SizedBox(height: 13),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
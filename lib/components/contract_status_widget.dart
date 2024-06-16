import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class StatusBar extends StatelessWidget {
  final String label;
  final bool isActive;

  const StatusBar({
    Key? key,
    required this.label,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10.0,
            fontWeight: FontWeight.w700,
            color: isActive ? Color(0xFF0E2288) : Color(0xFF8B8B8B),
          ),
        ),
        const SizedBox(height: 4.0),
        CircleAvatar(
          radius: 5,
          backgroundColor: isActive ? Color(0xFF0E2288) : Color(0xFF8B8B8B),
        ),
      ],
    );
  }
}

class ContractStatusWidget extends StatelessWidget {
  final String title;
  final String statusNow;
  final String address;
  final Function onButton;

  const ContractStatusWidget({
    super.key,
    required this.title,
    required this.statusNow,
    required this.address,
    required this.onButton(),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // 그림자의 색상 및 투명도
            offset: const Offset(0, 0), // x: 0, y: 0
            blurRadius: 20, // blur 반경
            spreadRadius: 0, // spread 반경
          ),
        ],
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                          color: Color(0xFF0E2288)),
                    ),
                    const SizedBox(width: 12.0),
                    Container(
                      margin: const EdgeInsets.only(top: 4.0),
                      width: 48,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Color(0xFF0E2288),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          statusNow,
                          style: const TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                              color: Color(0xFFFFFFFF)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 200.0),
                    InkWell(
                      onTap: () {
                        onButton();
                      },
                      child: SvgPicture.asset(
                        'images/External.svg', // 우측에 위치한 공통 아이콘
                        semanticsLabel: 'Expand_right',
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 13.0),
                Text(address,
                    style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                        color: Color(0xFF8B8B8B)),
                ),
                const SizedBox(height: 30.0), // 위젯들과 상태바 사이의 간격
                Stack(
                  children: [
                    Positioned(
                      top: 22.5,
                      left: 10.0,
                      right: 15.0,
                      child: Container(
                        height: 1.0,
                        color: Color(0xFF0E2288),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatusBar(label: "방확인", isActive: statusNow == "방확인"? true:false),
                        const SizedBox(width: 48.0),
                        StatusBar(label: "가계약", isActive: statusNow == "가계약"? true:false),
                        const SizedBox(width: 48.0),
                        StatusBar(label: "실계약", isActive: statusNow == "실계약"? true:false),
                        const SizedBox(width: 48.0),
                        StatusBar(label: "계약완료", isActive: statusNow == "계약완료"? true:false),
                        const SizedBox(width: 48.0),
                        StatusBar(label: "계약만료", isActive: statusNow == "계약만료"? true:false),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ]),
    );
  }
}



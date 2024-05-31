import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserEmailWidget extends StatelessWidget {
  const UserEmailWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) { //test git
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // 그림자의 색상 및 투명도
            offset: const Offset(0, 0), // x: 0, y: 0
            blurRadius: 20, // blur 반경
            spreadRadius: 0, // spread 반경
          ),
        ],
      ),
      child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'test@test.com',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                      color: Color(0xFF000000),
      ),
                ),
              ], //children
            ),
          ]),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UploadFileItemWidget extends StatelessWidget {
  const UploadFileItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '등기부등본.pdf',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter'),
                ),
                Text(
                  '서울 서초구 신반포로 270 101호',
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      color: Color(0xFF8B8B8B)
                    )
                ),
                Text(
                  '2024.01.01 00:00:00',
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                        color: Color(0xFF8B8B8B)
                    )
                ),
              ],
            ),
            SvgPicture.asset(
              'images/download.svg',
              semanticsLabel: 'Download',
            ),
          ]),
    );
  }
}

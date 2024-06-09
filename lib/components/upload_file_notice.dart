import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UploadFileNoticeWidget extends StatelessWidget {
  final String title;
  final String address;
  final String description;
  final String date;

  const UploadFileNoticeWidget({
    super.key,
    required this.title,
    required this.address,
    required this.description,
    required this.date,
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
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter'),
                ),
                Text(address,
                    style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                        color: Color(0xFF8B8B8B))),
                Text(description,
                    style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                        color: Color(0xFF8B8B8B))),
              ],
            ),
            // InkWell(
            //   onTap: () {
            //     onDownload();
            //   },
            //   child: SvgPicture.asset(
            //     'images/download.svg',
            //     semanticsLabel: 'Download',
            //   ),
            // )
            Text(
              date, // 날짜 텍스트 추가
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
                color: Color(0xFF8B8B8B),
              ),
            ),
          ]),

    );
  }
}

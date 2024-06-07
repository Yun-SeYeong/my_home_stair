import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContractAccountNumberWidget extends StatelessWidget {
  final String title;
  final String accountnum;
  final Function onCopy;

  ContractAccountNumberWidget({
    super.key,
    required this.title,
    required this.accountnum,
    required this.onCopy,
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
                const SizedBox(height: 10.0),
                Text(accountnum,
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                        color: Color(0xFF0E2288))),

              ],
            ),
            InkWell(
              onTap: () {
                onCopy();
              },
              child: SvgPicture.asset(
                'images/Copy.svg',
                semanticsLabel: 'Copy',
              ),
            ),
          ]),
    );
  }
}

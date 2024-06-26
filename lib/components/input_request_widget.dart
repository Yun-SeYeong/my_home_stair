import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class InputRequestWidget extends StatelessWidget {
  final String title;
  final String description;
  final String buttonName;
  final Function onButton;
  final Function searchButton;

  InputRequestWidget({
    super.key,
    required this.title,
    required this.description,
    required this.buttonName,
    required this.onButton,
    required this.searchButton
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
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                    color: Color(0xFF8B8B8B),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: 343,
                  child: TextField(
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: '파일종류',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF0E2288),
                          width: 3,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF0E2288),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFF0E2288), // 테두리 컬러
                      width: 1, // 테두리 두께
                    ),
                    borderRadius: BorderRadius.circular(5), // 테두리 둥글기 설정
                    color: Colors.transparent, // 배경 투명 설정
                  ),
                  child: InkWell(
                    onTap: () {
                      searchButton();
                    },
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0), // 원하는 패딩 값을 설정하세요
                        child: Text(
                          "등기부등본",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                            color: Color(0xFF0E2288),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: 343,
                  child: TextField(
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: '요청사항',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF0E2288),
                          width: 3,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF0E2288),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: 343,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFF0E2288), // 테두리 컬러
                      width: 1, // 테두리 두께
                    ),
                    borderRadius: BorderRadius.circular(5), // 테두리 둥글기 설정
                    color: Colors.transparent, // 배경 투명 설정
                  ),
                  child: InkWell(
                    onTap: () {
                      onButton();
                    },
                    child: Center(
                      child: Text(
                        buttonName,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                          color: Color(0xFF0E2288),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
    );
  }
}

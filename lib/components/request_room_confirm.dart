import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RequestRoomConfirmWidget extends StatelessWidget {
  final Function onConfirm;

  RequestRoomConfirmWidget({
    super.key,
    required this.onConfirm,
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
                '방 확인 요청',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                '방을 확인 하셨다면 아래 승인 버튼을 눌려주세요.',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                  color: Color(0xFF8B8B8B),
                ),
              ),
              SizedBox(height: 20.0),
              SizedBox(
                width: 310,
                height: 40,
                child: ElevatedButton(
                  onPressed: () => onConfirm(),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFF0E2288), // 버튼 텍스트 색상
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.white, // 버튼 배경색
                    ),
                    side: MaterialStateProperty.all<BorderSide>(
                      const BorderSide(
                        color: Color(0xFF0E2288), // 테두리 색상
                        width: 1, // 테두리 두께
                      ),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // 모서리 반경
                      ),
                    ),
                  ),
                  child: Text('확인'),
                ),
              ),
              // const SizedBox(height: 10.0), // 하단 여백 추가
            ],
          ),
        ],
      ), // Row
    );
  }
}

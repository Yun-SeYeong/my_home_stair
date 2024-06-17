import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_home_stair/components/my_house_stair_outline_button.dart';
import 'package:my_home_stair/dto/response/contract/contract_history_widget_status.dart';

class ContractHistoryCheckWidget extends StatelessWidget {
  final String title;
  final String description;
  final ContractHistoryWidgetStatus status;
  final Function onConfirm;

  const ContractHistoryCheckWidget({
    super.key,
    required this.title,
    required this.description,
    required this.status,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              if (status == ContractHistoryWidgetStatus.accepted)
                SvgPicture.asset('images/Check_fill.svg')
              else if (status == ContractHistoryWidgetStatus.waiting)
                SvgPicture.asset('images/Progress.svg')
              else
                Container()
            ],
          ),
          if (status == ContractHistoryWidgetStatus.request) ...[
            Text(
              description,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
                color: Color(0xFF8B8B8B),
              ),
            ),
            const SizedBox(height: 20.0),
            MyHouseStairOutlineButton(
              text: '확인',
              onPressed: onConfirm,
            ),
          ]
        ],
      ), // Row
    );
  }
}

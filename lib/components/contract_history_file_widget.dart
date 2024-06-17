import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:my_home_stair/components/my_house_stair_outline_button.dart';
import 'package:my_home_stair/dto/response/contract/contract_history_widget_status.dart';

class ContractHistoryFileWidget extends StatelessWidget {
  final String title;
  final String description;
  final DateTime date;
  final ContractHistoryWidgetStatus status;
  final Function onDownload;
  final Function onConfirm;

  const ContractHistoryFileWidget({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.onDownload,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                    if (status == ContractHistoryWidgetStatus.accepted) ...[
                      const SizedBox(height: 10.0),
                      Text(DateFormat("yyyy.MM.dd hh:mm").format(date),
                          style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                              color: Color(0xFF8B8B8B))),
                    ]
                  ],
                ),
                if (status == ContractHistoryWidgetStatus.accepted)
                  InkWell(
                    onTap: () {
                      onDownload();
                    },
                    child: SvgPicture.asset(
                      'images/download.svg',
                      semanticsLabel: 'Download',
                    ),
                  )
                else if (status == ContractHistoryWidgetStatus.waiting)
                  SvgPicture.asset('images/Progress.svg')
                else
                  Container()
              ]),
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
              text: '업로드',
              onPressed: onConfirm,
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_home_stair/components/color_styles.dart';
import 'package:my_home_stair/components/my_house_stair_outline_button.dart';
import 'package:my_home_stair/dto/response/contract/contract_history_widget_status.dart';

class ContractHistoryTextWidget extends StatelessWidget {
  final String title;
  final String description;
  final String? textInput;
  final ContractHistoryWidgetStatus status;
  final Function onCopy;
  final Function onConfirm;
  final ValueChanged<String> onChanged;

  const ContractHistoryTextWidget({
    super.key,
    required this.title,
    required this.description,
    required this.textInput,
    required this.status,
    required this.onCopy,
    required this.onConfirm,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currentTextInput = textInput;
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
                  ],
                ),
                if (status == ContractHistoryWidgetStatus.accepted)
                  InkWell(
                    onTap: () {
                      onCopy();
                    },
                    child: SvgPicture.asset(
                      'images/Copy.svg',
                    ),
                  )
                else if (status == ContractHistoryWidgetStatus.waiting)
                  SvgPicture.asset('images/Progress.svg')
                else
                  Container()
              ]),
          if (status == ContractHistoryWidgetStatus.accepted &&
              currentTextInput != null) ...[
            const SizedBox(height: 10.0),
            SizedBox(
              child: Text(
                currentTextInput,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                  color: ColorStyles.primaryColor,
                ),
              ),
            ),
          ],
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
            TextField(
              onChanged: onChanged,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: ColorStyles.primaryColor, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: ColorStyles.primaryColor, width: 1.5),
                ),
                enabled: true,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            const SizedBox(height: 20.0),
            MyHouseStairOutlineButton(
              text: '확인',
              onPressed: onConfirm,
            ),
          ],
        ],
      ),
    );
  }
}

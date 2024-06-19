import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_home_stair/components/color_styles.dart';
import 'package:my_home_stair/dto/response/contract/contract_status.dart';

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
  final ContractStatus status;
  final String address;
  final Function onClicked;
  final Function onCopy;

  const ContractStatusWidget({
    super.key,
    required this.title,
    required this.status,
    required this.address,
    required this.onClicked,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClicked();
      },
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), // 그림자의 색상 및 투명도
              offset: const Offset(4, 4), // x: 0, y: 0
              blurRadius: 10, // blur 반경
              spreadRadius: 1, // spread 반경
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E2288),
                    height: 1.25,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(width: 12.0),
                Container(
                  width: 48,
                  height: 20,
                  decoration: BoxDecoration(
                    color: ColorStyles.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      status.name,
                      style: const TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Flexible(flex: 1, child: Container()),
                InkWell(
                  onTap: () {
                    onCopy();
                  },
                  child: SvgPicture.asset(
                    'images/External.svg', // 우측에 위치한 공통 아이콘
                    semanticsLabel: 'Expand_right',
                  ),
                )
              ],
            ),
            const SizedBox(height: 10.0),
            Text(
              address,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: ColorStyles.greyColor,
              ),
            ),
            const SizedBox(height: 20.0),
            Stack(
              children: [
                Positioned(
                  top: 22.5,
                  left: 10.0,
                  right: 15.0,
                  child: Container(
                    height: 1.0,
                    color: ColorStyles.primaryColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatusBar(
                        label: "방확인",
                        isActive: ContractStatus.roomCheck.index <= status.index),
                    StatusBar(
                        label: "가계약",
                        isActive: ContractStatus.provisionalContract.index <=
                            status.index),
                    StatusBar(
                        label: "실계약",
                        isActive: ContractStatus.contract.index <= status.index),
                    StatusBar(
                        label: "계약완료",
                        isActive: ContractStatus.complete.index <= status.index),
                    StatusBar(
                        label: "계약만료",
                        isActive: ContractStatus.expired.index <= status.index),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

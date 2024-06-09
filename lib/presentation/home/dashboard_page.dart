import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_home_stair/components/color_styles.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contracts = [];
    return Stack(
      children: [
        Positioned(
          child: Container(
            color: ColorStyles.backgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _titleWidget(),
                const SizedBox(height: 20),
                if (contracts.isEmpty) _emptyContractWidget(),
              ],
            ),
          ),
        ),
        Positioned(
          right: 20,
          bottom: 84,
          child: _floatingButtonWidget(),
        )
      ],
    );
  }

  Container _emptyContractWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: const Center(
        child: Text(
          "계약이 없습니다.",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ColorStyles.greyColor,
          ),
        ),
      ),
    );
  }

  Widget _floatingButtonWidget() {
    return Container(
      height: 50,
      width: 50,
      padding: const EdgeInsets.all(13),
      decoration: const BoxDecoration(
        color: ColorStyles.primaryColor,
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        'images/AddContract.svg',
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "우리집 계약",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SvgPicture.asset(
          'images/Filter.svg',
        )
      ],
    );
  }
}

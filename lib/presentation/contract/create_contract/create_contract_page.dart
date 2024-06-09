import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_home_stair/components/color_styles.dart';
import 'package:my_home_stair/components/my_house_stair_button.dart';

class CreateContractPage extends StatefulWidget {
  static const route = "CreateContractPage";

  const CreateContractPage({super.key});

  @override
  State<CreateContractPage> createState() => _CreateContractPageState();
}

class _CreateContractPageState extends State<CreateContractPage> {
  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: statusBarHeight),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _appBarWidget(
                () => Navigator.of(context).pop(),
              ),
            ),
            Positioned(
              top: 64,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: ColorStyles.backgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _selectNewOrJoinWidget(),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: MyHouseStairButton(
                text: '다음',
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _selectNewOrJoinWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          '새로운 계약서를 생성할지 선택해주세요.',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ColorStyles.primaryColor,
          ),
        ),
        const SizedBox(height: 40),
        _button(
          SvgPicture.asset('images/AddContract.svg',
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              )),
          '새로운 계약서 생성',
          () {},
        ),
        const SizedBox(height: 20),
        _button(
          SvgPicture.asset('images/File_dock_search.svg',
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              )),
          '계약서 참여',
          () {},
        ),
      ],
    );
  }

  Widget _button(Widget icon, String text, Function onTap) {
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
            icon,
            Text(text,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(width: 24, height: 24),
          ]),
    );
  }

  Widget _appBarWidget(Function onBack) {
    return Container(
      color: Colors.white,
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => onBack(),
            child: SvgPicture.asset(
              'images/Expand_left.svg',
              height: 24,
            ),
          ),
          const Text(
            '계약서 추가',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 24, height: 24),
        ],
      ),
    );
  }
}

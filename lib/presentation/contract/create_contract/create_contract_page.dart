import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_home_stair/components/color_styles.dart';
import 'package:my_home_stair/components/my_house_stair_button.dart';
import 'package:my_home_stair/dto/response/contract/contract_role.dart';

import 'create_contract_page_bloc.dart';

class CreateContractPage extends StatefulWidget {
  static const route = "CreateContractPage";

  const CreateContractPage({super.key});

  @override
  State<CreateContractPage> createState() => _CreateContractPageState();
}

class _CreateContractPageState extends State<CreateContractPage> {
  TextEditingController addressController = TextEditingController();
  TextEditingController addressDetailController = TextEditingController();

  @override
  void initState() {
    addressController.addListener(() {
      context
          .read<CreateContractPageBloc>()
          .add(SelectAddressEvent(addressController.text));
    });
    addressDetailController.addListener(() {
      context
          .read<CreateContractPageBloc>()
          .add(SelectAddressDetailEvent(addressDetailController.text));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;
    final uiState = context.watch<CreateContractPageBloc>().state;

    final pages = [
      _selectNewOrJoinWidget(uiState.isContractNew, (isNew) {
        context
            .read<CreateContractPageBloc>()
            .add(SelectIsNewContractEvent(isNew));
      }),
      _selectContractRoleType(uiState.contractRole, (role) {
        context
            .read<CreateContractPageBloc>()
            .add(SelectContractRoleEvent(role));
      }),
      _selectContractAddress(addressController),
      _selectContractAddressDetail(
        uiState.address,
        addressDetailController,
      ),
      _selectContractJoinCode((text) {
        context.read<CreateContractPageBloc>().add(SelectJoinCodeEvent(text));
      }),
    ];

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
                () => context.read<CreateContractPageBloc>().add(BackEvent()),
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
                child: pages[uiState.pageIndex],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: MyHouseStairButton(
                text: uiState.buttonText,
                onPressed: () {
                  context
                      .read<CreateContractPageBloc>()
                      .add(NextButtonClickEvent());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _selectNewOrJoinWidget(
    bool isContractNew,
    void Function(bool isNew) selectIsNewContract,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          '계약서 생성 여부를 선택해주세요.',
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
          () {
            selectIsNewContract(true);
          },
          isContractNew,
        ),
        const SizedBox(height: 20),
        _button(
          SvgPicture.asset('images/File_dock_search.svg',
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              )),
          '계약서 참여',
          () {
            selectIsNewContract(false);
          },
          !isContractNew,
        ),
      ],
    );
  }

  Column _selectContractRoleType(
    ContractRole contractRole,
    void Function(ContractRole role) selectContractRole,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          '어떤 역할인지 선택해주세요.',
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
          '임차인',
          () {
            selectContractRole(ContractRole.lessee);
          },
          contractRole == ContractRole.lessee,
        ),
        const SizedBox(height: 20),
        _button(
          SvgPicture.asset('images/File_dock_search.svg',
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              )),
          '중계인',
          () {
            selectContractRole(ContractRole.landlord);
          },
          contractRole == ContractRole.landlord,
        ),
        const SizedBox(height: 20),
        _button(
          SvgPicture.asset('images/File_dock_search.svg',
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              )),
          '임대인',
          () {
            selectContractRole(ContractRole.intermediary);
          },
          contractRole == ContractRole.intermediary,
        ),
      ],
    );
  }

  Column _selectContractAddress(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          '주소를 입력해주세요.',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ColorStyles.primaryColor,
          ),
        ),
        const SizedBox(height: 40),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            label: Text('주소'),
            labelStyle: TextStyle(
              color: ColorStyles.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: ColorStyles.primaryColor, width: 2.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: ColorStyles.primaryColor, width: 2.5),
            ),
            enabled: true,
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      ],
    );
  }

  Column _selectContractAddressDetail(
      String address, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          '상세주소를 입력해주세요.',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ColorStyles.primaryColor,
          ),
        ),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 0),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                address,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            label: Text('상세주소'),
            labelStyle: TextStyle(
              color: ColorStyles.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: ColorStyles.primaryColor, width: 2.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: ColorStyles.primaryColor, width: 2.5),
            ),
            enabled: true,
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      ],
    );
  }

  Column _selectContractJoinCode(ValueChanged<String>? onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          '초대코드를 입력해주세요',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ColorStyles.primaryColor,
          ),
        ),
        const SizedBox(height: 40),
        TextField(
          onChanged: onChanged,
          decoration: const InputDecoration(
            label: Text('코드'),
            labelStyle: TextStyle(
              color: ColorStyles.primaryColor,
              fontWeight: FontWeight.bold,
            ),
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
      ],
    );
  }

  Widget _button(Widget icon, String text, Function onTap, bool isCheck) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(
            color: isCheck ? ColorStyles.primaryColor : Colors.white,
            width: 2.5,
          ),
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
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 24, height: 24),
            ]),
      ),
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

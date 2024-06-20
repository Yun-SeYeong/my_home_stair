import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:my_home_stair/components/color_styles.dart';
import 'package:my_home_stair/components/contract_history_check_widget.dart';
import 'package:my_home_stair/components/contract_history_file_widget.dart';
import 'package:my_home_stair/components/contract_history_text_widget.dart';
import 'package:my_home_stair/components/my_house_stair_outline_button.dart';
import 'package:my_home_stair/dto/response/contract/contract_detail_response.dart';
import 'package:my_home_stair/dto/response/contract/contract_history.dart';
import 'package:my_home_stair/dto/response/contract/contract_history_type.dart';
import 'package:my_home_stair/dto/response/contract/contract_history_widget_status.dart';
import 'package:my_home_stair/dto/response/contract/contract_role.dart';
import 'package:my_home_stair/dto/response/contract/contract_status.dart';
import 'package:my_home_stair/dto/response/contract/contract_step.dart';
import 'package:my_home_stair/presentation/contract/contract_detail/contract_detail_page_bloc.dart';

class ContractDetailPage extends StatefulWidget {
  static const String route = "ContractDetailPage";
  final String contractId;

  const ContractDetailPage({Key? key, required this.contractId})
      : super(key: key);

  @override
  State<ContractDetailPage> createState() => _ContractDetailPageState();
}

enum RequestMenuStatus {
  menuClosed,
  menuOpened,
  fileUploadRequest,
  contractSpecialRequest
}

class _ContractDetailPageState extends State<ContractDetailPage>
    with SingleTickerProviderStateMixin {
  RequestMenuStatus _requestMenuStatus = RequestMenuStatus.menuClosed;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    context
        .read<ContractDetailPageBloc>()
        .add(InitStateEvent(widget.contractId));
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      lowerBound: 0,
      upperBound: 0.7854,
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    context.read<ContractDetailPageBloc>().add(DisposeEvent());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final uiState = context.watch<ContractDetailPageBloc>().state;
    final contractDetail = uiState.contractDetail;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: ColorStyles.backgroundColor,
        padding: EdgeInsets.only(top: statusBarHeight, bottom: bottomPadding),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _appBarWidget(),
            ),
            Positioned(
              top: 64,
              left: 0,
              right: 0,
              bottom: 0,
              child: contractDetail == null
                  ? Container()
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: _contentWidget(uiState, contractDetail),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Container _contentWidget(
    ContractDetailPageState uiState,
    ContractDetailResponse contractDetail,
  ) {
    return Container(
      color: ColorStyles.backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            uiState.contractDetail?.contractRole.name ?? '',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorStyles.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "${contractDetail.address ?? ''} ${contractDetail.addressDetail ?? ''}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          for (ContractStep step in contractDetail.steps)
            if (step.status.index <= contractDetail.status.index)
              ..._stepWidget(contractDetail.contractRole, step),
          const SizedBox(height: 20),
          if (_requestMenuStatus == RequestMenuStatus.menuOpened)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _requestButtonWidget('images/File.svg', '파일\n업로드 요청', () {
                  _openRequestFileUpload();
                }),
                const SizedBox(width: 20),
                _requestButtonWidget('images/pen.svg', '계약서 특약\n추가 요청', () {
                  _openRequestContractSpecial();
                }),
              ],
            )
          else if (_requestMenuStatus == RequestMenuStatus.fileUploadRequest)
            _requestFileUploadWidget(
              _openMenu,
              () {
                context
                    .read<ContractDetailPageBloc>()
                    .add(CreateFileUploadHistoryEvent());
                setState(() {
                  _requestMenuStatus = RequestMenuStatus.menuClosed;
                });
              },
              (text) {
                context
                    .read<ContractDetailPageBloc>()
                    .add(FileTypeChangedEvent(text));
              },
              (text) {
                context
                    .read<ContractDetailPageBloc>()
                    .add(FileDescriptionChangedEvent(text));
              },
            )
          else if (_requestMenuStatus ==
              RequestMenuStatus.contractSpecialRequest)
            _requestSpecialContractWidget(
              _openMenu,
              () {
                context
                    .read<ContractDetailPageBloc>()
                    .add(CreateSpecialContractHistoryEvent());
                setState(() {
                  _requestMenuStatus = RequestMenuStatus.menuClosed;
                });
              },
              (text) {
                context
                    .read<ContractDetailPageBloc>()
                    .add(SpecialContractDescriptionChangedEvent(text));
              },
            ),
          const SizedBox(height: 20),
          if (contractDetail.contractRole == ContractRole.lessee &&
              contractDetail.status.index < ContractStatus.complete.index)
            Center(
              child: InkWell(
                onTap: () {
                  if (_requestMenuStatus == RequestMenuStatus.menuClosed) {
                    _openMenu();
                  } else {
                    _closeMenu();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(9),
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                      color: ColorStyles.primaryColor, shape: BoxShape.circle),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _controller.value,
                        child: child,
                      );
                    },
                    child: SvgPicture.asset(
                      'images/plus.svg',
                      height: 16,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 540),
        ],
      ),
    );
  }

  void _closeMenu() {
    setState(() {
      _controller.reverse();
      _requestMenuStatus = RequestMenuStatus.menuClosed;
    });
  }

  void _openMenu() {
    setState(() {
      _controller.forward();
      _requestMenuStatus = RequestMenuStatus.menuOpened;
    });
  }

  void _openRequestFileUpload() {
    setState(() {
      _requestMenuStatus = RequestMenuStatus.fileUploadRequest;
    });
  }

  void _openRequestContractSpecial() {
    setState(() {
      _requestMenuStatus = RequestMenuStatus.contractSpecialRequest;
    });
  }

  Widget _requestFileUploadWidget(
    Function onBack,
    Function onRequest,
    void Function(String) onFileTypeChanged,
    void Function(String) onRequestChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
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
            children: [
              InkWell(
                onTap: () => onBack(),
                child: SvgPicture.asset('images/Expand_left.svg'),
              ),
              const Text(
                '파일 업로드 요청',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 24)
            ],
          ),
          const SizedBox(height: 20),
          const Text('계약에 필요한 파일을 요청해보세요.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: ColorStyles.greyColor,
              )),
          const SizedBox(height: 20),
          TextField(
            onChanged: onFileTypeChanged,
            decoration: const InputDecoration(
              label: Text(
                '파일 종류',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorStyles.primaryColor,
                ),
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
          const SizedBox(height: 20),
          TextField(
            onChanged: onRequestChanged,
            decoration: const InputDecoration(
              label: Text(
                '요청사항',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorStyles.primaryColor,
                ),
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
          const SizedBox(height: 20),
          MyHouseStairOutlineButton(
            text: '확인',
            onPressed: onRequest,
          ),
        ],
      ),
    );
  }

  Widget _requestSpecialContractWidget(
    Function onBack,
    Function onRequest,
    void Function(String) onDescriptionChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
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
            children: [
              InkWell(
                onTap: () => onBack(),
                child: SvgPicture.asset('images/Expand_left.svg'),
              ),
              const Text(
                '계약서 특약 추가 요청',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 24)
            ],
          ),
          const SizedBox(height: 20),
          const Text('계약에 필요한 파일을 요청해보세요.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: ColorStyles.greyColor,
              )),
          const SizedBox(height: 20),
          TextField(
            onChanged: onDescriptionChanged,
            maxLines: 5,
            decoration: const InputDecoration(
              label: Text(
                '요청사항',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorStyles.primaryColor,
                ),
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
          const SizedBox(height: 20),
          MyHouseStairOutlineButton(
            text: '확인',
            onPressed: onRequest,
          ),
        ],
      ),
    );
  }

  Widget _requestButtonWidget(
      String imagePath, String menuName, Function onTap) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        width: 100,
        height: 140,
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
          children: [
            const SizedBox(height: 20),
            SvgPicture.asset(imagePath),
            const SizedBox(height: 20),
            Text(
              menuName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _stepWidget(ContractRole myRole, ContractStep step) {
    final contractHistories = step.contractHistories;
    final enabledHistories = [];
    for (int i = 0; i < contractHistories.length; i++) {
      enabledHistories.add(contractHistories[i]);
      if (!contractHistories[i].isCompleted) {
        break;
      }
    }
    return [
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            step.status.name,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            DateFormat("yyyy년 MM월 dd일").format(step.createdAt),
            style: const TextStyle(
              fontSize: 12,
              color: ColorStyles.greyColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      for (ContractHistory contractHistory in enabledHistories)
        ..._historyWidget(myRole, contractHistory),
    ];
  }

  List<Widget> _historyWidget(
      ContractRole myRole, ContractHistory contractHistory) {
    switch (contractHistory.type) {
      case ContractHistoryType.check:
        return [
          const SizedBox(height: 20),
          ContractHistoryCheckWidget(
            title: contractHistory.title,
            description: contractHistory.description,
            status: _getHistoryWidgetStatus(myRole, contractHistory),
            onConfirm: () {
              context
                  .read<ContractDetailPageBloc>()
                  .add(ContractHistoryCheckEvent(contractHistory.id));
            },
          ),
        ];
      case ContractHistoryType.file:
        return [
          const SizedBox(height: 20),
          ContractHistoryFileWidget(
            title: contractHistory.title,
            description: contractHistory.description,
            date: contractHistory.updatedAt,
            status: _getHistoryWidgetStatus(myRole, contractHistory),
            onDownload: () {
              context
                  .read<ContractDetailPageBloc>()
                  .add(DownloadFileEvent(contractHistory.id));
            },
            onConfirm: () {
              context
                  .read<ContractDetailPageBloc>()
                  .add(ContractHistoryUploadFileEvent(contractHistory.id));
            },
          )
        ];
      case ContractHistoryType.text:
        return [
          const SizedBox(height: 20),
          ContractHistoryTextWidget(
            title: contractHistory.title,
            description: contractHistory.description,
            textInput: contractHistory.textInput,
            status: _getHistoryWidgetStatus(myRole, contractHistory),
            onCopy: () {
              context
                  .read<ContractDetailPageBloc>()
                  .add(SetClipboardEvent(contractHistory.description));
            },
            onConfirm: () {
              context
                  .read<ContractDetailPageBloc>()
                  .add(ContractHistoryInputTextEvent(contractHistory.id));
            },
            onChanged: (text) {
              context.read<ContractDetailPageBloc>().add(
                  ContractHistoryInputTextChangedEvent(
                      text, contractHistory.id));
            },
          )
        ];
      default:
        return [];
    }
  }

  ContractHistoryWidgetStatus _getHistoryWidgetStatus(
      ContractRole myRole, ContractHistory contractHistory) {
    if (contractHistory.isCompleted) {
      return ContractHistoryWidgetStatus.accepted;
    } else if (contractHistory.verifiedBy == myRole) {
      return ContractHistoryWidgetStatus.request;
    } else {
      return ContractHistoryWidgetStatus.waiting;
    }
  }

  Widget _appBarWidget() {
    return Container(
      color: Colors.white,
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SvgPicture.asset(
              'images/Expand_left.svg',
              height: 24,
            ),
          ),
          SvgPicture.asset(
            'images/Bell.svg',
            height: 24,
          ),
        ],
      ),
    );
  }
}

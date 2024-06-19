import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:my_home_stair/components/color_styles.dart';
import 'package:my_home_stair/components/contract_history_check_widget.dart';
import 'package:my_home_stair/components/contract_history_file_widget.dart';
import 'package:my_home_stair/components/contract_history_text_widget.dart';
import 'package:my_home_stair/dto/response/contract/contract_detail_response.dart';
import 'package:my_home_stair/dto/response/contract/contract_history.dart';
import 'package:my_home_stair/dto/response/contract/contract_history_type.dart';
import 'package:my_home_stair/dto/response/contract/contract_history_widget_status.dart';
import 'package:my_home_stair/dto/response/contract/contract_role.dart';
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

class _ContractDetailPageState extends State<ContractDetailPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<ContractDetailPageBloc>()
        .add(InitStateEvent(widget.contractId));
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
          Center(
            child: Container(
              padding: const EdgeInsets.all(9),
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                  color: ColorStyles.primaryColor, shape: BoxShape.circle),
              child: SvgPicture.asset(
                'images/plus.svg',
                height: 16,
              ),
            ),
          ),
          const SizedBox(height: 120),
        ],
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
            onDownload: () {},
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
            onCopy: () {},
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

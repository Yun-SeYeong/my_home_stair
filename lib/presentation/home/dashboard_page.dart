import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_home_stair/components/color_styles.dart';
import 'package:my_home_stair/components/contract_status_widget.dart';
import 'package:my_home_stair/dto/response/contract/contract_response.dart';
import 'package:my_home_stair/presentation/home/home_page_bloc.dart';

class DashboardPage extends StatelessWidget {
  final ScrollController scrollController;

  const DashboardPage({Key? key, required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uiState = context.watch<HomePageBloc>().state;
    List<ContractResponse> contracts = uiState.contracts.toList();

    return Stack(
      children: [
        Positioned(
          child: Container(
            color: ColorStyles.backgroundColor,
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<HomePageBloc>().add(InitStateEvent());
              },
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 20),
                  _titleWidget(),
                  const SizedBox(height: 20),
                  if (contracts.isEmpty && !uiState.isLoading)
                    _emptyContractWidget()
                  else if (contracts.isEmpty && uiState.isLoading)
                    ...[
                      const SizedBox(height: 120),
                      const SizedBox(
                        height: 60,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    ]
                  else
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        controller: scrollController,
                        physics: const CustomBouncingScrollPhysics(),
                        itemCount:
                            contracts.length + (uiState.isLoading ? 0 : 1),
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 20,
                        ),
                        itemBuilder: (context, index) {
                          if (index == contracts.length) {
                            return contracts.length >= 10
                                ? const SizedBox(
                                    height: 60,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : const SizedBox();
                          } else {
                            final contract = contracts[index];
                            return ContractStatusWidget(
                              title: contract.contractRole.name,
                              status: contract.status,
                              address:
                                  "${contract.address} ${contract.addressDetail}",
                              onCopy: () {
                                context
                                    .read<HomePageBloc>()
                                    .add(SetClipboardEvent(contract.id));
                              },
                              onClicked: () {
                                context
                                    .read<HomePageBloc>()
                                    .add(LoadContractDetailEvent(contract.id));
                              },
                            );
                          }
                        },
                      ),
                    ),
                  if (uiState.isLoading) const SizedBox(height: 32),
                  const SizedBox(height: 64),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 20,
          bottom: 84,
          child: _floatingButtonWidget(
            () => Navigator.of(context).pushNamed("CreateContractPage"),
          ),
        )
      ],
    );
  }

  Widget _emptyContractWidget() {
    return const Expanded(
      child: SingleChildScrollView(
        physics: CustomBouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60),
          child: Center(
            child: Text(
              "계약이 없습니다.",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ColorStyles.greyColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _floatingButtonWidget(Function onTap) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
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
      ),
    );
  }

  Widget _titleWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
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
      ),
    );
  }
}

class CustomBouncingScrollPhysics extends BouncingScrollPhysics {
  const CustomBouncingScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CustomBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomBouncingScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    return true;
  }

  @override
  bool get allowImplicitScrolling => true;
}

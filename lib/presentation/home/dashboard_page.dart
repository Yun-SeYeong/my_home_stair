import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_home_stair/components/color_styles.dart';
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _titleWidget(),
                const SizedBox(height: 20),
                if (contracts.isEmpty)
                  _emptyContractWidget()
                else
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: contracts.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 80,
                              child: Center(
                                child: Text(contracts[index].id),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 20),
                if (uiState.isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                const SizedBox(height: 80),
              ],
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

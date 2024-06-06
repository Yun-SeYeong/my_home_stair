import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_home_stair/components/color_styles.dart';
import 'package:my_home_stair/presentation/home/home_page_bloc.dart';

class HomePage extends StatefulWidget {
  static const route = "HomePage";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController pageController = PageController(initialPage: 1);

  @override
  void initState() {
    super.initState();

    pageController.addListener(() {
      context.read<HomePageBloc>().add(SelectBottomNavigationEvent(HomeTab.values[pageController.page?.round() ?? 1]));
    });
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;
    final uiState = context.watch<HomePageBloc>().state;
    pageController.animateToPage(
      uiState.selectedTab.index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: statusBarHeight),
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
              child: Container(
                color: ColorStyles.backgroundColor,
                child: PageView(
                  controller: pageController,
                  children: [
                    Container(
                      color: Colors.red,
                    ),
                    Container(
                      color: Colors.green,
                    ),
                    Container(
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _bottomNavigationWidget(
                uiState.selectedTab,
                () {
                  context
                      .read<HomePageBloc>()
                      .add(SelectBottomNavigationEvent(HomeTab.archive));
                },
                () {
                  context
                      .read<HomePageBloc>()
                      .add(SelectBottomNavigationEvent(HomeTab.home));
                },
                () {
                  context
                      .read<HomePageBloc>()
                      .add(SelectBottomNavigationEvent(HomeTab.setting));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavigationWidget(
    HomeTab selectedTab,
    Function onArchiveTap,
    Function onHomeTap,
    Function onSettingTap,
  ) {
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
              onArchiveTap();
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: selectedTab == HomeTab.archive
                      ? ColorStyles.primaryColor
                      : Colors.white,
                  shape: BoxShape.circle),
              child: SvgPicture.asset(
                'images/Archive.svg',
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(
                  selectedTab == HomeTab.archive ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              onHomeTap();
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: selectedTab == HomeTab.home
                      ? ColorStyles.primaryColor
                      : Colors.white,
                  shape: BoxShape.circle),
              child: SvgPicture.asset(
                'images/Home.svg',
                height: 24,
                colorFilter: ColorFilter.mode(
                  selectedTab == HomeTab.home ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              onSettingTap();
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: selectedTab == HomeTab.setting
                      ? ColorStyles.primaryColor
                      : Colors.white,
                  shape: BoxShape.circle),
              child: SvgPicture.asset(
                'images/Setting_line.svg',
                height: 24,
                colorFilter: ColorFilter.mode(
                  selectedTab == HomeTab.setting ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
          SvgPicture.asset(
            'images/My_House_Stair_Logo.svg',
            height: 24,
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

enum HomeTab { archive, home, setting }

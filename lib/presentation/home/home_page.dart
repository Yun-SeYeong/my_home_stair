import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_home_stair/components/color_styles.dart';
import 'package:my_home_stair/presentation/home/archive_page.dart';
import 'package:my_home_stair/presentation/home/dashboard_page.dart';
import 'package:my_home_stair/presentation/home/home_page_bloc.dart';
import 'package:my_home_stair/presentation/home/setting_page.dart';

class HomePage extends StatefulWidget {
  static const route = "HomePage";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(initialPage: 1);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Controller 초기화
    _pageController.addListener(_selectBottomNavigation);
    _scrollController.addListener(_loadMoreContractsEvent);

    // HomePage 초기화 이벤트
    context.read<HomePageBloc>().add(InitStateEvent());
  }

  @override
  void dispose() {
    // Controller 해제
    _pageController.removeListener(_selectBottomNavigation);
    _scrollController.removeListener(_loadMoreContractsEvent);
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMoreContractsEvent() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<HomePageBloc>().add(LoadMoreContractsEvent());
    }
  }

  void _selectBottomNavigation() {
    context.read<HomePageBloc>().add(SelectBottomNavigationEvent(HomeTab.values[_pageController.page?.round() ?? 1]));
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final uiState = context.watch<HomePageBloc>().state;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
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
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ArchivePage(key: widget.key),
                  DashboardPage(key: widget.key, scrollController: _scrollController),
                  SettingPage(key: widget.key),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _bottomNavigationWidget(
                uiState.selectedTab,
                () {
                  _pageController.animateToPage(
                    HomeTab.archive.index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                () {
                  _pageController.animateToPage(
                    HomeTab.home.index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                () {
                  _pageController.animateToPage(
                    HomeTab.setting.index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
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

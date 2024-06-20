import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_home_stair/components/color_styles.dart';
import 'package:my_home_stair/dto/response/contract/archive_file_response.dart';
import 'package:my_home_stair/presentation/home/home_page_bloc.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final uiState = context.watch<HomePageBloc>().state;
    return Container(
      color: ColorStyles.backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          TextField(
            onChanged: (value) {
              context.read<HomePageBloc>().add(KeywordChangedEvent(value));
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              label: Text('검색'),
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
          if (uiState.isLoading) const LinearProgressIndicator(),
          const SizedBox(height: 20),
          if (uiState.archiveFileResponse.isEmpty)
            _emptyContractWidget()
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 84),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
                itemCount: uiState.archiveFileResponse.length,
                itemBuilder: (context, index) {
                  final archiveFileResponse =
                      uiState.archiveFileResponse[index];
                  return _archiveFileWidget(
                    archiveFileResponse,
                    () {
                      context.read<HomePageBloc>().add(DownloadArchiveFileEvent(
                            archiveFileResponse.contractId,
                            archiveFileResponse.historyId,
                          ));
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Container _archiveFileWidget(
    ArchiveFileResponse archiveFileResponse,
    void Function() onDownload,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 0),
            blurRadius: 20,
            spreadRadius: 0, // spread 반경
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${archiveFileResponse.address} ${archiveFileResponse.addressDetail}',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(
                  archiveFileResponse.historyTags.join(' | '),
                  style: const TextStyle(
                    fontSize: 12,
                    color: ColorStyles.greyColor,
                  ),
                ),
                Text(
                  archiveFileResponse.updatedAt.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: ColorStyles.greyColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          InkWell(
            onTap: onDownload,
            child: SvgPicture.asset('images/download.svg'),
          )
        ],
      ),
    );
  }

  Container _emptyContractWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: const Center(
        child: Text(
          "검색 결과가 없습니다.",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ColorStyles.greyColor,
          ),
        ),
      ),
    );
  }
}

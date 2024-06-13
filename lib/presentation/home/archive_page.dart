
import 'package:flutter/material.dart';
import 'package:my_home_stair/components/color_styles.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final archiveFiles = [];
    return Container(
      color: ColorStyles.backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              label: Text('검색'),
              labelStyle: TextStyle(
                color: ColorStyles.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ColorStyles.primaryColor, width: 2.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ColorStyles.primaryColor, width: 2.5),
              ),
              enabled: true,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          if (archiveFiles.isEmpty) _emptyContractWidget(),
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
import 'package:flutter/material.dart';


import 'components/upload_file_item_widget.dart';
import 'components/user_email.dart';
import 'components/my_settings.dart';
import 'components/request_room_confirm.dart';
import 'components/upload_file_notice.dart';
import 'components/checkbox_room_confirm.dart';
import 'components/contract_account_number.dart';
import 'components/request_adding_special_agreement.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
            children: [
            // UploadFileItemWidget(
            //   title: '등기부등본.pdf',
            //   description: '서울 서초구 신반포로 270 101호',
            //   date: '2024.01.01 00:00:00',
            //   onDownload: () {
            //     print('onDownload');
            //   },),
            // UserEmailWidget(
            //   userEmail: 'test@test.com'
            // ),
            // MySettingsWidget(
            //   goNotice: (){
            //   print('goNotice');},
            //   goLogout: (){
            //     print('goLogout');},
            //   goPolicy: (){
            //     print('goPolicy');},
            //   goAppver: (){
            //     print('goAppver');},
            //   ),
            // RequestRoomConfirmWidget(
            //   onConfirm: (){
            //     print('onConfirm');},
            // ),
            UploadFileNoticeWidget(
              title:'등기부등본 업로드',
              address: '서울 서초구 신반포로 270 101호',
              description: '중개인이 등기부등본을 업로드 하였습니다.',
              date: '2024.01.01',
            ),
            CheckboxRoomConfirmWidget(
              title: '방 확인 요청'
            ),
            ContractAccountNumberWidget(
                title: '가계약금 입금 확인 요청',
                accountnum: '기업은행 123-123-1234-1234',
                onCopy: (){
                  print('onCopy');
                },),
              RequestAddingSpecialAgreementWidget(
                title: '특약 추가 요청',
                comment: '본 계약은 임차인의 전세 자금 대출을 전제로 하며, 임대인 또는 임차 목적물의 하자로 인한 전세 자금 대출 미승인 시 계약은 무효로 하며 임대인은 계약금을 임차인에게 즉시 반환하기로 한다.',
                onCopy: (){
                  print('onCopy');
                },),
        ],//children
      ),
      ),
    );
  }
}

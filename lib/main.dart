import 'package:flutter/material.dart';

import 'components/upload_file_item_widget.dart';
import 'components/user_email.dart';
import 'components/my_settings.dart';
import 'components/request_room_confirm.dart';
import 'components/upload_file_notice.dart';
import 'components/checkbox_room_confirm.dart';
import 'components/contract_account_number.dart';
import 'components/request_adding_special_agreement.dart';
import 'components/input_text_box.dart';
import 'components/input_request_widget.dart';
import 'components/action_icon_widgeet.dart';
import 'components/contract_status_widget.dart';

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              UploadFileItemWidget(
                title: '등기부등본.pdf',
                description: '서울 서초구 신반포로 270 101호',
                date: '2024.01.01 00:00:00',
                onDownload: () {
                  print('onDownload');
                },
              ),
              UserEmailWidget(userEmail: 'test@test.com'),
              MySettingsWidget(
                goNotice: () {
                  print('goNotice');
                },
                goLogout: () {
                  print('goLogout');
                },
                goPolicy: () {
                  print('goPolicy');
                },
                goAppver: () {
                  print('goAppver');
                },
              ),
              RequestRoomConfirmWidget(
                onConfirm: () {
                  print('onConfirm');
                },
              ),
              const UploadFileNoticeWidget(
                title: '등기부등본 업로드',
                address: '서울 서초구 신반포로 270 101호',
                description: '중개인이 등기부등본을 업로드 하였습니다.',
                date: '2024.01.01',
              ),
              const CheckboxRoomConfirmWidget(title: '방 확인 요청'),
              ContractAccountNumberWidget(
                title: '가계약금 입금 확인 요청',
                accountnum: '기업은행 123-123-1234-1234',
                onCopy: () {
                  print('onCopy');
                },
              ),
              RequestAddingSpecialAgreementWidget(
                title: '특약 추가 요청',
                comment:
                    '본 계약은 임차인의 전세 자금 대출을 전제로 하며, 임대인 또는 임차 목적물의 하자로 인한 전세 자금 대출 미승인 시 계약은 무효로 하며 임대인은 계약금을 임차인에게 즉시 반환하기로 한다.',
                onCopy: () {
                  print('onCopy');
                },
              ),
              UploadFileItemWidget(
                title: '등기부등본.pdf',
                description: '서울 서초구 신반포로 270 101호',
                date: '2024.01.01 00:00:00',
                onDownload: () {
                  print('test');
                },
              ),
              UserEmailWidget(
                userEmail: '',
              ),
              MySettingsWidget(
                goNotice: () {},
                goLogout: () {},
                goPolicy: () {},
                goAppver: () {},
              ),
              Row(children: [
                ActionIconWidget(
                    description: "파일 업로드 요청",
                    iconpath: 'images/File.svg',
                    onButton: () {
                      print("버튼");
                    }),
                ActionIconWidget(
                    description: "계약서 특약 추가 요청",
                    iconpath: 'images/pen.svg',
                    onButton: () {
                      print("버튼");
                    }),
              ]),
              InputTextBox(
                  title: "가계약금 입금 계좌 요청",
                  description: "임차인이 가계약금을 입금 할 수 있도록 계좌번호를 입력해주세요.",
                  buttonName: "확인",
                  onButton: () {
                    print("계좌번호 입력 확인");
                  }),
              InputRequestWidget(
                  title: "파일 업로드 요청",
                  description: "계약에 필요한 파일을 요청해보세요.",
                  buttonName: "확인",
                  onButton: () {
                    print("파일종류 : 요청사항:");
                  },
                  searchButton: () {
                    print("검색 자동완성");
                  }),
              ContractStatusWidget(
                title: '임차인',
                statusNow: '방확인',
                address: '서울 서초구 신반포로 270 101호',
                onButton: () {
                  print("동작");
                },
                //isActive: ,
              ),
            ], //children
          ),
        ),
      ),
    );
  }
}

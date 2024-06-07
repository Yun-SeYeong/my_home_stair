import 'package:flutter/material.dart';


import 'components/upload_file_item_widget.dart';
import 'components/user_email.dart';
import 'components/my_settings.dart';
import 'components/input_text_box.dart';
import 'components/input_request_widget.dart';
import 'components/action_icon_widgeet.dart';

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
                  print('test');
                },
              ),
              const UserEmailWidget(),
              const MySettingsWidget(),
              Row(
                children: [
                ActionIconWidget(
                  description: "파일 업로드 요청",
                  iconpath: 'images/File.svg',
                    onButton: (){
                      print("버튼");
                    }
                ),
                ActionIconWidget(
                  description: "계약서 특약 추가 요청",
                  iconpath: 'images/pen.svg',
                    onButton: (){
                      print("버튼");
                    }
                ),
                ]),
              InputTextBox(
                  title: "가계약금 입금 계좌 요청",
                  description: "임차인이 가계약금을 입금 할 수 있도록 계좌번호를 입력해주세요.",
                  buttonName: "확인",
                  onButton: (){
                    print("계좌번호 입력 확인");
                  }
              ),
              InputRequestWidget(
                  title: "파일 업로드 요청",
                  description: "계약에 필요한 파일을 요청해보세요.",
                  buttonName: "확인",
                  onButton: (){
                    print("파일종류 : 요청사항:");
                  },
                  searchButton: (){
                    print("검색 자동완성");
                  }
              ),
            ],//children
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';


import 'components/upload_file_item_widget.dart';
import 'components/user_email.dart';
import 'components/my_settings.dart';

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
    return const SafeArea(
      child: Scaffold(
          body: Column(
            children: [
            UploadFileItemWidget(),
            UserEmailWidget(),
            MySettingsWidget(),
        ],//children
      ),
      ),
    );
  }
}

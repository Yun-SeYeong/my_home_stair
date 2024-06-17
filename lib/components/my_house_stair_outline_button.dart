import 'package:flutter/material.dart';

import 'color_styles.dart';

class MyHouseStairOutlineButton extends StatelessWidget {
  final Function onPressed;
  final bool enabled;
  final String text;

  const MyHouseStairOutlineButton({
    super.key,
    this.enabled = true,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: ColorStyles.primaryColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                  color: ColorStyles.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w900),
            )
          ],
        ),
      ),
    );
  }
}

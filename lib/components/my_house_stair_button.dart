import 'package:flutter/material.dart';

import 'color_styles.dart';

class MyHouseStairButton extends StatelessWidget {
  final Function onPressed;
  final bool enabled;
  final String text;

  const MyHouseStairButton({
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
          color: ColorStyles.primaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w900),
            )
          ],
        ),
      ),
    );
  }
}

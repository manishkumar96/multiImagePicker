import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonText extends StatelessWidget {
  final String? text;

  final Alignment? alignment;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final BoxDecoration? boxDecoration;
  final TextStyle? textStyle;
  final TextAlign? textAlign;

  const ButtonText(
      {Key? key,
       this.text,
       this.alignment,
       this.width,
       this.height,
       this.padding,
       this.boxDecoration,
       this.textStyle,
       this.textAlign })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      width: width,
      height: height,
      padding: padding,
      decoration: boxDecoration,
      child: Text(
        text!,
        style: textStyle,
        textAlign: textAlign,
      ),
    );
  }
}

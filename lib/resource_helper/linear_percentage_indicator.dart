import 'package:flutter/material.dart';
import 'package:multi_image_picker/resource_helper/dimens_helper.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PercentageIndicator extends StatelessWidget {

 final String text;


  const PercentageIndicator({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DimensHelper.twenty),
        child: LinearPercentIndicator(
          lineHeight: 15.0,
          percent: 0.2,
          center: Text(
            text,
            style: const TextStyle(
              fontSize: 12.0,
            ),
          ),
          animation: true,
          animationDuration: 1000,
          linearStrokeCap: LinearStrokeCap.butt,
          progressColor: Colors.red,
        ),
      ),
    );
  }
}

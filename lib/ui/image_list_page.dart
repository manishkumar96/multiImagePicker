import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/helper/api_helper.dart';
import 'package:multi_image_picker/resource_helper/string_helper.dart';
import 'package:multi_image_picker/widget/text_btn.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
class ImageListPage extends StatefulWidget {
  final List<File> image;


  const ImageListPage(this.image, {Key? key}) : super(key: key);

  @override
  _ImageListPageState createState() => _ImageListPageState();
}

class _ImageListPageState extends State<ImageListPage> {
  late ApiHelper apiHelper;
  List<MultipartFile> multipartImageList = [];
  late double _progressValue;
  late double percent;
  late Timer timer;
  double value=0;

  @override
  void initState() {
    super.initState();
    apiHelper = ApiHelper();
    _progressValue = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        body: Container(
          margin: const EdgeInsets.only(top: 10),
          child: Center(
            child: Column(
              children: [
                Expanded(child: Container(child: buildList(context))),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      print("upload image");
                      imageUpload(widget.image);
                    },
                    child: ButtonText(
                      alignment: Alignment.center,
                      text: StringHelper.uploadImage,
                      textAlign: TextAlign.center,
                      height: 40,
                      width: 150,
                      boxDecoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                          width: 1,
                          color: Colors.orange,
                        ),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListView buildList(BuildContext context) {
    return ListView.builder(
      itemCount: widget.image.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
               Expanded(
                child:

                /*LinearProgressIndicator(
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                  valueColor:AlwaysStoppedAnimation(Colors.red),
                  value: ,
                ),*/
                LinearPercentIndicator(
                  backgroundColor: Colors.cyanAccent,
                  linearStrokeCap: LinearStrokeCap.butt,
                  progressColor: Colors.red,
                  animationDuration: 2000,
                  percent: value,
                ),
              ),
              Text(value.toStringAsFixed(2)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(
                    widget.image[index],
                    height: 70,
                    width: 70,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  void imageUpload(List<File> image) {
  //  updateProgress();

    apiHelper.uploadImage(image,updatePercentage).then((value) {
      if (value.statusCode == 200) {

   //     timer.cancel();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Upload Complete")));
        print("image upload success");
      } else {
        print("image upload failed");
      }
    });
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      centerTitle: true,
      title: Row(
        children: [
          Text(
            widget.image.length.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.orange,
            ),
          ),
        ],
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  void updatePercentage(double percentage){
    print("value==$value");
    setState(() {
      value=percentage;
    });

  }
  void updateProgress() {
    const oneSec = Duration(seconds: 1);

    /*  timer = Timer.periodic(oneSec, (_) {
      setState(() {
        _progressValue += 1;
        print('progress value$_progressValue');
        if (_progressValue >= 100) {
          timer.cancel();
        }
      });
    });*/
    timer = Timer.periodic(oneSec, (Timer t) {
      _progressValue += 0.1;
      print("before progress $_progressValue");
      setState(() {
        if (_progressValue > 0.9) {
          print(_progressValue);
          t.cancel();
          return;
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

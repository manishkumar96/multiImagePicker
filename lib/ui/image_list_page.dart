import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:multi_image_picker/helper/api_helper.dart';
import 'package:multi_image_picker/resource_helper/string_helper.dart';
import 'package:multi_image_picker/widget/text_btn.dart';

class ImageListPage extends StatefulWidget {
  final List<File> image;
  final double percentage;

  const ImageListPage(this.image, this.percentage, {Key? key})
      : super(key: key);

  @override
  _ImageListPageState createState() => _ImageListPageState();
}

class _ImageListPageState extends State<ImageListPage> {
  late ApiHelper apiHelper;
  late double percent;
  late Timer timer;
  double value = 0;

  @override
  void initState() {
    super.initState();
    apiHelper = ApiHelper();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        body: Container(
          margin: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: [
                Expanded(child: Container(child: buildList(context))),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      print("upload image");
                      imageUpload(widget.image, widget.percentage);
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
        print("itemCount: ${widget.image.length}");
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                  valueColor: const AlwaysStoppedAnimation(Colors.red),
                  value: value / 100,
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  child: Text(value.toStringAsFixed(2) + "%")),
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

  void imageUpload(List<File> image, double percentage) {
    apiHelper.uploadImage(image, updatePercentage, percentage).then((value) {
      if (value.statusCode == 200) {
        /* ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Upload Complete")));*/
        print("image : $image");
        print("image upload success");
      } else {
        print("image upload failed");
      }
    });
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  void updatePercentage(double percentage) {
    print("value==$value");
    setState(() {
      value = percentage;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}

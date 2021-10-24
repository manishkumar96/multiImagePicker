import 'dart:io';

import 'package:flutter/material.dart';
import 'package:multi_image_picker/resource_helper/linear_percentage_indicator.dart';
import 'package:multi_image_picker/resource_helper/string_helper.dart';
import 'package:multi_image_picker/ui/image_list_page.dart';
import 'package:multi_image_picker/widget/text_btn.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path_provider/path_provider.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({Key? key}) : super(key: key);

  @override
  _ImagePickerScreen createState() => _ImagePickerScreen();
}

class _ImagePickerScreen extends State<ImagePickerScreen> {
  List<Asset> images = <Asset>[];
  List<File> imageFileList = <File>[];

  @override
  void initState() {
    super.initState();
  }

  void getFileList() async {
    for (int i = 0; i <= images.length; i++) {
      var file = await getImageFileFromAssets(images[i]);
      print(file);
      imageFileList.add(file);
    }
  }

  Future<File> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();

    final tempFile =
        File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appbar(),
        body: Container(
          margin: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              selectImages(),
              Expanded(child: gridviewimages()),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> imagesSelect() async {
    setState(() {
      images = <Asset>[];
    });

    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
          maxImages: 10, selectedAssets: images);
    } on Exception catch (e) {
      print(e.toString());
    }
    setState(() {
      images = resultList;
      getFileList();
    });
  }

  Widget gridviewimages() {
    if (images != null) {
      return GridView.count(
        crossAxisCount: 3,
        children: List.generate(
          images.length,
          (index) {
            Asset asset = images[index];
            return AssetThumb(
              asset: asset,
              width: 2000,
              height: 2000,
            );
          },
        ),
      );
    } else {
      return Container();
    }
  }

  Widget selectImages() {
    return Center(
      child: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              print("select images");
              imagesSelect();
            },
            child: ButtonText(
              alignment: Alignment.center,
              text: StringHelper.selectImages,
              textAlign: TextAlign.center,
              height: 40,
              width: 150,
              boxDecoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
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
      ),
    );
  }

  PreferredSizeWidget appbar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
              onTap: () {
                print(images.length);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ImageListPage(imageFileList)));
              },
              child: const Icon(
                Icons.check,
                color: Colors.black,
                size: 30,
              )),
        ),
      ],
    );
  }
}

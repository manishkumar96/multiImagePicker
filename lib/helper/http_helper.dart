import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:multi_image_picker/helper/api_constants.dart';
import 'package:multi_image_picker/ui/image_list_page.dart';
import 'constants.dart';
import 'package:path/path.dart' as fileUtil;
import 'package:http_parser/src/media_type.dart';

class HttpHelper {
  static final HttpHelper httpHelper = HttpHelper._internal();

  HttpHelper._internal();

  factory HttpHelper() {
    return httpHelper;
  }


 double percent =0.0;



  Future uploadMultipleImage(List multipartImageList , Function updatePercentage, double percentage) async {
    List<MultipartFile> multipart = <MultipartFile>[];

    print("uploadMultiple $multipartImageList");

    for (File asset in multipartImageList) {
      var dateTime = DateTime.now().millisecondsSinceEpoch;
      var multipartFile = await MultipartFile.fromFile(
        asset.path,
        filename: asset.path.toString(),
        contentType: MediaType("image", "jpg"),
      );
      multipart.add(multipartFile);
    }

    var formData = FormData.fromMap({
      "files": multipart,
    });

    var dio = Dio();

    dio.options.baseUrl = ApiConstants.baseUrl;
    dio.options.connectTimeout = 30000;
    dio.options.receiveTimeout = 30000;

    var uploadUrl = ApiConstants.imageUpload;

    Constants.printValue("API REQUEST :" + ApiConstants.imageUpload);
    try {
      var apiResponse = await dio.post(uploadUrl, data: formData,
          onSendProgress: (int sent, int total) {
            percentage = sent / total * 100;
            //percentage = sent / total;
            percent = percentage;

        print('http progress: $percent');
        updatePercentage(percent);
      });

      if (apiResponse.statusCode == 200) {
        print("STATUS CODE" + apiResponse.statusCode.toString());
        print("MESSAGE BODY" + apiResponse.toString());
        return apiResponse.data;
      } else {
        print("error");
        return null;
      }
    } catch (e) {
      print("exception : $e");
    }
  }
}

import 'package:multi_image_picker/models/image_upload_model.dart';
import 'http_helper.dart';

class ApiHelper {
  static final ApiHelper getInstance = ApiHelper._internal();

  ApiHelper._internal();

  factory ApiHelper() {
    return getInstance;
  }

  final HttpHelper httpHelper = HttpHelper();

  Future<ImageUploadModel> uploadImage(imageList ,  Function updatePercentage, double percentage) async {
    final result = await httpHelper.uploadMultipleImage(imageList,updatePercentage,percentage);
    if (result == null) {
      return Future.error("Failed to upload images on server");
    }
    return ImageUploadModel.fromJson(result);
  }
}

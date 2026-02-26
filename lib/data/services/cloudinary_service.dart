import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';

class CloudinaryService extends GetConnect implements GetxService {
  static const String cloudName = 'dumjy6p5e'; // Cloud Name của Minh
  static const String uploadPreset = 'ecomerce_preset'; // Preset Minh đã tạo
  static const String apiKey = '335696913515213';
  static const String apiSecret = 'ohKoXC8hdmdWypQxceMJyjzqQDg';

  late Cloudinary cloudinary;

  @override
  void onInit() {
    super.onInit();
    cloudinary = Cloudinary.fromCloudName(cloudName: cloudName);
    CloudinaryContext.cloudinary = cloudinary;
  }

  /// Upload đơn lẻ với trình theo dõi tiến độ
  // Trong file CloudinaryService.dart

  Future<String?> uploadImage({
    required Uint8List fileBytes,
    required String fileName,
    required String folder,
    String? publicId,
    Function(double)? onProgress,
  }) async {
    try {
      // 1. Làm sạch folder: Xóa dấu / ở đầu và cuối nếu có để nối chuỗi chuẩn xác
      // Ví dụ: folder truyền vào là '/categories/ID' -> sẽ thành 'categories/ID'
      final String cleanFolder = folder.startsWith('/')
          ? folder.substring(1)
          : folder;

      // 2. Tạo đường dẫn tuyệt đối bắt đầu từ folder gốc 'ecomerce'
      final String finalPath = 'ecomerce/$cleanFolder';

      final form = FormData({
        'file': MultipartFile(fileBytes, filename: fileName),
        'upload_preset': uploadPreset,
        'folder': finalPath, // Kết quả chắc chắn là 'ecomerce/categories/UUID'
      });

      final response = await post(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
        form,
        uploadProgress: (progress) {
          if (onProgress != null) onProgress(progress);
        },
      );

      if (!response.hasError && response.statusCode == 200) {
        // Trả về public_id đầy đủ bao gồm cả folder để lưu vào Firestore
        return response.body['public_id'];
      }
      return null;
    } catch (e) {
      print("Cloudinary Error: $e");
      return null;
    }
  }

  /// Upload nhiều ảnh với tiến độ tổng hợp
  Future<List<String>> uploadMultipleImages({
    required List<Uint8List> filesBytes,
    required List<String> fileNames,
    required String folder,
    Function(double)? onTotalProgress, // Tiến độ tổng của cả mảng ảnh
  }) async {
    List<String> uploadedIds = [];
    int totalFiles = filesBytes.length;

    // Mảng lưu trữ tiến độ của từng file
    List<double> individualProgress = List.filled(totalFiles, 0.0);

    List<Future<String?>> uploadTasks = [];

    for (int i = 0; i < totalFiles; i++) {
      print(i);
      uploadTasks.add(
        uploadImage(
          fileBytes: filesBytes[i],
          fileName: fileNames[i],
          folder: folder,
        ),
      );
    }

    List<String?> results = await Future.wait(uploadTasks);
    return results.whereType<String>().toList();
  }

  /// Hàm xóa nhiều ảnh cùng lúc trên Cloudinary
  Future<bool> deleteImages(List<String> publicIds) async {
    if (publicIds.isEmpty) return true;

    try {
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}';

      // Gọi API xóa tài nguyên của Cloudinary
      final response = await post(
        'https://api.cloudinary.com/v1_1/$cloudName/resources/image/upload',
        {'public_ids': publicIds},
        headers: {
          'Authorization': basicAuth,
          'Content-Type': 'application/json',
        },
      );

      if (!response.hasError && response.statusCode == 200) {
        print('Đã xóa các ảnh trên Cloudinary: $publicIds');
        return true;
      } else {
        print('Lỗi khi xóa ảnh Cloudinary: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Lỗi ngoại lệ khi xóa ảnh: $e');
      return false;
    }
  }
}

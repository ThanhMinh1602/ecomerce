import 'dart:convert';
import 'dart:typed_data';
// Ẩn các class của GetX trùng tên với Dio
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import 'package:dio/dio.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';

class CloudinaryService extends GetxService {
  static const String cloudName = 'dumjy6p5e';
  static const String uploadPreset = 'ecomerce_preset';
  static const String apiKey = '335696913515213';
  static const String apiSecret = 'ohKoXC8hdmdWypQxceMJyjzqQDg';

  late Cloudinary cloudinary;
  late Dio dio;

  @override
  void onInit() {
    super.onInit();
    cloudinary = Cloudinary.fromCloudName(cloudName: cloudName);
    CloudinaryContext.cloudinary = cloudinary;

    // Khởi tạo cấu hình mặc định cho Dio
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        responseType: ResponseType.json,
      ),
    );
  }

  /// 1. UPLOAD ĐƠN LẺ VỚI DIO
  Future<String?> uploadImage({
    required Uint8List fileBytes,
    required String fileName,
    required String folder,
    Function(double)? onProgress,
  }) async {
    try {
      final String cleanFolder = folder.startsWith('/')
          ? folder.substring(1)
          : folder;
      final String finalPath = 'ecomerce/$cleanFolder';

      // Sử dụng FormData của Dio
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
        'upload_preset': uploadPreset,
        'folder': finalPath,
      });

      final response = await dio.post(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
        data: formData,
        onSendProgress: (int sent, int total) {
          if (onProgress != null && total > 0) {
            onProgress(sent / total);
          }
        },
      );

      if (response.statusCode == 200) {
        return response.data['public_id'];
      }
      return null;
    } on DioException catch (e) {
      print(
        "❌ Lỗi Dio Upload: ${e.response?.statusCode} - ${e.response?.data}",
      );
      return null;
    } catch (e) {
      print("❌ Ngoại lệ Upload: $e");
      return null;
    }
  }

  /// 2. UPLOAD NHIỀU ẢNH
  Future<List<String>> uploadMultipleImages({
    required List<Uint8List> filesBytes,
    required List<String> fileNames,
    required String folder,
  }) async {
    List<Future<String?>> uploadTasks = [];

    for (int i = 0; i < filesBytes.length; i++) {
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

  Future<bool> deleteFolder(String folderPath) async {
    try {
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}';
      final options = Options(headers: {'Authorization': basicAuth});

      final String resourceUrl =
          'https://cors-anywhere.herokuapp.com/https://api.cloudinary.com/v1_1/$cloudName/resources/image/upload?prefix=$folderPath';

      final resourceRes = await dio.delete(resourceUrl, options: options);

      if (resourceRes.statusCode != 200 && resourceRes.statusCode != 404) {
        print("❌ Lỗi xóa tài nguyên: ${resourceRes.data}");
        return false;
      }
      final String folderUrl =
          'https://cors-anywhere.herokuapp.com/https://api.cloudinary.com/v1_1/$cloudName/folders/$folderPath';
      final folderRes = await dio.delete(folderUrl, options: options);

      if (folderRes.statusCode == 200) {
        print('✅ Đã xóa sạch folder: $folderPath');
        return true;
      } else {
        print("❌ Lỗi xóa folder: ${folderRes.data}");
        return false;
      }
    } on DioException catch (e) {
      print("❌ Lỗi Dio Delete: Mã ${e.response?.statusCode}");
      print("❌ Chi tiết Server trả về: ${e.response?.data}");
      return false;
    } catch (e) {
      print('❌ Lỗi hệ thống: $e');
      return false;
    }
  }
}

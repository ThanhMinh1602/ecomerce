import 'package:ecomerce/modules/app/product_detail/controllers/product_detail_controller.dart';
import 'package:get/get.dart';

class ProductDetailBinding  extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> ProductDetailController());
  }
}
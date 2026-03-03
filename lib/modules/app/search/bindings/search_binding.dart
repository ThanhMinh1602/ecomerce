import 'package:ecomerce/modules/app/search/controllers/search_product_controller.dart';
import 'package:get/get.dart';

class SearchBinding extends Bindings{
  @override
  void dependencies() {
   Get.lazyPut(()=> SearchProductController());
  }

}
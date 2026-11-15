import 'package:get/get.dart';
import '../controllers/detail_controller.dart';
import '../models/character.dart';

class DetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DetailController(Get.arguments as Character));
  }
}

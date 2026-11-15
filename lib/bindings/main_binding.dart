import 'package:get/get.dart';
import '../controllers/character_controller.dart';
import '../controllers/episode_controller.dart';
import '../controllers/navigation_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavigationController());
    Get.lazyPut(() => CharacterController());
    Get.lazyPut(() => EpisodeController());
  }
}

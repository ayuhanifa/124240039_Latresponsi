import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/favorite_controller.dart';

// Dipakai di seluruh aplikasi (login, home, detail, favorite)
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.put(FavoriteController(), permanent: true);
  }
}

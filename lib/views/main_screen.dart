import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/navigation_controller.dart';
import 'episode_screen.dart';
import 'favorite_screen.dart';
import 'home_screen.dart';

class MainScreen extends GetView<NavigationController> {
  const MainScreen({super.key});

  static const List<String> _titles = ["Rick & Morty", "Favorites", "Episodes"];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: Text(_titles[controller.currentIndex]),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: "Logout",
              onPressed: () => Get.find<AuthController>().logout(),
            ),
          ],
        ),
        
        body: IndexedStack(
          index: controller.currentIndex,
          children: const [HomeScreen(), FavoriteScreen(), EpisodeScreen()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex,
          onTap: controller.changeIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: "Characters",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favorites",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_circle),
              label: "Episodes",
            ),
          ],
        ),
      );
    });
  }
}

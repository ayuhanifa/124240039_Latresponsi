import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';
import '../widgets/character_tile.dart';

class FavoriteScreen extends GetView<FavoriteController> {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.favorites.isEmpty) {
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.favorite_border, size: 64, color: Colors.grey),
              SizedBox(height: 12),
              Text("Belum ada karakter favorite"),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: controller.favorites.length,
        itemBuilder: (context, index) {
          final character = controller.favorites[index];

          // Swipe ke kiri untuk menghapus dari favorite
          return Dismissible(
            key: ValueKey(character.id),
            direction: DismissDirection.endToStart,
            background: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              padding: const EdgeInsets.only(right: 20),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) => controller.removeFavorite(character),
            child: CharacterTile(
              character: character,
              trailing: const Icon(Icons.favorite, color: Colors.red),
            ),
          );
        },
      );
    });
  }
}

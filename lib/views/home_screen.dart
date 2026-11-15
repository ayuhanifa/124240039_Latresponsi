import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/character_controller.dart';
import '../controllers/favorite_controller.dart';
import '../widgets/character_tile.dart';
import '../widgets/error_view.dart';

class HomeScreen extends GetView<CharacterController> {
  const HomeScreen({super.key});

  // label di UI : nilai untuk query API
  static const Map<String, String> _filters = {
    "All": "",
    "Alive": "alive",
    "Dead": "dead",
    "Unknown": "unknown",
  };

  @override
  Widget build(BuildContext context) {
    final favoriteController = Get.find<FavoriteController>();

    return Column(
      children: [
        // Bonus: pencarian karakter berdasarkan nama
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: TextField(
            onChanged: (value) => controller.searchQuery.value = value,
            decoration: InputDecoration(
              hintText: "Cari karakter...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),

        // Filter status
        SizedBox(
          height: 48,
          child: Obx(() {
            return ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: _filters.entries.map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter.key),
                    selected: controller.selectedStatus == filter.value,
                    onSelected: (_) => controller.changeStatus(filter.value),
                  ),
                );
              }).toList(),
            );
          }),
        ),

        // Daftar karakter
        Expanded(
          child: Obx(() {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage.isNotEmpty) {
              return ErrorView(
                message: controller.errorMessage,
                onRetry: controller.retrieveData,
              );
            }

            if (controller.characters.isEmpty) {
              return const Center(child: Text("Karakter tidak ditemukan"));
            }

            return ListView.builder(
              controller: controller.scrollController,
              itemCount:
                  controller.characters.length +
                  (controller.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == controller.characters.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final character = controller.characters[index];

                return CharacterTile(
                  character: character,
                  // Obx di sini supaya icon langsung berubah saat favorite berubah
                  trailing: Obx(() {
                    final isFavorite = favoriteController.isFavorite(
                      character.id,
                    );
                    return IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: () =>
                          favoriteController.toggleFavorite(character),
                    );
                  }),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}

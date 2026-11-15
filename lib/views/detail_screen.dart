
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/detail_controller.dart';
import '../controllers/favorite_controller.dart';
import '../utils/status_color.dart';

class DetailScreen extends GetView<DetailController> {
  const DetailScreen({super.key});

  static const Color _blue = Color(0xFF1F5BFF);

  @override
  Widget build(BuildContext context) {
    final favoriteController = Get.find<FavoriteController>();

    return Obx(() {
      final character = controller.character;
      final isFavorite = favoriteController.isFavorite(character.id);

      return Scaffold(
        backgroundColor: const Color(0xFFDCE7F8),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFD6E4FA),
                Color(0xFFF1EAFB),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 950),
                  child: Container(
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x20000000),
                          blurRadius: 30,
                          offset: Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (controller.isLoading)
                          const LinearProgressIndicator(minHeight: 3),

                        // HEADER
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () => Get.back(),
                                icon: const Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 20,
                                ),
                              ),
                              const Text(
                                "Character Details",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    favoriteController.toggleFavorite(character),
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite
                                      ? Colors.red
                                      : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // RESPONSIVE CONTENT
                        Padding(
                          padding: const EdgeInsets.all(28),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final isDesktop =
                                  constraints.maxWidth > 600;

                              final photo = _buildPhoto(
                                character.image,
                                isDesktop ? 300 : 210,
                                isDesktop ? 360 : 250,
                              );

                              final information = _buildInformation(
                                character,
                              );

                              if (isDesktop) {
                                return Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Center(child: photo),
                                    ),
                                    const SizedBox(width: 40),
                                    Expanded(
                                      flex: 6,
                                      child: information,
                                    ),
                                  ],
                                );
                              }

                              return Column(
                                children: [
                                  photo,
                                  const SizedBox(height: 26),
                                  information,
                                ],
                              );
                            },
                          ),
                        ),

                        // FAVORITE BUTTON
                        Padding(
                          padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
                          child: SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor:
                                    isFavorite ? Colors.red : _blue,
                                foregroundColor: Colors.white,
                                shape: const StadiumBorder(),
                              ),
                              onPressed: () => favoriteController
                                  .toggleFavorite(character),
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                              ),
                              label: Text(
                                isFavorite
                                    ? "Hapus dari Favorite"
                                    : "Tambah ke Favorite",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  // FOTO KARAKTER
  Widget _buildPhoto(String image, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.network(
          image,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade200,
              child: const Icon(
                Icons.broken_image,
                size: 60,
                color: Colors.grey,
              ),
            );
          },
        ),
      ),
    );
  }

  // INFORMASI KARAKTER
  Widget _buildInformation(dynamic character) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          character.name,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xFF20243A),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          character.species,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black45,
          ),
        ),
        const SizedBox(height: 24),

        Row(
          children: [
            _stat(
              character.status,
              "Status",
              valueColor: statusColor(character.status),
            ),
            _stat(character.gender, "Gender"),
            _stat("#${character.id}", "ID"),
          ],
        ),

        const SizedBox(height: 26),

        const Text(
          "About Character",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),

        Text(
          "${character.name} is a ${character.species} "
          "from ${character.origin}, last seen in "
          "${character.location}.",
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
            color: Colors.black54,
          ),
        ),

        const SizedBox(height: 22),

        const Text(
          "Character Details",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        _detailRow(
          Icons.public,
          "Origin",
          character.origin,
        ),
        _detailRow(
          Icons.location_on_outlined,
          "Location",
          character.location,
        ),
        _detailRow(
          Icons.pets,
          "Species",
          character.species,
        ),
        _detailRow(
          Icons.wc,
          "Gender",
          character.gender,
        ),
      ],
    );
  }

  Widget _stat(String value, String label, {Color? valueColor}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value.isEmpty ? "-" : value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: valueColor ?? Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: _blue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value.isEmpty ? "-" : value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

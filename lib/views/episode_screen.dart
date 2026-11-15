import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/episode_controller.dart';
import '../widgets/error_view.dart';

class EpisodeScreen extends GetView<EpisodeController> {
  const EpisodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.isNotEmpty) {
        return ErrorView(
          message: controller.errorMessage,
          onRetry: controller.retrieveData,
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: controller.episodes.length,
        itemBuilder: (context, index) {
          final episode = controller.episodes[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: ListTile(
              title: Text(
                episode.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(episode.airDate),
            ),
          );
        },
      );
    });
  }
}

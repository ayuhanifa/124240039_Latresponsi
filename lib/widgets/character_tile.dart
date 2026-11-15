import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/character.dart';
import '../utils/status_color.dart';

class CharacterTile extends StatelessWidget {
  final Character character;
  final Widget? trailing;

  const CharacterTile({super.key, required this.character, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage(character.image),
        ),
        title: Text(
          character.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Row(
          children: [
            Icon(Icons.circle, size: 10, color: statusColor(character.status)),
            const SizedBox(width: 6),
            Text(character.status),
          ],
        ),
        trailing: trailing,
        onTap: () {
          Get.toNamed("/detail", arguments: character);
        },
      ),
    );
  }
}

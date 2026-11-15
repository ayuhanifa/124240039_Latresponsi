import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/character.dart';

class FavoriteController extends GetxController {
  static const String _key = 'favorites';

  // Simpan variable state
  final RxList<Character> _favorites = <Character>[].obs;

  List<Character> get favorites => _favorites;

  @override
  void onInit() {
    _loadFavorites();
    super.onInit();
  }

  // Baca data favorite dari Shared Preferences
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_key) ?? [];

    _favorites.assignAll(
      saved.map((item) => Character.fromJson(jsonDecode(item))).toList(),
    );
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      _favorites.map((c) => jsonEncode(c.toJson())).toList(),
    );
  }

  bool isFavorite(int id) {
    return _favorites.any((c) => c.id == id);
  }

  void _showMessage(String message) {
    Get.snackbar(
      "Favorite",
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 2),
    );
  }

  // Tambah kalau belum favorite, hapus kalau sudah
  Future<void> toggleFavorite(Character character) async {
    if (isFavorite(character.id)) {
      await removeFavorite(character);
    } else {
      _favorites.add(character);
      _showMessage("${character.name} ditambahkan ke favorite");
      await _saveFavorites();
    }
  }

  Future<void> removeFavorite(Character character) async {
    _favorites.removeWhere((c) => c.id == character.id);
    _showMessage("${character.name} dihapus dari favorite");
    await _saveFavorites();
  }
}

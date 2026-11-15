import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/character.dart';
import '../services/api_service.dart';

class CharacterController extends GetxController {
  final _characterService = CharacterService();

  final ScrollController scrollController = ScrollController();

  // Simpan variable state
  final RxList<Character> _characters = <Character>[].obs;
  final RxBool _isLoading = false.obs;
  final RxBool _isLoadingMore = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxString _selectedStatus = ''.obs; // '' = semua status
  final RxString searchQuery = ''.obs;

  int _page = 1;
  bool _hasNext = true;
  int _requestId = 0; // supaya response lama tidak menimpa response baru

  List<Character> get characters => _characters;
  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  String get errorMessage => _errorMessage.value;
  String get selectedStatus => _selectedStatus.value;

  @override
  void onInit() {
    retrieveData();

    // Pencarian jalan 500ms setelah user berhenti mengetik
    debounce(
      searchQuery,
      (_) => retrieveData(),
      time: const Duration(milliseconds: 500),
    );

    // Load halaman berikutnya saat scroll mendekati bawah
    scrollController.addListener(() {
      if (!scrollController.hasClients) return;
      final position = scrollController.position;
      if (position.pixels >= position.maxScrollExtent - 200) {
        loadMore();
      }
    });

    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> retrieveData() async {
    final currentRequest = ++_requestId;

    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      _page = 1;

      final data = await _characterService.fetchCharacters(
        page: _page,
        status: _selectedStatus.value,
        name: searchQuery.value.trim(),
      );
      if (currentRequest != _requestId) return;

      _characters.assignAll(data.characters);
      _hasNext = data.hasNext;
    } catch (e) {
      if (currentRequest != _requestId) return;

      _characters.clear();
      _errorMessage.value = "Gagal memuat data. Periksa koneksi internet kamu.";
    } finally {
      if (currentRequest == _requestId) _isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (_isLoading.value || _isLoadingMore.value || !_hasNext) return;
    final currentRequest = _requestId;

    try {
      _isLoadingMore.value = true;

      final data = await _characterService.fetchCharacters(
        page: _page + 1,
        status: _selectedStatus.value,
        name: searchQuery.value.trim(),
      );
      if (currentRequest != _requestId) return;

      _page++;
      _characters.addAll(data.characters);
      _hasNext = data.hasNext;
    } catch (e) {
      // Gagal load halaman berikutnya: biarkan data yang sudah ada
    } finally {
      _isLoadingMore.value = false;
    }
  }

  void changeStatus(String status) {
    if (_selectedStatus.value == status) return;
    _selectedStatus.value = status;
    retrieveData();
  }
}

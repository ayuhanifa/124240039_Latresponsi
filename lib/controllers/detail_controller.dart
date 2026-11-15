import 'package:get/get.dart';
import '../models/character.dart';
import '../services/api_service.dart';

class DetailController extends GetxController {
  DetailController(Character initial) : _character = initial.obs;

  final _characterService = CharacterService();

  // Awalnya diisi data dari list, lalu diperbarui dari /character/{id}
  final Rx<Character> _character;
  final RxBool _isLoading = false.obs;

  Character get character => _character.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    _retrieveData();
    super.onInit();
  }

  Future<void> _retrieveData() async {
    try {
      _isLoading.value = true;

      final data = await _characterService.fetchCharacterDetail(
        _character.value.id,
      );
      _character.value = data;
    } catch (e) {
      // Kalau gagal, tetap tampilkan data dari list
    } finally {
      _isLoading.value = false;
    }
  }
}

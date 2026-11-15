import 'package:get/get.dart';
import '../models/episode.dart';
import '../services/api_service.dart';

class EpisodeController extends GetxController {
  final _episodeService = EpisodeService();

  // Simpan variable state
  final RxList<Episode> _episodes = <Episode>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  List<Episode> get episodes => _episodes;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    retrieveData();
    super.onInit();
  }

  Future<void> retrieveData() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // API membagi episode per halaman, jadi ambil semua halaman
      final all = <Episode>[];
      int page = 1;
      bool hasNext = true;

      while (hasNext) {
        final data = await _episodeService.fetchEpisodes(page: page);
        all.addAll(data.episodes);
        hasNext = data.hasNext;
        page++;
      }

      _episodes.assignAll(all);
    } catch (e) {
      _episodes.clear();
      _errorMessage.value = "Gagal memuat episode. Periksa koneksi internet kamu.";
    } finally {
      _isLoading.value = false;
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';
import '../models/episode.dart';

class CharacterService {
  static const String _host = "rickandmortyapi.com";

  // GET /character?page=1&status=alive&name=rick
  Future<CharacterPage> fetchCharacters({
    int page = 1,
    String status = '',
    String name = '',
  }) async {
    final params = <String, String>{'page': '$page'};
    if (status.isNotEmpty) params['status'] = status;
    if (name.isNotEmpty) params['name'] = name;

    final url = Uri.https(_host, '/api/character', params);
    final response = await http.get(url);

    // API ngembaliin 404 kalau hasil filter/pencarian kosong
    if (response.statusCode == 404) {
      return CharacterPage(characters: [], hasNext: false);
    }
    if (response.statusCode != 200) {
      throw Exception("Gagal mengambil data (${response.statusCode})");
    }

    final result = jsonDecode(response.body);
    final List<dynamic> characters = result['results'];
    return CharacterPage(
      characters: characters.map((c) => Character.fromJson(c)).toList(),
      hasNext: result['info']['next'] != null,
    );
  }

  // GET /character/{id}
  Future<Character> fetchCharacterDetail(int id) async {
    final url = Uri.https(_host, '/api/character/$id');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Gagal mengambil detail (${response.statusCode})");
    }
    return Character.fromJson(jsonDecode(response.body));
  }
}

class EpisodeService {
  static const String _host = "rickandmortyapi.com";

  // GET /episode?page=1
  Future<EpisodePage> fetchEpisodes({int page = 1}) async {
    final url = Uri.https(_host, '/api/episode', {'page': '$page'});
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Gagal mengambil episode (${response.statusCode})");
    }

    final result = jsonDecode(response.body);
    final List<dynamic> episodes = result['results'];
    return EpisodePage(
      episodes: episodes.map((e) => Episode.fromJson(e)).toList(),
      hasNext: result['info']['next'] != null,
    );
  }
}

class Episode {
  final int id;
  final String name;
  final String airDate;
  final String episode;

  Episode({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episode,
  });

  factory Episode.fromJson(Map<String, dynamic> jsonData) {
    return Episode(
      id: jsonData['id'],
      name: jsonData['name'] ?? '',
      airDate: jsonData['air_date'] ?? '',
      episode: jsonData['episode'] ?? '',
    );
  }
}

class EpisodePage {
  final List<Episode> episodes;
  final bool hasNext;

  EpisodePage({required this.episodes, required this.hasNext});
}

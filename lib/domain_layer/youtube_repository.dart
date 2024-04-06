import 'package:youtube/data_layer/data_layer.dart';

class YoutubeRepository {
  final YoutubeApi _api;

  YoutubeRepository( {required YoutubeApi api}) : _api = api;

  Future<List<Video>> search(String query) async {
    final List<Video> videos = await _api.search(query);
    return videos;
  }

  Future<List<String>> getSuggestions(String query) async {
    if (query.isEmpty) {
      return [];
    } else {
      final List<String> suggestions = await _api.suggestions(query);
      return suggestions;
    }
  }
}

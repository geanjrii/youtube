import 'dart:convert';

import 'package:http/http.dart' as http;

import 'model/video.dart';

class YoutubeApi {
  final http.Client _client;

  YoutubeApi({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Video>> search(String query) async {
    const youtubeApiKey = 'AIzaSyDciO4Qgsrn6bp3-QERtEC_DZa-Epk7r9g';
    const chanelId = 'UCVHFbqXqoYvEWM1Ddxl0QDg';
    const baseUrl = 'https://www.googleapis.com/youtube/v3/';
    final url =
        '${baseUrl}search?part=snippet&type=video&maxResults=20&order=date&key=$youtubeApiKey&chanelId=$chanelId&q=$query';
    final uri = Uri.parse(url);
    final response = await _client.get(uri);

    if (response.statusCode != 200) throw SearchRequestFailure();

    final dadosJson = jsonDecode(response.body) as Map<String, dynamic>;

    if (!dadosJson.containsKey('items')) throw SearchNotFoundFailure();

    final List<Video> videos = dadosJson['items'].map<Video>((map) {
      return Video.fromJson(map);
    }).toList();

    // if (videos.isEmpty) throw SearchNotFoundFailure();
    return videos;
  }

  Future<List<String>> suggestions(String query) async {
    final url =
        "http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$query&format=5&alt=json";
    final Uri uri = Uri.parse(url);
    final response = await _client.get(uri);

    if (response.statusCode != 200) throw SuggestionsRequestFailure();

    final dadosJson = jsonDecode(response.body);

    if (dadosJson.isEmpty) throw SuggestionsNotFoundFailure();

    final ret = dadosJson[1].map<String>((v) {
      return v[0] as String;
    }).toList();

    return ret;
  }
}

class SearchRequestFailure implements Exception {}

class SearchNotFoundFailure implements Exception {}

class SuggestionsRequestFailure implements Exception {}

class SuggestionsNotFoundFailure implements Exception {}

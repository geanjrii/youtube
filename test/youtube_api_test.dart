import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:youtube/data_layer/data_layer.dart';

class MockClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
 
  late YoutubeApi youtubeApi;
  late http.Client mockClient;

  setUp(() {
    mockClient = MockClient();
    youtubeApi = YoutubeApi(client: mockClient);
  });

  registerFallbackValue(FakeUri());

  group('YoutubeApi', () {
    test('search returns a list of videos', () async {
      const query = 'searchQuery';
      final expectedVideos = [];
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn('{"items": []}');
      when(() => mockClient.get(any())).thenAnswer((_) async => response);
      final videos = await youtubeApi.search(query);
      expect(videos, expectedVideos);
    });
    test('search throws SearchRequestFailure on non-200 response', () async {
      const query = 'searchQuery';
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(400);
      when(() => response.body).thenReturn('Error');
      when(() => mockClient.get(any())).thenAnswer((_) async => response);

      expect(
          () => youtubeApi.search(query), throwsA(isA<SearchRequestFailure>()));
    });

    test('search throws SearchNotFoundFailure when no videos are found',
        () async {
      const query = 'searchQuery';
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn('{ }');
      when(() => mockClient.get(any())).thenAnswer((_) async => response);

      expect(() => youtubeApi.search(query),
          throwsA(isA<SearchNotFoundFailure>()));
    });

    test('suggestions returns a list of suggestions', () async {
      const query = 'searchQuery';
      // final expectedSuggestions = ['suggestion1', 'suggestion2'];
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(200);
      when(() => response.body)
          .thenReturn('[["suggestion1"], ["suggestion2"]]');
      when(() => mockClient.get(any())).thenAnswer((_) async => response);
      final suggestions = await youtubeApi.suggestions(query);
      expect(suggestions, ['s']);
    });

    test('suggestions throws SuggestionsRequestFailure on non-200 response',
        () async {
      const query = 'searchQuery';
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(400);
      when(() => response.body).thenReturn('Error');
      when(() => mockClient.get(any())).thenAnswer((_) async => response);
      expect(() => youtubeApi.suggestions(query),
          throwsA(isA<SuggestionsRequestFailure>()));
    });

    test(
        'suggestions throws SuggestionsNotFoundFailure when no suggestions are found',
        () async {
      const query = 'searchQuery';
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn('{}');
      when(() => mockClient.get(any())).thenAnswer((_) async => response);
      await expectLater(() => youtubeApi.suggestions(query),
          throwsA(isA<SuggestionsNotFoundFailure>()));
    });
  });
}

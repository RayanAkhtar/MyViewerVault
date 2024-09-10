import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MovieList {
  final String _apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
  final String _baseUrl = 'https://api.themoviedb.org/3';

  /// Fetches a list of random movies
  Future<List<Map<String, dynamic>>> getRandomMovies(int count) async {
    List<Map<String, dynamic>> movies = [];
    int totalPages = await _getTotalPages();

    while (movies.length < count) {
      int randomPage = _getRandomPage(totalPages);
      List<Map<String, dynamic>> pageMovies = await _fetchMoviesFromPage(randomPage);

      movies.addAll(pageMovies);

      if (movies.length > count) {
        movies = movies.sublist(0, count);
      }
    }

    return movies;
  }

  /// Gets the total number of pages for popular movies
  Future<int> _getTotalPages() async {
    final url = Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Get the total pages, ensuring it does not exceed 500
      int totalPages = data['total_pages'] ?? 1;
      return totalPages > 500 ? 500 : totalPages; // Cap at 500
    } else {
      throw Exception('Failed to load movie pages count');
    }
  }

  /// Fetches movies from a specific page
  Future<List<Map<String, dynamic>>> _fetchMoviesFromPage(int page) async {
    final url = Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&page=$page');
    print("Fetching from URL: $url");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List<dynamic>;
      return results.map((movie) => movie as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  /// Returns a random page number within the total pages available
  int _getRandomPage(int totalPages) {
    final random = Random();
    // Generate a page number between 1 and the total number of pages
    return random.nextInt(totalPages) + 1;
  }
}

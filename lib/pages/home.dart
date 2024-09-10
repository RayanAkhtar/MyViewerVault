// home_page.dart
import 'package:flutter/material.dart';
import '../backend/MovieList.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MovieList _movieList = MovieList();
  List<Map<String, dynamic>> _featuredMovies = [];
  bool _isLoading = true;
  bool _isOverlayVisible = false;

  @override
  void initState() {
    super.initState();
    _fetchFeaturedMovies();
  }

  Future<void> _fetchFeaturedMovies() async {
    try {
      final movies = await _movieList.getRandomMovies(50);
      setState(() {
        _featuredMovies = movies.take(10).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching movies: $e');
    }
  }

  void _showOverlay(BuildContext context) {
    setState(() {
      _isOverlayVisible = true;
    });
  }

  void _hideOverlay() {
    setState(() {
      _isOverlayVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(170, 58, 175, 185),
        title: const Center(child: Text('Home Page')),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => _showOverlay(context),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Featured Today',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _featuredMovies.length,
                  itemBuilder: (context, index) {
                    final movie = _featuredMovies[index];
                    return MovieCard(movie: movie);
                  },
                ),
              ),
            ],
          ),
          if (_isOverlayVisible)
            Positioned.fill(
              child: GestureDetector(
                onTap: _hideOverlay,
                child: Container(
                  color: Colors.black.withOpacity(0.8),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _featuredMovies.map((movie) {
                          return MovieCard(
                            movie: movie,
                            showFullText: true, // To display text fully in the overlay
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Map<String, dynamic> movie;
  final bool showFullText;

  const MovieCard({Key? key, required this.movie, this.showFullText = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  color: Colors.grey,
                  child: Icon(Icons.broken_image, color: Colors.white),
                );
              },
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            movie['title'] ?? 'No Title',
            maxLines: showFullText ? null : 1, // Limit to 1 line unless in overlay
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

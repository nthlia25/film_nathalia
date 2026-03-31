import 'dart:convert';

import 'package:film_nathalia/models/movie.dart';
import 'package:film_nathalia/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritScreen extends StatefulWidget {
  const FavoritScreen({super.key});

  @override
  State<FavoritScreen> createState() => _FavoritScreenState();
}

class _FavoritScreenState extends State<FavoritScreen> {
  List<Movie> _favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteMovies();
  }


  Future<void> _loadFavoriteMovies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //final List<String> favoriteMovieIds = prefs.getKeys().where((key) => key.startsWith('movie_')).toList();
    final List<String> favoriteMovieIds =
        prefs.getStringList('favoriteMovies') ?? [];


    //print('favoriteMovieIds: $favoriteMovieIds');
    setState(() {
      _favoriteMovies = favoriteMovieIds
          .map((id) {
            //final String? movieJson = prefs.getString(id);
            final String? movieJson = prefs.getString('movie_$id');
            if (movieJson != null && movieJson.isNotEmpty) {
              final Map<String, dynamic> movieData = jsonDecode(movieJson);
              return Movie.fromJson(movieData);
            }
            return null;
          })
          .where((movie) => movie != null)
          .cast<Movie>()
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit Movies'),
      ),
      body: ListView.builder(
        itemCount: _favoriteMovies.length,
        itemBuilder: (context, index) {
          final movie = _favoriteMovies[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.network(
                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
              title: Text(movie.title),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(movie: movie),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
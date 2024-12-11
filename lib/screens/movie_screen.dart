// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:ambient/services/tmdb_services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  //dependencies
  final TmdbServices _tmdbServices = TmdbServices();
  List<dynamic> movies = [];
  Color backgroundColor = Colors.black;
  Color secondaryColor = Colors.black;

  @override
  void initState() {
    super.initState();

    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final fetchedMovies = await _tmdbServices.fetchMovies();
    setState(() {
      movies = fetchedMovies;
    });
  }

  Future<void> updateBackaground(String imageUrl) async {
    final palletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(imageUrl),
    );
    setState(() {
      backgroundColor = palletteGenerator.dominantColor?.color ?? Colors.black;
      secondaryColor = palletteGenerator.lightMutedColor?.color ?? Colors.grey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            // Animated background with a gradient
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [backgroundColor, secondaryColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            movies.isEmpty
                ? Center(child: CircularProgressIndicator())
                : CarouselSlider.builder(
                    itemCount: movies.length,
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * 0.8,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) => updateBackaground(
                          'https://image.tmdb.org/t/p/w500${movies[index]['poster_path']}'),
                    ),
                    itemBuilder: (context, index, _) {
                      final movie = movies[index];
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 70,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                                height: 450,
                                width: 450,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            Text(
                              movie['title'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ));
  }
}
        
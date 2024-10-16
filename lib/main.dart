import 'package:flutter/material.dart';
import 'package:music_player/entry.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';

void main() {
  final credentials = SpotifyApiCredentials('e15417e560d241c5ae9d0f5054f288be', '86ddcaa5813f4380ab4781c01df2bb02');
  final spotify = SpotifyApi(credentials);
  runApp(
    ChangeNotifierProvider(
      create: (context) => PlaylistProvider(spotify),
      child: const MyApp(), // Wrap your app with ChangeNotifierProvider here
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Music Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(), // Assuming MainPage is the entry point
    );
  }
}

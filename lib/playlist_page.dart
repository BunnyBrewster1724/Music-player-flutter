import 'package:flutter/material.dart';
import 'package:music_player/models/music.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:music_player/music_player.dart';  // Ensure the correct import
import 'package:music_player/widgets/drawer_details.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(227, 127, 166, 210),
      appBar: AppBar(title: const Text("PLAYLIST")),
      drawer: const DrawerDetails(),
      body: Consumer<PlaylistProvider>(
        builder: (context, playlistProvider, child) {
          final List<Music> playlist = playlistProvider.playlist;

          if (playlist.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: playlist.length,
            itemBuilder: (context, index) {
              final Music song = playlist[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: song.songImage != null
                      ? NetworkImage(song.songImage!)
                      : const AssetImage("assets/default_image.png")
                          as ImageProvider,
                ),
                title: Text(song.songName ?? "Unknown Song"),
                subtitle: Text(song.artistName ?? "Unknown Artist"),
                onTap: () {
                  // Navigate to MusicPlayer with selected song
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MusicPlayer(music: song),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

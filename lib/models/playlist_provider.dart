import 'package:flutter/material.dart';
import 'package:music_player/models/music.dart';
import 'package:spotify/spotify.dart';  // Spotify API integration

class PlaylistProvider extends ChangeNotifier {
  final List<Music> _playlist = [
    Music(trackId: "4XOmIkNOkZn9aDgPukPAfl"), // Song 1
    Music(trackId: "7epv5ZjPcVVzLkb4bPj4F5"), // Song 2
    Music(trackId: "4GyOg0iHTbEik4LCZu6RQz"), // Song 3
    Music(trackId: "6TSZWeAfnenO6uRlmXSVLy")  // Song 4
  ];

  int? _currentSongIndex;  // current song playing index

  final SpotifyApi spotify;

  PlaylistProvider(this.spotify) {
    _fetchPlaylistDetails();
  }

  List<Music> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;

  // Fetch song details using Spotify API
  Future<void> _fetchPlaylistDetails() async {
    for (int i = 0; i < _playlist.length; i++) {
      final track = await spotify.tracks.get(_playlist[i].trackId);
      _playlist[i].songName = track.name;
      _playlist[i].artistName = track.artists?.first.name ?? 'Unknown Artist';
      _playlist[i].songImage = track.album?.images?.first.url;
      _playlist[i].artistImage = track.artists?.first.images?.first.url ?? "";
    }
    notifyListeners();
  }

  // Function to set the current song
  void setCurrentSong(int index) {
    _currentSongIndex = index;
    notifyListeners();
  }
}

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_player/constants/colors.dart';
import 'package:music_player/models/music.dart';
import 'package:music_player/playlist_page.dart';
import 'package:music_player/widgets/art_work.dart';
import 'package:music_player/widgets/lyrics_page.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class MusicPlayer extends StatefulWidget {
  final Music music;

  const MusicPlayer({super.key, required this.music});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final player = AudioPlayer();
  Duration? duration;

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchSongData();
  }

  Future<void> _fetchSongData() async {
    try {
      final yt = YoutubeExplode();
      final video = (await yt.search.search("${widget.music.songName} ${widget.music.artistName}")).first;
      final videoId = video.id.value;
      duration = video.duration;

      setState(() {});
      var manifest = await yt.videos.streamsClient.getManifest(videoId);
      var audioUrl = manifest.audioOnly.last.url;
      player.play(UrlSource(audioUrl.toString()));
    } catch (e) {
      print('Error fetching song data: $e');
    }
  }

  Future<Color?> getImagePalette(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor?.color;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: widget.music.songColor ?? Color.fromARGB(255, 60, 129, 214),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.close, color: Colors.transparent),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Playing now',
                        style: textTheme.bodyMedium?.copyWith(color: CustomColors.primaryColor),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: widget.music.artistImage != null
                                ? NetworkImage(widget.music.artistImage!)
                                : null,
                            radius: 10,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.music.artistName ?? "",
                            style: textTheme.bodyLarge?.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Icon(Icons.close, color: Colors.white),
                ],
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: ArtWorkImage(image: widget.music.songImage ?? ""),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.music.songName ?? "",
                              style: textTheme.titleLarge?.copyWith(color: Colors.white),
                              maxLines: null,
                              overflow: TextOverflow.visible,
                            ),
                            Text(
                              widget.music.artistName ?? "",
                              style: textTheme.titleMedium?.copyWith(color: Colors.white60),
                            ),
                          ],
                        ),
                        const Icon(Icons.favorite, color: CustomColors.primaryColor),
                      ],
                    ),
                    const SizedBox(height: 16),
                    StreamBuilder<Duration>(
                      stream: player.onPositionChanged,
                      builder: (context, snapshot) {
                        final currentDuration = snapshot.data ?? const Duration(seconds: 0);
                        final totalDuration = duration ?? const Duration(minutes: 4);

                        return ProgressBar(
                          progress: currentDuration,
                          total: totalDuration,
                          bufferedBarColor: Colors.white38,
                          baseBarColor: Colors.white10,
                          thumbColor: Colors.white,
                          timeLabelTextStyle: const TextStyle(color: Colors.white),
                          progressBarColor: Colors.white,
                          onSeek: (duration) {
                            player.seek(duration);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LyricsPage(music: widget.music, player: player),
                              ),
                            );
                          },
                          icon: const Icon(Icons.lyrics_outlined, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.skip_previous_outlined, color: Colors.white, size: 36),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (player.state == PlayerState.playing) {
                              await player.pause();
                            } else {
                              await player.resume();
                            }
                            setState(() {});
                          },
                          icon: Icon(
                            player.state == PlayerState.playing ? Icons.pause : Icons.play_circle,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.skip_next, color: Colors.white, size: 36),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.format_list_bulleted_outlined, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:music_player/models/lyric.dart';
import 'package:music_player/models/music.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class LyricsPage extends StatefulWidget {
  final Music music;
  final AudioPlayer player;

  const LyricsPage({super.key, required this.music, required this.player});

  @override
  State<LyricsPage> createState() => _LyricsPageState();
}

class _LyricsPageState extends State<LyricsPage> {
  List<Lyrics>? lyrics;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();
  StreamSubscription? streamSubscription;

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }
@override
void initState() {
  super.initState();

  // Listen for changes in audio player position
  streamSubscription = widget.player.onPositionChanged.listen((duration) {
    DateTime dt = DateTime(1970, 1, 1).copyWith(
        hour: duration.inHours,
        minute: duration.inMinutes.remainder(60),
        second: duration.inSeconds.remainder(60));

    // Scroll to the appropriate lyric line based on current position
    if (lyrics != null) {
      for (int index = 0; index < lyrics!.length; index++) {
        if (index > 4 && lyrics![index].timeStamp.isAfter(dt)) {
          itemScrollController.scrollTo(
              index: index - 3, duration: const Duration(milliseconds: 600));
          break;
        }
      }
    }
  });

  // Fetch lyrics using API
  _fetchLyrics();
}

Future<void> _fetchLyrics() async {
  final artistName = widget.music.artistName ?? 'Unknown Artist';
  final trackID = widget.music.trackId;

  try {
    final response = await http.get(Uri.parse(
        'https://paxsenixofc.my.id/server/getLyricsMusix.php?q=${Uri.encodeComponent(trackID)} ${Uri.encodeComponent(artistName)}&type=default'));

    if (response.statusCode == 200) {
      String data = response.body;
      if (kDebugMode) {
        print("API Response: $data");
      }

      // Check if the data is empty
      if (data.isEmpty) {
        print("No data received from API.");
        return;
      }

      // Try parsing the lyrics
      try {
        setState(() {
          lyrics = data
              .split('\n')
              .map((e) {
                var parts = e.split(' ');
                var timestamp = parts[0];
                var words = parts.sublist(1).join(' ');

                // Parse the timestamp
                return Lyrics(
                  words,
                  DateFormat("[mm:ss.SS]").parse(timestamp),
                );
              })
              .toList();
        });

        if (lyrics != null && lyrics!.isNotEmpty) {
          print("Lyrics parsed successfully.");
        } else {
          print("No lyrics found.");
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error parsing lyrics: $e");
        }
      }
    } else {
      if (kDebugMode) {
        print("Failed to load lyrics. Status code: ${response.statusCode}");
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error occurred: $e");
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.music.songColor,
      body: lyrics != null
          ? SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0)
                    .copyWith(top: 20),
                child: StreamBuilder<Duration>(
                    stream: widget.player.onPositionChanged,
                    builder: (context, snapshot) {
                      return ScrollablePositionedList.builder(
                        itemCount: lyrics!.length,
                        itemBuilder: (context, index) {
                          Duration duration =
                              snapshot.data ?? const Duration(seconds: 0);
                          DateTime dt = DateTime(1970, 1, 1).copyWith(
                              hour: duration.inHours,
                              minute: duration.inMinutes.remainder(60),
                              second: duration.inSeconds.remainder(60));
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              lyrics![index].words,
                              style: TextStyle(
                                color: lyrics![index].timeStamp.isAfter(dt)
                                    ? Colors.white38
                                    : Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                        itemScrollController: itemScrollController,
                        scrollOffsetController: scrollOffsetController,
                        itemPositionsListener: itemPositionsListener,
                        scrollOffsetListener: scrollOffsetListener,
                      );
                    }),
              ),
            )
          : const SizedBox(),
    );
  }
}

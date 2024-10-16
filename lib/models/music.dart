import 'package:flutter/material.dart';

class Music {
  Duration? duration;
  String? artistName;
  String? songName;
  String? songImage;
  String? artistImage;
  Color? songColor;
  String trackId;

  Music(
      { this.duration,
       this.artistName,
       this.songName,
       this.songImage,
       this.artistImage,
       this.songColor,
      required this.trackId});
}

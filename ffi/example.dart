import 'dart:async';
import 'dart:io';

import 'package:dart_vlc_ffi/dart_vlc_ffi.dart';

void main(List<String> args) {
  // Initialize the library.
  DartVLC.initialize(dynamicLibraryPath);

  // Create a new player. Provide an ID to handle multiple players.
  Player player = Player(
    id: 0,
    // Pass commandline VLC arguments.
    commandlineArguments: [],
  );

  // Listen to events on the player e.g. position, rate, volume etc.
  // Same can be accessed directly in the class without having to use the stream.

  player.generalStream.listen((event) {
    // Player's rate.
    print('Rate of the player is ${event.rate}');
    // Player's volume.
    print('Volume of the player is ${event.volume}');
  });

  player.positionStream.listen((event) {
    // Player's current media playback position.
    print('Position of the player is ${event.position}');
    // Player's current media playback duration.
    print('Duration of the player is ${event.duration}');
  });

  player.currentStream.listen((event) {
    // Index of the currently playing media.
    print('Current media index of the player is ${event.index}');
    // Currently playing media.
    print('Current playing media is ${event.media}');
    // All the medias in the playlist.
    print('Current playing media is ${event.medias}');
    // Whether current playback is a playlist or not.
    print('Current playing media is ${event.isPlaylist}');
  });

  player.playbackStream.listen((event) {
    print('isPlaying   :${event.isPlaying}');
    print('isSeekable  :${event.isSeekable}');
    print('isCompleted :${event.isCompleted}');
  });

  player.setRate(1.25);

  player.setVolume(1.0);

  // Create a new media using a URL.
  Media media = Media.network(
      Uri.parse(
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
      // Pass parse as true for accessing the metadata.
      parse: true);
  // Get media's metadata.
  print(media.metas);

  // Open the media into the player. You can also open a Playlist instead of a media.
  player.open(media);

  Timer(Duration(seconds: 10), () {
    // Alter playback rate.
    player.setRate(1.25);
    // Alter playback volume.
    player.setVolume(0.5);
  });

  Timer(Duration(seconds: 20), () {
    // Pause the player.
    player.pause();
    Timer(Duration(seconds: 2), () {
      // Resume the player.
      player.play();
    });
  });

  // A lot lot of other options like device enumeration & changing, equalizer, recording, broadcasting, chromecasting etc. are also available.
}

// Path to the dart_vlc.so
String get dynamicLibraryPath {
  String directory = Platform.script.path
      .split('/')
      .sublist(0, Platform.script.path.split('/').length - 1)
      .join('/');
  return '$directory/dart_vlc.so';
}

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicScreen extends StatefulWidget {
  static const routeName = '/music';

  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
 final List<Map<String, String>> _audios = [

  {'title': 'music1', 'file': 'assets/music1.mp3', 'image': 'assets/music1.jpg'},
  {'title': 'music2', 'file': 'assets/music2.mp3', 'image': 'assets/music2.jpg'},
  {'title': 'music3', 'file': 'assets/music3.mp3', 'image': 'assets/music3.jpg'},
  {'title': 'music4', 'file': 'assets/music4.mp3', 'image': 'assets/music4.jpg'},
  {'title': 'music5', 'file': 'assets/music5.mp3', 'image': 'assets/music5.jpg'},
  {'title': 'music6', 'file': 'assets/music6.mp3', 'image': 'assets/music6.jpg'},
  {'title': 'music7', 'file': 'assets/music7.mp3', 'image': 'assets/music7.jpg'},
  {'title': 'music8', 'file': 'assets/music8.mp3', 'image': 'assets/music8.jpg'},
  {'title': 'music9', 'file': 'assets/music9.mp3', 'image': 'assets/music9.jpg'},
  {'title': 'music10', 'file': 'assets/music10.mp3', 'image': 'assets/music10.jpg'},
];

  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentlyPlaying;

  void _playAudio(String filePath, String title) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(filePath));
    setState(() {
      _currentlyPlaying = title;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Music'),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: _audios.length,
        itemBuilder: (context, index) {
          final audio = _audios[index];
          return ListTile(
            leading: const Icon(Icons.music_note, color: Colors.white),
            title: Text(audio['title']!, style: const TextStyle(color: Colors.white)),
            subtitle: Text(
              _currentlyPlaying == audio['title']! ? 'Now Playing...' : '',
              style: const TextStyle(color: Colors.white70),
            ),
            onTap: () => _playAudio(audio['file']!, audio['title']!),
          );
        },
      ),
    );
  }
}

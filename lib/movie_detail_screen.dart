import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';


class MovieDetailScreen extends StatefulWidget {
  static const routeName = '/movie-detail';
  const MovieDetailScreen({Key? key}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late VideoPlayerController _controller;
  bool _showControls = false;
  Timer? _hideControlsTimer;
  bool _isInitialized = false;
  double _volume = 1.0;
  double _videoWidthFactor = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final movie = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      _controller = VideoPlayerController.asset(movie['video']!)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isInitialized = true;
              _showControls = true;
            });
            _controller.setVolume(_volume);
            _controller.play();
            _startHideTimer();
          }
        });
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) {
        _startHideTimer();
      } else {
        _hideControlsTimer?.cancel();
      }
    });
  }

  void _startHideTimer() {
    setState(() {
      _showControls = true;
    });
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
        _startHideTimer();
      }
    });
  }

  void _seekForward() {
    final position = _controller.value.position;
    final duration = _controller.value.duration;
    if (position + const Duration(seconds: 10) < duration) {
      _controller.seekTo(position + const Duration(seconds: 10));
    } else {
      _controller.seekTo(duration);
    }
    _startHideTimer();
  }

  void _seekBackward() {
    final position = _controller.value.position;
    if (position - const Duration(seconds: 10) > Duration.zero) {
      _controller.seekTo(position - const Duration(seconds: 10));
    } else {
      _controller.seekTo(Duration.zero);
    }
    _startHideTimer();
  }

  void _goFullscreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullscreenVideoPlayer(controller: _controller),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration position) {
    final minutes = position.inMinutes.remainder(60).toString().padLeft(1, '0');
    final seconds = position.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: MouseRegion(
        onHover: (details) {
          final size = MediaQuery.of(context).size;
          if (details.position.dy > size.height - 80) {
            _startHideTimer();
          }
        },
        child: Stack(
          children: [
            Center(
              child: _isInitialized
                  ? GestureDetector(
                      onTap: _toggleControls,
                      child: Stack(
                        children: [
                          FractionallySizedBox(
                            widthFactor: _videoWidthFactor,
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            ),
                          ),
                          if (_showControls)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.6),
                                      Colors.transparent,
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.6),
                                    ],
                                    stops: const [0.0, 0.3, 0.7, 1.0],
                                  ),
                                ),
                              ),
                            ),
                          if (_showControls)
                            Positioned.fill(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(height: 50),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.replay_10, size: 36, color: Colors.white),
                                        onPressed: _seekBackward,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          _controller.value.isPlaying
                                              ? Icons.pause_circle_filled
                                              : Icons.play_circle_fill,
                                          size: 64,
                                          color: Colors.white,
                                        ),
                                        onPressed: _togglePlayPause,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.forward_10, size: 36, color: Colors.white),
                                        onPressed: _seekForward,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: VideoProgressIndicator(
                                          _controller,
                                          allowScrubbing: true,
                                          padding: const EdgeInsets.only(top: 4),
                                          colors: const VideoProgressColors(
                                            playedColor: Colors.red,
                                            backgroundColor: Colors.white30,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _formatDuration(_controller.value.position),
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                            Text(
                                              _formatDuration(_controller.value.duration),
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.volume_up, color: Colors.white, size: 20),
                                            Expanded(
                                              child: Slider(
                                                value: _volume,
                                                min: 0.0,
                                                max: 1.0,
                                                divisions: 10,
                                                activeColor: Colors.white,
                                                thumbColor: Colors.white,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _volume = value;
                                                    _controller.setVolume(value);
                                                  });
                                                  _startHideTimer();
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            const Text("Width", style: TextStyle(color: Colors.white)),
                                            Expanded(
                                              child: Slider(
                                                value: _videoWidthFactor,
                                                min: 0.5,
                                                max: 1.0,
                                                divisions: 5,
                                                activeColor: Colors.blue,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _videoWidthFactor = value;
                                                  });
                                                  _startHideTimer();
                                                },
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.fullscreen, size: 28, color: Colors.white),
                                              onPressed: _goFullscreen,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    )
                  : const CircularProgressIndicator(color: Colors.white),
            ),
            Positioned(
              top: 40,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullscreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  const FullscreenVideoPlayer({Key? key, required this.controller}) : super(key: key);

  @override
  State<FullscreenVideoPlayer> createState() => _FullscreenVideoPlayerState();
}

class _FullscreenVideoPlayerState extends State<FullscreenVideoPlayer> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: widget.controller.value.aspectRatio,
              child: VideoPlayer(widget.controller),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

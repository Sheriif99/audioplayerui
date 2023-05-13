import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerButtons extends StatefulWidget {
  const PlayerButtons({
    Key? key,
    required this.audioPlayer,
  }) : super(key: key);

  final AudioPlayer audioPlayer;

  @override
  State<PlayerButtons> createState() => _PlayerButtonsState();
}

class _PlayerButtonsState extends State<PlayerButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<SequenceState?>(
          //previous button
          stream: widget.audioPlayer.sequenceStateStream,
          builder: (context, index) {
            return IconButton(
              onPressed: widget.audioPlayer.hasPrevious
                  ? widget.audioPlayer.seekToPrevious
                  : null,
              iconSize: 45,
              icon: const Icon(
                Icons.skip_previous,
                color: Colors.white,
              ),
            );
          },
        ),
        StreamBuilder<SequenceState?>(
          //rewind button
          stream: widget.audioPlayer.sequenceStateStream,
          builder: (context, index) {
            return IconButton(
              onPressed: () {
                if (widget.audioPlayer.position.inSeconds > 10) {
                  setState(() {
                    widget.audioPlayer.seek(Duration(seconds: -10));
                  });
                } else {
                  setState(() {
                    widget.audioPlayer.seek(Duration(seconds: 0));
                  });
                }
              },
              iconSize: 45,
              icon: const Icon(
                Icons.replay_10,
                color: Colors.white,
              ),
            );
          },
        ),
        StreamBuilder<PlayerState>(
            stream: widget.audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //check wether player has book or not
                final playerState = snapshot.data;
                final processingState =
                    (playerState! as PlayerState).processingState;

                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering) {
                  return Container(
                    //book is still loading
                    width: 64.0,
                    height: 64.0,
                    margin: const EdgeInsets.all(10.0),
                    child: CircularProgressIndicator(),
                  );
                } else if (!widget.audioPlayer.playing) {
                  //book is ready but not playing
                  return IconButton(
                    onPressed: widget.audioPlayer.play,
                    iconSize: 75,
                    icon: const Icon(
                      Icons.play_circle,
                      color: Colors.white,
                    ),
                  );
                } else if (processingState != ProcessingState.completed) {
                  //book is playing and didnt finish
                  return IconButton(
                    icon: const Icon(
                      Icons.pause_circle,
                      color: Colors.white,
                    ),
                    iconSize: 75.0,
                    onPressed: widget.audioPlayer.pause,
                  );
                } else {
                  //if book finishes play it again
                  return IconButton(
                      icon: const Icon(
                        Icons.replay_circle_filled_outlined,
                        color: Colors.white,
                      ),
                      iconSize: 75.0,
                      onPressed: () => widget.audioPlayer.seek(Duration.zero,
                          index: widget.audioPlayer.effectiveIndices!.first));
                }
              } else {
                return const CircularProgressIndicator();
              }
            }),
        StreamBuilder<SequenceState?>(
          //go forward button
          stream: widget.audioPlayer.sequenceStateStream,
          builder: (context, index) {
            return IconButton(
              onPressed: () {
                if (widget.audioPlayer.duration!.inSeconds -
                        widget.audioPlayer.position.inSeconds >
                    10) {
                  setState(() {
                    widget.audioPlayer.seek(Duration(seconds: 10));
                  });
                } else {
                  setState(() {
                    widget.audioPlayer.seek(widget.audioPlayer.duration!);
                  });
                }
              },
              iconSize: 45,
              icon: const Icon(
                Icons.forward_10,
                color: Colors.white,
              ),
            );
          },
        ),
        StreamBuilder<SequenceState?>(
          //Next button
          stream: widget.audioPlayer.sequenceStateStream,
          builder: (context, index) {
            return IconButton(
              onPressed: widget.audioPlayer.hasNext
                  ? widget.audioPlayer.seekToNext
                  : null,
              iconSize: 45,
              icon: const Icon(
                Icons.skip_next,
                color: Colors.white,
              ),
            );
          },
        ),
      ],
    );
  }
}

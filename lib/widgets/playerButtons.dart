import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerButtons extends StatelessWidget {
  const PlayerButtons({
    Key? key,
    required this.audioPlayer,
  }) : super(key: key);

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<SequenceState?>( //previous button
          stream: audioPlayer.sequenceStateStream,
          builder: (context, index){
            return IconButton(
            onPressed: audioPlayer.hasPrevious ? audioPlayer.seekToPrevious : null,
            iconSize:45 ,
            icon: const Icon(
              Icons.skip_previous,
              color: Colors.white,
            ),
            );
          },
          ),
        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot){
            if(snapshot.hasData){ //check wether player has book or not
              final playerState = snapshot.data;
              final processingState = 
              (playerState! as PlayerState).processingState;

              if(processingState == ProcessingState.loading || processingState == ProcessingState.buffering){
                return Container( //book is still loading
                  width: 64.0,
                  height: 64.0,
                  margin: const EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(),
                );
              } else if(!audioPlayer.playing){ //book is ready but not playing
                return IconButton(
                  onPressed: audioPlayer.play, 
                  iconSize: 75,
                  icon: const Icon(Icons.play_circle,
                  color: Colors.white,),
                  );
              }
              else if(processingState != ProcessingState.completed){ //book is playing and didnt finish
                return IconButton(
                  icon: const Icon(
                    Icons.pause_circle,
                    color: Colors.white,
                  ),
                  iconSize: 75.0,
                  onPressed: audioPlayer.pause,
                  );
              } else{ //if book finishes play it again
                return IconButton(
                  icon: const Icon(
                    Icons.replay_circle_filled_outlined,
                    color: Colors.white,
                  ),
                  iconSize: 75.0,
                  onPressed: () => audioPlayer.seek(Duration.zero,
                  index: audioPlayer.effectiveIndices!.first)
                );
              }
            }
              else{
                return const CircularProgressIndicator();
              }
          }),
          StreamBuilder<SequenceState?>( //Next button
          stream: audioPlayer.sequenceStateStream,
          builder: (context, index){
            return IconButton(
            onPressed: audioPlayer.hasNext ? audioPlayer.seekToNext : null,
            iconSize:45 ,
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
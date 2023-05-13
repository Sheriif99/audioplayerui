import 'package:audioplayerui/widgets/playerButtons.dart';
import 'package:audioplayerui/widgets/seekbar.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:just_audio/just_audio.dart';
import 'bookmodel/book_model.dart';

void main() {
  runApp(const Player());
}

class Player extends StatefulWidget {
  const Player({Key? key}) : super(key: key);
  @override
  State<Player> createState() => AudioP();
  }

  class AudioP extends State<Player>{
    AudioPlayer audioPlayer = AudioPlayer();
    Book book = Book.books[0];
    //Book book = Get.arguments ?? Bokk.books[]; //use this to passs arguments from one page to another
    @override
    void initState(){
      super.initState();

      audioPlayer.setAudioSource(
        ConcatenatingAudioSource(
        children: [
        AudioSource.uri(Uri.parse('asset:///${book.url}'), //Insert audiofiles here
        ),
        ],
      ),
      );

    }
    @override
    void dispose(){
      audioPlayer.dispose();
      super.dispose();
    }

    Stream<SeekBarData> get _seekBarDataStream => 
    rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
      audioPlayer.positionStream,
      audioPlayer.durationStream,
      (Duration position, Duration? duration,){
        return SeekBarData(position, duration ?? Duration.zero,);
      });
  @override
  Widget build(BuildContext context) {
     return MaterialApp(
       home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          fit: StackFit.expand,
          children: [
            //use this line to add the book cover images to audioplayer
            Image.asset(book.coverUrl, fit: BoxFit.cover,),
            const _BackgroundFilter(),
            _BookPlayer(seekBarDataStream: _seekBarDataStream, audioPlayer: audioPlayer, book: book,),
          ],
        ),
         ),
     );
  }
}

class _BookPlayer extends StatelessWidget {
  const _BookPlayer({
    Key? key,
    required this.book,
    required Stream<SeekBarData> seekBarDataStream,
    required this.audioPlayer,
  }) : _seekBarDataStream = seekBarDataStream,
  super(key: key);

  final Book book;
  final Stream<SeekBarData> _seekBarDataStream;
  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            book.title,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            book.description,
            maxLines: 2,
            style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Colors.white),

          ),
          const SizedBox(height: 30),
          StreamBuilder<SeekBarData>(
            stream: _seekBarDataStream,
            builder: (context, snapshot){
              final positionData = snapshot.data;
              return SeekBar(
              position: positionData?.duration ?? Duration.zero, 
              duration: positionData?.duration ?? Duration.zero,
              onChangedEnd: audioPlayer.seek,
              );
            }
            ),
            PlayerButtons(audioPlayer: audioPlayer),
        ],
      ),
    );
  }
}



class _BackgroundFilter extends StatelessWidget {
  const _BackgroundFilter({
    Key? key,
  }) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect){
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.0),
          ],
          stops: const [0.0,0.4,0.6]
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.deepPurple.shade200,
            Colors.deepPurple.shade800,
          ],
        )
      ),
    ),
      );
  }
}

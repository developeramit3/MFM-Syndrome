import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerScreen extends StatefulWidget {
  // YoutubePlayerScreen(this._controller);
  // final YoutubePlayerController _controller;

  @override
  _YoutubePlayerScreenState createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> with SingleTickerProviderStateMixin {
  AnimationController _anicontroller;
  Animation<Offset>_offsetAnimation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _anicontroller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _anicontroller,
      curve: Curves.linear,
    ));

  }
  @override
  Widget build(BuildContext context) {
    return Container();
   /* const player = YoutubePlayerIFrame();
    return YoutubePlayerControllerProvider(
      controller: widget._controller,
      child: LayoutBuilder(
        builder: (context, constraints) {

          if (kIsWeb && constraints.maxWidth > 800) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(child: player),
                const SizedBox(
                  width: 500,
                  child: SingleChildScrollView(
                    child: Controls(),
                  ),
                ),
              ],
            );
          }
          return player;
        },
      ),
    );
  */}
  void _insertOverlay(BuildContext context) {
    return Overlay.of(context).insert(
      OverlayEntry(builder: (context) {
        final size = MediaQuery.of(context).size;
        return  Positioned(
            width: size.width,
            top: 200,
            child: SlideTransition(
              position:_offsetAnimation,
              child: Container(
                  child: Text('amit@gmail.com',
                    style: TextStyle(
                        color: Colors.black,
                        backgroundColor: Colors.grey.shade200,
                        fontSize: 10
                    ),)
              ),
            ));
        return Positioned(
          width: 130,
          height: 50,
          top: 200,
          left: size.width - 200,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
                onTap: () => print('ON TAP OVERLAY!'),
                child: Center (child: Container(
                    decoration: BoxDecoration(color: Colors.redAccent),
                    child: Text('BETA VERSION')
                ),)
            ),
          ),
        );
      }),
    );
  }
  @override
  void dispose() {
    // widget._controller.close();
    super.dispose();
  }
}

class Controls extends StatelessWidget {
  const Controls();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _space,
          MetaDataSection(),
        ],
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);
}

class MetaDataSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
    /*return YoutubeValueBuilder(builder: (context, value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Text('', value.metaData.title),
          const SizedBox(height: 10),
        ],
      );
    });
  */}
}

class _Text extends StatelessWidget {
  final String title;
  final String value;

  const _Text(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '$title',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value ?? '',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:better_player/better_player.dart';
import 'package:eclass/common/apidata.dart';
import 'package:eclass/provider/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomPlayer extends StatefulWidget {
  CustomPlayer(this._controller);
  final BetterPlayerController _controller;

  @override
  _CustomPlayerState createState() => _CustomPlayerState();
}

class _CustomPlayerState extends State<CustomPlayer> with SingleTickerProviderStateMixin{
  AnimationController _anicontroller;
  Animation<Offset>_offsetAnimation;
  UserProfile user;
  @override
  void initState() {
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
    user = Provider.of<UserProfile>(context);
    return Stack(
      children: [
        Positioned(
            width: MediaQuery.of(context).size.width,
            top: 200,
            child: SlideTransition(
              position:_offsetAnimation,
              child: Container(
                  child: Text(user==null?"":"${user.profileInstance.email}",
                    style: TextStyle(
                        color: Colors.black,
                        backgroundColor: Colors.grey.shade200,
                        fontSize: 10
                    ),)
              ),
            )),
    AspectRatio(
      aspectRatio: 16 / 9,
      child: BetterPlayer(
        controller: widget._controller,
      ),
    ),
      ],
    );
  }
}
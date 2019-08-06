import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:njlzmusic/config/base_provide.dart';
import 'package:njlzmusic/tools/audio_tool.dart';
import 'package:njlzmusic/tools/audioplayer_tool.dart';
import 'package:njlzmusic/tools/common_util.dart';

class AudioPlayerProvide extends BaseProvide {
  AudioPlayerProvide() {
    PlayerTools.instance.stateSubject.listen((state) {
      setControlls();
    });

    PlayerTools.instance.progressSubject.listen((progress) {
      var pro = '${PlayerTools.instance.currentProgress}';
      this.songProgress = CommonUtil.dealDuration(pro);
    });

    PlayerTools.instance.currentSongSubject.listen((song) {
      this.currentSong = song;
      this.notify();
    });

    setControlls();
  }

  List _controls = [];
  List get controls => _controls;
  set controls(List controls) {
    _controls = controls;
    notify();
  }

  double _offsetY = 0.0;
  double get offsetY => _offsetY;
  set offsetY(double offsetY) {
    _offsetY = offsetY;
    notify();
  }

  Map _currentSong = Map();
  Map get currentSong => _currentSong;
  set currentSong(Map currentSong) {
    _currentSong = currentSong;
  }

  /// 歌曲进度
  String _songProgress = '';
  String get songProgress => _songProgress;
  set songProgress(String progress) {
    _songProgress = progress;
    notify();
  }

  /// 歌曲时长
  String songDuration() {
    return CommonUtil.dealDuration('${PlayerTools.instance.duration}');
  }

  /// slider
  double sliderValue() {
    if (PlayerTools.instance.duration == 0) {
      return 0.0;
    }
    var value = (PlayerTools.instance.currentProgress /
            PlayerTools.instance.duration) ??
        0.0;
    if (value > 1) {
      value = 1.0;
    }
    return value;
  }

  /// seek
  seek(double value) {
    int d = (value * PlayerTools.instance.duration).toInt();
    PlayerTools.instance.seek(d);
  }

  pre() {
    PlayerTools.instance.preAction();
  }

  play() {
    if (PlayerTools.instance.currentState == AudioToolsState.isPlaying) {
      PlayerTools.instance.pause();
    }
    if (PlayerTools.instance.currentState == AudioToolsState.isPaued) {
      PlayerTools.instance.resume();
    }
    PlayerTools.instance.play(_currentSong);
  }

  next() {
    PlayerTools.instance.nextAction();
  }

  Widget _getModeWidget() {
    return PlayerTools.instance.mode == 0
        ? new SvgPicture.asset("images/ic_spen.svg", width: 28, height: 28)
        : PlayerTools.instance.mode == 1
            ? new SvgPicture.asset("images/ic_rand.svg", width: 28, height: 28)
            : new SvgPicture.asset("images/is_single.svg",
                width: 28, height: 28);
  }

  changeMode() {
    if (PlayerTools.instance.mode == 0) {
      PlayerTools.instance.mode = 1;
      setControlls();
      return;
    }
    if (PlayerTools.instance.mode == 1) {
      PlayerTools.instance.mode = 2;
      setControlls();
      return;
    }
    if (PlayerTools.instance.mode == 2) {
      PlayerTools.instance.mode = 0;
      setControlls();
      return;
    }
  }

  setControlls() {
    this.controls = [
      _getModeWidget(),
      new Icon(
        Icons.skip_previous,
        color: Colors.white,
        size: 27,
      ),
      PlayerTools.instance.currentState == AudioToolsState.isPlaying
          ? new Icon(
              Icons.pause_circle_outline,
              color: Colors.white,
              size: 46,
            )
          : new Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: 46,
            ),
      new Icon(
        Icons.skip_next,
        color: Colors.white,
        size: 27,
      ),
      new Icon(
        Icons.menu,
        color: Colors.white,
        size: 27,
      )
    ];
  }

  showMenu(BuildContext context) {
//    Navigator.push(
//        context,
//        PageRouteBuilder(
//          opaque: false,
//          transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
//            return new FadeTransition(
//              opacity: animation,
//              child: child,
//            );
//          },
//          pageBuilder: (BuildContext context, _, __) => MusicListPage(),
//        )
//    ).then((value) {
//      if (value) {
//        this.notify();
//      }
//    });
  }

  notify() {
    notifyListeners();
  }
}

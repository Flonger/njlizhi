// import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/src/widgets/framework.dart';

import 'package:audioplayer/audioplayer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:njlzmusic/config/app_config.dart';
import 'package:njlzmusic/config/base_provide.dart';
import 'package:njlzmusic/pagemodel/audio/audioplayer_provide.dart';
import 'package:njlzmusic/tools/audio_tool.dart';
import 'package:njlzmusic/tools/audioplayer_tool.dart';
import 'package:njlzmusic/tools/navigation_util.dart';
import 'package:provide/provide.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart';

enum PlayerState { stopped, playing, paused }
typedef void OnError(Exception exception);

class TestPlayer extends StatefulWidget {
  final Map song;
  final String imgUrl;

  TestPlayer({Key key, this.song, this.imgUrl}) : super(key: key);

  _TestPlayerState createState() => _TestPlayerState();
}

class _TestPlayerState extends State<TestPlayer> with TickerProviderStateMixin {
  Animation<double> animationNeedle;
  Animation<double> animationRecord;
  AnimationController controllerNeedle;
  AnimationController controllerRecord;
  final _rotateTween = new Tween<double>(begin: -0.05, end: 0);
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);
  AnimationController ges_controller;
  CurvedAnimation ges_curve;
  Animation<double> ges_animation;

  Duration duration;
  Duration position;

  AudioPlayer audioPlayer;

  String localFilePath;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';
  get positionText =>
      position != null ? position.toString().split('.').first : '';

  bool isMuted = false;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  void initAudioPlayer() {
    audioPlayer = new AudioPlayer();
    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() => duration = audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }

  Future play() async {
    print(widget.song['url']);
    await audioPlayer.play(widget.song['url']);
    setState(() {
      playerState = PlayerState.playing;
    });
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = new Duration();
    });
  }

  Future mute(bool muted) async {
    await audioPlayer.mute(muted);
    setState(() {
      isMuted = muted;
    });
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  @override
  void initState() {
    super.initState();
    initAudioPlayer();

    controllerNeedle = new AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    animationNeedle =
        new CurvedAnimation(parent: controllerNeedle, curve: Curves.linear);

    controllerRecord = new AnimationController(
        duration: const Duration(milliseconds: 15000), vsync: this);
    animationRecord =
        new CurvedAnimation(parent: controllerRecord, curve: Curves.linear);

    ges_controller = new AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    ges_curve =
        new CurvedAnimation(parent: ges_controller, curve: Curves.linear);
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildGesture(),
    );
  }

  _buildGesture() {
    return new GestureDetector(
      onVerticalDragUpdate: (offset) {},
      onVerticalDragEnd: (offset) {},
      child: _buildView(),
    );
  }

  _buildView() {
    return new Container(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new CachedNetworkImage(
            key: Key(''),
            imageUrl: '',
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 0),
            placeholder: (context, url) => AppConfig.getPlaceHoder(),
            errorWidget: (context, url, error) => AppConfig.getPlaceHoder(),
          ),
          _setupContent()
        ],
      ),
    );
  }

  _setupContent() {
    return new Column(
      children: <Widget>[
        _setupTop(),
        _setupMiddle(),
        // _setupBottom(),
        _buildPlayer(),
      ],
    );
  }

  _setupTop() {
    return new SafeArea(
        child: new Row(
      children: <Widget>[
        new GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
              width: 50,
              child: new Icon(
                Icons.close,
                color: Colors.white,
                size: 27,
              )),
        ),
        new Expanded(
            child: new Text(
          widget.song['title'] ?? '',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          textAlign: TextAlign.center,
        )),
        new Container(
          width: 50,
        ),
      ],
    ));
  }

  _setupMiddle() {
    return new Container(
      margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
      child: new Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          new Container(
            margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: new Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                new Image.asset('images/disc.png'),
                new ClipOval(
                  child: new RotationTransition(
                    turns: _commonTween.animate(animationRecord),
                    alignment: Alignment.center,
                    child: new CachedNetworkImage(
                      width: 160,
                      height: 160,
                      key: Key(widget.imgUrl ?? ''),
                      imageUrl: widget.imgUrl ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          AppConfig.getPlaceHoder(160.0, 160.0),
                      errorWidget: (context, url, error) =>
                          AppConfig.getPlaceHoder(160.0, 160.0),
                    ),
                  ),
                )
              ],
            ),
          ),
          new Container(
            padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
            child: new RotationTransition(
              alignment: Alignment.topCenter,
              turns: _rotateTween.animate(animationNeedle),
              child: new Image.asset(
                'images/play_needle.png',
                width: 150,
                height: 86,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayer() => new Container(
      padding: new EdgeInsets.all(16.0),
      child: new Column(mainAxisSize: MainAxisSize.min, children: [
        new Row(mainAxisSize: MainAxisSize.min, children: [
          new IconButton(
              onPressed: isPlaying ? null : () => play(),
              iconSize: 64.0,
              icon: new Icon(Icons.play_arrow),
              color: Colors.cyan),
          new IconButton(
              onPressed: isPlaying ? () => pause() : null,
              iconSize: 64.0,
              icon: new Icon(Icons.pause),
              color: Colors.cyan),
          new IconButton(
              onPressed: isPlaying || isPaused ? () => stop() : null,
              iconSize: 64.0,
              icon: new Icon(Icons.stop),
              color: Colors.cyan),
        ]),
        duration == null
            ? new Container()
            : new Slider(
                value: position?.inMilliseconds?.toDouble() ?? 0.0,
                onChanged: (double value) =>
                    audioPlayer.seek((value / 1000).roundToDouble()),
                min: 0.0,
                max: duration.inMilliseconds.toDouble()),
        // new Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: <Widget>[
        //     new IconButton(
        //         onPressed: () => mute(true),
        //         icon: new Icon(Icons.headset_off),
        //         color: Colors.cyan),
        //     new IconButton(
        //         onPressed: () => mute(false),
        //         icon: new Icon(Icons.headset),
        //         color: Colors.cyan),
        //   ],
        // ),
        new Row(mainAxisSize: MainAxisSize.min, children: [
          new Padding(
              padding: new EdgeInsets.all(12.0),
              child: new Stack(children: [
                new CircularProgressIndicator(
                    value: 1.0,
                    valueColor: new AlwaysStoppedAnimation(Colors.grey[300])),
                new CircularProgressIndicator(
                  value: position != null && position.inMilliseconds > 0
                      ? (position?.inMilliseconds?.toDouble() ?? 0.0) /
                          (duration?.inMilliseconds?.toDouble() ?? 0.0)
                      : 0.0,
                  valueColor: new AlwaysStoppedAnimation(Colors.cyan),
                  backgroundColor: Colors.yellow,
                ),
              ])),
          new Text(
              position != null
                  ? "${positionText ?? ''} / ${durationText ?? ''}"
                  : duration != null ? durationText : '',
              style: new TextStyle(fontSize: 24.0))
        ])
      ]));
  Widget _setupBottom() {
    return new Expanded(
        child: new Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[_setupSlide(), _setupControl()],
    ));
  }

  _setupSlide() {
    return new Container(
      margin: EdgeInsets.fromLTRB(10, 50, 10, 0),
      child: new Row(
        children: <Widget>[
          new Text(
            '00',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          new Expanded(
              child: Slider(
            activeColor: Colors.white,
            inactiveColor: Colors.grey,
            value: 0.5,
            min: 0,
            max: 1,
            onChanged: (newValue) {
              print('onChanged:$newValue');
            },
            onChangeStart: (startValue) {
              print('onChangeStart:$startValue');
            },
            onChangeEnd: (endValue) {
              print('onChangeEnd:$endValue');
            },
            semanticFormatterCallback: (newValue) {
              return '${newValue.round()} dollars';
            },
          )),
          new Text(
            '100',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _setupControl() {
    return new SafeArea(
        child: new Container(
      height: 60,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _setupItems(),
      ),
    ));
  }

  List<GestureDetector> _setupItems() {
    return new List<GestureDetector>.generate(
        5, (int index) => _setupItem(index));
  }

  Widget _setupItem(int index) {
    return new GestureDetector(
      onTap: () {
        if (index == 0) {}
        if (index == 1) {}
        if (index == 2) {
          play();
        }
        if (index == 3) {}
        if (index == 4) {}
      },
      child: Icon(Icons.play_arrow),
    );
  }
}

/*
class TestPlayer extends PageProvideNode {
  final Map song;
  final String imgUrl;
  AudioPlayerProvide provide = AudioPlayerProvide();
  TestPlayer({this.imgUrl, this.song}) {
    mProviders.provide(Provider<AudioPlayerProvide>.value(provide));
  }

  @override
  Widget buildContent(BuildContext context) {
    // TODO: implement buildContent
    return _TestPlayerPage(song, imgUrl, provide);
  }
}

class _TestPlayerPage extends StatefulWidget {
  Map song;
  String imgUrl;
  AudioPlayerProvide provide;
  _TestPlayerPage(this.song, this.imgUrl, this.provide);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TestPlayerState();
  }
}

enum PlayerState { stopped, playing, paused }
typedef void OnError(Exception exception);

class _TestPlayerState extends State<_TestPlayerPage>
    with TickerProviderStateMixin {
  AudioPlayerProvide _provide;
  Animation<double> animationNeedle;
  Animation<double> animationRecord;
  AnimationController controllerNeedle;
  AnimationController controllerRecord;
  final _rotateTween = new Tween<double>(begin: -0.05, end: 0);
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);
  AnimationController ges_controller;
  CurvedAnimation ges_curve;
  Animation<double> ges_animation;

  final _subscriptions = CompositeSubscription();

  Duration duration;
  Duration position;

  AudioPlayer audioPlayer;

  String localFilePath;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';
  get positionText =>
      position != null ? position.toString().split('.').first : '';

  bool isMuted = false;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
    _provide ??= widget.provide;
    controllerNeedle = new AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    animationNeedle =
        new CurvedAnimation(parent: controllerNeedle, curve: Curves.linear);

    controllerRecord = new AnimationController(
        duration: const Duration(milliseconds: 15000), vsync: this);
    animationRecord =
        new CurvedAnimation(parent: controllerRecord, curve: Curves.linear);

    var s = PlayerTools.instance.stateSubject.listen((state) {
      if (state == AudioToolsState.isPlaying) {
        controllerNeedle.forward();
        controllerRecord.forward();
      } else {
        controllerNeedle.reverse();
        controllerRecord.stop(canceled: false);
      }
    });
    _subscriptions.add(s);

    animationRecord.addStatusListener((status) {
      if (status == AnimationStatus.completed &&
          PlayerTools.instance.currentState == AudioToolsState.isPlaying) {
        controllerRecord.repeat();
      } else if (status == AnimationStatus.dismissed) {
        controllerRecord.forward();
      }
    });

    ges_controller = new AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    ges_curve =
        new CurvedAnimation(parent: ges_controller, curve: Curves.linear);
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  void initAudioPlayer() {
    audioPlayer = new AudioPlayer();
    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() => duration = audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }

  Future play() async {
    print(widget.song['url']);
    await audioPlayer.play(widget.song['url']);
    setState(() {
      playerState = PlayerState.playing;
    });
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = new Duration();
    });
  }

  Future mute(bool muted) async {
    await audioPlayer.mute(muted);
    setState(() {
      isMuted = muted;
    });
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  Widget _buildPlayer() => new Container(
      padding: new EdgeInsets.all(16.0),
      child: new Column(mainAxisSize: MainAxisSize.min, children: [
        new Row(mainAxisSize: MainAxisSize.min, children: [
          new IconButton(
              onPressed: isPlaying ? null : () => play(),
              iconSize: 64.0,
              icon: new Icon(Icons.play_arrow),
              color: Colors.cyan),
          new IconButton(
              onPressed: isPlaying ? () => pause() : null,
              iconSize: 64.0,
              icon: new Icon(Icons.pause),
              color: Colors.cyan),
          new IconButton(
              onPressed: isPlaying || isPaused ? () => stop() : null,
              iconSize: 64.0,
              icon: new Icon(Icons.stop),
              color: Colors.cyan),
        ]),
        duration == null
            ? new Container()
            : new Slider(
                value: position?.inMilliseconds?.toDouble() ?? 0.0,
                onChanged: (double value) =>
                    audioPlayer.seek((value / 1000).roundToDouble()),
                min: 0.0,
                max: duration.inMilliseconds.toDouble()),
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new IconButton(
                onPressed: () => mute(true),
                icon: new Icon(Icons.headset_off),
                color: Colors.cyan),
            new IconButton(
                onPressed: () => mute(false),
                icon: new Icon(Icons.headset),
                color: Colors.cyan),
          ],
        ),
        new Row(mainAxisSize: MainAxisSize.min, children: [
          new Padding(
              padding: new EdgeInsets.all(12.0),
              child: new Stack(children: [
                new CircularProgressIndicator(
                    value: 1.0,
                    valueColor: new AlwaysStoppedAnimation(Colors.grey[300])),
                new CircularProgressIndicator(
                  value: position != null && position.inMilliseconds > 0
                      ? (position?.inMilliseconds?.toDouble() ?? 0.0) /
                          (duration?.inMilliseconds?.toDouble() ?? 0.0)
                      : 0.0,
                  valueColor: new AlwaysStoppedAnimation(Colors.cyan),
                  backgroundColor: Colors.yellow,
                ),
              ])),
          new Text(
              position != null
                  ? "${positionText ?? ''} / ${durationText ?? ''}"
                  : duration != null ? durationText : '',
              style: new TextStyle(fontSize: 24.0))
        ])
      ]));

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: _buildGesture(),
    );
  }

  Provide<AudioPlayerProvide> _buildGesture() {
    return Provide<AudioPlayerProvide>(builder:
        (BuildContext context, Widget child, AudioPlayerProvide value) {
      return new GestureDetector(
        onVerticalDragUpdate: (offset) {},
        onVerticalDragEnd: (offset) {},
        child: new Transform.translate(
          child: _buildView(),
        ),
      );
    });
  }

  Provide<AudioPlayerProvide> _buildView() {
    return Provide<AudioPlayerProvide>(builder:
        (BuildContext context, Widget child, AudioPlayerProvide value) {
      return new Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new CachedNetworkImage(
              key: Key(''),
              imageUrl: '',
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 0),
              placeholder: (context, url) => AppConfig.getPlaceHoder(),
              errorWidget: (context, url, error) => AppConfig.getPlaceHoder(),
            ),
            _setupContent()
          ],
        ),
      );
    });
  }

  Provide<AudioPlayerProvide> _setupContent() {
    return Provide<AudioPlayerProvide>(builder:
        (BuildContext context, Widget child, AudioPlayerProvide value) {
      return new Column(
        children: <Widget>[
          _setupTop(),
          _setupMiddle(),
          _setupBottom(),
        ],
      );
    });
  }

  Provide<AudioPlayerProvide> _setupTop() {
    return Provide<AudioPlayerProvide>(builder:
        (BuildContext context, Widget child, AudioPlayerProvide value) {
      return new SafeArea(
          child: new Row(
        children: <Widget>[
          new Container(
              width: 50,
              child: new Icon(
                Icons.close,
                color: Colors.white,
                size: 27,
              )),
          new Expanded(
              child: new Text(
            widget.song['title'] ?? '',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          )),
          new Container(
            width: 50,
          ),
        ],
      ));
    });
  }

  Provide<AudioPlayerProvide> _setupMiddle() {
    return Provide<AudioPlayerProvide>(builder:
        (BuildContext context, Widget child, AudioPlayerProvide value) {
      return new Container(
        margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
        child: new Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            new Container(
              margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: new Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  new Image.asset('images/disc.png'),
                  new ClipOval(
                    child: new RotationTransition(
                      turns: _commonTween.animate(animationRecord),
                      alignment: Alignment.center,
                      child: new CachedNetworkImage(
                        width: 160,
                        height: 160,
                        key: Key(widget.imgUrl ?? ''),
                        imageUrl: widget.imgUrl ?? '',
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            AppConfig.getPlaceHoder(160.0, 160.0),
                        errorWidget: (context, url, error) =>
                            AppConfig.getPlaceHoder(160.0, 160.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
            new Container(
              padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
              child: new RotationTransition(
                alignment: Alignment.topCenter,
                turns: _rotateTween.animate(animationNeedle),
                child: new Image.asset(
                  'images/play_needle.png',
                  width: 150,
                  height: 86,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _setupBottom() {
    return new Expanded(
        child: new Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[_setupSlide(), _setupControl()],
    ));
  }

  Provide<AudioPlayerProvide> _setupSlide() {
    return Provide<AudioPlayerProvide>(builder:
        (BuildContext context, Widget child, AudioPlayerProvide value) {
      return new Container(
        margin: EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: new Row(
          children: <Widget>[
            new Text(
              '00',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            new Expanded(
                child: Slider(
              activeColor: Colors.white,
              inactiveColor: Colors.grey,
              value: 0.5,
              min: 0,
              max: 1,
              onChanged: (newValue) {
                print('onChanged:$newValue');
              },
              onChangeStart: (startValue) {
                print('onChangeStart:$startValue');
              },
              onChangeEnd: (endValue) {
                print('onChangeEnd:$endValue');
              },
              semanticFormatterCallback: (newValue) {
                return '${newValue.round()} dollars';
              },
            )),
            new Text(
              '100',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      );
    });
  }

  Widget _setupControl() {
    return new SafeArea(
        child: new Container(
      height: 60,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _setupItems(),
      ),
    ));
  }

  List<GestureDetector> _setupItems() {
    return new List<GestureDetector>.generate(
        5, (int index) => _setupItem(index));
  }

  Widget _setupItem(int index) {
    return new GestureDetector(
      onTap: () {
        if (index == 0) {}
        if (index == 1) {}
        if (index == 2) {}
        if (index == 3) {}
        if (index == 4) {}
      },
      child: _provide.controls[index],
    );
  }
}
*/

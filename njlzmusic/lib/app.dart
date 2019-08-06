import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:njlzmusic/config/base_provide.dart';
import 'package:njlzmusic/main_provide.dart';
import 'package:njlzmusic/pages/audio/audio_miniplayer.dart';
import 'package:njlzmusic/pages/audio/audio_page.dart';
import 'package:njlzmusic/pages/video/video_page.dart';
import 'package:provide/provide.dart';

class App extends PageProvideNode {
  App() {
    mProviders.provide(Provider<MainProvide>.value(MainProvide.instance));
  }

  @override
  Widget buildContent(BuildContext context) {
    // TODO: implement buildContent
    return _AppContentPage();
  }
}

class _AppContentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AppState();
  }
}

class _AppState extends State<_AppContentPage>
    with TickerProviderStateMixin<_AppContentPage> {
  MainProvide _provide;
  TabController controller;
  AudioPage _audioPage = AudioPage();
  VideoPage _videoPage = VideoPage();
  MiniPlayerPage _miniPage = MiniPlayerPage();

  Animation<double> _animationMini;
  AnimationController _miniController;
  final _tranTween = new Tween<double>(begin: 1, end: 0);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _provide = MainProvide.instance;
    controller = new TabController(length: 2, vsync: this);
    _miniController = new AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationMini =
        new CurvedAnimation(parent: _miniController, curve: Curves.linear);
  }

  @override
  void dispose() {
    super.dispose();
    print('app释放');
  }

  onTap(int index) {
    _provide.currentIndex = index;
    controller.animateTo(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        overflow: Overflow.visible,
        children: <Widget>[_initTabbar(), _initMiniPlayer()],
      ),
      bottomNavigationBar: _initBottomNaviBar(),
    );
  }

  Provide<MainProvide> _initTabbar() {
    return Provide<MainProvide>(
        builder: (BuildContext context, Widget child, MainProvide value) {
      return IndexedStack(
        index: _provide.currentIndex,
        children: <Widget>[_audioPage, _videoPage],
      );
    });
  }

  Provide<MainProvide> _initMiniPlayer() {
    return Provide<MainProvide>(
        builder: (BuildContext context, Widget child, MainProvide value) {
      return Visibility(
        visible: _provide.showMini,
        child: new FadeTransition(
          opacity: _tranTween.animate(_animationMini),
          child: new Container(
            width: 80,
            height: 110,
            child: _miniPage,
          ),
        ),
      );
    });
  }

  Provide<MainProvide> _initBottomNaviBar() {
    return Provide<MainProvide>(
        builder: (BuildContext context, Widget child, MainProvide value) {
      return Theme(
        data: ThemeData(
            canvasColor: Colors.white,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: TextStyle(color: Colors.grey))),
        child: BottomNavigationBar(
          fixedColor: Colors.green,
          currentIndex: _provide.currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          items: [
            new BottomNavigationBarItem(
                icon: new Icon(Icons.music_note), title: new Text('音乐')),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.video_library), title: new Text('视频')),
          ],
        ),
      );
    });
  }
}

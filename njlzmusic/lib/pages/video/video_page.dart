import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:njlzmusic/config/base_provide.dart';
import 'package:njlzmusic/pagemodel/video/video_provide.dart';
import 'package:provide/provide.dart';

class VideoPage extends PageProvideNode {
  VideoProvide provide = VideoProvide();
  VideoPage() {
    mProviders.provide(Provider<VideoProvide>.value(provide));
  }

  @override
  Widget buildContent(BuildContext context) {
    // TODO: implement buildContent
    return _VideoContentPage(provide);
  }
}

class _VideoContentPage extends StatefulWidget {
  VideoProvide provide;
  _VideoContentPage(this.provide);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _VideoContentState();
  }
}

class _VideoContentState extends State<_VideoContentPage>
    with AutomaticKeepAliveClientMixin<_VideoContentPage> {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Center(
        child: Text('视频'),
      ),
    );
  }
}

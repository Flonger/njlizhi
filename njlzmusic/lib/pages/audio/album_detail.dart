import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:njlzmusic/config/app_config.dart';
import 'package:njlzmusic/config/base_provide.dart';
import 'package:njlzmusic/pagemodel/audio/albumdetail_provide.dart';
import 'package:njlzmusic/pagemodel/audio/audio_provide.dart';
import 'package:njlzmusic/pages/audio/test_player.dart';
import 'package:njlzmusic/tools/navigation_util.dart';
import 'package:provide/provide.dart';

import 'audio_player.dart';

class AlbumDetail extends PageProvideNode {
  final Map album;
  AlbumDetailProvide provide = AlbumDetailProvide();

  AlbumDetail({Map this.album}) {
    mProviders.provide(Provider<AlbumDetailProvide>.value(provide));
  }

  @override
  Widget buildContent(BuildContext context) {
    // TODO: implement buildContent
    return _AlbumDetailPage(provide, album);
  }
}

class _AlbumDetailPage extends StatefulWidget {
  AlbumDetailProvide provide;
  Map album;
  _AlbumDetailPage(this.provide, this.album);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AlbumDetailState();
  }
}

class _AlbumDetailState extends State<_AlbumDetailPage>
    with AutomaticKeepAliveClientMixin<_AlbumDetailPage> {
  AlbumDetailProvide _provide;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _provide ??= widget.provide;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('详情'),
      ),
      body: _initView(),
    );
  }

  Provide<AlbumDetailProvide> _initView() {
    return Provide<AlbumDetailProvide>(
      builder: (BuildContext context, Widget child, AlbumDetailProvide value) {
        return widget.album['songs'].length > 0
            ? _buildListView()
            : AppConfig.initLoading(false);
      },
    );
  }

  Provide<AlbumDetailProvide> _buildListView() {
    return Provide<AlbumDetailProvide>(
      builder: (BuildContext context, Widget child, AlbumDetailProvide value) {
        return _contentView();
      },
    );
  }

  _items(BuildContext context) {
    if (widget.album['songs'] == null) return null;
    List<Map> songs = widget.album['songs'];
    List<Widget> items = [];
    songs.forEach((Map song) {
      items.add(_item(context, song));
    });
    return Column(
      children: items.sublist(0, songs.length),
    );
  }

  Widget _item(BuildContext context, Map map) {
    return InkWell(
        onTap: () {
          NavigationUtil.push(
              context,
              TestPlayer(
                song: map,
                imgUrl: widget.album['icon'],
              ));
        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Container(
                height: 0.5,
                color: Colors.blueGrey,
              ),
            ),
            Container(
                height: 45,
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text(map['title']), Text('>')],
                  ),
                )),
          ],
        ));
  }

  Widget _contentView() {
    return ListView(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 15, top: 20),
              height: 100,
              width: 100,
              child: Image.network(widget.album['icon']),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, top: 20),
              child: Text(
                widget.album['title'] + '(' + widget.album['year'] + ')',
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(right: 15, top: 10, left: 15),
          child: Text(
            widget.album['desc'],
//              maxLines: 0,
            softWrap: true,
          ),
        ),
        Container(
          height: 20,
        ),
        Container(
          height: 0.5,
          color: Colors.blueGrey,
        ),
        _items(context),
      ],
    );
  }
}

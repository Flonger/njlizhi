import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:njlzmusic/config/app_config.dart';
import 'package:njlzmusic/config/base_provide.dart';
import 'package:njlzmusic/config/songs_config.dart';
import 'package:njlzmusic/pagemodel/audio/audio_provide.dart';
import 'package:njlzmusic/pages/audio/album_detail.dart';
import 'package:provide/provide.dart';
import 'package:njlzmusic/tools/navigation_util.dart';

class AudioPage extends PageProvideNode {
  AudioProvide provide = AudioProvide();
  AudioPage() {
    mProviders.provide(Provider<AudioProvide>.value(provide));
  }

  @override
  Widget buildContent(BuildContext context) {
    // TODO: implement buildContent
    return _AudioContentPage(provide);
  }
}

class _AudioContentPage extends StatefulWidget {
  AudioProvide provide;
  _AudioContentPage(this.provide);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AudioContentState();
  }
}

class _AudioContentState extends State<_AudioContentPage>
    with AutomaticKeepAliveClientMixin<_AudioContentPage> {
  List<String> album = [
    '01.被禁忌的游戏(2004)',
    '02.梵高先生(2005)',
    '03.这个世界会好吗(2006)',
    '04.工体东路没有人(2009)',
    '05.二零零九年十月十六日事件(2009)',
    '06.我爱南京(2009)',
    '07.你好，郑州(2010)',
    '08.F(2011)',
    '09.Imagine(2011)',
    '10.108个關鍵词(2012)',
    '11.勾三搭四(2013)',
    '12.1701(2014)',
    '13.iO(2014)',
    '14.看见(2015)',
    '15.动静(2015)',
    '16.李志北京不插电现场(2016)',
    '17.8(2016)',
    '18.在每一条伤心的应天大街上(2016)',
    '19.李志、电声与管弦乐(2016)',
    '20.爵士乐与不插电新编12首(2017)',
    '21.李志、电声与管弦乐Ⅱ(2018)',
    '22.洗心革面(2019)',
  ];
  List<String> albumImg = [
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564576228726&di=a50f5adb653e5324a563d61f2dae6407&imgtype=0&src=http%3A%2F%2Fspider.nosdn.127.net%2F94581dc7301e7129c52510daf59251ba.jpeg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564576284416&di=c88279dd6a35590052eec4890972508e&imgtype=0&src=http%3A%2F%2Fimg21.mtime.cn%2Fmg%2F2011%2F05%2F02%2F150256.17000320.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564576305522&di=acc2c8f572b5a6b6c9f8951d6f77155e&imgtype=0&src=http%3A%2F%2Fimg1.cache.netease.com%2Fent%2F2015%2F4%2F27%2F201504271754410f9a8_550.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564576392599&di=ed52d459d57e5d3a3e1e7827a704f9e4&imgtype=0&src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2Fc833295dd8ddb17d5bb87621be3267375c49c35b59458-PL6kBA_fw236',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564576392599&di=ed52d459d57e5d3a3e1e7827a704f9e4&imgtype=0&src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2Fc833295dd8ddb17d5bb87621be3267375c49c35b59458-PL6kBA_fw236',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564576447111&di=ec5aa0b57f1be9842db8d91920c62636&imgtype=0&src=http%3A%2F%2Fimg1.doubanio.com%2Fview%2Fphoto%2Fl%2Fpublic%2Fp2184788178.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564576469284&di=f02b9734a0f786cf6430660699fc9f90&imgtype=0&src=http%3A%2F%2Fimg3.doubanio.com%2Fview%2Fnote%2Flarge%2Fpublic%2Fp90072766-1.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564576504317&di=5d185eb9c91fb9a13390c175bdbdc131&imgtype=0&src=http%3A%2F%2Fec4.images-amazon.com%2Fimages%2FI%2F31ColaqV23L.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564576544872&di=7a519a16ec00bb064bb40272dd3d69fb&imgtype=0&src=http%3A%2F%2Fcdnimg103.lizhi.fm%2Faudio_cover%2F2016%2F02%2F21%2F26599039024744455_320x320.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564576566964&di=c3d9d16a949c70efb5199933906bd52b&imgtype=0&src=http%3A%2F%2Fimg3.doubanio.com%2Flpic%2Fs26714492.jpg',
    'https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2463090514,3287668001&fm=26&gp=0.jpg',
    'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=818734113,3199712573&fm=26&gp=0.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564576622493&di=c495f68dac6ac14a520f51ec86388fcb&imgtype=0&src=http%3A%2F%2Fimg4.cache.netease.com%2Fent%2F2015%2F2%2F2%2F20150202111716ee666_550.jpg',
    'https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=921556658,789552051&fm=26&gp=0.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1565171396&di=e350815a5e44c8e520857539a0df93ad&imgtype=jpg&er=1&src=http%3A%2F%2Fp4.music.126.net%2FZ8N_7knqz3E3Wv892reKOQ%3D%3D%2F1413971956081364.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564576694868&di=590b4d66b38c8b5290d8c6d76d3e8d0a&imgtype=0&src=http%3A%2F%2Fmmbiz.qpic.cn%2Fmmbiz_jpg%2FvyvWIOFbvAe2sHiautIUZHUibVlFFibjic6BQHuLp48g7CuFa4uJ7kp9gq6RgXbBY7eQWvRyP5x9rsJwrM5NdbfO0A%2F640%3Fwx_fmt%3Djpeg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564576711077&di=a059b406ddcf780aad38424e721b1a1f&imgtype=0&src=http%3A%2F%2Fwww.hinews.cn%2Fpic%2F003%2F013%2F439%2F00301343988_c3e4d5d5.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1565171682&di=69623029b69551536789e6d3d8109fdb&imgtype=jpg&er=1&src=http%3A%2F%2Fimg1.jiemian.com%2Fjiemian%2Foriginal%2F20161226%2F148274648660456400_a580xH.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564576827548&di=dfaea4cc167929f623b2540241952505&imgtype=0&src=http%3A%2F%2Fimg3.doubanio.com%2Fview%2Fgroup_topic%2Fl%2Fpublic%2Fp79204666.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1564566687&di=0dafa1b85eea2c36785aa76d2f1be0d5&src=http://www.chinanews.com/cr/2018/0420/4125453007.png',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564576942738&di=a43fdc8beb7456cbe222e9c82ec63a98&imgtype=0&src=http%3A%2F%2Fimg3.doubanio.com%2Fview%2Fphoto%2Fm%2Fpublic%2Fp2522253931.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564576901689&di=8e61b2fa0294fe5c079dc6bae050bd47&imgtype=0&src=http%3A%2F%2Fwx3.sinaimg.cn%2Forj360%2F9c100b3bly1fyhtazgw70j20b40b4ab7.jpg',
  ];

  ScrollController _scrollControll;

  AudioProvide _provide;

  @override
  void initState() {
    super.initState();
    _scrollControll = new ScrollController();
    _provide ??= widget.provide;

    print('音乐列表');
  }

  @override
  void dispose() {
    super.dispose();
    _scrollControll.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('专辑列表'),
      ),
      body: _initView(),
    );
  }

  Provide<AudioProvide> _initView() {
    return Provide<AudioProvide>(
      builder: (BuildContext content, Widget child, AudioProvide value) {
        return SongsConfig.albumList.length > 0
            ? _listView()
            : AppConfig.initLoading(false);
      },
    );
  }

  Provide<AudioProvide> _listView() {
    return Provide<AudioProvide>(
      builder: (BuildContext content, Widget child, AudioProvide value) {
        return ListView.builder(
          itemCount: SongsConfig.albumList.length,
          controller: _scrollControll,
          itemBuilder: (content, i) {
            if (SongsConfig.albumList.length > 0) {
              return _item(SongsConfig.albumList[i], i);
            }
          },
        );
      },
    );
  }

  Widget _item(Map album, int index) {
    return new Column(
      children: <Widget>[
        Container(
          height: 70,
          padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: InkWell(
            onTap: () {
              NavigationUtil.push(
                  context,
                  AlbumDetail(
                    album: album,
                  ));
            },
            child: Row(
              children: <Widget>[
                CachedNetworkImage(
                  width: 70,
                  height: 70,
                  key: Key(album['icon']),
                  imageUrl: album['icon'],
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      AppConfig.getPlaceHoder(70.0, 70.0),
                  errorWidget: (context, url, error) =>
                      AppConfig.getPlaceHoder(70.0, 70.0),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(album['title'] + '(' + album['year'] + ')',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

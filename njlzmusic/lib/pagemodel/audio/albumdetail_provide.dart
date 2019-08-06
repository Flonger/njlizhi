import 'package:njlzmusic/config/base_provide.dart';
import 'package:njlzmusic/tools/audioplayer_tool.dart';

class AlbumDetailProvide extends BaseProvide2 {
  List<Map> _dataArr = [];
  List<Map> get dataArr => _dataArr;
  set dataArr(List<Map> arr) {
    _dataArr = arr;
    this.notify();
  }

  notify() {
    notifyListeners();
  }

  setSongs(List data, int index) {
    PlayerTools.instance.setSongs(data, index);
  }
}

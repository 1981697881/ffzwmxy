import 'dart:convert';
import 'dart:math';
import 'package:ffzwmxy/model/currency_entity.dart';
import 'package:ffzwmxy/model/submit_entity.dart';
import 'package:ffzwmxy/utils/refresh_widget.dart';
import 'package:ffzwmxy/utils/text.dart';
import 'package:ffzwmxy/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

final String _fontFamily = Platform.isWindows ? "Roboto" : "";

class StockPage extends StatefulWidget {
  StockPage({Key key}) : super(key: key);

  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  //搜索字段
  String keyWord = '';
  final divider = Divider(height: 1, indent: 20);
  final rightIcon = Icon(Icons.keyboard_arrow_right);
  final scanIcon = Icon(Icons.filter_center_focus);
  static const scannerPlugin =
      const EventChannel('com.shinow.pda_scanner/plugin');
  StreamSubscription _subscription;
  var _code;
  List<dynamic> orderDate = [];

  @override
  void initState() {
    super.initState();
    /// 开启监听
    if (_subscription == null) {
      _subscription = scannerPlugin
          .receiveBroadcastStream()
          .listen(_onEvent, onError: _onError);
    }
  }

  @override
  void dispose() {
    super.dispose();

    /// 取消监听
    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  // 集合
  List hobby = [];
  getOrderList() async {
      Map<String, dynamic> userMap = Map();
      if(this.keyWord != ''){
        userMap['FilterString'] =
        "FMaterialId.FNumber='$keyWord'";
      }
      userMap['FormId'] = 'STK_Inventory';
      userMap['FieldKeys'] =
          'FMaterialId.FNumber,FMaterialId.FName,FMaterialId.FSpecification,FStockId.FName,FBaseQty';
      Map<String, dynamic> dataMap = Map();
      dataMap['data'] = userMap;
      String order = await CurrencyEntity.polling(dataMap);
      orderDate = [];
      orderDate = jsonDecode(order);
      print(orderDate);
      if (orderDate.length > 0) {
        hobby = [];
        orderDate.forEach((value) {
          List arr = [];
          arr.add({
            "title": "编码",
            "name": "FMaterialFNumber",
            "value": {"label": value[0], "value": value[0]}
          });
          arr.add({
            "title": "名称",
            "name": "FMaterialFName",
            "value": {"label": value[1], "value": value[1]}
          });
          arr.add({
            "title": "规格",
            "name": "FMaterialIdFSpecification",
            "value": {"label": value[2], "value": value[2]}
          });
          arr.add({
            "title": "仓库",
            "name": "FStockIdFName",
            "value": {"label": value[3], "value": value[3]}
          });
          arr.add({
            "title": "库存数量",
            "name": "FBaseQty",
            "value": {"label": value[4], "value": value[4]}
          });
          hobby.add(arr);
        });
        setState(() {
          EasyLoading.dismiss();
          this._getHobby();
        });
      } else {
        setState(() {
          EasyLoading.dismiss();
          this._getHobby();
        });
        ToastUtil.showInfo('无数据');
      }
  }

  void _onEvent(Object event) async {
    /*  setState(() {*/
    _code = event;
    EasyLoading.show(status: 'loading...');
    keyWord = _code;
    await getOrderList();
    /*});*/
  }
  void _onError(Object error) {
    setState(() {
      _code = "扫描异常";
    });
  }

  List<Widget> _getHobby() {
    List<Widget> tempList = [];
    for (int i = 0; i < this.hobby.length; i++) {
      List<Widget> comList = [];
      for (int j = 0; j < this.hobby[i].length; j++) {
        comList.add(
          Column(children: [
            Container(
              color: Colors.white,
              child: ListTile(
                title: Text(this.hobby[i][j]["title"] +
                    '：' +
                    this.hobby[i][j]["value"]["label"].toString()),
                trailing:
                Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  /* MyText(orderDate[i][j],
                        color: Colors.grey, rightpadding: 18),*/
                ]),
              ),
            ),
            divider,
          ]),
        );
      }
      tempList.add(
        SizedBox(height: 10),
      );
      tempList.add(
        Column(
          children: comList,
        ),
      );
    }
    return tempList;
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return FlutterEasyLoading(
      /*child: MaterialApp(
      title: "loging",*/
      child: Scaffold(
          appBar: AppBar(
            /* leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),*/
            title: Text("库存查询"),
            centerTitle: true,
          ),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: true,
                delegate: StickyTabBarDelegate(
                    minHeight: 50, //收起的高度
                    maxHeight: 50, //展开的最大高度
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: EdgeInsets.only(top: 2.0),
                        child: Container(
                          height: 52.0,
                          child: new Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: new Card(
                                child: new Container(
                                  child: new Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 6.0,
                                      ),
                                      Icon(
                                        Icons.search,
                                        color: Colors.grey,
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: TextField(
                                            controller: controller,
                                            decoration: new InputDecoration(
                                                contentPadding:
                                                EdgeInsets.only(
                                                    bottom: 8.0),
                                                hintText: '输入关键字',
                                                border: InputBorder.none),
                                            onSubmitted: (value) {
                                              setState(() {
                                                this.getOrderList();
                                                print(value);
                                              });
                                            },
                                            // onChanged: onSearchTextChanged,
                                          ),
                                        ),
                                      ),
                                      new IconButton(
                                        icon: new Icon(Icons.cancel),
                                        color: Colors.grey,
                                        iconSize: 18.0,
                                        onPressed: () {
                                          controller.clear();
                                          // onSearchTextChanged('');
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ),
                ),
              ),
              SliverFillRemaining(
                child: ListView(children: <Widget>[
                  Column(
                    children: this._getHobby(),
                  ),
                ]),
              ),
            ],
          )),
    );
    /*);*/
  }
}

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Container child;
  final double minHeight;
  final double maxHeight;
  StickyTabBarDelegate({@required this.minHeight,
  @required this.maxHeight,@required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return this.child;
  }

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:ffzwmxy/model/currency_entity.dart';
import 'package:ffzwmxy/utils/toast_util.dart';
import 'package:path_provider/path_provider.dart';

class DrawingPage extends StatefulWidget {
  DrawingPage({Key key}) : super(key: key);

  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  static const scannerPlugin =
      const EventChannel('com.shinow.pda_scanner/plugin');
  StreamSubscription _subscription;
  String pathPDF = "";
  String pdfUrl = "";
  String keyWord = '';
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

  void _onEvent(Object event) async {
    /*  setState(() {*/
    _code = event;
    keyWord = _code;
    await getOrderList();
    /*});*/
  }

  void _onError(Object error) {
    setState(() {
      _code = "扫描异常";
    });
  }

  getOrderList() async {
    Map<String, dynamic> userMap = Map();
    userMap['FilterString'] =
        "FNumber='$keyWord' and FUseOrgId.FNumber = '102'";
    userMap['FormId'] = 'BD_MATERIAL';
    userMap['FieldKeys'] = 'F_ora_Text';
    Map<String, dynamic> dataMap = Map();
    dataMap['data'] = userMap;
    String order = await CurrencyEntity.polling(dataMap);
    orderDate = [];
    orderDate = jsonDecode(order);
    if (orderDate.length > 0) {
      print(orderDate);
      pdfUrl = orderDate[0][0];
      createFileOfPdfUrl().then((f) {
        setState(() {
          pathPDF = f.path;
          print(pathPDF);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PDFScreen(pathPDF)),
          );
        });
      });
    } else {
      ToastUtil.showInfo('无数据');
    }
  }

  Future<File> createFileOfPdfUrl() async {
    var url = "https://tz.xinyuanhengye.cn:8088/tz.html?file=$pdfUrl.pdf";
    /*var url = "http://africau.edu/images/default/sample.pdf";*/
    final filename = url.substring(url.lastIndexOf("/") + 1);
    HttpClient client = HttpClient();
    client.badCertificateCallback = (X509Certificate cert,String host,int port){
      return true;
    };
    var request = await client.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }
  @override
  void dispose() {
    super.dispose();

    /// 取消监听
    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('图纸查询'), centerTitle: true),
    );
  }
}
// ignore: must_be_immutable
class PDFScreen extends StatelessWidget {
  String pathPDF = "";

  PDFScreen(this.pathPDF);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text("图纸"),
        ),
        path: pathPDF);
  }
}

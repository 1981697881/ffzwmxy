import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:ffzwmxy/views/login/login_page.dart';
import 'package:ffzwmxy/views/stock/stock_page.dart';
import 'package:ffzwmxy/views/drawing/drawing_page.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndexPage extends StatefulWidget {
  IndexPage({
    Key key,
  }) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final _saved = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  // 承载listView的滚动视图
  ScrollController _scrollController = ScrollController();

  // tabs 容器
  Widget buildAppBarTabs() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AppBarTabsItem(
            icon: Icons.web,
            text: "库存查询",
            color: Theme.of(context).primaryColor.withOpacity(0.8),
            router: StockPage()),
        AppBarTabsItem(
            icon: Icons.wallpaper,
            text: "图纸查询",
            color: Colors.green.withOpacity(0.7),
            router: DrawingPage()),
      ],
    );
  }

  void _pushSaved() async{
    /* Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LoginPage(
          );
        },
      ),
    );*/
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;//版本号
    String buildNumber = packageInfo.buildNumber;//版本构建号
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return new Scaffold(
            appBar: new AppBar(
              title: new Text('系统设置'),
              centerTitle: true,
            ),
            body: new ListView(padding: EdgeInsets.all(10), children: <Widget>[
              ListTile(
                leading: Icon(Icons.search),
                title: Text('版本信息（$version）'),
              ),
              Divider(
                height: 10.0,
                indent: 0.0,
                color: Colors.grey,
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('退出登录'),
                onTap: () async {
                  print("点击退出登录");
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.clear();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginPage();
                      },
                    ),
                  );
                },
              ),
              Divider(
                height: 10.0,
                indent: 0.0,
                color: Colors.grey,
              ),
            ]),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('主页'),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.settings), onPressed: _pushSaved),
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 10.0),
              padding: EdgeInsets.symmetric(
                // 同appBar的titleSpacing一致
                horizontal: NavigationToolbar.kMiddleSpacing,
                vertical: 20.0,
              ),
              child: buildAppBarTabs(),
            ),
            /*Expanded(
              child: ListView.builder(
                itemCount: 4,
                padding: EdgeInsets.symmetric(
                    // vertical: 5.0,
                    // horizontal: NavigationToolbar.kMiddleSpacing,
                    ),
                itemBuilder: (BuildContext listViewContext, int index) {
                  MessageModel mm = MessageModel();
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[100]),
                      ),
                    ),
                    child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Image.network(
                            mm.tileAvatar,
                            fit: BoxFit.cover,
                            width: 40.0,
                            height: 40.0,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(mm.tileTime),
                            index % 2 == 0
                                ? BadgeWidget(
                                    child: Container(
                                      height: 7.0,
                                      width: 7.0,
                                    ),
                                  )
                                : Container(
                                    height: 7.0,
                                    width: 7.0,
                                  )
                          ],
                        ),
                        title: Text(mm.tileName),
                        subtitle: Text(mm.tileContent),
                        //item 点击事件
                        onTap: () {
                          print("点击到第" + index.toString());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ReportPage(
                                    // 路由参数
                                    );
                              },
                            ),
                          );
                        },
                        //item 长按事件
                        onLongPress: () {
                          print("长按" + index.toString());
                        }),
                  );
                },
              ),
            ),
          */
          ],
        ),
      ),
    );
  }
}

class AppBarTabsItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final router;

  const AppBarTabsItem({Key key, this.icon, this.text, this.color,this.router})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => router),
            );
          },
          child: Container(
            padding: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
                color: this.color, borderRadius: BorderRadius.circular(6.0)),
            child: Icon(
              this.icon,
              size: IconTheme.of(context).size - 6,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(this.text),
      ],
    );
  }
}

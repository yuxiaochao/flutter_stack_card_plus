import 'package:flutter/material.dart';

import 'flutter_stack_card_plus/flutter_stack_card.dart';
import 'flutter_stack_card_plus/src/flutter_stack_card.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '卡片',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Color> list = [
    Colors.green,
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.brown
  ];
  var width, height;
  PageController pageController;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text('卡片'),
        ),
        body: Column(
          children: [
            Container(
              height: 700,
              // color: Colors.blue,
              child: StackCard.builder(
                itemCount: list.length,
                onSwap: (index) {},
                pageController: (PageController _pageController) {
                  pageController = _pageController;
                },
                boxDecoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), //底色,阴影颜色
                    offset: Offset(0, -2), //阴影位置,从什么位置开始
                    blurRadius: 12, // 阴影模糊层度
                    spreadRadius: 0,
                  )
                ], borderRadius: BorderRadius.all(Radius.circular(12))),
                scale: 0.95,
                isRotate: true,
                dimension: StackDimension(width: 400.0, height: 600.0),
                stackType: StackType.middle,
                stackOffset: Offset(0, 20),
                itemBuilder: (context, index) {
                  return _itemBuilder(list[index]);
                },
              ),
            ),
            TextButton(
                onPressed: () {
                  pageController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.fastOutSlowIn);
                },
                child: Text("下一页")),
            TextButton(
                onPressed: () {
                  pageController.previousPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.fastOutSlowIn);
                },
                child: Text("上一页"))
          ],
        ));
  }

  Widget _itemBuilder(Color color) {
    return Container(
      child: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: color,
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: height,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'stack_dimension.dart';
import 'stack_type.dart';

class StackCard extends StatefulWidget {
  StackCard.builder(
      {this.stackType = StackType.middle,
      @required this.itemBuilder, //@required 必传参数
      @required this.itemCount,
      this.pageController,
      this.dimension,
      this.stackOffset = const Offset(15, 15),
      this.onSwap,
      this.scale = 0.9,
      this.boxDecoration,
      this.isRotate = true});

  //卡片数量
  final int itemCount;

  //卡片内容
  final IndexedWidgetBuilder itemBuilder;

  //滑动监听
  final ValueChanged<int> onSwap;

  //卡片大小
  final StackDimension dimension;

  //横向or纵向
  final StackType stackType;

  //偏移量
  final Offset stackOffset;

  //后方卡片缩放
  final double scale;

  //卡片样式
  final BoxDecoration boxDecoration;

  final Function pageController;

  //卡片滑动时是否倾斜
  final bool isRotate;

  @override
  _StackCardState createState() => _StackCardState();
}

class _StackCardState extends State<StackCard> {
  var _pageController = PageController();
  var _currentPage = 0.0;
  var _width, _height;
  int index = 0;

  void onSwap(int _index) {
    index = _index;
    widget.onSwap(_index);
  }

  @override
  Widget build(BuildContext context) {
    widget.pageController(_pageController);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page;
      });
    });

    if (widget.dimension == null) {
      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;
    } else {
      assert(widget.dimension.width > 0);
      assert(widget.dimension.height > 0);
      _width = widget.dimension.width;
      _height = widget.dimension.height;
    }

    return Stack(fit: StackFit.expand, children: <Widget>[
      _cardStack(),
      PageView.builder(
        onPageChanged: onSwap,
        physics: BouncingScrollPhysics(),
        controller: _pageController,
        itemCount: widget.itemCount,
        itemBuilder: (context, index) {
          return Container();
        },
      )
    ]);
  }

  Widget _cardStack() {
    List<Widget> _cards = [];
    for (int i = widget.itemCount - 1; i >= 0; i--) {
      var leftOffset =
          (widget.stackOffset.dx * i) - (_currentPage * widget.stackOffset.dx);
      var topOffset =
          (widget.stackOffset.dy * i) - (_currentPage * widget.stackOffset.dy);

      _cards.add(Positioned.fill(
        child: _cardBuilder(i),
        top: topOffset,
        left: widget.stackType == StackType.middle
            ? (_currentPage > (i) ? -(_currentPage - i) * (_width * 4) : 0)
            : (_currentPage > (i)
                ? -(_currentPage - i) * (_width * 4)
                : leftOffset),
      ));
    }

    return Stack(fit: StackFit.expand, children: _cards);
  }

  Widget _cardBuilder(int _index) {
    var boxDecoration = BoxDecoration(boxShadow: [
      BoxShadow(
        color: Colors.black12.withOpacity(0.1), //底色,阴影颜色
        offset: Offset(0, -2), //阴影位置,从什么位置开始
        blurRadius: 12, // 阴影模糊层度
        spreadRadius: 0,
      )
    ], borderRadius: BorderRadius.all(Radius.circular(12)));
    if (widget.boxDecoration != null) {
      boxDecoration = widget.boxDecoration;
    }
    //当卡片大小不变的层叠显示时，只显示第一个的阴影
    if (widget.scale == 1.0 && index != _index) {
      boxDecoration =
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12)));
    }
    return Transform.rotate(
        angle: _index - _currentPage < 0 && widget.isRotate ? (_index - _currentPage) : 0,
        child: Transform.scale(
            scale: pow(widget.scale, _index - _currentPage),
            child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                    width: _width,
                    height: _height,
                    decoration: boxDecoration,
                    child: widget.itemBuilder(context, _index)))));
  }
}

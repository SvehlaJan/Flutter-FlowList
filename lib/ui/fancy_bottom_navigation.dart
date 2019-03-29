import 'package:flutter/material.dart';
import 'package:flutter_flow_list/main.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'fancy_tab_item.dart';
import 'package:vector_math/vector_math.dart' as vector;

enum TabItem { list, chat, settings }

class TabHelper {
  static TabItem item({int index}) {
    switch (index) {
      case 0:
        return TabItem.list;
      case 1:
        return TabItem.chat;
      case 2:
        return TabItem.settings;
    }
    return TabItem.chat;
  }

  static String description(TabItem tabItem) {
    switch (tabItem) {
      case TabItem.list:
        return 'LIST';
      case TabItem.chat:
        return 'CHAT';
      case TabItem.settings:
        return 'SETTINGS';
    }
    return '';
  }

  static String initialRoute(TabItem tabItem) {
    switch (tabItem) {
      case TabItem.list:
        return Constants.koprRoute;
      case TabItem.chat:
        return Constants.chatRoute;
      case TabItem.settings:
        return Constants.settingsRoute;
    }
    return Constants.notFoundRoute;
  }

  static IconData icon(TabItem tabItem) {
    switch (tabItem) {
      case TabItem.list:
        return Icons.format_list_bulleted;
      case TabItem.chat:
        return Icons.chat;
      case TabItem.settings:
        return Icons.settings;
    }
    return Icons.error;
  }

  static MaterialColor color(TabItem tabItem, BuildContext context) {
    switch (tabItem) {
      case TabItem.list:
        return Theme.of(context).accentColor;
      case TabItem.chat:
        return Theme.of(context).accentColor;
      case TabItem.settings:
        return Theme.of(context).accentColor;
    }
    return Colors.grey;
  }
}

class FancyBottomNavigation extends StatefulWidget {
  final TabItem _selectedTab;
  final ValueChanged<TabItem> onTabChanged;

  FancyBottomNavigation(this._selectedTab, {this.onTabChanged});

  @override
  _FancyBottomNavigationState createState() =>
      _FancyBottomNavigationState(selectedTab: _selectedTab);
}

class _FancyBottomNavigationState extends State<FancyBottomNavigation>
    with TickerProviderStateMixin {
  _FancyBottomNavigationState({@required this.selectedTab});

  AnimationController _animationController;
  Tween<double> _positionTween;
  Animation<double> _positionAnimation;

  AnimationController _fadeOutController;
  Animation<double> _fadeFabOutAnimation;
  Animation<double> _fadeFabInAnimation;

  double fabIconAlpha = 1;
  IconData nextIcon = Icons.search;
  IconData activeIcon = Icons.search;

  TabItem selectedTab;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: ANIM_DURATION));
    _fadeOutController = AnimationController(
        vsync: this, duration: Duration(milliseconds: (ANIM_DURATION ~/ 5)));

    _positionTween = Tween<double>(begin: 0, end: 0);
    _positionAnimation = _positionTween.animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutExpo))
      ..addListener(() {
        setState(() {});
      });

    _fadeFabOutAnimation = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: _fadeOutController, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {
          fabIconAlpha = _fadeFabOutAnimation.value;
        });
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            activeIcon = nextIcon;
          });
        }
      });

    _fadeFabInAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.8, 1, curve: Curves.easeOut)))
      ..addListener(() {
        setState(() {
          fabIconAlpha = _fadeFabInAnimation.value;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    List<FancyTabItem> fancyItems = <FancyTabItem>[];
    for (TabItem tabItem in TabItem.values) {
      fancyItems.add(FancyTabItem(
          selected: selectedTab == tabItem,
          iconData: TabHelper.icon(tabItem),
          title: TabHelper.description(tabItem),
          callbackFunction: () {
            setState(() {
              nextIcon = TabHelper.icon(tabItem);
              selectedTab = tabItem;
              widget.onTabChanged(tabItem);
            });
            _initAnimationAndStart(
                _positionAnimation.value, tabItem.index - 1.0);
          }));
    }

    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          height: 65,
          margin: EdgeInsets.only(top: 45),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, -1), blurRadius: 8)
          ]),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: fancyItems,
          ),
        ),
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(color: Colors.transparent),
            child: Align(
              heightFactor: 1,
              alignment: Alignment(_positionAnimation.value, 0),
              child: FractionallySizedBox(
                widthFactor: 1 / 3,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 90,
                      width: 90,
                      child: ClipRect(
                          clipper: HalfClipper(),
                          child: Container(
                            child: Center(
                              child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 8)
                                      ])),
                            ),
                          )),
                    ),
                    SizedBox(
                        height: 70,
                        width: 90,
                        child: CustomPaint(
                          painter: HalfPainter(),
                        )),
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).accentColor,
                            border: Border.all(
                                color: Colors.white,
                                width: 5,
                                style: BorderStyle.none)),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Opacity(
                            opacity: fabIconAlpha,
                            child: Icon(
                              activeIcon,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _initAnimationAndStart(double from, double to) {
    _positionTween.begin = from;
    _positionTween.end = to;

    _animationController.reset();
    _fadeOutController.reset();
    _animationController.forward();
    _fadeOutController.forward();
  }
}

class HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height / 2);
    return rect;
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}

class HalfPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect beforeRect = Rect.fromLTWH(0, (size.height / 2) - 10, 10, 10);
    final Rect largeRect = Rect.fromLTWH(10, 0, size.width - 20, 70);
    final Rect afterRect =
        Rect.fromLTWH(size.width - 10, (size.height / 2) - 10, 10, 10);

    final path = Path();
    path.arcTo(beforeRect, vector.radians(0), vector.radians(90), false);
    path.lineTo(20, size.height / 2);
    path.arcTo(largeRect, vector.radians(0), -vector.radians(180), false);
    path.moveTo(size.width - 10, size.height / 2);
    path.lineTo(size.width - 10, (size.height / 2) - 10);
    path.arcTo(afterRect, vector.radians(180), vector.radians(-90), false);
    path.close();

    canvas.drawPath(path, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

import 'package:flutter/material.dart';
import 'models.dart';

enum _AdaptiveScaffoldType {
  bottomMenu,
  leftMenu,
}

class AdaptiveScaffold extends StatefulWidget {
  const AdaptiveScaffold({
    Key? key,
    this.leftMenuHeader,
    this.leftMenuFooter,
    required this.destinations,
  }) : super(key: key);
  final List<AdaptiveScaffoldDestination> destinations;
  final Widget? leftMenuHeader;
  final Widget? leftMenuFooter;

  @override
  State<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _AdaptiveScaffoldType _getAdaptiveScaffoldType(BuildContext context) {
    if (MediaQuery.of(context).size.width < 768) {
      return _AdaptiveScaffoldType.bottomMenu;
    } else {
      return _AdaptiveScaffoldType.leftMenu;
    }
  }

  @override
  Widget build(BuildContext context) {
    var type = _getAdaptiveScaffoldType(context);
    return Scaffold(
      body: Row(
        children: [
          ...type == _AdaptiveScaffoldType.leftMenu
              ? [
                  _buildLeftMenu(context),
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                  ),
                ]
              : [],
          Expanded(
            child: _buildPages(context),
          ),
        ],
      ),
      bottomNavigationBar: type == _AdaptiveScaffoldType.bottomMenu
          ? _BottomMenu(
              controller: _controller,
              items: widget.destinations,
            )
          : null,
    );
  }

  Widget _buildLeftMenu(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...widget.leftMenuHeader != null
              ? [
                  widget.leftMenuHeader!,
                ]
              : [],
          Expanded(
            child: _LeftMenu(
              controller: _controller,
              items: widget.destinations,
            ),
          ),
          ...widget.leftMenuFooter != null
              ? [
                  const Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  widget.leftMenuFooter!,
                ]
              : [],
        ],
      ),
    );
  }

  Widget _buildPages(BuildContext context) {
    return PageView.builder(
      physics: const NeverScrollableScrollPhysics(),
      controller: _controller,
      itemBuilder: (context, index) {
        var item = widget.destinations[index];
        if (item.keepAlive) {
          return _KeepAliveView(
            child: item.bodyBuilder(context),
          );
        } else {
          return item.bodyBuilder(context);
        }
      },
    );
  }
}

class _KeepAliveView extends StatefulWidget {
  final Widget child;
  const _KeepAliveView({required this.child});
  @override
  _KeepAliveViewState createState() => _KeepAliveViewState();
}

class _KeepAliveViewState extends State<_KeepAliveView>
    with AutomaticKeepAliveClientMixin<_KeepAliveView> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class _BottomMenu extends StatefulWidget {
  final PageController controller;
  final List<AdaptiveScaffoldDestination> items;

  const _BottomMenu({
    Key? key,
    required this.controller,
    required this.items,
  }) : super(key: key);
  @override
  _BottomMenuState createState() => _BottomMenuState();
}

class _BottomMenuState extends State<_BottomMenu> {
  late int _index;

  @override
  void initState() {
    if (widget.controller.hasClients && widget.controller.page != null) {
      _index = widget.controller.page!.round();
    } else {
      _index = widget.controller.initialPage;
    }
    widget.controller.addListener(_indexChange);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_indexChange);
    super.dispose();
  }

  void _indexChange() {
    int page = widget.controller.page!.round();
    if (_index != page) {
      setState(() {
        _index = page;
      });
    }
  }

  void _onItemClick(int value) {
    if (value == widget.controller.page!.round()) {
      widget.items[value].onTitleSelectedClick?.call();
    } else {
      widget.controller.jumpToPage(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedFontSize: 12,
      unselectedFontSize: 12,
      iconSize: 22,
      type: BottomNavigationBarType.fixed,
      currentIndex: _index,
      onTap: _onItemClick,
      items: widget.items
          .map((item) => BottomNavigationBarItem(
                icon: item.icon,
                activeIcon: item.activeIcon,
                label: item.title,
              ))
          .toList(),
    );
  }
}

class _LeftMenu extends StatefulWidget {
  final PageController controller;
  final List<AdaptiveScaffoldDestination> items;

  const _LeftMenu({
    Key? key,
    required this.controller,
    required this.items,
  }) : super(key: key);
  @override
  _LeftMenuState createState() => _LeftMenuState();
}

class _LeftMenuState extends State<_LeftMenu> {
  late int _index;

  @override
  void initState() {
    if (widget.controller.hasClients && widget.controller.page != null) {
      _index = widget.controller.page!.round();
    } else {
      _index = widget.controller.initialPage;
    }
    widget.controller.addListener(_indexChange);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_indexChange);
    super.dispose();
  }

  void _indexChange() {
    int page = widget.controller.page!.round();
    if (_index != page) {
      setState(() {
        _index = page;
      });
    }
  }

  void _onItemClick(int value) {
    if (value == widget.controller.page!.round()) {
      widget.items[value].onTitleSelectedClick?.call();
    } else {
      widget.controller.jumpToPage(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (int i = 0; i < widget.items.length; i++) {
      var item = widget.items[i];
      children.add(ListTile(
        leading: (_index == i && item.activeIcon != null)
            ? item.activeIcon
            : item.icon,
        title: Text(item.title),
        selected: _index == i,
        selectedTileColor: Theme.of(context).hoverColor,
        onTap: () {
          _onItemClick(i);
        },
      ));
    }
    return ListView(
      children: children,
    );
  }
}

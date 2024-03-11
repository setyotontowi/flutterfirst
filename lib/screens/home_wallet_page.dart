import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeWalletPage extends StatefulWidget {
  const HomeWalletPage({super.key});

  @override
  State<HomeWalletPage> createState() => _HomeWalletPageState();
}

class _HomeWalletPageState extends State<HomeWalletPage> {
  double _opacity = 1.0;
  double _height = 80.0;
  late final ScrollController _scrollController;
  ScrollNotification? _lastNotification;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      double scrollFraction = _scrollController.offset / 80.0;
      setState(() {
        _opacity = 1.0 - scrollFraction.clamp(0.0, 1.0);
        _height = 80.0 * (1.0 - scrollFraction.clamp(0.0, 1.0));
        print("Height  = $_height");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          floating: true,
          expandedHeight: _height,
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
            centerTitle: true,
            collapseMode: CollapseMode.pin,
            title: WalletAppBar(
              title: "Wallet",
              subtitle: "You have 3 active wallets",
              opacity: _opacity,
              button: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    print("ONPRESSED");
                  }),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                height: 100.0,
              );
            },
            childCount: 20,
          ),
        ),
      ],
    );
  }
}

class WalletAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final Widget button;
  final double opacity;

  const WalletAppBar({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.button,
    required this.opacity,
  }) : super(key: key);

  bool isVisible(double opacity) {
    if (opacity > 0.0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<WalletAppBar> createState() => _WalletAppBarState();
}

class _WalletAppBarState extends State<WalletAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Stack(alignment: Alignment.bottomCenter, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(widget.title, style: TextStyle(fontSize: 18.0)),
                  Opacity(
                      opacity: widget.opacity,
                      child: Text(widget.subtitle,
                          style: TextStyle(fontSize: 10.0, color: Colors.grey)))
                ],
              ),
              Visibility(
                  visible: widget.isVisible(widget.opacity),
                  child: Opacity(opacity: widget.opacity, child: widget.button)),
            ],
          ),
        ),
      ]),
      actions: [],
    );
  }
}

import 'package:flutter/material.dart';

class HomeWalletPage extends StatefulWidget {
  const HomeWalletPage({super.key});

  @override
  State<HomeWalletPage> createState() => _HomeWalletPageState();
}

class _HomeWalletPageState extends State<HomeWalletPage> {
  double _opacity = 1.0;
  late final ScrollController _scrollController;
  ScrollNotification? _lastNotification;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      double scrollFraction = _scrollController.offset / 80.0;
      setState(() {
        _opacity = 1.0 - scrollFraction.clamp(0.0, 1.0);
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
          expandedHeight: 80.0,
          stretch: false,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(bottom: 8.0),
            centerTitle: true,
            collapseMode: CollapseMode.pin,
            title: WalletAppBar(
              title: "Wallet",
              subtitle: "You have 3 active wallets",
              opacity: _opacity,
              button: IconButton(
                icon: Icon(Icons.add),
                onPressed: null,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                color: index.isOdd ? Colors.white : Colors.black12,
                height: 100.0,
                child: Center(
                  child: Text('$index', textScaler: const TextScaler.linear(5.0)),
                ),
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
        Row(
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
                    child:
                        Text(widget.subtitle, style: TextStyle(fontSize: 14.0, color: Colors.grey)))
              ],
            ),
            widget.button,
          ],
        ),
        Container(
          color: Colors.amber.withOpacity(0.5),
          width: double.infinity,
        )
      ]),
      actions: [],
    );
  }
}

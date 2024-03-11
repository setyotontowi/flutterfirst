import 'package:flutter/material.dart';

class HomeWalletPage extends StatelessWidget {
  const HomeWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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

class WalletAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final Widget button;

  const WalletAppBar({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.button,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

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
                Text(title, style: TextStyle(fontSize: 18.0)),
                Text(subtitle, style: TextStyle(fontSize: 14.0, color: Colors.grey))
              ],
            ),
            button,
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

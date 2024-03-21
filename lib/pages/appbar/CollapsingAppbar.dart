import 'package:firstapp/pages/home_page.dart';
import 'package:flutter/material.dart';

class CollapsingAppbarWithTabsPage extends StatelessWidget {
  const CollapsingAppbarWithTabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 300.0,
                floating: false,
                pinned: true,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    collapseMode: CollapseMode.parallax,
                    background: Image.network(
                      "https://media.licdn.com/dms/image/C4D0BAQE4NqLgFy5pwA/company-logo_200_200/0/1673460887289?e=2147483647&v=beta&t=NuVm3Hd7SdKTYG1oRAknpfhmwJzoAFHGG-6XavRL6f8",
                      fit: BoxFit.cover,
                    )),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  const TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: Color.fromARGB(255, 206, 13, 224),
                    unselectedLabelColor: Colors.grey,
                    tabs: _tabs,
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(children: _tabs.map((e) => HomePage()).toList()),
        ),
      ),
    );
  }
}

const _tabs = [
  Tab(icon: Icon(Icons.home_rounded), text: "Home"),
  Tab(icon: Icon(Icons.person), text: "Customers"),
  Tab(icon: Icon(Icons.shopping_bag_rounded), text: "Services"),
];

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _tabBar;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

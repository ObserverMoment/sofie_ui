import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class ShimmerCircle extends StatelessWidget {
  final double diameter;
  const ShimmerCircle({Key? key, required this.diameter}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.15,
      child: Shimmer.fromColors(
          baseColor: context.theme.cardBackground,
          highlightColor: context.theme.primary,
          child: Container(
            height: diameter,
            width: diameter,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: context.theme.primary),
          )),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  final double? height;
  final double? width;
  const ShimmerCard({Key? key, this.height, this.width}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.15,
      child: Shimmer.fromColors(
          baseColor: context.theme.cardBackground,
          highlightColor: context.theme.primary,
          child: Card(
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.circular(12),
            margin: const EdgeInsets.all(4),
            height: height,
            child: Container(width: width),
          )),
    );
  }
}

class ShimmerCardList extends StatelessWidget {
  final int itemCount;
  final double? cardHeight;
  final EdgeInsets cardPadding;
  const ShimmerCardList(
      {Key? key,
      required this.itemCount,
      this.cardHeight = 160,
      this.cardPadding = const EdgeInsets.symmetric(vertical: 6.0)})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(4.0),
      itemCount: itemCount,
      itemBuilder: (context, index) => Padding(
        padding: cardPadding,
        child: ShimmerCard(
          height: cardHeight,
        ),
      ),
    );
  }
}

class ShimmerHorizontalCardList extends StatelessWidget {
  final int itemCount;
  final double listHeight;
  final double cardWidth;

  const ShimmerHorizontalCardList(
      {Key? key,
      this.itemCount = 10,
      this.listHeight = 120,
      this.cardWidth = 170})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: listHeight,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(4.0),
          child: ShimmerCard(
            width: cardWidth,
          ),
        ),
      ),
    );
  }
}

class ShimmerFriendsList extends StatelessWidget {
  final int itemCount;
  final double avatarSize;
  final Axis scrollDirection;
  const ShimmerFriendsList(
      {Key? key,
      this.itemCount = 10,
      this.avatarSize = 76,
      this.scrollDirection = Axis.horizontal})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: avatarSize,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: itemCount,
        scrollDirection: scrollDirection,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ShimmerCircle(
            diameter: avatarSize,
          ),
        ),
      ),
    );
  }
}

class ShimmerCardGrid extends StatelessWidget {
  final int itemCount;
  final double maxCardWidth;
  final EdgeInsets cardPadding;
  const ShimmerCardGrid(
      {Key? key,
      required this.itemCount,
      this.maxCardWidth = 200,
      this.cardPadding = const EdgeInsets.all(6.0)})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 12, right: 12),
      child: GridView.builder(
          shrinkWrap: true,
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: maxCardWidth,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16),
          itemBuilder: (c, i) => const ShimmerCard()),
    );
  }
}

class ShimmerCirclesGrid extends StatelessWidget {
  final int itemCount;
  final double maxDiameter;
  final EdgeInsets cardPadding;
  const ShimmerCirclesGrid(
      {Key? key,
      this.itemCount = 20,
      this.maxDiameter = 80,
      this.cardPadding = const EdgeInsets.all(6.0)})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 12, right: 12),
      child: GridView.builder(
          shrinkWrap: true,
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: maxDiameter,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16),
          itemBuilder: (c, i) => ShimmerCircle(
                diameter: maxDiameter,
              )),
    );
  }
}

class ShimmerListPage extends StatelessWidget {
  final String title;
  final double? cardHeight;
  const ShimmerListPage(
      {Key? key, this.title = 'Getting ready...', this.cardHeight = 200})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        navigationBar: MyNavBar(
          middle: NavBarTitle(title),
        ),
        child: ShimmerCardList(
          itemCount: 10,
          cardHeight: cardHeight,
        ));
  }
}

class ShimmerGridPage extends StatelessWidget {
  final String title;
  const ShimmerGridPage({Key? key, this.title = 'Getting ready...'})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        navigationBar: MyNavBar(
          middle: NavBarTitle(title),
        ),
        child: const ShimmerCardGrid(
          itemCount: 10,
        ));
  }
}

class ShimmerDetailsPage extends StatelessWidget {
  final String title;
  const ShimmerDetailsPage({Key? key, this.title = 'Getting ready...'})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        navigationBar: MyNavBar(
          backgroundColor: context.theme.background,
          middle: NavBarTitle(title),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ShimmerCard(),
              ),
            ),
            Flexible(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ShimmerCard(),
              ),
            ),
            Flexible(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ShimmerCard(),
              ),
            ),
          ],
        ));
  }
}

class ShimmerChatChannelPreviewList extends StatelessWidget {
  final int itemCount;
  const ShimmerChatChannelPreviewList({
    Key? key,
    this.itemCount = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = context.theme.primary.withOpacity(0.4);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: itemCount,
          itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Shimmer.fromColors(
                  baseColor: context.theme.cardBackground,
                  highlightColor: primary,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    height: 66,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: primary,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints.tightFor(
                            height: 44,
                            width: 44,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                constraints: const BoxConstraints.tightFor(
                                  height: 14,
                                  width: 90,
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                    constraints: const BoxConstraints.expand(
                                      height: 14,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: primary,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints.tightFor(
                            height: 22,
                            width: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
    );
  }
}

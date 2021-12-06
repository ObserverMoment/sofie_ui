import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/profile/social_media_links.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/model/country.dart';
import 'package:sofie_ui/pages/authed/progress/components/lifetime_log_stats_summary.dart';
import 'package:sofie_ui/services/stream.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class HeaderContent extends StatelessWidget {
  final UserProfile profile;
  final double avatarSize;
  final bool isAuthedUserProfile;
  const HeaderContent(
      {Key? key,
      required this.profile,
      this.avatarSize = 100,
      required this.isAuthedUserProfile})
      : super(key: key);

  EdgeInsets get verticalPadding => const EdgeInsets.symmetric(vertical: 8.0);

  @override
  Widget build(BuildContext context) {
    final hasSocialLinks = [
      profile.youtubeHandle,
      profile.instagramHandle,
      profile.tiktokHandle,
      profile.linkedinHandle,
    ].any((l) => l != null);

    final hasCountry = Utils.textNotNull(profile.countryCode);
    final hasTown = Utils.textNotNull(profile.townCity);

    final followerCount = profile.followerCount ?? 0;

    return Padding(
      padding: EdgeInsets.only(top: avatarSize / 2),
      child: Card(
          padding: EdgeInsets.only(
              top: avatarSize / 2, left: 10, right: 10, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 10),
              if (!isAuthedUserProfile)
                Padding(
                  padding: verticalPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UserFeedConnectionButton(
                        otherUserId: profile.id,
                      ),
                      const SizedBox(width: 8),
                      BorderButton(
                        text: 'Message',
                        prefix: const Icon(
                          CupertinoIcons.chat_bubble_2,
                          size: 15,
                        ),
                        onPressed: () => context.navigateTo(OneToOneChatRoute(
                          otherUserId: profile.id,
                        )),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 4),
              if (Utils.textNotNull(profile.tagline))
                MyText(
                  profile.tagline!,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  weight: FontWeight.bold,
                ),
              if (hasCountry || hasTown)
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (hasCountry)
                        MyText(
                          Country.fromIsoCode(profile.countryCode!).name,
                          size: FONTSIZE.two,
                          subtext: true,
                        ),
                      if (hasCountry && hasTown)
                        const MyText(
                          ' | ',
                          size: FONTSIZE.two,
                          subtext: true,
                        ),
                      if (hasTown)
                        MyText(
                          profile.townCity!,
                          size: FONTSIZE.two,
                          subtext: true,
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              if (Utils.textNotNull(profile.bio))
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                  child: ReadMoreTextBlock(
                    text: profile.bio!,
                    title: 'Bio',
                    textAlign: TextAlign.center,
                    trimLines: 5,
                  ),
                ),
              if (followerCount > 0)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText('$followerCount', size: FONTSIZE.five),
                      const SizedBox(height: 3),
                      const MyText(
                        'FOLLOWERS',
                        size: FONTSIZE.one,
                        subtext: true,
                      )
                    ],
                  ),
                ),
              const HorizontalLine(),
              if (profile.lifetimeLogStatsSummary != null)
                Container(
                  height: 60,
                  alignment: Alignment.center,
                  child: LifetimeLogStatsSummaryDisplay(
                    minutesWorked:
                        profile.lifetimeLogStatsSummary!.minutesWorked,
                    sessionsLogged:
                        profile.lifetimeLogStatsSummary!.sessionsLogged,
                  ),
                ),
              if (hasSocialLinks) const HorizontalLine(),
              if (hasSocialLinks)
                Padding(
                  padding: verticalPadding,
                  child: SocialMediaLinks(
                    profile: profile,
                  ),
                ),
            ],
          )),
    );
  }
}

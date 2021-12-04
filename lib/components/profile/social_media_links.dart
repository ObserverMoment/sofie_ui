import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaLinks extends StatelessWidget {
  final UserProfile userPublicProfile;
  const SocialMediaLinks({Key? key, required this.userPublicProfile})
      : super(key: key);

  Future<void> _handleOpenSocialUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        if (Utils.textNotNull(userPublicProfile.instagramHandle))
          _SocialLink(
              url: userPublicProfile.instagramHandle!,
              onPressed: () =>
                  _handleOpenSocialUrl(userPublicProfile.instagramHandle!)),
        if (Utils.textNotNull(userPublicProfile.tiktokHandle))
          _SocialLink(
              url: userPublicProfile.tiktokHandle!,
              onPressed: () =>
                  _handleOpenSocialUrl(userPublicProfile.tiktokHandle!)),
        if (Utils.textNotNull(userPublicProfile.linkedinHandle))
          _SocialLink(
              url: userPublicProfile.linkedinHandle!,
              onPressed: () =>
                  _handleOpenSocialUrl(userPublicProfile.linkedinHandle!)),
        if (Utils.textNotNull(userPublicProfile.youtubeHandle))
          _SocialLink(
              url: userPublicProfile.youtubeHandle!,
              onPressed: () =>
                  _handleOpenSocialUrl(userPublicProfile.youtubeHandle!)),
      ],
    );
  }
}

class _SocialLink extends StatelessWidget {
  final String url;
  final VoidCallback onPressed;
  const _SocialLink({Key? key, required this.url, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(CupertinoIcons.link, size: 16),
          const SizedBox(width: 6),
          MyText(
            url,
            size: FONTSIZE.two,
            weight: FontWeight.bold,
          )
        ],
      ),
    );
  }
}

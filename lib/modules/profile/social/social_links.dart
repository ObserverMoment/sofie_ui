import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/other_app_icons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

enum _Network { tiktok, youtube, instagram, linkedin }

Map<_Network, String> _mapping = {
  _Network.tiktok: kTiktokBaseUrl,
  _Network.youtube: kYoutubeBaseUrl,
  _Network.instagram: kInstagramBaseUrl,
  _Network.linkedin: kLinkedinBaseUrl
};

class SocialLinks extends StatelessWidget {
  final UserProfile profile;
  const SocialLinks({Key? key, required this.profile}) : super(key: key);

  Future<void> _handleOpenSocialUrl(_Network network, String handle) async {
    final url = '${_mapping[network]}/$handle';

    if (await canLaunchUrl(Uri(path: url))) {
      await launchUrl(Uri(path: url));
    } else {
      throw 'Could not launch $handle';
    }
  }

  double get _iconSize => 24.0;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        if (Utils.textNotNull(profile.instagramHandle))
          _SocialLink(
              handle: profile.instagramHandle!,
              icon: InstagramIcon(size: _iconSize),
              onPressed: () => _handleOpenSocialUrl(
                  _Network.instagram, profile.instagramHandle!)),
        if (Utils.textNotNull(profile.tiktokHandle))
          _SocialLink(
              handle: profile.tiktokHandle!,
              icon: TikTokIcon(size: _iconSize),
              onPressed: () =>
                  _handleOpenSocialUrl(_Network.tiktok, profile.tiktokHandle!)),
        if (Utils.textNotNull(profile.linkedinHandle))
          _SocialLink(
              handle: profile.linkedinHandle!,
              icon: LinkedInIcon(size: _iconSize),
              onPressed: () => _handleOpenSocialUrl(
                  _Network.linkedin, profile.linkedinHandle!)),
        if (Utils.textNotNull(profile.youtubeHandle))
          _SocialLink(
              handle: profile.youtubeHandle!,
              icon: YouTubeIcon(size: _iconSize),
              onPressed: () => _handleOpenSocialUrl(
                  _Network.youtube, profile.youtubeHandle!)),
      ],
    );
  }
}

class _SocialLink extends StatelessWidget {
  final String handle;
  final VoidCallback onPressed;
  final Widget icon;
  const _SocialLink(
      {Key? key,
      required this.handle,
      required this.onPressed,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentBox(
      backgroundColor: context.theme.cardBackground.withOpacity(0.75),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(width: 5),
              MyText(
                handle,
              )
            ],
          ),
        ),
      ),
    );
  }
}

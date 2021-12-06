import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/other_app_icons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaLinks extends StatelessWidget {
  final UserProfile profile;
  const SocialMediaLinks({Key? key, required this.profile}) : super(key: key);

  Future<void> _handleOpenSocialUrl(String handle) async {
    /// TODO: convert to correct url based on network name.

    if (await canLaunch(handle)) {
      await launch(handle);
    } else {
      throw 'Could not launch $handle';
    }
  }

  double get _iconSize => 20.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, top: 4, right: 4),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: [
          if (Utils.textNotNull(profile.instagramHandle))
            _SocialLink(
                handle: profile.instagramHandle!,
                icon: InstagramIcon(size: _iconSize),
                onPressed: () =>
                    _handleOpenSocialUrl(profile.instagramHandle!)),
          if (Utils.textNotNull(profile.tiktokHandle))
            _SocialLink(
                handle: profile.tiktokHandle!,
                icon: TikTokIcon(size: _iconSize),
                onPressed: () => _handleOpenSocialUrl(profile.tiktokHandle!)),
          if (Utils.textNotNull(profile.linkedinHandle))
            _SocialLink(
                handle: profile.linkedinHandle!,
                icon: LinkedInIcon(size: _iconSize),
                onPressed: () => _handleOpenSocialUrl(profile.linkedinHandle!)),
          if (Utils.textNotNull(profile.youtubeHandle))
            _SocialLink(
                handle: profile.youtubeHandle!,
                icon: YouTubeIcon(size: _iconSize),
                onPressed: () => _handleOpenSocialUrl(profile.youtubeHandle!)),
        ],
      ),
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 6),
            MyText(
              handle,
            )
          ],
        ),
      ),
    );
  }
}

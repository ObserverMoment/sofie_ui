import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/other_app_icons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class SocialHandlesInput extends StatelessWidget {
  final void Function(String key, String value) update;
  final UserProfile profile;
  const SocialHandlesInput(
      {Key? key, required this.update, required this.profile})
      : super(key: key);

  Widget _padding({required Widget child}) =>
      Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: child);

  double get _iconSize => 24.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MyHeaderText('Social Handles'),
        const SizedBox(height: 6),
        _padding(
          child: _HandleInput(
            title: 'YouTube',
            icon: YouTubeIcon(size: _iconSize),
            value: profile.youtubeHandle,
            updateHandle: (h) => update('youtubeHandle', h),
          ),
        ),
        _padding(
          child: _HandleInput(
            title: 'Instagram',
            icon: InstagramIcon(size: _iconSize),
            value: profile.instagramHandle,
            updateHandle: (h) => update('instagramHandle', h),
          ),
        ),
        _padding(
          child: _HandleInput(
            title: 'TikTok',
            icon: TikTokIcon(size: _iconSize),
            value: profile.tiktokHandle,
            updateHandle: (h) => update('tiktokHandle', h),
          ),
        ),
        _padding(
          child: _HandleInput(
            title: 'LinkedIn',
            icon: LinkedInIcon(size: _iconSize),
            value: profile.linkedinHandle,
            updateHandle: (h) => update('linkedinHandle', h),
          ),
        ),
      ],
    );
  }
}

class _HandleInput extends StatelessWidget {
  final String title;
  final String? value;
  final void Function(String handle) updateHandle;
  final Widget icon;
  const _HandleInput({
    Key? key,
    required this.title,
    required this.updateHandle,
    this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EditableTextFieldRow(
      text: value ?? '',
      inputValidation: (t) => true,
      onSave: updateHandle,
      title: title,
      icon: icon,
      validationMessage:
          'Enter your user name or handle, NOT a full web address',
    );
  }
}

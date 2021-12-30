import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/material_elevation.dart';

class UserAvatar extends StatelessWidget {
  final String? avatarUri; // Uploadcare file ID. aka user.avatarUrl
  final double size;
  final bool border;
  final double borderWidth;
  final int? elevation;

  const UserAvatar({
    Key? key,
    this.size = 100,
    this.avatarUri,
    this.border = false,
    this.borderWidth = 3,
    this.elevation = 3,
  }) : super(key: key);

  Widget _buildAvatar(BuildContext context) => Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: context.theme.cardBackground),
      width: border ? size - (borderWidth * 2) : size,
      height: border ? size - (borderWidth * 2) : size,
      child: avatarUri == null
          ? Center(
              child: Icon(
                CupertinoIcons.person_alt,
                size: size / 1.5,
              ),
            )
          : SizedUploadcareImage(
              avatarUri!,
              displaySize: Size.square(size * 2),
            ));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: kElevation[elevation], shape: BoxShape.circle),
      child: border
          ? Container(
              padding: EdgeInsets.all(borderWidth),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: context.theme.cardBackground),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: context.theme.background, width: borderWidth)),
                child: _buildAvatar(context),
              ),
            )
          : _buildAvatar(context),
    );
  }
}

/// A circle that displays [+ overflow] in the same style as a user avatar.
class UserCountDisplay extends StatelessWidget {
  final int count;
  final double size;
  final FONTSIZE fontSize;
  final bool border;
  final double borderWidth;

  const UserCountDisplay(
      {Key? key,
      required this.count,
      this.size = 100,
      this.border = false,
      this.borderWidth = 3,
      this.fontSize = FONTSIZE.three})
      : super(key: key);

  double get outerPadding => size * 0.1;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: border ? size - borderWidth - outerPadding : size - outerPadding,
        height:
            border ? size - borderWidth - outerPadding : size - outerPadding,
        decoration: BoxDecoration(
            boxShadow: kElevation[3],
            shape: BoxShape.circle,
            color: context.theme.primary.withOpacity(0.9),
            border: border ? Border.all(color: Styles.primaryAccent) : null),
        child: Center(
            child: MyText(
          '$count',
          color: context.theme.background,
          lineHeight: 1,
          size: fontSize,
          weight: FontWeight.bold,
        )));
  }
}

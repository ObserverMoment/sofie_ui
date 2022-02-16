import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class UserDayLogRatingSelector extends StatefulWidget {
  final UserDayLogRating? userDayLogRating;

  /// For emoji use the name as found here:
  /// https://raw.githubusercontent.com/omnidan/node-emoji/master/lib/emoji.json
  final String? badLabel;
  final String? badEmoji;
  final String? averageLabel;
  final String? averageEmoji;
  final String? goodEmoji;
  final String? goodLabel;
  final void Function(UserDayLogRating userDayLogRating) updateRating;
  const UserDayLogRatingSelector(
      {Key? key,
      this.userDayLogRating,
      required this.updateRating,
      this.badEmoji,
      this.averageEmoji,
      this.goodEmoji,
      this.badLabel,
      this.averageLabel,
      this.goodLabel})
      : super(key: key);

  @override
  State<UserDayLogRatingSelector> createState() =>
      _UserDayLogRatingSelectorState();
}

class _UserDayLogRatingSelectorState extends State<UserDayLogRatingSelector> {
  /// https://raw.githubusercontent.com/omnidan/node-emoji/master/lib/emoji.json
  /// https://pub.dev/packages/flutter_emoji/example
  final parser = EmojiParser();

  Widget _buildIcon() {
    switch (widget.userDayLogRating) {
      case UserDayLogRating.bad:
        return SizeFadeIn(
            key: Key(widget.userDayLogRating.toString()),
            child: MyText(
              parser.emojify(widget.badEmoji != null
                  ? ':${widget.badEmoji}:'
                  : ':disappointed:'),
              size: FONTSIZE.eleven,
            ));
      case UserDayLogRating.average:
        return SizeFadeIn(
            key: Key(widget.userDayLogRating.toString()),
            child: MyText(
              parser.emojify(widget.averageEmoji != null
                  ? ':${widget.averageEmoji}:'
                  : ':neutral_face:'),
              size: FONTSIZE.eleven,
            ));
      case UserDayLogRating.good:
        return SizeFadeIn(
            key: Key(widget.userDayLogRating.toString()),
            child: MyText(
              parser.emojify(widget.goodEmoji != null
                  ? ':${widget.goodEmoji}:'
                  : ':grinning:'),
              size: FONTSIZE.eleven,
            ));
      default:
        throw Exception(
            'UserDayLogRatingSelector._buildIcon: No builder defined for ${widget.userDayLogRating}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.userDayLogRating != null)
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildIcon(),
          ),
        MySlidingSegmentedControl<UserDayLogRating>(
          fontSize: 20,
          value: widget.userDayLogRating,
          updateValue: widget.updateRating,
          children: {
            UserDayLogRating.bad: widget.badLabel ?? 'Bad',
            UserDayLogRating.average: widget.averageLabel ?? 'OK',
            UserDayLogRating.good: widget.goodLabel ?? 'Good!',
          },
        ),
      ],
    );
  }
}

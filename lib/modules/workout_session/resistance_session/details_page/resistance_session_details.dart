import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/profile/user_avatar/user_avatar.dart';
import 'package:sofie_ui/modules/workout_session/resistance_session/details_page/info_section.dart';
import 'package:sofie_ui/modules/workout_session/resistance_session/display/resistance_exercise_display.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/utils.dart';

class ResistanceSessionDetails extends StatelessWidget {
  final ResistanceSession resistanceSession;
  const ResistanceSessionDetails({Key? key, required this.resistanceSession})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? authedUserId = GetIt.I<AuthBloc>().authedUser?.id;
    final bool isOwner = resistanceSession.user.id == authedUserId;

    return ListView(
      children: [
        if (!isOwner)
          GestureDetector(
            onTap: () => context.navigateTo(UserPublicProfileDetailsRoute(
                userId: resistanceSession.user.id)),
            behavior: HitTestBehavior.opaque,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    UserAvatar(
                      avatarUri: resistanceSession.user.avatarUri,
                      size: 50,
                    ),
                    Column(
                      children: [
                        const MyText('Created by'),
                        const SizedBox(height: 6),
                        MyText(resistanceSession.user.displayName),
                      ],
                    )
                  ],
                ),
                const HorizontalLine(
                  verticalPadding: 8,
                ),
              ],
            ),
          ),
        if (Utils.textNotNull(resistanceSession.note))
          InfoSection(
            content: ReadMoreTextBlock(
                text: resistanceSession.note!, title: resistanceSession.name),
            header: 'Notes',
            icon: CupertinoIcons.doc_text,
          ),
        const SizedBox(height: 12),
        ...resistanceSession.resistanceExercises
            .map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ResistanceExerciseDisplay(
                    resistanceExercise: e,
                    openMoveInfoPageOnSetTap: true,
                  ),
                ))
            .toList(),
      ],
    );
  }
}

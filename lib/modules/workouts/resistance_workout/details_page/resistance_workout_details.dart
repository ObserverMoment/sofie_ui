import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/profile/user_avatar/user_avatar.dart';
import 'package:sofie_ui/modules/workouts/resistance_workout/details_page/info_section.dart';
import 'package:sofie_ui/modules/workouts/resistance_workout/display/resistance_exercise_display.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/utils.dart';

class ResistanceWorkoutDetails extends StatelessWidget {
  final ResistanceWorkout resistanceWorkout;
  const ResistanceWorkoutDetails({Key? key, required this.resistanceWorkout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? authedUserId = GetIt.I<AuthBloc>().authedUser?.id;
    final bool isOwner = resistanceWorkout.user.id == authedUserId;

    return ListView(
      children: [
        if (!isOwner)
          GestureDetector(
            onTap: () => context.navigateTo(UserPublicProfileDetailsRoute(
                userId: resistanceWorkout.user.id)),
            behavior: HitTestBehavior.opaque,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    UserAvatar(
                      avatarUri: resistanceWorkout.user.avatarUri,
                      size: 50,
                    ),
                    Column(
                      children: [
                        const MyText('Created by'),
                        const SizedBox(height: 6),
                        MyText(resistanceWorkout.user.displayName),
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
        if (Utils.textNotNull(resistanceWorkout.note))
          InfoSection(
            content: ReadMoreTextBlock(
                text: resistanceWorkout.note!, title: resistanceWorkout.name),
            header: 'Notes',
            icon: CupertinoIcons.doc_text,
          ),
        const SizedBox(height: 4),
        ...resistanceWorkout.resistanceExercises
            .map((e) => Padding(
                  padding:
                      const EdgeInsets.only(left: 4, right: 4, bottom: 8.0),
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

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/animated/animated_like_heart.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/my_tab_bar_view.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/components/workout_type_icons.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/modules/workouts/resistance_workout/details_page/action_icon_button.dart';
import 'package:sofie_ui/modules/workouts/resistance_workout/details_page/resistance_workout_body_areas.dart';
import 'package:sofie_ui/modules/workouts/resistance_workout/details_page/resistance_workout_details.dart';
import 'package:sofie_ui/modules/workouts/resistance_workout/details_page/resistance_workout_equipment.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/sharing_and_linking.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class ResistanceWorkoutDetailsPage extends StatelessWidget {
  final String id;
  final String? previousPageTitle;
  const ResistanceWorkoutDetailsPage(
      {Key? key, @PathParam('id') required this.id, this.previousPageTitle})
      : super(key: key);

  Future<void> _handleDeleteWorkout(BuildContext context) async {
    context.showConfirmDeleteDialog(
        itemType: 'Resistance Workout',
        onConfirm: () async {
          try {
            await GraphQLStore.store.delete(
                mutation: DeleteResistanceWorkoutMutation(
                    variables: DeleteResistanceWorkoutArguments(id: id)),
                objectId: id,
                typename: kResistanceWorkoutTypeName,
                clearQueryDataAtKeys: [
                  GQLVarParamKeys.resistanceWorkoutById(id),
                ],
                broadcastQueryIds: [GQLOpNames.userCreatedResistanceWorkouts],
                onSuccess: context.pop);
          } catch (e) {
            context.showToast(
                message: kDefaultErrorMessage,
                toastType: ToastType.destructive);
          }
        });
  }

  Future<void> _handleDuplicateWorkout(BuildContext context) async {
    try {
      await GraphQLStore.store.create(
          mutation: DuplicateResistanceWorkoutMutation(
              variables: DuplicateResistanceWorkoutArguments(id: id)),
          addRefToQueries: [GQLOpNames.userCreatedResistanceWorkouts],
          onSuccess: () {
            context.showToast(
              message: 'Copy added to your workouts.',
            );
          });
    } catch (e) {
      context.showToast(
          message: kDefaultErrorMessage, toastType: ToastType.destructive);
    }
  }

  Future<void> _shareWorkout() async {
    await SharingAndLinking.shareLink(
        'resistance/$id', 'Check out this resistance workout!');
  }

  @override
  Widget build(BuildContext context) {
    final query = ResistanceWorkoutByIdQuery(
        variables: ResistanceWorkoutByIdArguments(id: id));

    return QueryObserver<ResistanceWorkoutById$Query,
            ResistanceWorkoutByIdArguments>(
        key: Key('ResistanceWorkoutDetailsPage - ${query.operationName}-$id'),
        query: query,
        parameterizeQuery: true,
        builder: (data) {
          final resistanceWorkout = data.resistanceWorkoutById;

          if (resistanceWorkout == null) {
            return const ObjectNotFoundIndicator();
          }

          final String? authedUserId = GetIt.I<AuthBloc>().authedUser?.id;
          final bool isOwner = resistanceWorkout.user.id == authedUserId;

          return MyPageScaffold(
              navigationBar: MyNavBar(
                previousPageTitle: previousPageTitle,
                middle: MyText(
                  resistanceWorkout.name,
                  weight: FontWeight.bold,
                ),
                trailing: NavBarIconButton(
                  iconData: CupertinoIcons.ellipsis,
                  onPressed: () => openBottomSheetMenu(
                      context: context,
                      child: BottomSheetMenu(
                          header: BottomSheetMenuHeader(
                            name: resistanceWorkout.name,
                            subtitle: 'Resistance Workout',
                          ),
                          items: [
                            if (!isOwner)
                              BottomSheetMenuItem(
                                  text: 'View creator',
                                  icon: CupertinoIcons.profile_circled,
                                  onPressed: () => context.navigateTo(
                                      UserPublicProfileDetailsRoute(
                                          userId: resistanceWorkout.user.id))),
                            if (isOwner)
                              BottomSheetMenuItem(
                                  text: 'Share',
                                  icon: CupertinoIcons.paperplane,
                                  onPressed: _shareWorkout),
                            if (isOwner)
                              BottomSheetMenuItem(
                                  text: 'Edit',
                                  icon: CupertinoIcons.pencil,
                                  onPressed: () => context.navigateTo(
                                      ResistanceWorkoutCreatorRoute(
                                          resistanceWorkout:
                                              resistanceWorkout))),
                            if (isOwner)
                              BottomSheetMenuItem(
                                  text: 'Duplicate',
                                  icon: CupertinoIcons
                                      .plus_rectangle_on_rectangle,
                                  onPressed: () =>
                                      _handleDuplicateWorkout(context)),
                            if (isOwner)
                              BottomSheetMenuItem(
                                  text: 'Export',
                                  icon: CupertinoIcons.download_circle,
                                  onPressed: () => context.showAlertDialog(
                                      title: 'Coming soon!')),
                            if (isOwner)
                              BottomSheetMenuItem(
                                  text: 'Delete',
                                  icon: CupertinoIcons.delete_simple,
                                  isDestructive: true,
                                  onPressed: () =>
                                      _handleDeleteWorkout(context)),
                          ])),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ActionIconButton(
                        icon: const Icon(WorkoutType.resistance),
                        label: 'Do It',
                        onPressed: () {},
                      ),
                      ActionIconButton(
                        icon: const Icon(CupertinoIcons.text_badge_checkmark),
                        label: 'Log It',
                        onPressed: () {},
                      ),
                      ActionIconButton(
                        icon: const Icon(CupertinoIcons.calendar_badge_plus),
                        label: 'Plan It',
                        onPressed: () {},
                      ),
                      if (!isOwner)

                        /// TODO:
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Vibrate.feedback(FeedbackType.selection);
                            print('save / unsave');
                          },
                          child: const ContentBox(
                            child: AnimatedLikeHeart(active: false, size: 26),
                          ),
                        ),
                    ],
                  ),
                  const HorizontalLine(
                    verticalPadding: 8,
                  ),
                  Expanded(
                    child:
                        MyTabBarView(alignment: Alignment.center, tabs: const [
                      'Details',
                      'Equipment',
                      'Body Areas'
                    ], pages: [
                      ResistanceWorkoutDetails(
                        resistanceWorkout: resistanceWorkout,
                      ),
                      ResistanceWorkoutEquipment(
                        resistanceWorkout: resistanceWorkout,
                      ),
                      ResistanceWorkoutBodyAreas(
                        resistanceWorkout: resistanceWorkout,
                      ),
                    ]),
                  )
                ],
              ));
        });
  }
}

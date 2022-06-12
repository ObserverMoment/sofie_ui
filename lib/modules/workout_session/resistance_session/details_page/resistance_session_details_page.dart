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
import 'package:sofie_ui/components/session_type_icons.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/workout_session/resistance_session/details_page/action_icon_button.dart';
import 'package:sofie_ui/modules/workout_session/resistance_session/details_page/resistance_session_details.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/sharing_and_linking.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class ResistanceSessionDetailsPage extends StatelessWidget {
  final String id;
  final String? previousPageTitle;
  const ResistanceSessionDetailsPage(
      {Key? key, required this.id, this.previousPageTitle})
      : super(key: key);

  Future<void> _shareWorkout() async {
    await SharingAndLinking.shareLink(
        'resistance/$id', 'Check out this resistance workout!');
  }

  @override
  Widget build(BuildContext context) {
    final query = ResistanceSessionByIdQuery(
        variables: ResistanceSessionByIdArguments(id: id));

    return QueryObserver<ResistanceSessionById$Query,
            ResistanceSessionByIdArguments>(
        key: Key('ResistanceSessionDetailsPage - ${query.operationName}-$id'),
        query: query,
        parameterizeQuery: true,
        builder: (data) {
          print(data.resistanceSessionById);
          final resistanceSession = data.resistanceSessionById;

          if (resistanceSession == null) {
            return const ObjectNotFoundIndicator();
          }

          final String? authedUserId = GetIt.I<AuthBloc>().authedUser?.id;
          final bool isOwner = resistanceSession.user.id == authedUserId;

          return MyPageScaffold(
              navigationBar: MyNavBar(
                previousPageTitle: previousPageTitle,
                middle: NavBarTitle(resistanceSession.name),
                trailing: NavBarIconButton(
                  iconData: CupertinoIcons.ellipsis,
                  onPressed: () => openBottomSheetMenu(
                      context: context,
                      child: BottomSheetMenu(
                          header: BottomSheetMenuHeader(
                            name: resistanceSession.name,
                            subtitle: 'Resistance Session',
                          ),
                          items: [
                            if (!isOwner)
                              BottomSheetMenuItem(
                                  text: 'View creator',
                                  icon: CupertinoIcons.profile_circled,
                                  onPressed: () => context.navigateTo(
                                      UserPublicProfileDetailsRoute(
                                          userId: resistanceSession.user.id))),
                            BottomSheetMenuItem(
                                text: 'Share',
                                icon: CupertinoIcons.paperplane,
                                onPressed: _shareWorkout),
                            if (isOwner)
                              BottomSheetMenuItem(
                                  text: 'Edit',
                                  icon: CupertinoIcons.pencil,
                                  onPressed: () => print('edit session')),
                            if (isOwner)
                              BottomSheetMenuItem(
                                  text: 'Copy',
                                  icon: CupertinoIcons
                                      .plus_rectangle_on_rectangle,
                                  onPressed: () => print('copy session')),
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
                                  onPressed: () => print('delete workout')),
                          ])),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ActionIconButton(
                        icon: const Icon(SessionType.resistance),
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
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Vibrate.feedback(FeedbackType.selection);
                          print('save / unsave');
                        },
                        child: const ContentBox(
                          child: AnimatedLikeHeart(active: true, size: 26),
                        ),
                      ),
                    ],
                  ),
                  const HorizontalLine(
                    verticalPadding: 8,
                  ),
                  Expanded(
                    child: MyTabBarView(tabs: const [
                      'Details',
                      'Equipment',
                      'Body Areas'
                    ], pages: [
                      ResistanceSessionDetails(
                        resistanceSession: resistanceSession,
                      ),
                      MyText('Equipment'),
                      MyText('Body Areas'),
                    ]),
                  )
                ],
              ));
        });
  }
}

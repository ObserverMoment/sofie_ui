import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/future_builder_handler.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/audio/audio_thumbnail_player.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/modules/profile/user_avatar/user_avatar.dart';
import 'package:sofie_ui/components/media/video/video_thumbnail_player.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';

class ClubInviteLandingPage extends StatefulWidget {
  final String id;
  const ClubInviteLandingPage({Key? key, @PathParam('id') required this.id})
      : super(key: key);

  @override
  State<ClubInviteLandingPage> createState() => _ClubInviteLandingPageState();
}

class _ClubInviteLandingPageState extends State<ClubInviteLandingPage> {
  /// https://stackoverflow.com/questions/57793479/flutter-futurebuilder-gets-constantly-called
  late Future<CheckClubInviteTokenResult> _checkClubInviteTokenFuture;

  double get size => 100.0;
  Size get thumbSize => Size.square(size);

  @override
  void initState() {
    super.initState();
    _checkClubInviteTokenFuture = _checkClubInviteToken();
  }

  Future<CheckClubInviteTokenResult> _checkClubInviteToken() async {
    final variables = CheckClubInviteTokenArguments(id: widget.id);
    final result = await GraphQLStore.store.networkOnlyOperation<
            CheckClubInviteToken$Query, CheckClubInviteTokenArguments>(
        operation: CheckClubInviteTokenQuery(variables: variables));

    if (result.hasErrors || result.data == null) {
      throw Exception(
          'There was a network error while trying to get details of this invite.');
    } else {
      return result.data!.checkClubInviteToken;
    }
  }

  Future<void> _addUserToClubViaInviteToken(
      BuildContext context, ClubSummary club) async {
    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;
    final alertDialogContext = context.showLoadingAlert('Joining Club...',
        icon: const Icon(CupertinoIcons.star_fill));

    final variables = AddUserToClubViaInviteTokenArguments(
        userId: authedUserId, clubInviteTokenId: widget.id);

    final result = await GraphQLStore.store.networkOnlyOperation<
            AddUserToClubViaInviteToken$Mutation,
            AddUserToClubViaInviteTokenArguments>(
        operation: AddUserToClubViaInviteTokenMutation(variables: variables));

    alertDialogContext.pop(); // Loading dialog.

    if (result.hasErrors || result.data == null) {
      result.errors?.forEach((e) {
        printLog(e.toString());
      });
      context.showToast(
          message: 'Sorry, there was a problem joining the club.',
          toastType: ToastType.destructive);
    } else {
      // Successfully joined - pop this screen and push to the Club details page.
      context.router.popAndPush(ClubDetailsRoute(id: club.id));
    }
  }

  Widget _buildOwnerAvatar(ClubSummary club) => GestureDetector(
        onTap: () => context
            .navigateTo(UserPublicProfileDetailsRoute(userId: club.owner.id)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UserAvatar(
              avatarUri: club.owner.avatarUri,
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: MyText(
                club.owner.displayName,
                size: FONTSIZE.one,
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FutureBuilderHandler<CheckClubInviteTokenResult>(
        future: _checkClubInviteTokenFuture,
        builder: (data) {
          if (data is InviteTokenError) {
            return _TokenErrorMessageScreen(
              error: data,
            );
          } else {
            /// data must be type [ClubInviteTokenData]
            final club = (data as ClubInviteTokenData).club;

            final hasCoverImage = Utils.textNotNull(club.coverImageUri);

            return CupertinoPageScaffold(
                child: SafeArea(
              top: !hasCoverImage,
              child: Column(
                children: [
                  if (Utils.textNotNull(club.coverImageUri))
                    SizedBox(
                      height: 180,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          SizedUploadcareImage(club.coverImageUri!,
                              fit: BoxFit.cover),
                        ],
                      ),
                    ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 12),
                      shrinkWrap: true,
                      children: [
                        const MyText(
                          'You have been invited to join a club!',
                          textAlign: TextAlign.center,
                          weight: FontWeight.bold,
                        ),
                        const SizedBox(height: 12),
                        MyHeaderText(
                          club.name,
                          size: FONTSIZE.six,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        if (Utils.textNotNull(club.location))
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(CupertinoIcons.location,
                                    size: 18, color: Styles.primaryAccent),
                                const SizedBox(width: 2),
                                MyText(club.location!,
                                    color: Styles.primaryAccent)
                              ],
                            ),
                          ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildOwnerAvatar(club),
                            if (Utils.textNotNull(data.introVideoUri))
                              Column(
                                children: [
                                  ClipOval(
                                    child: VideoThumbnailPlayer(
                                      videoUri: data.introVideoUri,
                                      videoThumbUri: data.introVideoThumbUri,
                                      displaySize: thumbSize,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(6.0),
                                    child: MyText(
                                      'Watch',
                                      size: FONTSIZE.one,
                                    ),
                                  ),
                                ],
                              ),
                            if (Utils.textNotNull(data.introAudioUri))
                              Column(
                                children: [
                                  ClipOval(
                                    child: AudioThumbnailPlayer(
                                      audioUri: data.introAudioUri!,
                                      displaySize: thumbSize,
                                      playerTitle: '${club.name} - Intro',
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(6.0),
                                    child: MyText(
                                      'Listen',
                                      size: FONTSIZE.one,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Column(
                            children: [
                              if (Utils.textNotNull(club.description))
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ReadMoreTextBlock(
                                    trimLines: 5,
                                    text: club.description!,
                                    title: 'Description',
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const HorizontalLine(),
                      const SizedBox(height: 12),
                      Column(
                        children: [
                          PrimaryButton(
                              text: 'Yes, Join the Club!',
                              prefixIconData: CupertinoIcons.checkmark_alt,
                              onPressed: () =>
                                  _addUserToClubViaInviteToken(context, club)),
                          const SizedBox(height: 12),
                          SecondaryButton(
                              prefixIconData: CupertinoIcons.xmark,
                              text: 'No, thanks',
                              onPressed: context.pop)
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ));
          }
        });
  }
}

class _TokenErrorMessageScreen extends StatelessWidget {
  final InviteTokenError error;
  const _TokenErrorMessageScreen({Key? key, required this.error})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        navigationBar: const MyNavBar(
          middle: NavBarTitle('This Was Unexpected...'),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyText(
                error.message,
                maxLines: 3,
                textAlign: TextAlign.center,
                size: FONTSIZE.four,
              ),
              const SizedBox(height: 24),
              TertiaryButton(
                  prefixIconData: CupertinoIcons.clear,
                  text: 'Exit',
                  onPressed: context.pop)
            ],
          ),
        ));
  }
}

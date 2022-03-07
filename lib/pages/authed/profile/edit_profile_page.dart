import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/coercers.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/skill_creator/skills_manager.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/user_avatar_uploader.dart';
import 'package:sofie_ui/components/media/video/user_intro_video_uploader.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/display_name_edit_row.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/tappable_row.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/pickers/date_picker_cupertino.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/components/user_input/selectors/country_selector.dart';
import 'package:sofie_ui/components/user_input/selectors/selectable_boxes.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/country.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/pages/authed/profile/components/social_handles_input.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  /// Can also be used by other widgets.
  static Future<void> updateUserFields(
      BuildContext context, String id, Map<String, dynamic> data) async {
    final variables =
        UpdateUserProfileArguments(data: UpdateUserProfileInput.fromJson(data));

    final result = await context.graphQLStore.networkOnlyOperation(
        operation: UpdateUserProfileMutation(variables: variables),
        customVariablesMap: {'data': data});

    checkOperationResult(context, result, onFail: () {
      context.showToast(
          message: 'Sorry, there was a problem.',
          toastType: ToastType.destructive);
    }, onSuccess: () {
      /// Write new user data to UserProfile object.
      final prev =
          context.graphQLStore.readDenomalized('$kUserProfileTypename:$id');

      var updated = <String, dynamic>{
        ...prev,
      };

      for (final key in data.keys) {
        updated[key] = result.data!.updateUserProfile.toJson()[key];
      }

      context.graphQLStore.writeDataToStore(
          data: updated, broadcastQueryIds: [GQLVarParamKeys.userProfile(id)]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;
    final query =
        UserProfileQuery(variables: UserProfileArguments(userId: authedUserId));

    return QueryObserver<UserProfile$Query, UserProfileArguments>(
        key: Key('EditProfilePage - ${query.operationName}'),
        query: query,
        parameterizeQuery: true,
        fetchPolicy: QueryFetchPolicy.storeFirst,
        builder: (data) {
          if (data.userProfile == null) {
            return const ObjectNotFoundIndicator();
          }

          final userProfile = data.userProfile!;

          return MyPageScaffold(
              child: NestedScrollView(
                  headerSliverBuilder: (c, i) =>
                      [const MySliverNavbar(title: 'Edit Profile')],
                  body: ListView(
                      padding: const EdgeInsets.all(8),
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  UserAvatarUploader(
                                    avatarUri: userProfile.avatarUri,
                                    displaySize: const Size(100, 100),
                                    onUploadSuccess: (uri) => updateUserFields(
                                        context,
                                        userProfile.id,
                                        {'avatarUri': uri}),
                                  ),
                                  const SizedBox(height: 6),
                                  const MyText(
                                    'Photo',
                                    size: FONTSIZE.two,
                                    subtext: true,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  UserIntroVideoUploader(
                                    introVideoUri: userProfile.introVideoUri,
                                    introVideoThumbUri:
                                        userProfile.introVideoThumbUri,
                                    displaySize: const Size(100, 100),
                                    onUploadSuccess: (videoUri, thumbUri) =>
                                        updateUserFields(
                                            context, userProfile.id, {
                                      'introVideoUri': videoUri,
                                      'introVideoThumbUri': thumbUri
                                    }),
                                  ),
                                  const SizedBox(height: 6),
                                  const MyText(
                                    'Video',
                                    subtext: true,
                                    size: FONTSIZE.two,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        UserInputContainer(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const MyText(
                                    'Profile Privacy',
                                  ),
                                  MySlidingSegmentedControl<UserProfileScope>(
                                      value: userProfile.userProfileScope,
                                      children: {
                                        for (final v in UserProfileScope.values
                                            .where((v) =>
                                                v !=
                                                UserProfileScope
                                                    .artemisUnknown))
                                          v: v.display.capitalize
                                      },
                                      updateValue: (scope) => updateUserFields(
                                              context, userProfile.id, {
                                            'userProfileScope': scope.apiValue
                                          })),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: AnimatedSwitcher(
                                    duration: kStandardAnimationDuration,
                                    child: MyText(
                                      userProfile.userProfileScope ==
                                              UserProfileScope.private
                                          ? 'Your profile will not be discoverable or visible to the community.'
                                          : 'Your profile will be visible to and discoverable by the community.',
                                      textAlign: TextAlign.start,
                                      size: FONTSIZE.two,
                                      maxLines: 3,
                                      subtext: true,
                                      lineHeight: 1.2,
                                    )),
                              )
                            ],
                          ),
                        ),
                        UserInputContainer(
                          child: EditableDisplayNameRow(
                            title: 'Name',
                            text: userProfile.displayName,
                            onSave: (newText) => updateUserFields(context,
                                userProfile.id, {'displayName': newText}),
                            inputValidation: (String text) =>
                                text.length > 2 && text.length <= 30,
                            validationMessage: 'Min 3, max 30 characters',
                            maxChars: 30,
                            apiMessage:
                                'Sorry, this display name has been taken.',
                            apiValidation: (t) async {
                              if (userProfile.displayName == t) {
                                return true;
                              } else {
                                final isAvailable =
                                    await AuthBloc.displayNameAvailableCheck(t);
                                return isAvailable;
                              }
                            },
                          ),
                        ),
                        UserInputContainer(
                          child: EditableTextAreaRow(
                            title: 'Bio',
                            text: userProfile.bio ?? '',
                            onSave: (newText) => updateUserFields(
                                context, userProfile.id, {'bio': newText}),
                            inputValidation: (t) => true,
                            maxDisplayLines: 2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ContentBox(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              child: SocialHandlesInput(
                                profile: userProfile,
                                update: (key, value) => updateUserFields(
                                    context, userProfile.id, {key: value}),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, top: 16),
                          child: ContentBox(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 8),
                            child: PageLink(
                                linkText: 'Gym Profiles',
                                bold: true,
                                separator: false,
                                onPress: () => context
                                    .navigateTo(const YourGymProfilesRoute())),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, top: 16),
                          child: ContentBox(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 8),
                            child: PageLink(
                                linkText: 'Skills and Qualifications',
                                bold: true,
                                separator: false,
                                onPress: () =>
                                    context.push(child: const SkillsManager())),
                          ),
                        ),
                        UserInputContainer(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: TappableRow(
                                title: 'Country',
                                display: userProfile.countryCode != null
                                    ? ContentBox(
                                        child: SelectedCountryDisplay(
                                            userProfile.countryCode!))
                                    : null,
                                onTap: () => context.push(
                                        child: CountrySelector(
                                      selectedCountry:
                                          userProfile.countryCode != null
                                              ? Country.fromIsoCode(
                                                  userProfile.countryCode!)
                                              : null,
                                      selectCountry: (country) =>
                                          updateUserFields(
                                              context,
                                              userProfile.id,
                                              {'countryCode': country.isoCode}),
                                    ))),
                          ),
                        ),
                        UserInputContainer(
                          child: EditableTextFieldRow(
                            title: 'Town / City',
                            text: userProfile.townCity ?? '',
                            onSave: (newText) => updateUserFields(
                                context, userProfile.id, {'townCity': newText}),
                            inputValidation: (t) => true,
                          ),
                        ),
                        UserInputContainer(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: TappableRow(
                                title: 'Birthdate',
                                display: userProfile.birthdate != null
                                    ? ContentBox(
                                        child: MyText(
                                            userProfile.birthdate!.dateString))
                                    : null,
                                onTap: () => context.showActionSheetPopup(
                                        child: DatePickerCupertino(
                                      selectedDate: userProfile.birthdate,
                                      saveDate: (date) => updateUserFields(
                                          context, userProfile.id, {
                                        'birthdate':
                                            fromDartDateTimeToGraphQLDateTime(
                                                date)
                                      }),
                                    ))),
                          ),
                        ),
                        UserInputContainer(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: const [
                                    MyText(
                                      'Gender',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: Gender.values
                                      .where((v) => v != Gender.artemisUnknown)
                                      .map((g) => SelectableBox(
                                          isSelected: userProfile.gender == g,
                                          onPressed: () => updateUserFields(
                                              context,
                                              userProfile.id,
                                              {'gender': g.apiValue}),
                                          text: g.display))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ])));
        });
  }
}

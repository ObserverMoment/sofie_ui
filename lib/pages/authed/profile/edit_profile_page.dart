import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/coercers.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/user_avatar_uploader.dart';
import 'package:sofie_ui/components/media/video/user_intro_video_uploader.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/display_name_edit_row.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/tappable_row.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/pickers/date_picker.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/components/user_input/selectors/country_selector.dart';
import 'package:sofie_ui/components/user_input/selectors/selectable_boxes.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/country.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  Future<void> updateUserFields(
      BuildContext context, String id, String key, dynamic value) async {
    final variables =
        UpdateUserArguments(data: UpdateUserInput.fromJson({key: value}));

    await context.graphQLStore.mutate(
      mutation: UpdateUserMutation(variables: variables),
      customVariablesMap: {
        'data': {key: value}
      },
      broadcastQueryIds: [AuthedUserQuery().operationName],
    );
  }

  @override
  Widget build(BuildContext context) {
    return QueryObserver<AuthedUser$Query, json.JsonSerializable>(
        key: Key('EditProfilePage - ${AuthedUserQuery().operationName}'),
        query: AuthedUserQuery(),
        fetchPolicy: QueryFetchPolicy.storeFirst,
        builder: (data) {
          final user = data.authedUser;

          return MyPageScaffold(
              child: NestedScrollView(
                  headerSliverBuilder: (c, i) => [
                        const CupertinoSliverNavigationBar(
                            leading: null,
                            largeTitle: Text('Edit Profile'),
                            border: null)
                      ],
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
                                    avatarUri: user.avatarUri,
                                    displaySize: const Size(100, 100),
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
                                    introVideoUri: user.introVideoUri,
                                    introVideoThumbUri: user.introVideoThumbUri,
                                    displaySize: const Size(100, 100),
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
                                      value: user.userProfileScope,
                                      children: {
                                        for (final v in UserProfileScope.values
                                            .where((v) =>
                                                v !=
                                                UserProfileScope
                                                    .artemisUnknown))
                                          v: v.display.capitalize
                                      },
                                      updateValue: (scope) => updateUserFields(
                                          context,
                                          user.id,
                                          'userProfileScope',
                                          scope.apiValue)),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: AnimatedSwitcher(
                                    duration: kStandardAnimationDuration,
                                    child: MyText(
                                      user.userProfileScope ==
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
                            text: user.displayName,
                            onSave: (newText) => updateUserFields(
                                context, user.id, 'displayName', newText),
                            inputValidation: (String text) =>
                                text.length > 2 && text.length <= 30,
                            validationMessage: 'Min 3, max 30 characters',
                            maxChars: 30,
                            apiMessage:
                                'Sorry, this display name has been taken.',
                            apiValidation: (t) async {
                              if (user.displayName == t) {
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
                            text: user.bio ?? '',
                            onSave: (newText) => updateUserFields(
                                context, user.id, 'bio', newText),
                            inputValidation: (t) => true,
                            maxDisplayLines: 2,
                          ),
                        ),
                        UserInputContainer(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: TappableRow(
                                title: 'Country',
                                display: user.countryCode != null
                                    ? ContentBox(
                                        child: SelectedCountryDisplay(
                                            user.countryCode!))
                                    : null,
                                onTap: () => context.push(
                                        child: CountrySelector(
                                      selectedCountry: user.countryCode != null
                                          ? Country.fromIsoCode(
                                              user.countryCode!)
                                          : null,
                                      selectCountry: (country) =>
                                          updateUserFields(context, user.id,
                                              'countryCode', country.isoCode),
                                    ))),
                          ),
                        ),
                        UserInputContainer(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: TappableRow(
                                title: 'Birthdate',
                                display: user.birthdate != null
                                    ? ContentBox(
                                        child:
                                            MyText(user.birthdate!.dateString))
                                    : null,
                                onTap: () => context.showActionSheetPopup(
                                        child: DatePicker(
                                      selectedDate: user.birthdate,
                                      saveDate: (date) => updateUserFields(
                                          context,
                                          user.id,
                                          'birthdate',
                                          fromDartDateTimeToGraphQLDateTime(
                                              date)),
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
                                          isSelected: user.gender == g,
                                          onPressed: () => updateUserFields(
                                              context,
                                              user.id,
                                              'gender',
                                              g.apiValue),
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

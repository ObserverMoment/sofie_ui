import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/coercers.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/modules/profile/blocs/profile_bloc.dart';
import 'package:sofie_ui/modules/profile/user_avatar/user_avatar_uploader.dart';
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
import 'package:sofie_ui/modules/profile/social/social_handles_input.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

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
              navigationBar:
                  const MyNavBar(middle: NavBarLargeTitle('Edit Bio')),
              child: ListView(
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
                                onUploadSuccess: (uri) =>
                                    ProfileBloc.updateUserFields(
                                        userProfile.id,
                                        {'avatarUri': uri},
                                        () => context.showToast(
                                            message:
                                                'Sorry, there was a problem',
                                            toastType: ToastType.destructive)),
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
                                    ProfileBloc.updateUserFields(
                                        userProfile.id,
                                        {
                                          'introVideoUri': videoUri,
                                          'introVideoThumbUri': thumbUri
                                        },
                                        () => context.showToast(
                                            message:
                                                'Sorry, there was a problem',
                                            toastType: ToastType.destructive)),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            UserProfileScope.artemisUnknown))
                                      v: v.display.capitalize
                                  },
                                  updateValue: (scope) =>
                                      ProfileBloc.updateUserFields(
                                          userProfile.id,
                                          {'userProfileScope': scope.apiValue},
                                          () => context.showToast(
                                              message:
                                                  'Sorry, there was a problem',
                                              toastType:
                                                  ToastType.destructive))),
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
                        onSave: (newText) => ProfileBloc.updateUserFields(
                            userProfile.id,
                            {'displayName': newText},
                            () => context.showToast(
                                message: 'Sorry, there was a problem',
                                toastType: ToastType.destructive)),
                        inputValidation: (String text) =>
                            text.length > 2 && text.length <= 30,
                        validationMessage: 'Min 3, max 30 characters',
                        maxChars: 30,
                        apiMessage: 'Sorry, this display name has been taken.',
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
                        onSave: (newText) => ProfileBloc.updateUserFields(
                            userProfile.id,
                            {'bio': newText},
                            () => context.showToast(
                                message: 'Sorry, there was a problem',
                                toastType: ToastType.destructive)),
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
                            update: (key, value) =>
                                ProfileBloc.updateUserFields(
                                    userProfile.id,
                                    {key: value},
                                    () => context.showToast(
                                        message: 'Sorry, there was a problem',
                                        toastType: ToastType.destructive)),
                          )),
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
                                      ProfileBloc.updateUserFields(
                                          userProfile.id,
                                          {'countryCode': country.isoCode},
                                          () => context.showToast(
                                              message:
                                                  'Sorry, there was a problem',
                                              toastType:
                                                  ToastType.destructive)),
                                ))),
                      ),
                    ),
                    UserInputContainer(
                      child: EditableTextFieldRow(
                        title: 'Town / City',
                        text: userProfile.townCity ?? '',
                        onSave: (newText) => ProfileBloc.updateUserFields(
                            userProfile.id,
                            {'townCity': newText},
                            () => context.showToast(
                                message: 'Sorry, there was a problem',
                                toastType: ToastType.destructive)),
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
                                  saveDate: (date) =>
                                      ProfileBloc.updateUserFields(
                                          userProfile.id,
                                          {
                                            'birthdate':
                                                fromDartDateTimeToGraphQLDateTime(
                                                    date)
                                          },
                                          () => context.showToast(
                                              message:
                                                  'Sorry, there was a problem',
                                              toastType:
                                                  ToastType.destructive)),
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
                                      onPressed: () =>
                                          ProfileBloc.updateUserFields(
                                              userProfile.id,
                                              {'gender': g.apiValue},
                                              () => context.showToast(
                                                  message:
                                                      'Sorry, there was a problem',
                                                  toastType:
                                                      ToastType.destructive)),
                                      text: g.display))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]));
        });
  }
}

import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/coercers.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/tappable_row.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/selectors/country_selector.dart';
import 'package:sofie_ui/components/user_input/pickers/date_picker.dart';
import 'package:sofie_ui/components/user_input/selectors/selectable_boxes.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/country.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class ProfilePersonalPage extends StatelessWidget {
  const ProfilePersonalPage({Key? key}) : super(key: key);

  Future<void> updateUserFields(
      BuildContext context, String id, String key, dynamic value) async {
    final variables =
        UpdateUserArguments(data: UpdateUserInput.fromJson({key: value}));

    await context.graphQLStore.mutate(
        mutation: UpdateUserMutation(variables: variables),
        customVariablesMap: {
          'data': {key: value}
        },
        broadcastQueryIds: [
          AuthedUserQuery().operationName
        ],
        optimisticData: {
          '__typename': 'User',
          'id': id,
          key: value
        });
  }

  @override
  Widget build(BuildContext context) {
    return QueryObserver<AuthedUser$Query, json.JsonSerializable>(
        key: Key('ProfilePersonalPage - ${AuthedUserQuery().operationName}'),
        query: AuthedUserQuery(),
        loadingIndicator: const ShimmerCardList(
          itemCount: 12,
          cardHeight: 20,
          cardPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 16),
        ),
        builder: (data) {
          final User user = data.authedUser;

          return ListView(
            children: [
              const SizedBox(height: 8),
              UserInputContainer(
                child: EditableTextFieldRow(
                  title: 'Name',
                  text: user.displayName,
                  onSave: (newText) => updateUserFields(
                      context, user.id, 'displayName', newText),
                  inputValidation: (String text) =>
                      text.length > 2 && text.length <= 30,
                  validationMessage: 'Min 3, max 30 characters',
                  maxChars: 30,
                ),
              ),
              UserInputContainer(
                child: EditableTextAreaRow(
                  title: 'Bio',
                  text: user.bio ?? '',
                  onSave: (newText) =>
                      updateUserFields(context, user.id, 'bio', newText),
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
                              child: SelectedCountryDisplay(user.countryCode!))
                          : null,
                      onTap: () => context.push(
                          fullscreenDialog: true,
                          child: CountrySelector(
                            selectedCountry: user.countryCode != null
                                ? Country.fromIsoCode(user.countryCode!)
                                : null,
                            selectCountry: (country) => updateUserFields(
                                context,
                                user.id,
                                'countryCode',
                                country.isoCode),
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
                              child: MyText(user.birthdate!.dateString))
                          : null,
                      onTap: () => context.showActionSheetPopup(
                              child: DatePicker(
                            selectedDate: user.birthdate,
                            saveDate: (date) => updateUserFields(
                                context,
                                user.id,
                                'birthdate',
                                fromDartDateTimeToGraphQLDateTime(date)),
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
                                    context, user.id, 'gender', g.apiValue),
                                text: g.display))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}

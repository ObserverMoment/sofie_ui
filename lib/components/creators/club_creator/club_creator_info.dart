import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/selectors/content_access_scope_selector.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';

class ClubCreatorInfo extends StatelessWidget {
  final Club club;
  final void Function(Map<String, dynamic> data) updateClub;

  const ClubCreatorInfo(
      {Key? key, required this.club, required this.updateClub})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        UserInputContainer(
          child: EditableTextFieldRow(
            title: 'Name',
            text: club.name,
            onSave: (t) => updateClub({'name': t}),
            inputValidation: (t) => t.length > 3 && t.length <= 30,
            validationMessage: 'Min 3, max 30 characters',
            maxChars: 30,
          ),
        ),
        UserInputContainer(
          child: EditableTextAreaRow(
            title: 'Description',
            text: club.description ?? '',
            onSave: (t) => updateClub({'description': t}),
            inputValidation: (t) => true,
          ),
        ),
        UserInputContainer(
          child: EditableTextFieldRow(
            title: 'Location',
            icon: const Icon(CupertinoIcons.location, size: 14),
            text: club.location ?? '',
            onSave: (t) => updateClub({'location': t}),
            inputValidation: (t) => true,
          ),
        ),
        ContentAccessScopeSelector(
            contentAccessScope: club.contentAccessScope,
            updateContentAccessScope: (scope) =>
                updateClub({'contentAccessScope': scope.apiValue}))
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/workout_session/creator/blocs/resistance_session_bloc.dart';

class ResistanceSessionEdit extends StatelessWidget {
  final ResistanceSession resistanceSession;
  final String workoutSessionId;
  const ResistanceSessionEdit(
      {Key? key,
      required this.resistanceSession,
      required this.workoutSessionId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ResistanceSessionBloc(
          initial: resistanceSession, workoutSessionId: workoutSessionId),
      builder: (context, child) {
        final bloc = context.watch<ResistanceSessionBloc>();
        final session = bloc.resistanceSession;

        return MyPageScaffold(
            navigationBar: MyNavBar(
              withoutLeading: true,
              middle: const LeadingNavBarTitle(
                'Resistance Session',
              ),
              trailing: NavBarSaveButton(
                context.pop,
              ),
            ),
            child: ListView(
              children: [
                UserInputContainer(
                  child: EditableTextAreaRow(
                    title: 'Notes',
                    text: session.note ?? '',
                    onSave: (text) =>
                        bloc.updateResistanceSession({'note': text}),
                    inputValidation: (t) => true,
                  ),
                ),
              ],
            ));
      },
    );
  }
}

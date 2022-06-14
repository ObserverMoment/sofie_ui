import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/text_input.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';

/// Allows user to enter the basic info required to create a workout of any type (they all require a name when creating) in the DB.
/// They can also abort here if they want and nothing will be created in the DB.
class WorkoutCreate extends StatefulWidget {
  final void Function(String name) createWorkout;
  final bool creatingNewWorkout;
  const WorkoutCreate(
      {Key? key, required this.createWorkout, required this.creatingNewWorkout})
      : super(key: key);

  @override
  State<WorkoutCreate> createState() => _WorkoutCreateState();
}

class _WorkoutCreateState extends State<WorkoutCreate> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = 'Workout ${DateTime.now().dateString}';
    _nameController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
          customLeading: NavBarCancelButton(context.pop),
          trailing: widget.creatingNewWorkout
              ? const NavBarLoadingIndicator()
              : null),
      child: ListView(children: [
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: MyHeaderText(
            'Name for this session',
            size: FONTSIZE.four,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: MyTextFormFieldRow(
            keyboardType: TextInputType.emailAddress,
            controller: _nameController,
            validator: () => _nameController.text.isNotEmpty,
            autofocus: true,
            autofillHints: const <String>[AutofillHints.email],
            placeholder: 'Name (required)',
          ),
        ),
        if (_nameController.text.isNotEmpty)
          FadeIn(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PrimaryButton(
                  text: 'Create',
                  loading: widget.creatingNewWorkout,
                  onPressed: () => widget.createWorkout(_nameController.text)),
            ),
          )
      ]),
    );
  }
}

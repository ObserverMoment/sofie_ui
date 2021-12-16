import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class JournalMoodCreatorPage extends StatefulWidget {
  final JournalMood? journalMood;
  const JournalMoodCreatorPage({Key? key, this.journalMood}) : super(key: key);

  @override
  _JournalMoodCreatorPageState createState() => _JournalMoodCreatorPageState();
}

class _JournalMoodCreatorPageState extends State<JournalMoodCreatorPage> {
  bool _formIsDirty = false;
  JournalMood? _activeJournalMood;

  @override
  void initState() {
    super.initState();
    _activeJournalMood = widget.journalMood != null
        ? JournalMood.fromJson(widget.journalMood!.toJson())
        : JournalMood()
      ..id = 'temp'
      ..createdAt = DateTime.now()
      ..tags = [];
  }

  bool get _validToSubmit => false;

  void _saveAndClose() {}

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        withoutLeading: true,
        middle: const LeadingNavBarTitle(
          'Mood Tracking',
        ),
        trailing: _formIsDirty && _validToSubmit
            ? FadeIn(
                child: NavBarSaveButton(
                  _saveAndClose,
                ),
              )
            : null,
      ),
      child: ListView(
        children: [
          MyText('Mood Input'),
          MyText('Energy Input'),
          MyText('Tags Input'),
          MyText('Note Input'),
        ],
      ),
    );
  }
}

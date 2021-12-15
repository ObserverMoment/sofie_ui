import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/journal/journal_goals.dart';
import 'package:sofie_ui/components/journal/journal_moods.dart';
import 'package:sofie_ui/components/journal/journal_notes.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({Key? key}) : super(key: key);

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  int _activeTabIndex = 0;

  void _updateTabIndex(int i) {
    setState(() => _activeTabIndex = i);
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      child: NestedScrollView(
          headerSliverBuilder: (c, i) =>
              [const MySliverNavbar(title: 'Journal')],
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                width: double.infinity,
                child: MySlidingSegmentedControl(children: const {
                  0: 'Notes',
                  1: 'Moods',
                  2: 'Goals',
                }, updateValue: _updateTabIndex, value: _activeTabIndex),
              ),
              Expanded(
                child: IndexedStack(
                  index: _activeTabIndex,
                  children: const [
                    JournalNotes(),
                    JournalMoods(),
                    JournalGoals(),
                  ],
                ),
              )
            ],
          )),
    );
  }
}

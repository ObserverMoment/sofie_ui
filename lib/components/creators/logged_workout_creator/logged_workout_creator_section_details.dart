import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/logged_workout_creator_bloc.dart';
import 'package:sofie_ui/components/body_areas/body_area_selectors.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';

class LoggedWorkoutCreatorSectionDetails extends StatefulWidget {
  final int sectionIndex;
  const LoggedWorkoutCreatorSectionDetails(
      {Key? key, required this.sectionIndex})
      : super(key: key);

  @override
  _LoggedWorkoutCreatorSectionDetailsState createState() =>
      _LoggedWorkoutCreatorSectionDetailsState();
}

class _LoggedWorkoutCreatorSectionDetailsState
    extends State<LoggedWorkoutCreatorSectionDetails> {
  int _activeTabIndex = 0;

  void _updatePage(int page) {
    setState(() => _activeTabIndex = page);
  }

  @override
  Widget build(BuildContext context) {
    final loggedWorkoutSection =
        context.select<LoggedWorkoutCreatorBloc, LoggedWorkoutSection>(
            (b) => b.loggedWorkout.loggedWorkoutSections[widget.sectionIndex]);

    final bodyAreas = loggedWorkoutSection.uniqueBodyAreas;
    final moveTypes = loggedWorkoutSection.uniqueMoveTypes;

    return MyPageScaffold(
      navigationBar: const MyNavBar(
        middle: NavBarTitle('Body Areas and Move Types'),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            width: double.infinity,
            child: MySlidingSegmentedControl<int>(
                value: _activeTabIndex,
                children: const {0: 'Body Areas', 1: 'Move Types'},
                updateValue: _updatePage),
          ),
          IndexedStack(
            index: _activeTabIndex,
            children: [
              LayoutBuilder(
                builder: (context, constraints) =>
                    BodyAreaSelectorFrontBackPaged(
                  bodyGraphicHeight: MediaQuery.of(context).size.height * 0.55,
                  handleTapBodyArea: (_) => {},
                  selectedBodyAreas: bodyAreas,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: moveTypes
                      .map((m) => Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ContentBox(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MyText(
                                      m.name,
                                      size: FONTSIZE.four,
                                    ),
                                  ],
                                )),
                          ))
                      .toList(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

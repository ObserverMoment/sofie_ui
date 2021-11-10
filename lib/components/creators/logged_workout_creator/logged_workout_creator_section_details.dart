import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/logged_workout_creator_bloc.dart';
import 'package:sofie_ui/components/body_areas/body_area_selectors.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/navigation.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/selectors/move_type_multi_selector.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

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
    final bloc = context.read<LoggedWorkoutCreatorBloc>();

    final loggedWorkoutSection =
        context.select<LoggedWorkoutCreatorBloc, LoggedWorkoutSection>(
            (b) => b.loggedWorkout.loggedWorkoutSections[widget.sectionIndex]);

    return MyPageScaffold(
      navigationBar: const MyNavBar(
        middle: NavBarTitle('Body Areas and Move Types'),
      ),
      child: Column(
        children: [
          MyTabBarNav(
              titles: const ['Body Areas', 'Move Types'],
              handleTabChange: _updatePage,
              activeTabIndex: _activeTabIndex),
          IndexedStack(
            index: _activeTabIndex,
            children: [
              LayoutBuilder(
                builder: (context, constraints) =>
                    BodyAreaSelectorFrontBackPaged(
                  bodyGraphicHeight: MediaQuery.of(context).size.height * 0.55,
                  handleTapBodyArea: (ba) =>
                      bloc.toggleSectionBodyArea(widget.sectionIndex, ba),
                  selectedBodyAreas: loggedWorkoutSection.bodyAreas,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MoveTypeMultiSelector(
                  name: 'Move types in this section',
                  selectedTypes: loggedWorkoutSection.moveTypes,
                  updateSelectedTypes: (types) =>
                      bloc.updateSectionMoveTypes(widget.sectionIndex, types),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

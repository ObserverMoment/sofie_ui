import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/tappable_row.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/gym_profile/gym_profile_card.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/query_observer.dart';

class GymProfileSelectorDisplay extends StatelessWidget {
  final GymProfile? gymProfile;
  final void Function(GymProfile? gymProfile) selectGymProfile;
  final VoidCallback clearGymProfile;
  const GymProfileSelectorDisplay({
    Key? key,
    required this.gymProfile,
    required this.selectGymProfile,
    required this.clearGymProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Row(
        children: [
          Expanded(
            child: TappableRow(
              onTap: () => context.push(
                  child: GymProfileSelector(
                selectedGymProfile: gymProfile,
                selectGymProfile: selectGymProfile,
              )),
              title: 'Gym Profile',
              display: gymProfile == null
                  ? const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: MyText('Select'),
                    )
                  : ContentBox(child: MyText(gymProfile!.name)),
            ),
          ),
          if (gymProfile != null)
            FadeIn(
              child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: clearGymProfile,
                  child: const Icon(
                    CupertinoIcons.clear_thick,
                    color: Styles.errorRed,
                    size: 20,
                  )),
            )
        ],
      ),
    );
  }
}

/// Not wrapped in a page scaffold to allow inline opening or bottom sheet style.
class GymProfileSelector extends StatefulWidget {
  final void Function(GymProfile? profile) selectGymProfile;
  final GymProfile? selectedGymProfile;
  const GymProfileSelector(
      {Key? key, required this.selectGymProfile, this.selectedGymProfile})
      : super(key: key);

  @override
  State<GymProfileSelector> createState() => _GymProfileSelectorState();
}

class _GymProfileSelectorState extends State<GymProfileSelector> {
  GymProfile? _activeSelectedGymProfile;

  @override
  void initState() {
    super.initState();
    _activeSelectedGymProfile = widget.selectedGymProfile;
  }

  void _handleSelection(GymProfile gymProfile) {
    /// Allow for toggle type interaction.
    if (gymProfile == _activeSelectedGymProfile) {
      widget.selectGymProfile(null);
      setState(() => _activeSelectedGymProfile = null);
    } else {
      widget.selectGymProfile(gymProfile);
      setState(() => _activeSelectedGymProfile = gymProfile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return QueryObserver<GymProfiles$Query, json.JsonSerializable>(
      key: Key('GymProfileSelector - ${GymProfilesQuery().operationName}'),
      loadingIndicator: const ShimmerListPage(
        cardHeight: 160,
      ),
      query: GymProfilesQuery(),
      builder: (data) {
        final gymProfiles = data.gymProfiles.reversed.toList();
        return MyPageScaffold(
          navigationBar: MyNavBar(
            customLeading: NavBarCancelButton(context.pop),
            middle: const NavBarTitle('Select Gym Profile'),
            trailing: NavBarTertiarySaveButton(context.pop, text: 'Done'),
          ),
          child: gymProfiles.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const MyText('No gym profiles...'),
                          const SizedBox(height: 16),
                          SecondaryButton(
                              prefixIconData: CupertinoIcons.add,
                              text: 'Create a Gym Profile',
                              onPressed: () =>
                                  context.pushRoute(GymProfileCreatorRoute()))
                        ],
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SecondaryButton(
                              prefixIconData: CupertinoIcons.add,
                              text: 'New Gym Profile',
                              onPressed: () =>
                                  context.pushRoute(GymProfileCreatorRoute())),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          MyText('Or select...'),
                        ],
                      ),
                    ),
                    ...gymProfiles
                        .map((g) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: GestureDetector(
                                onTap: () => _handleSelection(g),
                                child: SelectGymProfileItem(
                                    gymProfile: g,
                                    isSelected: g == _activeSelectedGymProfile),
                              ),
                            ))
                        .toList()
                  ],
                ),
        );
      },
    );
  }
}

class SelectGymProfileItem extends StatelessWidget {
  final GymProfile gymProfile;
  final bool isSelected;
  const SelectGymProfileItem(
      {Key? key, required this.gymProfile, required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: kStandardAnimationDuration,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              width: 3,
              color: Styles.primaryAccent.withOpacity(isSelected ? 1.0 : 0.0))),
      child: GymProfileCard(
        gymProfile: gymProfile,
      ),
    );
  }
}

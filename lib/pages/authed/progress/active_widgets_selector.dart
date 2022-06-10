import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/modules/profile/blocs/profile_bloc.dart';
import 'package:sofie_ui/pages/authed/progress/progress_page.dart';
import 'package:sofie_ui/services/repos/core_data_repo.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:collection/collection.dart';

/// Activate one or more progress widgets by adding their ids to [User.activeProgressWidgets]
class ActiveWidgetsSelector extends StatefulWidget {
  const ActiveWidgetsSelector({Key? key}) : super(key: key);

  @override
  State<ActiveWidgetsSelector> createState() => _ActiveWidgetsSelectorState();
}

class _ActiveWidgetsSelectorState extends State<ActiveWidgetsSelector> {
  String? _processingId;

  Future<void> _toggleActivateWidget(
      List<String> activeProgressWidgets, String id) async {
    if (_processingId != null) {
      return;
    }

    setState(() {
      _processingId = id;
    });

    late List<String> updated;

    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;

    if (activeProgressWidgets.contains(id)) {
      updated = activeProgressWidgets.where((w) => w != id).toList();
    } else {
      updated = [...activeProgressWidgets, id];
    }

    await ProfileBloc.updateUserFields(
        authedUserId,
        {'activeProgressWidgets': updated},
        () => context.showToast(
            message: 'Sorry, there was a problem',
            toastType: ToastType.destructive));

    setState(() {
      _processingId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;

    final userProfileQuery =
        UserProfileQuery(variables: UserProfileArguments(userId: authedUserId));
    final allWidgets =
        CoreDataRepo.progressWidgets.sortedBy<num>((w) => int.parse(w.id));

    return QueryObserver<UserProfile$Query, UserProfileArguments>(
        key: Key('ActiveWidgetsSelector - ${userProfileQuery.operationName}'),
        query: userProfileQuery,
        fetchPolicy: QueryFetchPolicy.storeFirst,
        parameterizeQuery: true,
        builder: (userData) {
          if (userData.userProfile == null) {
            return const ObjectNotFoundIndicator();
          }

          final userProfile = userData.userProfile!;
          final activeWidgets = userProfile.activeProgressWidgets ?? [];

          return MyPageScaffold(
            navigationBar: MyNavBar(
              customLeading: IconButton(
                  iconData: CupertinoIcons.chevron_down,
                  onPressed: context.pop),
              middle: const NavBarTitle('Tap To Activate / De-Activate'),
            ),
            child: ListView(
              itemExtent: 140,
              shrinkWrap: true,
              padding: const EdgeInsets.all(12),
              children: allWidgets
                  .map((w) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _WidgetSelectorTile(
                          activatedWidgets: activeWidgets,
                          widget: w,
                          onTap: () =>
                              _toggleActivateWidget(activeWidgets, w.id),
                          processingId: _processingId,
                        ),
                      ))
                  .toList(),
            ),
          );
        });
  }
}

class _WidgetSelectorTile extends StatelessWidget {
  final List<String> activatedWidgets;
  final ProgressWidget widget;
  final VoidCallback onTap;
  final String? processingId;
  const _WidgetSelectorTile(
      {Key? key,
      required this.activatedWidgets,
      required this.widget,
      required this.onTap,
      required this.processingId})
      : super(key: key);

  bool get _isActive => activatedWidgets.contains(widget.id);

  String get _tagText => _isActive ? 'Active' : 'Inactive';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: processingId == null ? onTap : null,
      child: ContentBox(
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyHeaderText(
                      widget.name,
                      maxLines: 2,
                    ),
                    if (Utils.textNotNull(widget.description))
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: MyText(
                          widget.description!,
                          maxLines: 4,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircularBox(
                        color: context.theme.background,
                        padding: const EdgeInsets.all(9),
                        child: Icon(kWidgetIdToIconMap[widget.id], size: 20)),
                    SizeFadeIn(
                      key: Key(_isActive.toString()),
                      child: Tag(
                          fontSize: FONTSIZE.three,
                          tag: _tagText,
                          color: _isActive
                              ? Styles.primaryAccent
                              : context.theme.primary.withOpacity(0.2)),
                    ),
                  ],
                )
              ],
            ),
            if (processingId == widget.id)
              SizeFadeIn(
                  child: Center(
                child: material.CircularProgressIndicator(
                  color: context.theme.primary,
                ),
              ))
          ],
        ),
      ),
    );
  }
}

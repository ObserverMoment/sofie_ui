import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/logged_workout_creator_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/loading_shimmers.dart';
import 'package:sofie_ui/components/creators/logged_workout_creator/logged_workout_creator_with_sections.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

/// Very simlar to the LoggedWorkoutCreator.
/// Shares most of its components and logic is handled by [LoggedWorkoutCreatorBloc].
class LoggedWorkoutDetailsPage extends StatelessWidget {
  final String id;
  const LoggedWorkoutDetailsPage({Key? key, @PathParam('id') required this.id})
      : super(key: key);

  Future<void> _deleteLoggedWorkout(BuildContext context) async {
    await context.showConfirmDeleteDialog(
        itemType: 'Log',
        message: 'This cannot be undone.',
        onConfirm: () async {
          final result = await context.graphQLStore
              .delete<DeleteLoggedWorkoutById$Mutation, json.JsonSerializable>(
            typename: kLoggedWorkoutTypename,
            objectId: id,
            mutation: DeleteLoggedWorkoutByIdMutation(
              variables: DeleteLoggedWorkoutByIdArguments(id: id),
            ),
            clearQueryDataAtKeys: [
              getParameterizedQueryId(LoggedWorkoutByIdQuery(
                  variables: LoggedWorkoutByIdArguments(id: id)))
            ],
            removeRefFromQueries: [GQLNullVarsKeys.userLoggedWorkoutsQuery],
          );

          if (result.hasErrors) {
            context.showErrorAlert(
                'Something went wrong, the log was not deleted correctly');
          } else {
            context.pop(); // The screen.
          }
        });
  }

  /// Saves all changes to the global graphql store once the user is done with this spage.
  void _handleSaveAndClose(BuildContext context) {
    context.read<LoggedWorkoutCreatorBloc>().writeAllChangesToStore();
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final query =
        LoggedWorkoutByIdQuery(variables: LoggedWorkoutByIdArguments(id: id));

    return QueryObserver<LoggedWorkoutById$Query, LoggedWorkoutByIdArguments>(
        key: Key('LoggedWorkoutDetailsPage - ${query.operationName}'),
        query: query,
        parameterizeQuery: true,
        fetchPolicy: QueryFetchPolicy.networkOnly,
        loadingIndicator: const ShimmerDetailsPage(title: 'Finding log...'),
        builder: (data) {
          final loggedWorkout = data.loggedWorkoutById;

          return ChangeNotifierProvider(
            create: (context) => LoggedWorkoutCreatorBloc(
              context: context,
              prevLoggedWorkout: loggedWorkout,
            ),
            builder: (context, child) {
              return MyPageScaffold(
                  navigationBar: MyNavBar(
                    customLeading: NavBarBackButtonStandalone(
                      onPressed: () => _handleSaveAndClose(context),
                    ),
                    middle: NavBarTitle(loggedWorkout.name),
                    trailing: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(CupertinoIcons.ellipsis),
                        onPressed: () => openBottomSheetMenu(
                            context: context,
                            child: BottomSheetMenu(
                                header: BottomSheetMenuHeader(
                                  name: loggedWorkout.name,
                                  subtitle: 'Logged Workout',
                                ),
                                items: [
                                  BottomSheetMenuItem(
                                      text: 'Delete',
                                      icon: const Icon(
                                        CupertinoIcons.delete_simple,
                                        color: Styles.errorRed,
                                      ),
                                      isDestructive: true,
                                      onPressed: () =>
                                          _deleteLoggedWorkout(context)),
                                ]))),
                  ),
                  child: const LoggedWorkoutCreatorWithSections());
            },
          );
        });
  }
}

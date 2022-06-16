import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/placeholders/content_empty_placeholder.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/workouts/resistance_workout/components/resistance_workout_card.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:json_annotation/json_annotation.dart' as json;

class YourResistanceWorkouts extends StatelessWidget {
  const YourResistanceWorkouts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;

    return QueryObserver<UserCreatedResistanceWorkouts$Query,
            json.JsonSerializable>(
        key: Key(
            'ResistanceWorkoutsPage - ${UserCreatedResistanceWorkoutsQuery().operationName}'),
        query: UserCreatedResistanceWorkoutsQuery(),
        fetchPolicy: QueryFetchPolicy.storeFirst,
        builder: (created) => QueryObserver<UserSavedResistanceWorkouts$Query,
                json.JsonSerializable>(
            key: Key(
                'ResistanceWorkoutsPage - ${UserSavedResistanceWorkoutsQuery().operationName}'),
            query: UserSavedResistanceWorkoutsQuery(),
            fetchPolicy: QueryFetchPolicy.storeFirst,
            builder: (saved) {
              final sortedByUpdatedAt = [
                ...created.userCreatedResistanceWorkouts,
                ...saved.userSavedResistanceWorkouts
              ].sortedBy<DateTime>((s) => s.updatedAt).reversed;

              return sortedByUpdatedAt.isEmpty
                  ? ContentEmptyPlaceholder(
                      message: 'Nothing to display',
                      explainer:
                          'Get creative and make your own workouts, or get involved in some Circles to discover the best workouts out there!',
                      actions: [
                          EmptyPlaceholderAction(
                              action: () => context
                                  .navigateTo(ResistanceWorkoutCreatorRoute()),
                              buttonIcon: CupertinoIcons.add,
                              buttonText: 'Create Workout'),
                        ])
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      shrinkWrap: true,
                      children: sortedByUpdatedAt
                          .map((s) => GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => context.navigateTo(
                                    ResistanceWorkoutDetailsRoute(id: s.id)),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ResistanceWorkoutCard(
                                      resistanceWorkout: s,
                                      showUserAvatar:
                                          authedUserId != s.user.id),
                                ),
                              ))
                          .toList(),
                    );
            }));
  }
}

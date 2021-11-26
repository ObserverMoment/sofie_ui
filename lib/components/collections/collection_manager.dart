import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/components/user_input/selectors/collection_selector.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';

/// Class for a set of functions used to perfom operations on collections.
/// Adding and removing objects.
/// Copying from one collection to another
class CollectionManager {
  /// Either removes the workout from one of its current collections ([collections.isNotEmpty])
  /// Or Adds to an existing collection.
  /// Or adds to a newly created collection.
  static void addOrRemoveObjectFromCollection<T>(BuildContext context, T object,
      {List<Collection> alreadyInCollections = const []}) {
    if (alreadyInCollections.isNotEmpty) {
      openBottomSheetMenu(
          context: context,
          child: BottomSheetMenu(items: [
            BottomSheetMenuItem(
                text: 'Save to Collection',
                onPressed: () => selectCollectionToSaveTo<T>(context, object)),
            ...alreadyInCollections
                .map(
                  (collection) => BottomSheetMenuItem(
                      text: 'Remove from ${collection.name}',
                      onPressed: () => confirmRemoveObjectFromCollection<T>(
                            context,
                            collection,
                            object,
                          )),
                )
                .toList()
          ]));
    } else {
      selectCollectionToSaveTo<T>(context, object);
    }
  }

  static void selectCollectionToSaveTo<T>(BuildContext context, T object) {
    context.push(
        fullscreenDialog: true,
        child: CollectionSelector(
            title: 'Save to Collection',
            selectCollection: (collection) {
              if (object is WorkoutSummary) {
                addWorkoutToCollection(context, collection, object);
              } else if (object is WorkoutPlanSummary) {
                addWorkoutPlanToCollection(context, collection, object);
              } else {
                throw Exception(
                    'CollectionManager._selectCollectionToSaveTo: Cannot add type ${object.runtimeType} to a collection.');
              }
            }));
  }

  static void confirmRemoveObjectFromCollection<T>(
    BuildContext context,
    Collection collection,
    T object,
  ) {
    context.showConfirmDialog(
        title: 'Remove from Collection',
        subtitle: collection.name,
        verb: 'Remove',
        isDestructive: true,
        onConfirm: () {
          if (object is WorkoutSummary) {
            removeWorkoutFromCollection(context, collection, object);
          } else if (object is WorkoutPlanSummary) {
            removeWorkoutPlanFromCollection(context, collection, object);
          } else {
            throw Exception(
                'CollectionManager.confirmRemoveObjectFromCollection: Cannot remove type ${object.runtimeType} from a collection.');
          }
        });
  }

  /// Add / Remove Workout from Collection ////
  static Future<void> addWorkoutToCollection(BuildContext context,
      Collection collection, WorkoutSummary workout) async {
    final updatedCollection = Collection.fromJson(collection.toJson());
    updatedCollection.workouts.add(workout);

    final variables = AddWorkoutToCollectionArguments(
        data: AddWorkoutToCollectionInput(
            collectionId: collection.id,
            workout: ConnectRelationInput(id: workout.id)));

    final result = await context.graphQLStore.mutate<
            AddWorkoutToCollection$Mutation, AddWorkoutToCollectionArguments>(
        mutation: AddWorkoutToCollectionMutation(variables: variables),
        optimisticData: updatedCollection.toJson(),
        broadcastQueryIds: [
          UserCollectionsQuery().operationName,
          GQLVarParamKeys.userCollectionByIdQuery(collection.id)
        ]);

    if (result.hasErrors || result.data == null) {
      context.showErrorAlert(
          'Sorry there was a problem, the workout was not added.');
    } else {
      context.showToast(message: 'Saved to collection: ${collection.name}');
    }
  }

  static Future<void> removeWorkoutFromCollection(
      BuildContext context, Collection collection, WorkoutSummary workout,
      {bool showToast = true}) async {
    final updatedCollection = Collection.fromJson(collection.toJson());
    updatedCollection.workouts =
        collection.workouts.where((w) => w.id != workout.id).toList();

    final variables = RemoveWorkoutFromCollectionArguments(
        data: RemoveWorkoutFromCollectionInput(
            collectionId: collection.id,
            workout: ConnectRelationInput(id: workout.id)));

    final result = await context.graphQLStore.mutate<
            RemoveWorkoutFromCollection$Mutation,
            RemoveWorkoutFromCollectionArguments>(
        mutation: RemoveWorkoutFromCollectionMutation(variables: variables),
        optimisticData: updatedCollection.toJson(),
        broadcastQueryIds: [
          UserCollectionsQuery().operationName,
          GQLVarParamKeys.userCollectionByIdQuery(collection.id)
        ]);

    if (result.hasErrors || result.data == null) {
      context.showErrorAlert(
          'Sorry there was a problem, the workout was not removed.');
    } else {
      if (showToast) {
        context.showToast(
            message: 'Removed from collection: ${collection.name}');
      }
    }
  }

  /// Add / Remove WorkoutPlan from Collection ////
  static Future<void> addWorkoutPlanToCollection(BuildContext context,
      Collection collection, WorkoutPlanSummary workoutPlan) async {
    final updatedCollection = Collection.fromJson(collection.toJson());
    updatedCollection.workoutPlans.add(workoutPlan);

    final variables = AddWorkoutPlanToCollectionArguments(
        data: AddWorkoutPlanToCollectionInput(
            collectionId: collection.id,
            workoutPlan: ConnectRelationInput(id: workoutPlan.id)));

    final result = await context.graphQLStore.mutate<
            AddWorkoutPlanToCollection$Mutation,
            AddWorkoutPlanToCollectionArguments>(
        mutation: AddWorkoutPlanToCollectionMutation(variables: variables),
        optimisticData: updatedCollection.toJson(),
        broadcastQueryIds: [
          UserCollectionsQuery().operationName,
          GQLVarParamKeys.userCollectionByIdQuery(collection.id)
        ]);

    if (result.hasErrors || result.data == null) {
      context.showErrorAlert(
          'Sorry there was a problem, the workout plan was not added');
    } else {
      context.showToast(message: 'Saved to collection: ${collection.name}');
    }
  }

  static Future<void> removeWorkoutPlanFromCollection(BuildContext context,
      Collection collection, WorkoutPlanSummary workoutPlan,
      {bool showToast = true}) async {
    final updatedCollection = Collection.fromJson(collection.toJson());
    updatedCollection.workoutPlans =
        collection.workoutPlans.where((wp) => wp.id != workoutPlan.id).toList();

    final variables = RemoveWorkoutPlanFromCollectionArguments(
        data: RemoveWorkoutPlanFromCollectionInput(
            collectionId: collection.id,
            workoutPlan: ConnectRelationInput(id: workoutPlan.id)));

    final result = await context.graphQLStore.mutate<
            RemoveWorkoutPlanFromCollection$Mutation,
            RemoveWorkoutPlanFromCollectionArguments>(
        mutation: RemoveWorkoutPlanFromCollectionMutation(variables: variables),
        optimisticData: updatedCollection.toJson(),
        broadcastQueryIds: [
          UserCollectionsQuery().operationName,
          GQLVarParamKeys.userCollectionByIdQuery(collection.id)
        ]);

    if (result.hasErrors || result.data == null) {
      context.showErrorAlert(
          'Sorry there was a problem, the workout plan was not removed');
    } else {
      if (showToast) {
        context.showToast(
            message: 'Removed from collection: ${collection.name}');
      }
    }
  }
}

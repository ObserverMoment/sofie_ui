import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';

enum ObjectTextSearchScope { private, public }

class TextSearchFilters {
  static bool workoutBySearchString(
      WorkoutSummary workout, String searchString) {
    return [
      workout.name,
      ...workout.tags,
    ]
        .where((t) => Utils.textNotNull(t))
        .map((t) => t.toLowerCase())
        .any((t) => t.contains(searchString));
  }

  static List<WorkoutSummary> workoutsBySearchString(
      List<WorkoutSummary> original, String searchString) {
    return Utils.textNotNull(searchString)
        ? original.where((w) => workoutBySearchString(w, searchString)).toList()
        : [];
  }

  static bool workoutPlanBySearchString(
      WorkoutPlan workoutPlan, String searchString) {
    return workoutPlan.name.toLowerCase().contains(searchString);
  }

  static List<WorkoutPlan> workoutPlansBySearchString(
      List<WorkoutPlan> original, String searchString) {
    return Utils.textNotNull(searchString)
        ? original
            .where((p) => workoutPlanBySearchString(p, searchString))
            .toList()
        : [];
  }
}

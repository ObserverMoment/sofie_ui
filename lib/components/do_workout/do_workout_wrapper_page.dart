import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/blocs/do_workout_bloc/do_workout_bloc.dart';
import 'package:sofie_ui/components/do_workout/do_workout_do_workout_page.dart';
import 'package:sofie_ui/components/future_builder_handler.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

/// Gets the workout from the DB based on its ID and then inits the DoWorkoutBloc.
/// Uses [AutoRouter.declarative] to move the user from the do workout page to the log workout page onec all workout sections are completed.
class DoWorkoutWrapperPage extends StatefulWidget {
  final String id;

  // When present these should be passed on to log creator.
  /// [scheduledWorkout] so that we can add the log to the scheduled workout to mark it as done.
  /// [workoutPlanDayWorkoutId] and [workoutPlanEnrolmentId] so that we can create a [CompletedWorkoutPlanDayWorkout] to mark it as done in the plan.
  final ScheduledWorkout? scheduledWorkout;
  final String? workoutPlanDayWorkoutId;
  final String? workoutPlanEnrolmentId;
  const DoWorkoutWrapperPage(
      {Key? key,
      @PathParam('id') required this.id,
      this.scheduledWorkout,
      this.workoutPlanDayWorkoutId,
      this.workoutPlanEnrolmentId})
      : super(key: key);

  @override
  _DoWorkoutWrapperPageState createState() => _DoWorkoutWrapperPageState();
}

class _DoWorkoutWrapperPageState extends State<DoWorkoutWrapperPage> {
  /// https://stackoverflow.com/questions/57793479/flutter-futurebuilder-gets-constantly-called
  late Future<Workout> _initWorkoutFuture;

  Future<Workout> _getWorkoutById() async {
    final variables = WorkoutByIdArguments(id: widget.id);
    final query = WorkoutByIdQuery(variables: variables);

    final result =
        await context.graphQLStore.networkOnlyOperation(operation: query);

    checkOperationResult(context, result);

    return result.data!.workoutById;
  }

  Widget get _loadingWidget => CupertinoPageScaffold(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/logos/sofie_logo.svg',
                width: 48,
                color: context.theme.primary,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: MyText('WARMING UP'),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CupertinoActivityIndicator(
                  radius: 14,
                ),
              ),
            ],
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
    _initWorkoutFuture = _getWorkoutById();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilderHandler<Workout>(
        loadingWidget: _loadingWidget,
        future: _initWorkoutFuture,
        builder: (workout) => ChangeNotifierProvider<DoWorkoutBloc>(
              create: (context) => DoWorkoutBloc(
                  originalWorkout: workout,
                  scheduledWorkout: widget.scheduledWorkout,
                  workoutPlanDayWorkoutId: widget.workoutPlanDayWorkoutId,
                  workoutPlanEnrolmentId: widget.workoutPlanEnrolmentId),
              builder: (context, _) {
                final mediaSetupComplete = context.select<DoWorkoutBloc, bool>(
                    (b) => b.audioInitSuccess && b.videoInitSuccess);

                if (!mediaSetupComplete) return _loadingWidget;

                return const DoWorkoutDoWorkoutPage();
              },
            ));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/modules/workout_session/resistance_session/edit/resistance_session_edit.dart';
import 'package:sofie_ui/modules/workout_session/resistance_session/resistance_session_bloc.dart';
import 'package:sofie_ui/modules/workout_session/session_create.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class ResistanceSessionCreatorPage extends StatefulWidget {
  final ResistanceSession? resistanceSession;
  const ResistanceSessionCreatorPage({Key? key, this.resistanceSession})
      : super(key: key);

  @override
  State<ResistanceSessionCreatorPage> createState() =>
      _ResistanceSessionCreatorPageState();
}

class _ResistanceSessionCreatorPageState
    extends State<ResistanceSessionCreatorPage> {
  ResistanceSessionBloc? _bloc;
  bool _creatingNewResistanceSession = false;

  @override
  void initState() {
    super.initState();
    if (widget.resistanceSession != null) {
      _initBloc(widget.resistanceSession!);
    }
  }

  void _initBloc(ResistanceSession resistanceSession) {
    setState(() => _bloc = ResistanceSessionBloc(resistanceSession));
  }

  /// Create a bare bones workout in the DB and add it to the store.
  Future<void> _createResistanceSession(String name) async {
    setState(() {
      _creatingNewResistanceSession = true;
    });

    final result = await GraphQLStore.store.create<
        CreateResistanceSession$Mutation, CreateResistanceSessionArguments>(
      mutation: CreateResistanceSessionMutation(
        variables: CreateResistanceSessionArguments(
            data: CreateResistanceSessionInput(name: name)),
      ),
      processResult: (newSession) {
        final prev = GraphQLStore.store.readDenomalized('userWorkoutSessions');
        // prev.re
      },
    );

    checkOperationResult(result, onSuccess: () {
      _initBloc(result.data!.createResistanceSession);
    });

    setState(() {
      _creatingNewResistanceSession = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: kStandardAnimationDuration,
        child: _bloc != null
            ? ChangeNotifierProvider.value(
                value: _bloc,
                child: const ResistanceSessionEdit(),
              )
            : SessionCreate(
                createSession: _createResistanceSession,
                creatingNewSession: _creatingNewResistanceSession));
  }
}

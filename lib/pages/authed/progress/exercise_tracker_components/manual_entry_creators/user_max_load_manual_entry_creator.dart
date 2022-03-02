// import 'package:flutter/cupertino.dart';
// import 'package:sofie_ui/components/animated/mounting.dart';
// import 'package:sofie_ui/components/buttons.dart';
// import 'package:sofie_ui/components/indicators.dart';
// import 'package:sofie_ui/components/layout.dart';
// import 'package:sofie_ui/components/text.dart';
// import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
// import 'package:sofie_ui/components/user_input/number_input.dart';
// import 'package:sofie_ui/components/user_input/pickers/date_time_pickers.dart';
// import 'package:sofie_ui/constants.dart';
// import 'package:sofie_ui/extensions/context_extensions.dart';
// import 'package:sofie_ui/extensions/enum_extensions.dart';
// import 'package:sofie_ui/extensions/type_extensions.dart';
// import 'package:sofie_ui/generated/api/graphql_api.dart';
// import 'package:sofie_ui/model/enum.dart';
// import 'package:sofie_ui/services/graphql_operation_names.dart';
// import 'package:sofie_ui/services/store/store_utils.dart';
// import 'package:sofie_ui/services/utils.dart';

// class UserMaxLoadManualEntryCreator extends StatefulWidget {
//   final UserMaxLoadExerciseTracker parent;
//   const UserMaxLoadManualEntryCreator({
//     Key? key,
//     required this.parent,
//   }) : super(key: key);
//   @override
//   _UserMaxLoadManualEntryCreatorState createState() =>
//       _UserMaxLoadManualEntryCreatorState();
// }

// class _UserMaxLoadManualEntryCreatorState
//     extends State<UserMaxLoadManualEntryCreator> {
//   bool _loading = false;

//   final TextEditingController _loadAmountController = TextEditingController();
//   double? _loadAmount;
//   DateTime _completedOn = DateTime.now();
//   String? _localVideoPath;

//   @override
//   void initState() {
//     super.initState();
//     _loadAmountController.addListener(() {
//       setState(() {
//         _loadAmount = Utils.textNotNull(_loadAmountController.text)
//             ? double.parse(_loadAmountController.text)
//             : null;
//       });
//     });
//   }

//   Future<void> _createManualEntry() async {
//     if (_loadAmount == null) {
//       return;
//     }

//     setState(() => _loading = true);

//     final variables = CreateUserMaxLoadTrackerManualEntryArguments(
//         data: CreateUserMaxLoadTrackerManualEntryInput(
//             completedOn: _completedOn,
//             loadAmount: _loadAmount!,
//             videoUri: 'TODO',
//             userMaxLoadExerciseTracker:
//                 ConnectRelationInput(id: widget.parent.id)));

//     /// Run the update on the network - no client side writes until data can be merged with the parent.
//     final result = await context.graphQLStore.networkOnlyOperation(
//         operation:
//             CreateUserMaxLoadTrackerManualEntryMutation(variables: variables));

//     setState(() => _loading = false);

//     checkOperationResult(context, result, onSuccess: () {
//       /// TODO: As the benchmarkEntry exists both normalized and also as a nested object ({$ref}) within a field of the parent benchmark, we will need to overwrite the entire benchmark in the store, with the new entry added to field [UserBenchmarkEntries] so that when we rebroadcast the queries it is included in the retireved data.
//       final parentBenchmarkData = context.graphQLStore.readDenomalized(
//         '$kUserBenchmarkTypename:${widget.userBenchmark.id}',
//       );

//       final entry = result.data!.createUserBenchmarkEntry;
//       final parentBenchmark = UserBenchmark.fromJson(parentBenchmarkData);
//       parentBenchmark.userBenchmarkEntries.add(entry);

//       final success = context.graphQLStore.writeDataToStore(
//         data: parentBenchmark.toJson(),
//         broadcastQueryIds: [
//           GQLVarParamKeys.userBenchmark(widget.userBenchmark.id),
//           GQLOpNames.userBenchmarks,
//         ],
//       );

//       if (!success) {
//         context.showToast(
//             message: kDefaultErrorMessage, toastType: ToastType.destructive);
//       } else {
//         context.pop();
//       }
//     });
//   }

//   bool get _validToSubmit =>
//       Utils.textNotNull(_loadAmountController.text) && _formIsDirty;

//   String _buildScoreHeaderText() {
//     switch (widget.userBenchmark.benchmarkType) {
//       case BenchmarkType.maxload:
//         return 'Max Load';
//       case BenchmarkType.fastesttime:
//         return 'Fastest Time';
//       case BenchmarkType.unbrokenreps:
//         return 'Unbroken Reps';
//       case BenchmarkType.unbrokentime:
//         return 'Unbroken Time';
//       case BenchmarkType.amrap:
//         return 'AMRAP';
//       default:
//         throw Exception(
//             'UserMaxLoadManualEntryCreator._buildScoreHeaderText: No method defined for ${widget.userBenchmark.benchmarkType}.');
//     }
//   }

//   String _buildScoreUnit() {
//     switch (widget.userBenchmark.benchmarkType) {
//       case BenchmarkType.maxload:
//         return widget.userBenchmark.loadUnit.display.capitalize;
//       case BenchmarkType.fastesttime:
//       case BenchmarkType.unbrokentime:
//         return 'SECONDS';
//       case BenchmarkType.amrap:
//       case BenchmarkType.unbrokenreps:
//         return 'REPS';
//       default:
//         throw Exception(
//             'UserMaxLoadManualEntryCreator._buildScoreUnit: No method defined for ${widget.userBenchmark.benchmarkType}.');
//     }
//   }

//   Widget _buildNumberInput() => Column(
//         children: [
//           MyNumberInput(
//             _loadAmountController,
//             allowDouble: true,
//             autoFocus: true,
//           ),
//           const SizedBox(height: 6),
//           MyText(
//             _buildScoreUnit(),
//             size: FONTSIZE.four,
//             weight: FontWeight.bold,
//           ),
//         ],
//       );

//   Widget _buildDurationInput() {
//     final duration = Duration(seconds: _score.round());
//     return Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: CupertinoTimerPicker(
//             initialTimerDuration: duration,
//             onTimerDurationChanged: (d) => _setStateWrapper(
//                   () => _score = d.inSeconds.toDouble(),
//                 )));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MyPageScaffold(
//       navigationBar: MyNavBar(
//         customLeading: NavBarCancelButton(_handleCancel),
//         middle: NavBarTitle(widget.userBenchmark.name),
//         trailing: _loading
//             ? Row(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: const [
//                   LoadingIndicator(
//                     size: 12,
//                   ),
//                 ],
//               )
//             : _validToSubmit
//                 ? FadeIn(child: NavBarTertiarySaveButton(_saveAndClose))
//                 : null,
//       ),
//       child: ListView(
//         shrinkWrap: true,
//         children: [
//           UserInputContainer(
//             child: DateTimePickerDisplay(
//               dateTime: _completedOn,
//               saveDateTime: (DateTime d) {
//                 _setStateWrapper(() {
//                   _completedOn = d;
//                 });
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
//             child: Column(
//               children: [
//                 H3(_buildScoreHeaderText().toUpperCase()),
//                 const SizedBox(height: 12),
//                 if ([
//                   BenchmarkType.maxload,
//                   BenchmarkType.unbrokenreps,
//                   BenchmarkType.amrap
//                 ].contains(widget.userBenchmark.benchmarkType))
//                   _buildNumberInput()
//                 else
//                   _buildDurationInput(),
//               ],
//             ),
//           ),
//           UserInputContainer(
//             child: EditableTextAreaRow(
//                 title: 'Note',
//                 text: _note ?? '',
//                 maxDisplayLines: 6,
//                 onSave: (t) => _setStateWrapper(() => _note = t),
//                 inputValidation: (t) => true),
//           )
//         ],
//       ),
//     );
//   }
// }

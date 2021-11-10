import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/info_pages/personal_best_rep_type_info.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/components/user_input/selectors/selectable_boxes.dart';
import 'package:sofie_ui/components/user_input/selectors/user_benchmark_tags_selector.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';

class PersonalBestCreatorPage extends StatefulWidget {
  final UserBenchmark? userBenchmark;
  const PersonalBestCreatorPage({Key? key, this.userBenchmark})
      : super(key: key);

  @override
  _PersonalBestCreatorPageState createState() =>
      _PersonalBestCreatorPageState();
}

class _PersonalBestCreatorPageState extends State<PersonalBestCreatorPage> {
  bool _formIsDirty = false;
  bool _loading = false;

  BenchmarkType? _benchmarkType;

  String? _name;
  String? _description;
  String? _equipmentInfo;
  LoadUnit _loadUnit = LoadUnit.kg;
  List<UserBenchmarkTag> _tags = [];

  @override
  void initState() {
    super.initState();
    if (widget.userBenchmark != null) {
      _benchmarkType = widget.userBenchmark!.benchmarkType;
      _name = widget.userBenchmark!.name;
      _description = widget.userBenchmark!.description;
      _equipmentInfo = widget.userBenchmark!.equipmentInfo;
      _loadUnit = widget.userBenchmark!.loadUnit;
      _tags = widget.userBenchmark!.userBenchmarkTags;
    }
  }

  void _setStateWrapper(void Function() cb) {
    _formIsDirty = true;
    setState(cb);
  }

  Future<void> _saveAndClose() async {
    setState(() => _loading = true);
    if (widget.userBenchmark != null) {
      final variables = UpdateUserBenchmarkArguments(
          data: UpdateUserBenchmarkInput(
              id: widget.userBenchmark!.id,
              benchmarkType: _benchmarkType!,
              name: _name,
              description: _description,
              equipmentInfo: _equipmentInfo,
              loadUnit: _loadUnit,
              userBenchmarkTags:
                  _tags.map((t) => ConnectRelationInput(id: t.id)).toList()));

      final result = await context.graphQLStore.mutate(
          mutation: UpdateUserBenchmarkMutation(variables: variables),
          broadcastQueryIds: [
            GQLOpNames.userBenchmarksQuery,
            getParameterizedQueryId(UserBenchmarkByIdQuery(
                variables:
                    UserBenchmarkByIdArguments(id: widget.userBenchmark!.id)))
          ]);

      setState(() => _loading = false);

      if (result.hasErrors || result.data == null) {
        context.showToast(
            message: "Sorry, that didn't work",
            toastType: ToastType.destructive);
      } else {
        context.pop();
      }
    } else {
      final variables = CreateUserBenchmarkArguments(
          data: CreateUserBenchmarkInput(
              benchmarkType: _benchmarkType!,
              name: _name!,
              description: _description,
              equipmentInfo: _equipmentInfo,
              loadUnit: _loadUnit,
              userBenchmarkTags:
                  _tags.map((t) => ConnectRelationInput(id: t.id)).toList()));

      final result = await context.graphQLStore.create(
          mutation: CreateUserBenchmarkMutation(variables: variables),
          addRefToQueries: [GQLOpNames.userBenchmarksQuery]);

      setState(() => _loading = false);

      if (result.hasErrors || result.data == null) {
        context.showToast(
            message: "Sorry, that didn't work",
            toastType: ToastType.destructive);
      } else {
        context.pop();
      }
    }
  }

  void _handleCancel() {
    if (_formIsDirty) {
      context.showConfirmDialog(
          title: 'Close without saving?', onConfirm: context.pop);
    } else {
      context.pop();
    }
  }

  bool get _validToSubmit => _name != null && _benchmarkType != null;

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
          customLeading: NavBarCancelButton(_handleCancel),
          middle: NavBarTitle(widget.userBenchmark == null
              ? 'New Personal Best'
              : 'Edit Personal Best'),
          trailing: _formIsDirty && _validToSubmit
              ? FadeIn(
                  child: NavBarSaveButton(
                    _saveAndClose,
                    loading: _loading,
                  ),
                )
              : null),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  MyText('How will you score this PB?'),
                  InfoPopupButton(infoWidget: PersonalBestRepTypeInfo())
                ],
              ),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: BenchmarkType.values
                    .where((v) => v != BenchmarkType.artemisUnknown)
                    .map((type) => SelectableBox(
                        isSelected: type == _benchmarkType,
                        onPressed: () => setState(() => _benchmarkType = type),
                        text: type.display))
                    .toList(),
              ),
              const SizedBox(height: 16),
              GrowInOut(
                show: _benchmarkType != null,
                child: Column(
                  children: [
                    UserInputContainer(
                      child: EditableTextFieldRow(
                          title: 'Name',
                          isRequired: _name == null,
                          text: _name ?? '',
                          onSave: (t) => _setStateWrapper(() => _name = t),
                          validationMessage: 'Min 4, max 30 characters',
                          inputValidation: (t) =>
                              t.length > 3 && t.length < 31),
                    ),
                    UserInputContainer(
                      child: EditableTextAreaRow(
                          title: 'Description',
                          text: _description ?? '',
                          maxDisplayLines: 6,
                          onSave: (t) =>
                              _setStateWrapper(() => _description = t),
                          inputValidation: (t) => true),
                    ),
                    UserInputContainer(
                      child: EditableTextAreaRow(
                          title: 'Equipment Info',
                          text: _equipmentInfo ?? '',
                          maxDisplayLines: 6,
                          onSave: (t) =>
                              _setStateWrapper(() => _equipmentInfo = t),
                          inputValidation: (t) => true),
                    ),
                  ],
                ),
              ),
              GrowInOut(
                show: _benchmarkType == BenchmarkType.maxload,
                child: UserInputContainer(
                  child: Column(
                    children: [
                      const H3('Max Load PB'),
                      const SizedBox(height: 8),
                      const MyText('Submit your score as'),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SlidingSelect<LoadUnit>(
                              value: _loadUnit,
                              children: {
                                for (final v in LoadUnit.values.where((v) =>
                                    v != LoadUnit.artemisUnknown &&
                                    v != LoadUnit.percentmax))
                                  v: MyText(v.display)
                              },
                              updateValue: (loadUnit) =>
                                  _setStateWrapper(() => _loadUnit = loadUnit)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              GrowInOut(
                show: _benchmarkType != null,
                child: UserBenchmarkTagsSelectorRow(
                  selectedTags: _tags,
                  updateTags: (tags) => _setStateWrapper(() => _tags = tags),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

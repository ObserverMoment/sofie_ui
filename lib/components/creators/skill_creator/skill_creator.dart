import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/text_input.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class SkillCreator extends StatefulWidget {
  final Skill? skill;
  const SkillCreator({Key? key, this.skill}) : super(key: key);

  @override
  _SkillCreatorState createState() => _SkillCreatorState();
}

class _SkillCreatorState extends State<SkillCreator> {
  late String _authedUserId;

  /// Pre-create data fields.
  /// User must add these (only name is required) and then save.
  /// This creates a new skill in the DB and returns it.
  final _nameController = TextEditingController();
  final _experienceController = TextEditingController();

  /// Post-create data. We go straight here in the case of editing a skill.
  Skill? _activeSkill;
  Map<String, dynamic> _activeSkillBackup = {};

  /// Doing something over the network - replaces tab sliding select and 'done' buttons with loading indicators.
  bool _savingToDB = false;
  late bool _isCreate;

  @override
  void initState() {
    super.initState();

    _authedUserId = GetIt.I<AuthBloc>().authedUser!.id;

    _isCreate = widget.skill == null;

    if (!_isCreate) {
      _activeSkill = Skill.fromJson(widget.skill!.toJson());
    }

    if (_activeSkill == null) {
      _initPreCreateDataFields();
    } else {
      /// Create initial backup data.
      _activeSkillBackup = _activeSkill!.toJson();
    }
  }

  void _initPreCreateDataFields() {
    _nameController.addListener(() {
      setState(() {});
    });
    _experienceController.addListener(() {
      setState(() {});
    });
  }

  Future<void> _createSkill() async {
    setState(() => _savingToDB = true);

    final variables = CreateSkillArguments(
        data: CreateSkillInput(
            name: _nameController.text,
            experience: _experienceController.text));

    final result = await context.graphQLStore
        .networkOnlyOperation<CreateSkill$Mutation, CreateSkillArguments>(
      operation: CreateSkillMutation(variables: variables),
    );

    setState(() => _savingToDB = false);

    checkOperationResult(context, result,
        onFail: () => context.showErrorAlert(
            'Sorry there was a problem, the Skill was not created.'),
        onSuccess: () {
          setState(() {
            _activeSkill = result.data!.createSkill;
          });

          context.showToast(
              message: 'Skill created!', toastType: ToastType.success);

          _activeSkillBackup = _activeSkill!.toJson();

          _mergeSkillToUserProfileInStore(addNewSkill: true);
        });
  }

  Future<void> _updateSkill(Map<String, dynamic> data) async {
    if (_activeSkill == null) {
      throw Exception(
          'SkillCreatorPage._updateSkill: [_activeSkill] has not been initialized.');
    }

    /// Optimistic.
    setState(() {
      _activeSkill = Skill.fromJson({
        ..._activeSkill!.toJson(),
        ...data,
      });
    });

    final variables = UpdateSkillArguments(
        data: UpdateSkillInput.fromJson(_activeSkill!.toJson()));

    final result = await context.graphQLStore
        .networkOnlyOperation<UpdateSkill$Mutation, UpdateSkillArguments>(
      operation: UpdateSkillMutation(variables: variables),
    );

    checkOperationResult(context, result, onFail: () {
      setState(() {
        _activeSkill = Skill.fromJson(_activeSkillBackup);
      });
      context.showErrorAlert(
          'Sorry there was a problem, the Skill was not updated.');
    }, onSuccess: () {
      setState(() {
        _activeSkill = result.data!.updateSkill;
      });

      _activeSkillBackup = _activeSkill!.toJson();

      _mergeSkillToUserProfileInStore();
    });
  }

  /// Merge the new skill data into the parent user profile data within the store and then re-broadcast.
  /// When creating a new skill set [addNewSkill] as true. This will add the skill to the profile.skills before merging into store. When [addNewSkill] is false this will find the previous skill and overwrite it.
  void _mergeSkillToUserProfileInStore({bool addNewSkill = false}) {
    final prev = context.graphQLStore
        .readDenomalized('$kUserProfileTypename:$_authedUserId');
    final profile = UserProfile.fromJson(prev);
    final activeId = _activeSkill!.id;

    if (addNewSkill) {
      profile.skills.add(_activeSkill!);
    } else {
      profile.skills = profile.skills
          .map((s) => s.id == activeId ? _activeSkill! : s)
          .toList();
    }

    context.graphQLStore.writeDataToStore(
        data: profile.toJson(),
        broadcastQueryIds: [GQLVarParamKeys.userProfile(_authedUserId)]);
  }

  /// Will not save anything as saving is incremental once we are post-create.
  void _close() {
    context.pop();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        withoutLeading: true,
        middle: Row(
          children: [
            NavBarLargeTitle(_isCreate ? 'Add Skill' : 'Update Skill'),
          ],
        ),
        trailing: _savingToDB
            ? const NavBarTrailingRow(
                children: [
                  NavBarLoadingDots(),
                ],
              )
            : _activeSkill == null
                ? NavBarCancelButton(_close)
                : NavBarTextButton(_close, 'Done'),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: AnimatedSwitcher(
          duration: kStandardAnimationDuration,
          child: _activeSkill == null
              ? _PreCreateInputUI(
                  addSkill: _createSkill,
                  experienceController: _experienceController,
                  nameController: _nameController,
                  savingToDB: _savingToDB,
                )
              : ListView(
                  children: [
                    UserInputContainer(
                      child: EditableTextFieldRow(
                        title: 'Skill',
                        text: _activeSkill!.name,
                        onSave: (t) => _updateSkill({'name': t}),
                        inputValidation: (t) => t.length > 2 && t.length < 51,
                        validationMessage: 'Min 3, max 50 characters',
                      ),
                    ),
                    UserInputContainer(
                      child: EditableTextAreaRow(
                        title: 'Experience',
                        text: _activeSkill!.experience ?? '',
                        onSave: (t) => _updateSkill({'experience': t}),
                        inputValidation: (t) => true,
                      ),
                    ),
                    ContentBox(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: MyHeaderText('Certification'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: EditableTextFieldRow(
                            title: 'Certification',
                            text: _activeSkill!.certification ?? '',
                            onSave: (t) => _updateSkill({'certification': t}),
                            inputValidation: (t) => true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: EditableTextFieldRow(
                            title: 'Awarding Body',
                            text: _activeSkill!.awardingBody ?? '',
                            onSave: (t) => _updateSkill({'awardingBody': t}),
                            inputValidation: (t) => true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: EditableTextFieldRow(
                            title: 'Certificate Reference',
                            text: _activeSkill!.certificateRef ?? '',
                            onSave: (t) => _updateSkill({'certificateRef': t}),
                            inputValidation: (t) => true,
                          ),
                        )
                      ],
                    ))
                  ],
                ),
        ),
      ),
    );
  }
}

/// Displays in the case the a user is creating a brand new skill.
/// They enter some basic info about it and then click save.
/// Once saved and data is back from the DB then UI reverts to the standard UI.
class _PreCreateInputUI extends StatelessWidget {
  final VoidCallback addSkill;
  final bool savingToDB;
  final TextEditingController nameController;
  final TextEditingController experienceController;

  const _PreCreateInputUI({
    Key? key,
    required this.nameController,
    required this.experienceController,
    required this.addSkill,
    required this.savingToDB,
  }) : super(key: key);

  bool get _nameIsValid =>
      nameController.text.length > 2 && nameController.text.length < 51;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 12),
      child: ListView(
        shrinkWrap: true,
        children: [
          PrimaryButton(
            text: 'Add Skill',
            onPressed: addSkill,
            prefixIconData: CupertinoIcons.add,
            disabled: !_nameIsValid,
            loading: savingToDB,
          ),
          UserInputContainer(
            child: MyTextFormFieldRow(
              autofocus: true,
              backgroundColor: context.theme.cardBackground,
              controller: nameController,
              placeholder: 'Name (required)',
              keyboardType: TextInputType.text,
              validator: () => _nameIsValid,
              validationMessage: 'Min 3, max 50 characters',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 4, top: 10),
            child: MyTextAreaFormFieldRow(
                placeholder: 'Experience (optional)',
                backgroundColor: context.theme.cardBackground,
                keyboardType: TextInputType.text,
                controller: experienceController),
          ),
        ],
      ),
    );
  }
}

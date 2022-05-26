import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/number_input.dart';
import 'package:sofie_ui/components/user_input/pickers/cupertino_switch_row.dart';
import 'package:sofie_ui/components/user_input/text_input.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/default_object_factory.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';

/// Creates or updates an invite token via the API and then updates the client store with [ClubInviteTokens] object that is returned.
class ClubInviteTokenCreator extends StatefulWidget {
  /// When creating [token] should be null.
  final ClubInviteToken? token;
  final String clubId;
  const ClubInviteTokenCreator({
    Key? key,
    this.token,
    required this.clubId,
  }) : super(key: key);

  @override
  _ClubInviteTokenCreatorState createState() => _ClubInviteTokenCreatorState();
}

class _ClubInviteTokenCreatorState extends State<ClubInviteTokenCreator> {
  late bool _isCreate;
  bool _savingToDB = false;
  late ClubInviteToken _activeToken;
  late bool _enableInviteLimit;
  final _nameController = TextEditingController();
  final _inviteLimitController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _isCreate = widget.token == null;

    if (!_isCreate) {
      _activeToken = ClubInviteToken.fromJson(widget.token!.toJson());
      _nameController.text = _activeToken.name;
      _inviteLimitController.text = _activeToken.inviteLimit.toString();
    } else {
      _activeToken = DefaultObjectfactory.defaultClubInviteToken();
    }

    _inviteLimitController.text = _activeToken.inviteLimit.toString();
    _enableInviteLimit = _activeToken.inviteLimit != 0;

    _nameController.addListener(() {
      setState(() {
        _activeToken.name = _nameController.text;
      });
    });

    _inviteLimitController.addListener(() {
      if (Utils.textNotNull(_inviteLimitController.text)) {
        setState(() {
          _activeToken.inviteLimit = int.parse(_inviteLimitController.text);
        });
      } else {
        _inviteLimitController.text = 0.toString();
      }
    });
  }

  Future<void> _createClubInviteToken() async {
    setState(() => _savingToDB = true);

    final variables = CreateClubInviteTokenArguments(
        data: CreateClubInviteTokenInput(
            name: _activeToken.name,
            inviteLimit: _enableInviteLimit ? _activeToken.inviteLimit : 0,
            clubId: widget.clubId));

    final result = await GraphQLStore.store
        .mutate<CreateClubInviteToken$Mutation, CreateClubInviteTokenArguments>(
            mutation: CreateClubInviteTokenMutation(variables: variables),
            broadcastQueryIds: [
          GQLVarParamKeys.clubInviteTokens(widget.clubId)
        ]);

    setState(() => _savingToDB = false);

    checkOperationResult(result,
        onFail: () => context.showToast(
            message: 'Sorry there was a problem creating the invite link.',
            toastType: ToastType.destructive),
        onSuccess: context.pop);
  }

  Future<void> _updateClubInviteToken() async {
    setState(() => _savingToDB = true);

    final variables = UpdateClubInviteTokenArguments(
        data: UpdateClubInviteTokenInput(
            name: _activeToken.name,
            inviteLimit: _enableInviteLimit ? _activeToken.inviteLimit : 0,
            id: _activeToken.id,
            clubId: widget.clubId));

    final result = await GraphQLStore.store
        .mutate<UpdateClubInviteToken$Mutation, UpdateClubInviteTokenArguments>(
            mutation: UpdateClubInviteTokenMutation(variables: variables),
            broadcastQueryIds: [
          GQLVarParamKeys.clubInviteTokens(widget.clubId)
        ]);

    setState(() => _savingToDB = false);

    checkOperationResult(result,
        onFail: () => context.showToast(
            message: 'Sorry there was a problem updating the invite link.',
            toastType: ToastType.destructive),
        onSuccess: context.pop);
  }

  bool get _validToSubmit =>
      _activeToken.name.length > 2 && _activeToken.name.length < 21;

  void _handleCancel() {
    context.showConfirmDialog(
        title: 'Close without saving?', onConfirm: context.pop);
  }

  @override
  void dispose() {
    _inviteLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
          withoutLeading: true,
          middle: Row(
            children: [
              NavBarLargeTitle(
                  _isCreate ? 'Create Invite Link' : 'Edit Invite Link'),
            ],
          ),
          trailing: _savingToDB
              ? const NavBarTrailingRow(children: [NavBarLoadingIndicator()])
              : NavBarCancelButton(_handleCancel)),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8.0),
        children: [
          if (!_isCreate)
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(
                      'This link has been used ${_activeToken.joinedUserIds.length} times so far.'),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: MyTextFormFieldRow(
              autofocus: _isCreate,
              controller: _nameController,
              placeholder: 'Label (required)',
              keyboardType: TextInputType.text,
              validator: () => _validToSubmit,
              validationMessage: 'Min 3, max 20 characters',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4.0),
            child: CupertinoSwitchRow(
                title: 'Limit Invites',
                updateValue: (v) => setState(() => _enableInviteLimit = v),
                value: _enableInviteLimit),
          ),
          const SizedBox(height: 8),
          GrowInOut(
            show: _enableInviteLimit,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(child: MyText('Expire after')),
                  Flexible(child: MyNumberInput(_inviteLimitController)),
                  const Flexible(child: MyText('have joined.')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          if (_validToSubmit)
            FadeInUp(
              child: PrimaryButton(
                  loading: _savingToDB,
                  prefixIconData:
                      _isCreate ? CupertinoIcons.add : CupertinoIcons.pencil,
                  text: _isCreate ? 'Create Invite Link' : 'Update Invite Link',
                  onPressed: _isCreate
                      ? _createClubInviteToken
                      : _updateClubInviteToken),
            )
        ],
      ),
    );
  }
}

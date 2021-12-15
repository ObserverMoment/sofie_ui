import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/club_creator/club_creator_info.dart';
import 'package:sofie_ui/components/creators/club_creator/club_creator_media.dart';
import 'package:sofie_ui/components/creators/club_creator/club_creator_members.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/components/user_input/text_input.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/extensions/data_type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/debounce.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';

class ClubCreatorPage extends StatefulWidget {
  final Club? club;
  const ClubCreatorPage({
    Key? key,
    this.club,
  }) : super(key: key);

  @override
  _ClubCreatorPageState createState() => _ClubCreatorPageState();
}

class _ClubCreatorPageState extends State<ClubCreatorPage> {
  /// Pre-create data fields.
  /// User must add these (only name is required) and then save.
  /// This creates a new club in the DB and returns it.
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  // Pre-create we need to check that the club name is available and that is valid.
  bool _nameIsValid = false;
  bool _nameIsAvailable = true;
  final _debouncer = Debouncer();

  Future<void> _checkNameAvailable() async {
    final _text = _nameController.text;
    _nameIsValid = _text.length > 2 && _text.length < 21;

    if (_nameIsValid) {
      _debouncer.run(() async {
        final isAvailable = await context.graphQLStore.networkOnlyOperation(
            operation: CheckUniqueClubNameQuery(
                variables: CheckUniqueClubNameArguments(name: _text)));
        setState(() => _nameIsAvailable =
            isAvailable.data != null && isAvailable.data!.checkUniqueClubName);
      });
    }
  }

  /// Post-create data. We go straight here in the case of editing a club.
  Club? _activeClub;
  Map<String, dynamic> _activeClubBackup = {};

  int _activePageIndex = 0;

  /// Doing something over the network - replaces tab sliding select and 'done' buttons with loading indicators.
  bool _savingToDB = false;
  bool _uploadingMedia = false;
  late bool _isCreate;

  @override
  void initState() {
    super.initState();

    _isCreate = widget.club == null;

    if (!_isCreate) {
      _activeClub = Club.fromJson(widget.club!.toJson());
    }

    if (_activeClub == null) {
      _initPreCreateDataFields();
    } else {
      /// Create initial backup data.
      _activeClubBackup = _activeClub!.toJson();
    }

    _nameController.addListener(_checkNameAvailable);
  }

  void _initPreCreateDataFields() {
    _nameController.addListener(() {
      setState(() {});
    });
    _descriptionController.addListener(() {
      setState(() {});
    });
    _locationController.addListener(() {
      setState(() {});
    });
  }

  void _updatePageIndex(int i) {
    Utils.hideKeyboard(context);
    setState(() => _activePageIndex = i);
  }

  Future<void> _createClub() async {
    setState(() => _savingToDB = true);

    final variables = CreateClubArguments(
        data: CreateClubInput(
            name: _nameController.text,
            description: _descriptionController.text,
            location: _locationController.text));

    final result = await context.graphQLStore
        .create<CreateClub$Mutation, CreateClubArguments>(
      mutation: CreateClubMutation(variables: variables),
      processResult: (data) {
        _writeClubSummaryUpdateAndBroadcast(data.createClub,
            addRefToQuery: true);
      },
    );

    setState(() => _savingToDB = false);

    checkOperationResult(context, result,
        onFail: () => context.showErrorAlert(
            'Sorry there was a problem, the Club was not created.'),
        onSuccess: () {
          setState(() {
            _activeClub = result.data!.createClub;
          });

          context.showToast(
              message: 'Club created!', toastType: ToastType.success);

          _activeClubBackup = _activeClub!.toJson();
        });
  }

  void _onMediaUploadComplete(Map<String, dynamic> data) {
    setState(() {
      _uploadingMedia = false;
    });

    _updateClub(data);
  }

  void _updateClub(Map<String, dynamic> data) {
    if (_activeClub == null) {
      throw Exception(
          'ClubCreatorPage._updateClub: [_activeClub] has not been initialized.');
    }

    setState(() {
      _activeClub = Club.fromJson({
        ..._activeClub!.toJson(),
        ...data,
      });
    });

    /// Send new data to DB. Pass just the updated data via [customVariablesMap]
    _saveUpdateToDB(data);
  }

  Future<void> _saveUpdateToDB(Map<String, dynamic> data) async {
    if (_activeClub == null) {
      throw Exception(
          'ClubCreatorPage._saveUpdateToDB: [_activeClub] has not been initialized.');
    }

    setState(() => _savingToDB = true);

    final variables = UpdateClubArguments(
        data: UpdateClubInput(
      id: _activeClub!.id,
    ));

    final result = await context.graphQLStore
        .mutate<UpdateClub$Mutation, UpdateClubArguments>(
      mutation: UpdateClubMutation(variables: variables),
      customVariablesMap: {
        'data': {'id': _activeClub!.id, ...data}
      },
      processResult: (data) {
        _writeClubSummaryUpdateAndBroadcast(data.updateClub);
      },
      broadcastQueryIds: [GQLVarParamKeys.clubByIdQuery(_activeClub!.id)],
    );

    setState(() => _savingToDB = false);

    checkOperationResult(context, result, onFail: () {
      context.showErrorAlert(
          'Sorry there was a problem, the Club was not updated.');

      /// Roll back the changes.
      setState(() {
        _activeClub = Club.fromJson(_activeClubBackup);
      });
    }, onSuccess: () {
      setState(() {
        _activeClub = result.data!.updateClub;
      });

      /// Update the backup data.
      _activeClubBackup = _activeClub!.toJson();
    });
  }

  /// Methods to handle ClubInviteToken CRUD. ClubInviteTokens are nested within Clubs so a manual store write is required to ensure that all the UI updates correctly.
  /// Adds the new or updated token (which was created in [ClubInviteTokenCreator]) to local state - _activeClub.
  /// Then write the updated club to global GraphQLStore and re-broadcast as necessary.
  void _addNewInviteTokenToState(ClubInviteToken token) {
    if (_activeClub == null) {
      throw Exception(
          'ClubCreatorPage._addNewInviteTokenToState: [_activeClub] has not been initialized.');
    }
    setState(() {
      _activeClub!.clubInviteTokens!.add(token);
    });

    _writeClubToGraphQLStore(_activeClub!);
  }

  void _addUpdatedInviteTokenToState(ClubInviteToken token) {
    if (_activeClub == null) {
      throw Exception(
          'ClubCreatorPage._addUpdatedInviteTokenToState: [_activeClub] has not been initialized.');
    }

    setState(() {
      _activeClub!.clubInviteTokens = _activeClub!.clubInviteTokens!
          .map((original) => token.id == original.id ? token : original)
          .toList();
    });

    _writeClubToGraphQLStore(_activeClub!);
  }

  Future<void> _deleteClubInviteToken(ClubInviteToken token) async {
    if (_activeClub == null) {
      throw Exception(
          'ClubCreatorPage._saveUpdateToDB: [_activeClub] has not been initialized.');
    }

    setState(() => _savingToDB = true);

    final variables = DeleteClubInviteTokenByIdArguments(id: token.id);

    final result = await context.graphQLStore.delete<
            DeleteClubInviteTokenById$Mutation,
            DeleteClubInviteTokenByIdArguments>(
        mutation: DeleteClubInviteTokenByIdMutation(variables: variables),
        objectId: token.id,
        typename: kClubInviteTokenTypeName,
        removeAllRefsToId: true);

    setState(() => _savingToDB = false);

    if (result.hasErrors ||
        result.data?.deleteClubInviteTokenById != token.id) {
      context.showErrorAlert(
          'Sorry there was a problem, the invite link was not deleted.');
    } else {
      setState(() {
        _activeClub!.clubInviteTokens =
            _activeClub!.clubInviteTokens!.toggleItem(token);
      });

      /// Update the backup data.
      _activeClubBackup = _activeClub!.toJson();
    }
  }

  Future<void> _giveMemberAdminStatus(String userId) async {
    if (_activeClub == null) {
      throw Exception(
          'ClubCreatorPage._giveMemberAdminStatus: [_activeClub] has not been initialized.');
    }

    try {
      setState(() => _savingToDB = true);

      final result = await context.graphQLStore.mutate<
              GiveMemberAdminStatus$Mutation, GiveMemberAdminStatusArguments>(
          mutation: GiveMemberAdminStatusMutation(
              variables: GiveMemberAdminStatusArguments(
                  userId: userId, clubId: _activeClub!.id)),
          processResult: (data) {
            _writeClubSummaryUpdateAndBroadcast(data.giveMemberAdminStatus);
          },
          broadcastQueryIds: [
            GQLVarParamKeys.clubByIdQuery(_activeClub!.id),
          ]);

      setState(() {
        _activeClub = result.data!.giveMemberAdminStatus;
      });
      context.showToast(
        message: 'Member given admin status.',
      );
    } catch (e) {
      printLog(e.toString());
      context.showToast(
          message: 'Sorry, there was a problem adding admin status!',
          toastType: ToastType.destructive);
    } finally {
      setState(() => _savingToDB = false);
    }

    /// Update the backup data.
    _activeClubBackup = _activeClub!.toJson();
  }

  Future<void> _removeMemberAdminStatus(String userId) async {
    if (_activeClub == null) {
      throw Exception(
          'ClubCreatorPage._removeMemberAdminStatus: [_activeClub] has not been initialized.');
    }

    try {
      setState(() => _savingToDB = true);

      final result = await context.graphQLStore.mutate<
              RemoveMemberAdminStatus$Mutation,
              RemoveMemberAdminStatusArguments>(
          mutation: RemoveMemberAdminStatusMutation(
              variables: RemoveMemberAdminStatusArguments(
                  userId: userId, clubId: _activeClub!.id)),
          processResult: (data) {
            _writeClubSummaryUpdateAndBroadcast(data.removeMemberAdminStatus);
          },
          broadcastQueryIds: [
            GQLVarParamKeys.clubByIdQuery(_activeClub!.id),
          ]);

      setState(() {
        _activeClub = result.data!.removeMemberAdminStatus;
      });
      context.showToast(
        message: 'Member admin status removed.',
      );
    } catch (e) {
      printLog(e.toString());
      context.showToast(
          message: 'Sorry, there was a problem removing admin status!',
          toastType: ToastType.destructive);
    } finally {
      setState(() => _savingToDB = false);
    }

    /// Update the backup data.
    _activeClubBackup = _activeClub!.toJson();
  }

  Future<void> _removeUserFromClub(
      String userId, ClubMemberType memberType) async {
    if (_activeClub == null) {
      throw Exception(
          'ClubCreatorPage._removeUserFromClub: [_activeClub] has not been initialized.');
    }
    if (memberType == ClubMemberType.owner) {
      throw Exception(
          'ClubCreatorPage._removeUserFromClub: Cannot remove and Owner from the club.');
    }
    try {
      setState(() => _savingToDB = true);
      final result = await context.graphQLStore
          .mutate<RemoveUserFromClub$Mutation, RemoveUserFromClubArguments>(
              mutation: RemoveUserFromClubMutation(
                  variables: RemoveUserFromClubArguments(
                      userToRemoveId: userId, clubId: _activeClub!.id)),
              processResult: (data) {
                _writeClubSummaryUpdateAndBroadcast(data.removeUserFromClub);
              },
              broadcastQueryIds: [
            GQLVarParamKeys.clubByIdQuery(_activeClub!.id),
          ]);

      setState(() {
        _activeClub = result.data!.removeUserFromClub;
      });

      context.showToast(
        message: 'Member removed from club.',
      );
    } catch (e) {
      printLog(e.toString());
      context.showToast(
          message:
              'Sorry, there was a problem removing this person from the club!',
          toastType: ToastType.destructive);
    } finally {
      setState(() => _savingToDB = false);
    }

    /// Update the backup data.
    _activeClubBackup = _activeClub!.toJson();
  }

  /// Manual writes to store for [Club] and [ClubSummary] objects ///
  /// Also rebroadcasts the correct queries.
  void _writeClubToGraphQLStore(Club club) {
    final success = context.graphQLStore.writeDataToStore(
      data: _activeClub!.toJson(),
      broadcastQueryIds: [
        GQLVarParamKeys.clubByIdQuery(_activeClub!.id),
      ],
    );

    if (!success) {
      context.showErrorAlert(
          'Sorry there was a problem. The changes were not updated correctly!');
    }
  }

  void _writeClubSummaryUpdateAndBroadcast(Club club,
      {bool addRefToQuery = false}) {
    final success = context.graphQLStore.writeDataToStore(
        data: club.summary.toJson(),
        addRefToQueries: addRefToQuery ? [GQLOpNames.userClubsQuery] : [],
        broadcastQueryIds: addRefToQuery ? [] : [GQLOpNames.userClubsQuery]);

    if (!success) {
      context.showErrorAlert(
          'Sorry there was a problem. The changes were not updated correctly!');
    }
  }

  /// Will not save anything.
  void _close() {
    context.pop();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        withoutLeading: true,
        middle: Row(
          children: [
            NavBarLargeTitle(_isCreate ? 'Create Club' : 'Manage Club'),
          ],
        ),
        trailing: _savingToDB
            ? const NavBarTrailingRow(
                children: [
                  NavBarLoadingDots(),
                ],
              )
            : _activeClub == null
                ? NavBarCancelButton(_close)
                : NavBarTextButton(_close, 'Done'),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 80,
            child: AnimatedSwitcher(
              duration: kStandardAnimationDuration,
              child: _uploadingMedia
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        MyText('Uploading media'),
                        SizedBox(width: 6),
                        NavBarLoadingDots()
                      ],
                    )
                  : _activeClub == null
                      ? PrimaryButton(
                          text: 'Create Club',
                          onPressed: _createClub,
                          prefixIconData: CupertinoIcons.add,
                          disabled: !_nameIsValid || !_nameIsAvailable,
                          loading: _savingToDB,
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: MySlidingSegmentedControl<int>(
                                value: _activePageIndex,
                                updateValue: _updatePageIndex,
                                children: const {
                                  0: 'Info',
                                  1: 'Media',
                                  2: 'Members',
                                }),
                          ),
                        ),
            ),
          ),
          if (_activeClub == null)
            Expanded(
              child: _PreCreateInputUI(
                descriptionController: _descriptionController,
                nameIsValid: _nameIsValid,
                nameIsAvailable: _nameIsAvailable,
                locationController: _locationController,
                nameController: _nameController,
              ),
            )
          else
            Expanded(
              child: IndexedStack(
                index: _activePageIndex,
                children: [
                  ClubCreatorInfo(
                    club: _activeClub!,
                    updateClub: _updateClub,
                  ),
                  ClubCreatorMedia(
                    coverImageUri: _activeClub?.coverImageUri,
                    onImageUploaded: (imageUri) =>
                        _onMediaUploadComplete({'coverImageUri': imageUri}),
                    removeImage: (_) =>
                        _onMediaUploadComplete({'coverImageUri': null}),
                    introVideoUri: _activeClub?.introVideoUri,
                    introVideoThumbUri: _activeClub?.introVideoThumbUri,
                    onVideoUploaded: (videoUri, thumbUri) =>
                        _onMediaUploadComplete({
                      'introVideoUri': videoUri,
                      'introVideoThumbUri': thumbUri
                    }),
                    removeVideo: () => _onMediaUploadComplete(
                        {'introVideoUri': null, 'introVideoThumbUri': null}),
                    introAudioUri: _activeClub?.introAudioUri,
                    onAudioUploaded: (audioUri) =>
                        _onMediaUploadComplete({'introAudioUri': audioUri}),
                    removeAudio: () =>
                        _onMediaUploadComplete({'introAudioUri': null}),
                    onMediaUploadStart: () =>
                        setState(() => _uploadingMedia = true),
                    onMediaUploadFail: () =>
                        setState(() => _uploadingMedia = false),
                  ),
                  ClubCreatorMembers(
                    club: _activeClub!,
                    onCreateInviteToken: _addNewInviteTokenToState,
                    onUpdateInviteToken: _addUpdatedInviteTokenToState,
                    deleteClubInviteToken: (token) =>
                        _deleteClubInviteToken(token),
                    giveMemberAdminStatus: _giveMemberAdminStatus,
                    removeMemberAdminStatus: _removeMemberAdminStatus,
                    removeUserFromClub: _removeUserFromClub,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Displays in the case the a user is creating a brand new club.
/// They enter some basic info about it and then click save.
/// Once saved and data is back from the DB then UI reverts to the standard UI.
class _PreCreateInputUI extends StatelessWidget {
  final TextEditingController nameController;
  final bool nameIsValid;
  final bool nameIsAvailable;
  final TextEditingController descriptionController;
  final TextEditingController locationController;

  const _PreCreateInputUI({
    Key? key,
    required this.nameController,
    required this.descriptionController,
    required this.locationController,
    required this.nameIsValid,
    required this.nameIsAvailable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        UserInputContainer(
          child: MyTextFormFieldRow(
            autofocus: true,
            backgroundColor: context.theme.cardBackground,
            controller: nameController,
            placeholder: 'Name (required)',
            keyboardType: TextInputType.text,
            validator: () => nameIsValid && nameIsAvailable,
            validationMessage: 'Min 3, max 20 characters',
          ),
        ),
        GrowInOut(
            show: nameIsValid && !nameIsAvailable,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
              child: MyText('Sorry, this club name is already taken.',
                  color: Styles.primaryAccent),
            )),
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 4, top: 10),
          child: MyTextAreaFormFieldRow(
              placeholder: 'Description (optional)',
              backgroundColor: context.theme.cardBackground,
              keyboardType: TextInputType.text,
              controller: descriptionController),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 4, top: 10),
          child: MyTextAreaFormFieldRow(
              placeholder: 'Location (optional)',
              backgroundColor: context.theme.cardBackground,
              keyboardType: TextInputType.text,
              controller: locationController),
        ),
      ],
    );
  }
}

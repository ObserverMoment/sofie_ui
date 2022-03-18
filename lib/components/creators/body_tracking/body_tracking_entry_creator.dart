import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/image_uploader.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/number_picker_row_tap_to_edit.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';

class BodyTrackingEntryCreatorPage extends StatefulWidget {
  final BodyTrackingEntry? bodyTrackingEntry;
  const BodyTrackingEntryCreatorPage({Key? key, this.bodyTrackingEntry})
      : super(key: key);

  @override
  _BodyTrackingEntryCreatorPageState createState() =>
      _BodyTrackingEntryCreatorPageState();
}

class _BodyTrackingEntryCreatorPageState
    extends State<BodyTrackingEntryCreatorPage> {
  /// 0 = Info, 1 = Photos
  int _activeTabIndex = 0;

  /// Doing something over the network - replaces tab sliding select and 'done' buttons with loading indicators.
  bool _uploadingMedia = false;

  /// When the user enters their first piece of data we create a new object in the DB.
  /// Note: Different flow to other widgets which either make you enter some basic details before saving (Workout Creator) or ask you to save before leaving (Gym Profile)
  /// This may be a smoother experience for the user.
  bool _existsInDB = false;
  late bool _isCreate;

  Map<String, dynamic> _backup =
      {}; // For rollbacks after server CRUD update fail.
  BodyTrackingEntry? _activeBodyTrackingEntry;

  void _updateTabIndex(int i) {
    Utils.hideKeyboard(context);
    setState(() => _activeTabIndex = i);
  }

  @override
  void initState() {
    super.initState();

    _isCreate = widget.bodyTrackingEntry == null;

    if (!_isCreate) {
      _backup = widget.bodyTrackingEntry!.toJson();
      _activeBodyTrackingEntry = BodyTrackingEntry.fromJson(_backup);
      _existsInDB = true;
    } else {
      // Set up a defaul object.
      _activeBodyTrackingEntry = BodyTrackingEntry()
        ..id = 'temp'
        ..createdAt = DateTime.now()
        ..photoUris = [];
    }
  }

  Future<void> _updateBodyTrackingEntry(Map<String, dynamic> data) async {
    /// Optimistically update the UI
    setState(() {
      _activeBodyTrackingEntry = BodyTrackingEntry.fromJson(
          {..._activeBodyTrackingEntry?.toJson() ?? {}, ...data});
    });

    if (!_existsInDB) {
      /// Create the object first.
      final mutation = CreateBodyTrackingEntryMutation(
          variables: CreateBodyTrackingEntryArguments(
              data: CreateBodyTrackingEntryInput.fromJson(data)));

      final result = await context.graphQLStore.create<
              CreateBodyTrackingEntry$Mutation,
              CreateBodyTrackingEntryArguments>(
          mutation: mutation,
          addRefToQueries: [GQLOpNames.bodyTrackingEntries]);

      checkOperationResult(context, result,
          onFail: _handleOnFailAndBackup,
          onSuccess: () =>
              _handleSuccessfulUpdate(result.data!.createBodyTrackingEntry));
    } else {
      final mutation = UpdateBodyTrackingEntryMutation(
          variables: UpdateBodyTrackingEntryArguments(
              data: UpdateBodyTrackingEntryInput.fromJson(
                  _activeBodyTrackingEntry!.toJson())));

      final result = await context.graphQLStore.mutate<
              UpdateBodyTrackingEntry$Mutation,
              UpdateBodyTrackingEntryArguments>(
          mutation: mutation,
          broadcastQueryIds: [GQLOpNames.bodyTrackingEntries]);

      checkOperationResult(context, result,
          onFail: _handleOnFailAndBackup,
          onSuccess: () =>
              _handleSuccessfulUpdate(result.data!.updateBodyTrackingEntry));
    }
  }

  void _handleSuccessfulUpdate(BodyTrackingEntry entry) {
    setState(() {
      _existsInDB = true;
      _activeBodyTrackingEntry = entry;
      _backup = _activeBodyTrackingEntry!.toJson();
    });
  }

  void _handleOnFailAndBackup() {
    setState(() {
      _activeBodyTrackingEntry = BodyTrackingEntry.fromJson(_backup);
    });
    context.showToast(
        message: 'Sorry, there was a problem!',
        toastType: ToastType.destructive);
  }

  /// Will not need to save anything or check before leaving as flow of this widget saves incrementally.
  void _close() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
      navigationBar: MyNavBar(
        withoutLeading: true,
        middle: Row(
          children: [
            NavBarLargeTitle(_isCreate ? 'Create Entry' : 'Edit Entry'),
          ],
        ),
        trailing: _uploadingMedia
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  NavBarLoadingIndicator(),
                ],
              )
            : _existsInDB
                ? NavBarTextButton(_close, 'Done')
                : NavBarCancelButton(_close),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            width: double.infinity,
            child: MySlidingSegmentedControl<int>(
                value: _activeTabIndex,
                children: const {0: 'Stats', 1: 'Photos'},
                updateValue: _updateTabIndex),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
              child: IndexedStack(
                index: _activeTabIndex,
                children: [
                  _Stats(
                    activeBodyTrackingEntry: _activeBodyTrackingEntry,
                    update: _updateBodyTrackingEntry,
                  ),
                  _Photos(
                    photoUris: _activeBodyTrackingEntry?.photoUris ?? [],
                    update: _updateBodyTrackingEntry,
                    onUploadStart: () => setState(() => _uploadingMedia = true),
                    onUploadEnd: () => setState(() => _uploadingMedia = false),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  final BodyTrackingEntry? activeBodyTrackingEntry;
  final void Function(Map<String, dynamic> data) update;
  const _Stats(
      {Key? key, required this.activeBodyTrackingEntry, required this.update})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loadUnitString =
        activeBodyTrackingEntry?.bodyweightUnit?.display ?? 'kg';
    return ListView(
      shrinkWrap: true,
      children: [
        UserInputContainer(
          child: EditableTextAreaRow(
              title: 'Note',
              text: activeBodyTrackingEntry?.note ?? '',
              onSave: (note) => update({'note': note}),
              inputValidation: (t) => true),
        ),
        UserInputContainer(
            child: DoublePickerRowTapToEdit(
          title: 'Body Weight',
          suffix: loadUnitString,
          value: activeBodyTrackingEntry?.bodyweight,
          inputUnitDisplay: loadUnitString,
          saveValue: (bodyweight) => update({'bodyweight': bodyweight}),
        )),
        SizedBox(
            width: double.infinity,
            child: MySlidingSegmentedControl<BodyweightUnit>(
              value:
                  activeBodyTrackingEntry?.bodyweightUnit ?? BodyweightUnit.kg,
              children: const {
                BodyweightUnit.kg: 'KG',
                BodyweightUnit.lb: 'LB',
              },
              updateValue: (unit) => update({'bodyweightUnit': unit.apiValue}),
            )),
        UserInputContainer(
            child: DoublePickerRowTapToEdit(
          title: 'Body Fat percentage',
          suffix: '%',
          value: activeBodyTrackingEntry?.fatPercent,
          saveValue: (fatPercent) => update({'fatPercent': fatPercent}),
        )),
      ],
    );
  }
}

class _Photos extends StatelessWidget {
  final List<String> photoUris;
  final VoidCallback onUploadStart;
  final VoidCallback onUploadEnd;
  final void Function(Map<String, dynamic> data) update;
  const _Photos(
      {Key? key,
      required this.photoUris,
      required this.update,
      required this.onUploadStart,
      required this.onUploadEnd})
      : super(key: key);

  /// Remove previous uri and add the new uri
  void _handleImageUpdate(String oldUri, String newUri) {
    onUploadEnd();
    update({
      'photoUris': [
        ...photoUris.where((u) => u != oldUri),
        newUri,
      ]
    });
  }

  void _handleNewImageUpload(String newUri) {
    onUploadEnd();
    update({
      'photoUris': [
        ...photoUris,
        newUri,
      ]
    });
  }

  void _handleRemoveImageUpload(String uri) {
    onUploadEnd();
    update({'photoUris': photoUris.where((u) => u != uri)});
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 3 / 4,
      children: [
        FadeIn(
          child: ImageUploader(
            onUploadStart: onUploadStart,
            onUploadSuccess: _handleNewImageUpload,
            removeImage: (_) => {},
            emptyThumbIcon: CupertinoIcons.add,
            borderRadius: 0,
          ),
        ),
        ...photoUris
            .map((uri) => ImageUploader(
                  imageUri: uri,
                  onUploadStart: onUploadStart,
                  onUploadSuccess: (newUri) => _handleImageUpdate(uri, newUri),
                  removeImage: _handleRemoveImageUpload,
                  emptyThumbIcon: CupertinoIcons.add,
                  borderRadius: 0,
                ))
            .toList(),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/utils.dart';

/// Follows a similar pattern to the [WorkoutCreatorBloc]. Mutations are sent to the DB incrementally and the local UI state is updated immediately (optimistically). However the global graphql store is only updated at the end of the session.
/// Updates are processed locally optimistically, then to the network. If there is an error from the network then changes are rolled back via [backupJson].
/// When creating i.e. [isCreate == true]: A new entry is created in the DB at the start of the session.
/// This pattern is useful because the user can upload media to this object, and we need an object in place to enable easy media uploads to the server and avoid messy local management of temp selected media (see V1 - benchmark_me!).
class ProgressJournalEntryCreatorBloc extends ChangeNotifier {
  ProgressJournal parentJournal;
  final ProgressJournalEntry initialEntry;
  final BuildContext context;
  final bool isCreate;

  ProgressJournalEntryCreatorBloc(
      {required this.parentJournal,
      required this.initialEntry,
      required this.context,
      required this.isCreate})
      : entry = initialEntry;

  /// The main data structure that the user is editing on the client.
  ProgressJournalEntry entry;
  Map<String, dynamic> backupJson = {};

  bool formIsDirty = false;

  /// Run this before constructing the bloc
  static Future<ProgressJournalEntry> initialize(
      BuildContext context,
      ProgressJournal parentJournal,
      ProgressJournalEntry? prevEntryData) async {
    try {
      if (prevEntryData != null) {
        // User is editing a previous entry - return a copy.
        return ProgressJournalEntry.fromJson(prevEntryData.toJson());
      } else {
        // User is creating - make an empty entry in the db and return for editing.
        final variables = CreateProgressJournalEntryArguments(
          data: CreateProgressJournalEntryInput(
            progressJournal: ConnectRelationInput(id: parentJournal.id),
          ),
        );

        /// Use [mutate] here instead of [create] as we will hold off from writing the new entry to the store until the user has finished their editing session.
        final result = await context.graphQLStore.networkOnlyOperation<
            CreateProgressJournalEntry$Mutation,
            CreateProgressJournalEntryArguments>(
          operation: CreateProgressJournalEntryMutation(variables: variables),
        );

        if (result.hasErrors || result.data == null) {
          throw Exception(
              'There was a problem creating a new journal entry in the database.');
        } else {
          final newEntry = result.data!.createProgressJournalEntry;

          context.showToast(message: 'Journal Entry Created');
          return newEntry;
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Once the editing / creating session is completed we write all the new data to the global store.
  bool saveAllChanges(String parentJournalId) {
    if (isCreate) {
      /// As the entry is a nested object within a field of the root query object (the journal), we will need to overwrite the entire Journal in store, with the new entry added to field [ProgressJournalEntries] so that when we rebroadcast the queries it is included in the retireved data.
      final parentJournalData = context.graphQLStore.readDenomalized(
        '$kProgressJournalTypename:$parentJournalId',
      );

      final parentJournal = ProgressJournal.fromJson(parentJournalData);
      parentJournal.progressJournalEntries.add(entry);

      final success = context.graphQLStore.writeDataToStore(
        data: parentJournal.toJson(),
        broadcastQueryIds: [
          GQLVarParamKeys.progressJournalByIdQuery(parentJournalId),
          GQLOpNames.userProgressJournalsQuery,
        ],
      );
      return success;
    } else {
      /// If not a create then we can just update the root normalized [ProgressJournalEntry] object as usual.
      final success = context.graphQLStore.writeDataToStore(
        data: entry.toJson(),
        broadcastQueryIds: [
          ProgressJournalByIdQuery(
                  variables: ProgressJournalByIdArguments(id: parentJournalId))
              .operationName,
          UserProgressJournalsQuery().operationName
        ],
      );
      return success;
    }
  }

  /// Users should not be able to navigate away from the current page while this in in progress.
  /// Otherwise the upload will fail and throw an error.
  /// The top right 'done' button should also be disabled.
  bool uploadingMedia = false;
  void setUploadingMedia({required bool uploading}) {
    uploadingMedia = uploading;
    notifyListeners();
  }

  /// Should run at the start of all CRUD ops.
  void _backupAndMarkDirty() {
    formIsDirty = true;
    backupJson = entry.toJson();
  }

  void _revertChanges(List<Object>? errors) {
    // There was an error so revert to backup, notify listeners and show error toast.
    entry = ProgressJournalEntry.fromJson(backupJson);
    if (errors != null && errors.isNotEmpty) {
      for (final e in errors) {
        printLog(e.toString());
      }
    }
    context.showToast(
        message: 'There was a problem, changes not saved',
        toastType: ToastType.destructive);
  }

  bool _checkApiResult(OperationResult result) {
    if (result.hasErrors || result.data == null) {
      _revertChanges(result.errors);
      return false;
    } else {
      return true;
    }
  }

  /// CRUD Ops for the entry ///
  Future<void> updateEntry(Map<String, dynamic> data) async {
    /// Client.
    _backupAndMarkDirty();
    final updated = ProgressJournalEntry.fromJson({...entry.toJson(), ...data});
    entry = updated;
    notifyListeners();

    /// Api.
    final variables = UpdateProgressJournalEntryArguments(
        data: UpdateProgressJournalEntryInput.fromJson(updated.toJson()));

    final result = await context.graphQLStore.networkOnlyOperation<
        UpdateProgressJournalEntry$Mutation,
        UpdateProgressJournalEntryArguments>(
      operation: UpdateProgressJournalEntryMutation(variables: variables),
    );

    final success = _checkApiResult(result);

    if (success) {
      entry = result.data!.updateProgressJournalEntry;
    }

    notifyListeners();
  }
}

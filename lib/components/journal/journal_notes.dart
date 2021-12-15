import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/media/audio/mic_audio_recorder.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/pages/authed/home/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:sofie_ui/services/uploadcare.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';

class JournalNotes extends StatefulWidget {
  const JournalNotes({Key? key}) : super(key: key);

  @override
  State<JournalNotes> createState() => _JournalNotesState();
}

class _JournalNotesState extends State<JournalNotes> {
  Future<void> _createJournalNote(
      {String? textNote, String? voiceNoteUri}) async {
    assert(textNote != null || voiceNoteUri != null);

    final variables = CreateJournalNoteArguments(
        data: CreateJournalNoteInput(
            textNote: textNote, voiceNoteUri: voiceNoteUri));

    final result = await context.graphQLStore.create(
      mutation: CreateJournalNoteMutation(variables: variables),
      addRefToQueries: [
        GQLOpNames.journalNotes,
      ],
    );

    checkOperationResult(context, result,
        onFail: () => context.showToast(
            message: 'Sorry, there was a problem creating this note.',
            toastType: ToastType.destructive));
  }

  Future<void> _deleteJournalNote(String id) async {
    final variables = DeleteJournalNoteByIdArguments(id: id);

    final result = await context.graphQLStore.delete(
        mutation: DeleteJournalNoteByIdMutation(variables: variables),
        objectId: id,
        typename: kJournalNoteTypename,
        broadcastQueryIds: [
          GQLOpNames.journalNotes,
        ],
        removeAllRefsToId: true);

    checkOperationResult(context, result,
        onFail: () => context.showToast(
            message: 'Sorry, there was a problem deleting this note.',
            toastType: ToastType.destructive));
  }

  void _openTextNoteInput({String? text}) {
    context.push(
        child: FullScreenTextEditing(
            title: 'Note',
            initialValue: text,
            onSave: (note) => _createJournalNote(textNote: note),
            inputValidation: (_) => true));
  }

  void _openVoiceNoteInput() {
    context.push(child: MicAudioRecorder(saveAudioRecording: (filePath) {
      final file = File(filePath);
      UploadcareService().uploadFile(
          file: SharedFile(file),
          onComplete: (fileId) {
            _createJournalNote(voiceNoteUri: fileId);
          },
          onFail: (_) => _showErrorToast);
    }));
  }

  void _showErrorToast() => context.showToast(
      message: 'Sorry, there was a problem.', toastType: ToastType.destructive);

  @override
  Widget build(BuildContext context) {
    return QueryObserver<JournalNotes$Query, json.JsonSerializable>(
        key: Key('JournalNotes - ${JournalNotesQuery().operationName}'),
        query: JournalNotesQuery(),
        fetchPolicy: QueryFetchPolicy.storeFirst,
        builder: (data) {
          final sortedNotes = data.journalNotes
              .sortedBy<DateTime>((e) => e.createdAt)
              .reversed
              .toList();

          return sortedNotes.isEmpty
              ? YourContentEmptyPlaceholder(
                  message: 'No notes added',
                  explainer:
                      'Put your notes, thoughts or feeling about your fitness journey here, either as text or as a voice note.',
                  actions: [
                      EmptyPlaceholderAction(
                          action: _openTextNoteInput,
                          buttonIcon: CupertinoIcons.doc_text,
                          buttonText: 'Add Text Note'),
                      EmptyPlaceholderAction(
                          action: _openVoiceNoteInput,
                          buttonIcon: CupertinoIcons.mic,
                          buttonText: 'Add Voice Note'),
                    ])
              : FABPage(
                  columnButtons: [
                      FloatingButton(
                        onTap: _openVoiceNoteInput,
                        icon: CupertinoIcons.mic,
                      ),
                      FloatingButton(
                        onTap: _openTextNoteInput,
                        icon: CupertinoIcons.doc_text,
                      ),
                    ],
                  child: GridView.builder(
                      itemCount: sortedNotes.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (c, i) {
                        if (Utils.textNotNull(sortedNotes[i].textNote)) {
                          return MyText('Text note UI');
                        } else {
                          return MyText('Voice note UI');
                        }
                      }));
        });
  }
}

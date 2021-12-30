import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/media/audio/audio_players.dart';
import 'package:sofie_ui/components/media/audio/mic_audio_recorder.dart';
import 'package:sofie_ui/components/read_more_text_block.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/menus/popover.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
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

    checkOperationResult(context, result, onFail: _showErrorToast);
  }

  Future<void> _updateJournalNote(
      {required String id, String? textNote, String? voiceNoteUri}) async {
    assert(textNote != null || voiceNoteUri != null);

    final variables = UpdateJournalNoteArguments(
        data: UpdateJournalNoteInput(
            id: id, textNote: textNote, voiceNoteUri: voiceNoteUri));

    final result = await context.graphQLStore.mutate(
      mutation: UpdateJournalNoteMutation(variables: variables),
      broadcastQueryIds: [
        GQLOpNames.journalNotes,
      ],
    );

    checkOperationResult(context, result, onFail: _showErrorToast);
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

  void _openTextNoteInput({JournalNote? journalNote}) {
    context.push(
        child: FullScreenTextEditing(
            title: 'Note',
            initialValue: journalNote?.textNote,
            onSave: (note) => journalNote?.textNote != null
                ? _updateJournalNote(id: journalNote!.id, textNote: note)
                : _createJournalNote(textNote: note),
            inputValidation: (t) => t.isNotEmpty));
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

  void _confirmDeleteJournalNote(String id) {
    context.showConfirmDeleteDialog(
        itemType: 'Note', onConfirm: () => _deleteJournalNote(id));
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
                  rowButtonsAlignment: MainAxisAlignment.end,
                  rowButtons: [
                    FloatingButton(
                      onTap: _openVoiceNoteInput,
                      icon: CupertinoIcons.mic,
                    ),
                    const SizedBox(width: 12),
                    FloatingButton(
                      onTap: _openTextNoteInput,
                      icon: CupertinoIcons.doc_text,
                    ),
                  ],
                  child: GridView.builder(
                    itemCount: sortedNotes.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 6,
                            crossAxisSpacing: 6,
                            crossAxisCount: 2),
                    padding:
                        const EdgeInsets.only(left: 6, right: 6, bottom: 0),
                    // shrinkWrap: true,
                    itemBuilder: (context, i) {
                      final item = sortedNotes[i];
                      return SizedBox(
                        height: 90,
                        child: Utils.textNotNull(item.textNote)
                            ? _TextNoteTile(
                                note: item,
                                openTextNoteInput: () =>
                                    _openTextNoteInput(journalNote: item),
                                confirmDeleteNote: () =>
                                    _confirmDeleteJournalNote(item.id),
                              )
                            : _VoiceNoteTile(
                                note: item,
                                confirmDeleteNote: () =>
                                    _confirmDeleteJournalNote(item.id),
                              ),
                      );
                    },
                  ),
                );
        });
  }
}

class _TextNoteTile extends StatelessWidget {
  final JournalNote note;
  final VoidCallback openTextNoteInput;
  final VoidCallback confirmDeleteNote;
  const _TextNoteTile(
      {Key? key,
      required this.note,
      required this.openTextNoteInput,
      required this.confirmDeleteNote})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.showBottomSheet(
          child: TextViewer(
              note.textNote!, 'Note ${note.createdAt.compactDateString}')),
      child: Card(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeIn(
                        key: Key(note.textNote!),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: MyText(
                            note.textNote!,
                            maxLines: 3,
                            lineHeight: 1.2,
                            size: FONTSIZE.four,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 4,
              child: PopoverMenu(
                  button: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(CupertinoIcons.ellipsis),
                  ),
                  items: [
                    PopoverMenuItem(
                      onTap: openTextNoteInput,
                      iconData: CupertinoIcons.pencil,
                      text: 'Edit',
                    ),
                    PopoverMenuItem(
                      onTap: confirmDeleteNote,
                      iconData: CupertinoIcons.trash_circle,
                      text: 'Delete',
                    ),
                  ]),
            ),
            Positioned(
              top: 8,
              left: 2,
              child: MyText(
                note.createdAt.dateAndTime,
                size: FONTSIZE.one,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _VoiceNoteTile extends StatelessWidget {
  final JournalNote note;
  final VoidCallback confirmDeleteNote;
  const _VoiceNoteTile(
      {Key? key, required this.note, required this.confirmDeleteNote})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          const Opacity(
              opacity: 0.07,
              child: Icon(
                CupertinoIcons.waveform,
                size: 120,
              )),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: InlineAudioPlayer(
              audioUri: note.voiceNoteUri!,
              layout: Axis.vertical,
              buttonSize: 50,
            ),
          ),
          Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: confirmDeleteNote,
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(CupertinoIcons.delete_simple, size: 18),
                ),
              )),
          Positioned(
            top: 8,
            left: 2,
            child: MyText(
              note.createdAt.dateAndTime,
              size: FONTSIZE.one,
            ),
          )
        ],
      ),
    );
  }
}

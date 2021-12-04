import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/video/video_uploader.dart';
import 'package:sofie_ui/components/personal_best/entry_top_score_display.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/utils.dart';

class PersonalBestEntryCard extends StatelessWidget {
  final UserBenchmarkEntry entry;
  final UserBenchmark benchmark;
  const PersonalBestEntryCard(
      {Key? key, required this.entry, required this.benchmark})
      : super(key: key);

  /// Video Updates: we can update the root normalized [UserBenchmarkEntry] object then rebroadcast the userBenchmarksQuery and the specific query for the parent UserBenchmark.
  /// Use [customVariablesMap] so that you can send only the media related fields (and the id) to the API.
  /// Remember, when using Artemis types any empty fields will be cast to null and may result in the API deleting any values for those fields in the DB.

  Future<void> _saveUploadedVideo(
      BuildContext context, String videoUri, String videoThumbUri) async {
    final variables = UpdateUserBenchmarkEntryArguments(
        data: UpdateUserBenchmarkEntryInput(id: entry.id));

    final result = await context.graphQLStore.mutate(
        mutation: UpdateUserBenchmarkEntryMutation(variables: variables),
        customVariablesMap: {
          'data': {
            'id': entry.id,
            'videoUri': videoUri,
            'videoThumbUri': videoThumbUri
          }
        },
        broadcastQueryIds: [
          GQLOpNames.userBenchmarksQuery,
          GQLVarParamKeys.userBenchmarkByIdQuery(benchmark.id)
        ]);

    if (result.hasErrors || result.data == null) {
      result.errors?.forEach((e) {
        printLog(e.toString());
      });
      context.showToast(
          message: kDefaultErrorMessage, toastType: ToastType.destructive);
    } else {
      context.showToast(message: 'Video Uploaded.');
    }
  }

  Future<void> _deleteUploadedVideo(BuildContext context) async {
    final variables = UpdateUserBenchmarkEntryArguments(
        data: UpdateUserBenchmarkEntryInput(id: entry.id));

    final result = await context.graphQLStore.mutate(
        mutation: UpdateUserBenchmarkEntryMutation(variables: variables),
        customVariablesMap: {
          'data': {'id': entry.id, 'videoUri': null, 'videoThumbUri': null}
        },
        broadcastQueryIds: [
          GQLOpNames.userBenchmarksQuery,
          GQLVarParamKeys.userBenchmarkByIdQuery(benchmark.id)
        ]);

    if (result.hasErrors || result.data == null) {
      result.errors?.forEach((e) {
        printLog(e.toString());
      });
      context.showToast(
          message: kDefaultErrorMessage, toastType: ToastType.destructive);
    } else {
      context.showToast(message: 'Video Deleted.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ContentBox(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UserBenchmarkScoreDisplay(
                benchmark: benchmark,
                benchmarkEntry: entry,
                fontSize: FONTSIZE.five,
                showDate: false,
              ),
              Column(
                children: [
                  MyText(
                    entry.completedOn.dateString,
                    size: FONTSIZE.two,
                  ),
                  MyText(
                    entry.completedOn.timeString,
                    size: FONTSIZE.two,
                  ),
                ],
              ),
              VideoUploader(
                videoUri: entry.videoUri,
                videoThumbUri: entry.videoThumbUri,
                displaySize: const Size(60, 60),
                onUploadSuccess: (v, t) => _saveUploadedVideo(context, v, t),
                removeVideo: () => _deleteUploadedVideo(context),
              )
            ],
          ),
          if (Utils.textNotNull(entry.note))
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: MyText(
                entry.note!,
                size: FONTSIZE.two,
                lineHeight: 1.3,
              ),
            ),
        ],
      ),
    );
  }
}

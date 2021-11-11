import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/info_pages/custom_move_valid_rep_types_info.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/video/video_uploader.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/click_to_edit/text_row_click_to_edit.dart';
import 'package:sofie_ui/components/user_input/selectors/selectable_boxes.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/services/uploadcare.dart';
import 'package:sofie_ui/services/utils.dart';

class CustomMoveCreatorMeta extends StatelessWidget {
  final Move move;
  final void Function(Map<String, dynamic> data) updateMove;
  const CustomMoveCreatorMeta(
      {Key? key, required this.move, required this.updateMove})
      : super(key: key);

  Widget _buildValidrepTypeButton(
      BuildContext context, WorkoutMoveRepType repType) {
    final bool isSelected = move.validRepTypes.contains(repType);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: SelectableBox(
          isSelected: isSelected,
          height: 60,
          onPressed: () => updateMove({
                'validRepTypes': move.validRepTypes
                    .toggleItem(repType)
                    .map((rt) => rt.apiValue)
                    .toList()
              }),
          text: repType.display),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          UserInputContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    MyText(
                      'Demo Video',
                    ),
                    MyText(
                      '(Aspect must be Landscape)',
                      size: FONTSIZE.two,
                      subtext: true,
                    ),
                  ],
                ),
                VideoUploader(
                    videoUri: move.demoVideoUri,
                    videoThumbUri: move.demoVideoThumbUri,
                    displaySize: const Size(60, 60),
                    onUploadSuccess: (v, t) {
                      context.showToast(message: 'Video uploaded');
                      updateMove({
                        'demoVideoUri': v,
                        'demoVideoThumbUri': t,
                      });
                    },
                    removeVideo: () {
                      UploadcareService().deleteFiles(
                          fileIds: [
                            move.demoVideoUri!,
                            move.demoVideoThumbUri!
                          ],
                          onComplete: () {
                            updateMove({
                              'demoVideoUri': null,
                              'demoVideoThumbUri': null,
                            });
                            context.showToast(message: 'Video removed');
                          },
                          onFail: (e) {
                            printLog(e.toString());
                            context.showToast(
                                message: 'Sorry, there was a problem.',
                                toastType: ToastType.destructive);
                          });
                    }),
              ],
            ),
          ),
          UserInputContainer(
            child: EditableTextFieldRow(
              title: 'Name',
              text: move.name,
              onSave: (text) => updateMove({'name': text}),
              inputValidation: (text) => text.length >= 3,
              maxChars: 50,
            ),
          ),
          UserInputContainer(
            child: EditableTextAreaRow(
              title: 'Description',
              text: move.description ?? '',
              onSave: (text) => updateMove({'description': text}),
              maxDisplayLines: 5,
              inputValidation: (t) => true,
            ),
          ),
          UserInputContainer(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    MyText(
                      'Valid Rep Types',
                    ),
                    InfoPopupButton(infoWidget: CustomMoveValidRepTypesInfo())
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const MyText(
                      'TIME + ',
                      weight: FontWeight.bold,
                    ),
                    _buildValidrepTypeButton(context, WorkoutMoveRepType.reps),
                    _buildValidrepTypeButton(
                        context, WorkoutMoveRepType.calories),
                    _buildValidrepTypeButton(
                        context, WorkoutMoveRepType.distance),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 16)
        ],
      ),
    );
  }
}

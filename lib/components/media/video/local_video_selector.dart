import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/utils.dart';

/// Select / record a local video and tne return the local path.
class LocalVideoSelector extends StatelessWidget {
  final String? title;
  final String addVideoText;
  final String? pickedFilePath;
  final void Function(String? filePath) savePickedFilePath;
  const LocalVideoSelector(
      {Key? key,
      this.addVideoText = 'Add a Video',
      required this.pickedFilePath,
      required this.savePickedFilePath,
      this.title})
      : super(key: key);

  Future<void> _pickVideo(BuildContext context, ImageSource source) async {
    try {
      final XFile? pickedFile = await ImagePicker().pickVideo(source: source);

      if (pickedFile != null) {
        savePickedFilePath(pickedFile.path);
      }
    } on PlatformException catch (e) {
      printLog(e.toString());
      context.showErrorAlert(e.toString());
    } on Exception catch (e) {
      printLog(e.toString());
      context.showToast(message: 'Video not selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    final videoSelected = pickedFilePath != null;
    final buttonColor = context.theme.background;

    return ContentBox(
      child: Column(
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyText(
                title!,
                subtext: true,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedSwitcher(
                duration: kStandardAnimationDuration,
                child: videoSelected
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              MyText('Video Selected'),
                              SizedBox(width: 6),
                              Icon(CupertinoIcons.checkmark_alt),
                            ],
                          ),
                          const SizedBox(height: 6),
                          TertiaryButton(
                            text: 'De-select Video',
                            onPressed: () => savePickedFilePath(null),
                            backgroundColor: buttonColor,
                          )
                        ],
                      )
                    : TertiaryButton(
                        text: addVideoText,
                        prefixIconData: CupertinoIcons.tv,
                        backgroundColor: buttonColor,
                        onPressed: () => openBottomSheetMenu(
                            context: context,
                            child: BottomSheetMenu(
                              items: [
                                BottomSheetMenuItem(
                                  text: videoSelected
                                      ? 'Take new video'
                                      : 'Take video',
                                  onPressed: () =>
                                      _pickVideo(context, ImageSource.camera),
                                ),
                                BottomSheetMenuItem(
                                  text: videoSelected
                                      ? 'Choose new from library'
                                      : 'Choose from library',
                                  onPressed: () =>
                                      _pickVideo(context, ImageSource.gallery),
                                ),
                              ],
                            )),
                      )),
          ),
        ],
      ),
    );
  }
}

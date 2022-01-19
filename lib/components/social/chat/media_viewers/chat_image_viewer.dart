import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:cached_network_image/src/image_provider/cached_network_image_provider.dart';

/// Full Screen.
/// Does not use uploadcare cdn as data comes from Stream.io servers as bytes within the message payload.
class ChatImageViewer extends StatelessWidget {
  final String imageUrl;
  const ChatImageViewer({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          PhotoView(
              imageProvider: CachedNetworkImageProvider(
            imageUrl,
          )),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  SizedBox.square(
                    dimension: 40,
                    child: CircularBox(
                        color: Styles.black.withOpacity(0.5),
                        padding: const EdgeInsets.all(6),
                        child: IconButton(
                            iconData: CupertinoIcons.clear,
                            onPressed: context.pop,
                            iconColor: Styles.white)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

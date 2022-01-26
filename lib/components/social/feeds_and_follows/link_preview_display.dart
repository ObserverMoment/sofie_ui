import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/future_builder_handler.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

// https://getstream.io/activity-feeds/docs/flutter-dart/open_graph_scraping/?language=dart
/// Displays a preview of the website linked to and opens that website on tap.
class LinkPreviewDisplay extends StatefulWidget {
  final String url;
  const LinkPreviewDisplay({Key? key, required this.url}) : super(key: key);

  @override
  State<LinkPreviewDisplay> createState() => _LinkPreviewDisplayState();
}

class _LinkPreviewDisplayState extends State<LinkPreviewDisplay> {
  /// https://stackoverflow.com/questions/57793479/flutter-futurebuilder-gets-constantly-called
  late Future<OpenGraphData> _getLinkPreviewFuture;
  late StreamFeedClient _streamFeedClient;

  @override
  void initState() {
    super.initState();
    _streamFeedClient = context.streamFeedClient;
    _getLinkPreviewFuture = _getLinkPreview();
  }

  Future<OpenGraphData> _getLinkPreview() async {
    final preview = await _streamFeedClient.og(widget.url);
    return preview;
  }

  void _openLink() async {
    final success = await launch(widget.url);
    if (!success) {
      context.showToast(
          message: "Sorry, we can't open this link",
          toastType: ToastType.destructive);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openLink,
      child: SizedBox(
        height: 70,
        child: FutureBuilderHandler<OpenGraphData>(
          future: _getLinkPreviewFuture,
          loadingWidget: const Center(
            child: CupertinoActivityIndicator(
              radius: 10,
            ),
          ),
          builder: (data) {
            final title = data.title ?? 'Check it out here!';
            final siteName = data.siteName ?? data.site;

            final imageUrl = data.images != null && data.images!.isNotEmpty
                ? data.images![0].image
                : null;

            return ContentBox(
              padding: const EdgeInsets.all(2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        if (imageUrl != null)
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: imageUrl,
                              ),
                            ),
                          ),
                        Flexible(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MyText(
                                  title,
                                  maxLines: 2,
                                  lineHeight: 1.3,
                                ),
                                if (siteName != null)
                                  MyText(
                                    siteName,
                                    size: FONTSIZE.two,
                                    subtext: true,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 6.0, left: 4),
                    child: Icon(CupertinoIcons.chevron_right, size: 28),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

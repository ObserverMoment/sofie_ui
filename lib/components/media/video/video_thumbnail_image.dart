import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

/// Widget for creating video thumbnail image
class VideoThumbnailImage extends StatefulWidget {
  /// Constructor for creating [VideoThumbnailImage]
  const VideoThumbnailImage({
    Key? key,
    required this.videoUrl,
    this.showPlayIcon = false,
    this.width,
    this.height = 200,
    this.fit = BoxFit.cover,
    this.errorBuilder,
    this.placeholderBuilder,
  }) : super(key: key);

  /// Video path
  final String videoUrl;

  final bool showPlayIcon;

  /// Width of widget
  final double? width;

  /// Height of widget
  final double height;

  /// Fit of iamge
  final BoxFit fit;

  /// Builds widget on error
  final Widget Function(BuildContext, Object?)? errorBuilder;

  /// Builds placeholder
  final WidgetBuilder? placeholderBuilder;

  @override
  _VideoThumbnailImageState createState() => _VideoThumbnailImageState();
}

class _VideoThumbnailImageState extends State<VideoThumbnailImage> {
  late Future<Uint8List?> _thumbnailFuture;

  @override
  void initState() {
    _thumbnailFuture = VideoThumbnail.thumbnailData(
        video: widget.videoUrl,
        maxHeight: widget.height.toInt(),
        maxWidth:
            widget.width == double.infinity ? 0 : widget.width?.toInt() ?? 0);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant VideoThumbnailImage oldWidget) {
    if (oldWidget.videoUrl != widget.videoUrl) {
      _thumbnailFuture = VideoThumbnail.thumbnailData(
          video: widget.videoUrl,
          maxHeight: widget.height.toInt(),
          maxWidth: widget.width?.toInt() ?? 0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: widget.height,
        child: FutureBuilder<Uint8List?>(
          future: _thumbnailFuture,
          builder: (context, snapshot) => AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: Builder(
              key: ValueKey<AsyncSnapshot<Uint8List?>>(snapshot),
              builder: (_) {
                if (snapshot.hasError) {
                  return widget.errorBuilder?.call(context, snapshot.error) ??
                      const Center(
                        child: Icon(
                          CupertinoIcons.exclamationmark_circle_fill,
                          color: Styles.errorRed,
                        ),
                      );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CupertinoActivityIndicator());
                }
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.memory(
                      snapshot.data!,
                      fit: widget.fit,
                      height: widget.height,
                      width: widget.width,
                    ),
                    if (widget.showPlayIcon)
                      const Icon(
                        CupertinoIcons.play_fill,
                        size: 50,
                        color: Styles.white,
                      )
                  ],
                );
              },
            ),
          ),
        ),
      );
}

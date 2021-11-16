import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/images/full_screen_image_gallery.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/type_extensions.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';

class BodyTrackingEntryCard extends StatelessWidget {
  final BodyTrackingEntry bodyTrackingEntry;
  const BodyTrackingEntryCard({Key? key, required this.bodyTrackingEntry})
      : super(key: key);

  /// Just photos from the entry in which the user clicked.
  void _openEntryPhotosViewer(BuildContext context, List<String> photoUris) {
    context.push(
        child: Stack(
          children: [
            FullScreenImageGallery(
              photoUris,
              withTopNavBar: false,
            ),
            SafeArea(
              child: CupertinoButton(
                child: CircularBox(
                    padding: const EdgeInsets.all(10),
                    color: context.readTheme.background.withOpacity(0.5),
                    child: Icon(
                      CupertinoIcons.clear_thick,
                      color: context.readTheme.primary.withOpacity(0.8),
                    )),
                onPressed: () => context.pop(rootNavigator: true),
              ),
            )
          ],
        ),
        rootNavigator: true);
  }

  @override
  Widget build(BuildContext context) {
    final leanMass = bodyTrackingEntry.bodyweight != null &&
            bodyTrackingEntry.fatPercent != null
        ? bodyTrackingEntry.bodyweight! /
            100 *
            (100 - bodyTrackingEntry.fatPercent!)
        : null;

    final bodyweightString = bodyTrackingEntry.bodyweight != null
        ? bodyTrackingEntry.bodyweight!.toStringAsFixed(1)
        : null;
    final unitString = bodyTrackingEntry.bodyweightUnit?.apiValue ?? 'KG';

    final fatPercentString = bodyTrackingEntry.fatPercent != null
        ? bodyTrackingEntry.fatPercent!.toStringAsFixed(1)
        : null;

    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyText(bodyTrackingEntry.createdAt.compactDateString),
                ),
                if (leanMass != null)
                  MyText(
                    'Lean Mass: $leanMass $unitString',
                  ),
                if (bodyweightString != null || fatPercentString != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (bodyweightString != null)
                          Column(
                            children: [
                              Row(
                                children: [
                                  MyText(
                                    bodyweightString,
                                    size: FONTSIZE.eight,
                                  ),
                                  const SizedBox(width: 4),
                                  MyText(
                                    unitString,
                                    size: FONTSIZE.four,
                                  ),
                                ],
                              ),
                              const MyText('body weight'),
                            ],
                          ),
                        if (fatPercentString != null)
                          Column(
                            children: [
                              Row(
                                children: [
                                  MyText(
                                    fatPercentString,
                                    size: FONTSIZE.eight,
                                  ),
                                  const SizedBox(width: 3),
                                  const MyText(
                                    '%',
                                    size: FONTSIZE.four,
                                  ),
                                ],
                              ),
                              const MyText('body fat')
                            ],
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (bodyTrackingEntry.photoUris.isNotEmpty)
            GestureDetector(
              onTap: () =>
                  _openEntryPhotosViewer(context, bodyTrackingEntry.photoUris),
              child: SizedBox(
                  width: 80,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Card(
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.zero,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedUploadcareImage(
                            bodyTrackingEntry.photoUris[0],
                            displaySize: const Size(80, 120),
                          ),
                        ),
                      ),
                      Positioned(
                          top: -10,
                          right: -2,
                          child: CircularBox(
                            gradient: Styles.secondaryAccentGradient,
                            padding: const EdgeInsets.all(7),
                            child: MyText(
                              bodyTrackingEntry.photoUris.length.toString(),
                              color: Styles.white,
                              lineHeight: 1.3,
                              weight: FontWeight.bold,
                              size: FONTSIZE.two,
                            ),
                          )),
                    ],
                  )),
            ),
        ],
      ),
    );
  }
}

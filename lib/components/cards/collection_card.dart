import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class CollectionCard extends StatelessWidget {
  final Collection collection;
  const CollectionCard({Key? key, required this.collection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Remove any archived content from the display.
    final activeWorkouts =
        collection.workouts.where((w) => !w.archived).toList();
    final activeWorkoutPlans =
        collection.workoutPlans.where((wp) => !wp.archived).toList();

    final planWithImage = collection.workoutPlans
        .firstWhereOrNull((wp) => Utils.textNotNull(wp.coverImageUri));

    final workoutWithImage = planWithImage != null
        ? null
        : collection.workouts
            .firstWhereOrNull((w) => Utils.textNotNull(w.coverImageUri));

    final selectedImageUri = planWithImage != null
        ? planWithImage.coverImageUri
        : workoutWithImage?.coverImageUri;

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 80,
            width: 80,
            child: selectedImageUri != null
                ? SizedUploadcareImage(selectedImageUri)
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SvgPicture.asset(
                      'assets/logos/sofie_logo.svg',
                      color: context.theme.primary,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyHeaderText(
                collection.name,
                maxLines: 2,
                lineHeight: 1.3,
              ),
              if (Utils.textNotNull(
                collection.description,
              ))
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: MyText(
                          collection.description!,
                          maxLines: 2,
                          lineHeight: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 10,
                runSpacing: 6,
                children: [
                  MyText(
                    '${activeWorkouts.length} ${activeWorkouts.length == 1 ? "workout" : "workouts"}',
                    color: Styles.secondaryAccent,
                  ),
                  MyText(
                    '${activeWorkoutPlans.length} ${activeWorkoutPlans.length == 1 ? "plan" : "plans"}',
                    color: Styles.secondaryAccent,
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/pages/authed/home/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/services/utils.dart';

/// Retrieves and displays all the skills of a user in a list.
class ProfileBio extends StatelessWidget {
  final String? bio;
  const ProfileBio({Key? key, required this.bio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Utils.textNotNull(bio)
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: MyText(
              bio!,
              lineHeight: 1.5,
              maxLines: 99,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              YourContentEmptyPlaceholder(
                  message: 'No bio info to display', actions: []),
            ],
          );
  }
}

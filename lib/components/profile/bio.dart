import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';

class ProfileBio extends StatelessWidget {
  final String bio;
  const ProfileBio({Key? key, required this.bio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: MyText(
        bio,
        lineHeight: 1.5,
        maxLines: 99,
      ),
    );
  }
}

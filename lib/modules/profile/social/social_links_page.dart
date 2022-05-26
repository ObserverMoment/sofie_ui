import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/modules/profile/blocs/profile_bloc.dart';
import 'package:sofie_ui/modules/profile/social/social_handles_input.dart';

class SocialLinksPage extends StatelessWidget {
  final UserProfile profile;
  const SocialLinksPage({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const MyNavBar(
        middle: NavBarLargeTitle('Social Links'),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ContentBox(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: SocialHandlesInput(
              profile: profile,
              update: (key, value) => ProfileBloc.updateUserFields(
                  profile.id,
                  {key: value},
                  () => context.showToast(
                      message: 'Sorry, there was a problem',
                      toastType: ToastType.destructive)),
            )),
      ),
    );
  }
}

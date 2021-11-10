import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';

class ClubInviteLinkLimitsInfo extends StatelessWidget {
  const ClubInviteLinkLimitsInfo({Key? key}) : super(key: key);

  Widget get spacer => const SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        children: [
          const InfoPageText(
            'Invite links let you bring new people into your club. Anyone who has access to this link will be able to become a club member.',
          ),
          spacer,
          spacer,
          const MyHeaderText('Limited'),
          spacer,
          const InfoPageText(
            'Set a limit for the number of people that can join using this link. Especially useful if you are posting it on social media or anywhere public but want to control the number of new members.',
          ),
          spacer,
          spacer,
          const MyHeaderText('Unlimited'),
          spacer,
          const InfoPageText(
            'This link will be valid until you de-activate it - there will be no limit on the number of new members who can join via this link.',
          ),
        ],
      ),
    );
  }
}

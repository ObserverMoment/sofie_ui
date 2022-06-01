import 'package:flutter/src/widgets/framework.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class CardioSessionEdit extends StatelessWidget {
  const CardioSessionEdit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPageScaffold(
        navigationBar: MyNavBar(
          withoutLeading: true,
          middle: const LeadingNavBarTitle(
            'Resistance Session',
          ),
          trailing: NavBarTrailingRow(
            children: [
              NavBarCancelButton(
                () => print('check exit without saving'),
                color: Styles.errorRed,
              ),
              NavBarSaveButton(
                context.pop,
              ),
            ],
          ),
        ),
        child: MyText('Resistance'));
  }
}

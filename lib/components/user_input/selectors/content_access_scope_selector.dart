import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/pickers/sliding_select.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/extensions/enum_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

/// Select between PRIVATE and PUBLIC via sliding select and display a brief explainer.
/// Content of the explainer depends on which option is selected.
class ContentAccessScopeSelector extends StatelessWidget {
  final ContentAccessScope contentAccessScope;
  final void Function(ContentAccessScope scope) updateContentAccessScope;
  const ContentAccessScopeSelector(
      {Key? key,
      required this.contentAccessScope,
      required this.updateContentAccessScope})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserInputContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          children: [
            SizedBox(
                width: double.infinity,
                child: SlidingSelect<ContentAccessScope>(
                    value: contentAccessScope,
                    children: <ContentAccessScope, Widget>{
                      for (final v in ContentAccessScope.values
                          .where((v) => v != ContentAccessScope.artemisUnknown))
                        v: MyText(v.display)
                    },
                    updateValue: updateContentAccessScope)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedSwitcher(
                  duration: kStandardAnimationDuration,
                  child: MyText(
                    contentAccessScope == ContentAccessScope.private
                        ? 'This will not be discoverable or visible to the community.'
                        : 'This will be visible to and discoverable by anyone in the community.',
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    lineHeight: 1.2,
                  )),
            )
          ],
        ),
      ),
    );
  }
}

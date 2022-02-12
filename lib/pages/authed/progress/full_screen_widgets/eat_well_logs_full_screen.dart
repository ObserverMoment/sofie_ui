import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/pages/authed/progress/progress_page.dart';

class EatWellLogsFullScreen extends StatelessWidget {
  final String widgetId;
  const EatWellLogsFullScreen({Key? key, required this.widgetId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: context.theme.cardBackground,
        child: NestedScrollView(
            headerSliverBuilder: (c, i) => [
                  MySliverNavbar(
                    title: 'Food Health',
                    leadingIcon: CupertinoIcons.chevron_down,
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: CircularBox(
                          padding: const EdgeInsets.all(10),
                          color: context.theme.background,
                          child: Icon(kWidgetIdToIconMap[widgetId], size: 20)),
                    ),
                    backgroundColor: context.theme.cardBackground,
                  ),
                ],
            body: ListView(children: [MyText('Hello')])));
  }
}

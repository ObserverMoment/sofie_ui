import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class EatWellLogsFullScreen extends StatelessWidget {
  const EatWellLogsFullScreen({Key? key}) : super(key: key);

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
                          padding: const EdgeInsets.all(7),
                          color: context.theme.background,
                          child: const Icon(
                            material.Icons.restaurant,
                          )),
                    ),
                    backgroundColor: context.theme.cardBackground,
                  ),
                ],
            body: ListView(children: [MyText('Hello')])));
  }
}

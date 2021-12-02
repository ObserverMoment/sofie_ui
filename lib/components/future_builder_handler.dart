import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/services/utils.dart';

/// Wrapper around [FutureBuilder] which handles loading and error states in a consistent way across the application.
class FutureBuilderHandler<T> extends StatelessWidget {
  final Widget? loadingWidget;
  final Future<T> future;
  final Widget Function(T data) builder;
  const FutureBuilderHandler(
      {Key? key,
      required this.future,
      required this.builder,
      this.loadingWidget})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          printLog(snapshot.error.toString());
          return const MyPageScaffold(
            navigationBar: MyNavBar(
              middle: NavBarTitle('Oops...'),
            ),
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: MyText(
                'Sorry there was a problem setting up this screen',
                color: Styles.errorRed,
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
            ),
          );
        } else if (!snapshot.hasData) {
          return loadingWidget ??
              const SafeArea(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: LoadingSpinningLines(),
                  ),
                ),
              );
        } else {
          // ignore: null_check_on_nullable_type_parameter
          return builder(snapshot.data!);
        }
      },
    );
  }
}

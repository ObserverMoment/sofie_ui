import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/text.dart';

class BodyTrackingInfo extends StatelessWidget {
  const BodyTrackingInfo({Key? key}) : super(key: key);

  Widget get spacer => const SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: SingleChildScrollView(
        child: Column(
          children: const [
            InfoPageText(
                'Track your body health and aesthetics with our body tracking tools! Log your key stats and monitor physical aspects such as body weight and fat percentage. Plus record your physical transformation over time with a chronological photo series.'),
          ],
        ),
      ),
    );
  }
}

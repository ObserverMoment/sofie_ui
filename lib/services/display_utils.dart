import 'package:flutter/cupertino.dart';

/// Set of utils for calculating display sizes or adjusting the display based on screen size or device type.
class DisplayUtils {
  /// Horizontal lists should fill the screen with as many complete items / cards as possible.
  /// if the list overlaps the edge of the screen enough of a card should be visible so the user knows that scrolling is possible.
  static double horizontalListItemWidth(
      {required BuildContext context,
      required double targetWidth,
      double idealOverhang = 20}) {
    final double screenWidthExOverhang =
        MediaQuery.of(context).size.width - idealOverhang;
    // Get the number of items at the target width that will closest fit on the screen.
    // Rounding up here will decrease returned item width, rounding down will increase it.
    final int fullItemsOnScreenAtTargetWidth =
        (screenWidthExOverhang / targetWidth).round();

    return screenWidthExOverhang / fullItemsOnScreenAtTargetWidth;
  }
}

import 'package:sofie_ui/model/enum.dart';

/// Pass to context.pop() when you when the popped to page to show a toast.
class ToastRequest {
  final ToastType type;
  final String message;
  ToastRequest({this.type = ToastType.standard, required this.message});
}

import 'package:intl/intl.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

String formatDate(DateTime date) {
  final dateFormat = DateFormat.yMd();
  return dateFormat.format(date);
}

String formatDateSameWeek(DateTime date) {
  DateFormat dateFormat;
  if (date.day == DateTime.now().day) {
    dateFormat = DateFormat('hh:mm a');
  } else {
    dateFormat = DateFormat('EEEE');
  }
  return dateFormat.format(date);
}

String formatDateMessage(DateTime date) {
  final dateFormat = DateFormat('EEE. MMM. d ' 'yy' '  hh:mm a');
  return dateFormat.format(date);
}

/// Will also try and get any of the other image urls if there is no thumb.
String? getAttachmentThumbUrl(Attachment attachment) =>
    attachment.thumbUrl ?? attachment.imageUrl ?? attachment.assetUrl;

String? getAttachmentMainImageUrl(Attachment attachment) =>
    attachment.imageUrl ?? attachment.assetUrl ?? attachment.thumbUrl;

bool isImageMessage(Message message) =>
    message.attachments.isNotEmpty == true &&
    message.attachments.first.type == 'image';

bool isSameWeek(DateTime timestamp) =>
    DateTime.now().difference(timestamp).inDays < 7;

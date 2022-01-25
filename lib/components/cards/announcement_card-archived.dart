// import 'package:flutter/cupertino.dart';
// import 'package:sofie_ui/components/cards/card.dart';
// import 'package:sofie_ui/components/layout.dart';
// import 'package:sofie_ui/components/media/images/sized_uploadcare_image.dart';
// import 'package:sofie_ui/components/media/images/user_avatar.dart';
// import 'package:sofie_ui/components/text.dart';
// import 'package:sofie_ui/generated/api/graphql_api.dart';
// import 'package:sofie_ui/services/utils.dart';
// import 'package:sofie_ui/extensions/type_extensions.dart';
// import 'package:sofie_ui/extensions/context_extensions.dart';

// class AnnouncementCard extends StatelessWidget {
//   final ClubAnnouncement announcement;
//   const AnnouncementCard({Key? key, required this.announcement})
//       : super(key: key);

//   Size get _imageSize => const Size(600, 600);
//   double get _imageHeight => 100;

//   Widget _imageContainer({required Widget child}) => ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: SizedBox(
//           height: _imageHeight,
//           child: child,
//         ),
//       );

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   UserAvatar(avatarUri: announcement.user.avatarUri, size: 30),
//                   const SizedBox(width: 10),
//                   MyText(
//                     announcement.user.displayName,
//                     weight: FontWeight.bold,
//                   ),
//                 ],
//               ),
//               ContentBox(
//                   borderRadius: 60,
//                   backgroundColor: context.theme.background,
//                   child: MyText(
//                     announcement.createdAt.dateAndTime,
//                     size: FONTSIZE.one,
//                   ))
//             ],
//           ),
//           const SizedBox(height: 8),
//           if (Utils.textNotNull(announcement.imageUri))
//             _imageContainer(
//               child: SizedUploadcareImage(
//                 announcement.imageUri!,
//                 displaySize: _imageSize,
//               ),
//             ),
//           if (Utils.textNotNull(announcement.videoUri))
//             _imageContainer(
//               child: SizedUploadcareImage(
//                 announcement.videoThumbUri!,
//                 displaySize: _imageSize,
//               ),
//             ),
//           if (Utils.textNotNull(announcement.audioUri))
//             const Icon(
//               CupertinoIcons.headphones,
//               size: 80,
//             ),
//           Padding(
//             padding: const EdgeInsets.only(top: 16.0, bottom: 4),
//             child: MyText(announcement.description, maxLines: 6),
//           ),
//         ],
//       ),
//     );
//   }
// }

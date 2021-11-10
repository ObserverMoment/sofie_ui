import 'package:share_plus/share_plus.dart';
import 'package:sofie_ui/constants.dart';

class SharingAndLinking {
  static Future<void> shareLink(String uri, String? message) async {
    try {
      final String link = '$kDeepLinkSchema$uri';
      await Share.share(link, subject: message ?? 'Check this out!');
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> shareClubInviteLink(
    String token,
  ) async {
    try {
      final String link = '${kDeepLinkSchema}club-invite/$token';
      await Share.share(link, subject: 'You have been invited to join a Club!');
    } catch (e) {
      throw Exception(e);
    }
  }
}

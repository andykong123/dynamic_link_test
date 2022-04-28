import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class FirebaseDynamicLinkService {

  static Future<String> createDynamicLink(String title, bool short) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://moclap.com',
      link: Uri.parse('https://moclap.com/room?channel=41655632'),
      androidParameters: const AndroidParameters(
        packageName: 'com.test.dynamic_link_test',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.test.dynamic_link_test',
        minimumVersion: '0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: title,
        description: '모클랩 - 다같이 즐기는 오디오 플랫폼',
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
      await FirebaseDynamicLinks.instance.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await FirebaseDynamicLinks.instance.buildLink(parameters);
    }

    print('url.path = ${url.path}');
    print('url.query = ${url.query}');

    return url.toString();
  }

  static Future<void> initDynamicLink() async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) {
      final Uri deepLink  = dynamicLink.link;

      bool isInvitation = deepLink.pathSegments.contains('room');
      if(isInvitation) {
        String? channel = deepLink.queryParameters['channel'];

        if(channel != null) {
          print(channel);
        }
      }
    });

    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    if(data != null) {
      final Uri? deepLink = data.link;
      if(deepLink != null) {
        bool isInvitation = deepLink.pathSegments.contains('room');
        if(isInvitation) {
          String? channel = deepLink.queryParameters['channel'];

          if (channel != null) {
            print(channel);
          }
        }
      }
    }
  }
}
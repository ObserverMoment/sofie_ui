import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/post_creator/feed_post_creator_page.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/feed_utils.dart';
import 'package:sofie_ui/components/social/feeds_and_follows/model.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:stream_feed/stream_feed.dart';

/// Full screen modal which congratulates the user on completing a workout and lets them share the log to their feed / share it to some social media platforms.
class CongratulationsLoggedWorkout extends StatefulWidget {
  final VoidCallback onExit;
  final LoggedWorkout loggedWorkout;

  const CongratulationsLoggedWorkout(
      {Key? key, required this.onExit, required this.loggedWorkout})
      : super(key: key);

  @override
  State<CongratulationsLoggedWorkout> createState() =>
      _CongratulationsLoggedWorkoutState();
}

class _CongratulationsLoggedWorkoutState
    extends State<CongratulationsLoggedWorkout> with TickerProviderStateMixin {
  late final AnimationController _controller;

  /// A stream User ref. Make sure format is correct by using [StreamUser.ref].
  /// [context.streamFeedClient.currentUser!.ref].
  /// Format of stream user ref is: [SU:a379ea36-8a96-4bc6-82ae-c1b716c85b86]
  late String _actor;

  bool _sharedToFeed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);

    _actor = context.streamFeedClient.currentUser!.ref;
  }

  Future<void> _shareToFeed() async {
    final activity = CreateStreamFeedActivityInput(
        actor: _actor,
        verb: kDefaultFeedPostVerb,
        object:
            '${kFeedPostTypeToStreamName[FeedPostType.loggedWorkout]}:${widget.loggedWorkout.id}',
        extraData: CreateStreamFeedActivityExtraDataInput(
          title: widget.loggedWorkout.name,
          caption: 'Just crushed this workout!',
          tags: [],
        ));

    await context.push(
        child: FeedPostCreatorPage(
      activityInput: activity,
      title: 'Share to Feed',
      onComplete: () {
        setState(() {
          _sharedToFeed = true;
        });
      },
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
              opacity: 0.3,
              child: Image.asset(
                'assets/placeholder_images/workout.jpg',
                fit: BoxFit.cover,
              )),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24, bottom: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      MyHeaderText(
                        'Workout Logged',
                        lineHeight: 1.3,
                      ),
                      SizedBox(width: 6),
                      Icon(
                        CupertinoIcons.checkmark_alt,
                        size: 24,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const MyText(
                        'WHOOP!',
                        size: FONTSIZE.nine,
                      ),
                      Lottie.asset('assets/lottie/congratulations.json',
                          controller: _controller,
                          repeat: false,
                          width: 160,
                          height: 160, onLoaded: (composition) {
                        Future.delayed(const Duration(seconds: 1), () {
                          // Configure the AnimationController with the duration of the
                          // Lottie file and start the animation.
                          _controller
                            ..duration = composition.duration
                            ..forward();
                        });
                      }),
                      const MyText(
                        'You just won the day!',
                        size: FONTSIZE.seven,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
                  _sharedToFeed
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                              MyHeaderText('Shared to Feed!'),
                              SizedBox(width: 6),
                              Icon(
                                CupertinoIcons.checkmark_alt,
                                size: 24,
                              ),
                            ])
                      : Column(
                          children: [
                            const MyText('Go on...stick it in your feed.'),
                            const SizedBox(
                              height: 8,
                            ),
                            FloatingButton(
                                width: 240,
                                iconSize: 20,
                                icon: CupertinoIcons.news,
                                text: 'SHARE TO FEED',
                                onTap: _shareToFeed),
                          ],
                        ),
                  Column(
                    children: const [
                      MyText(
                        'Remember...',
                        subtext: true,
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      MyText(
                        'HEALTHY BODY  ==  HEALTHY MIND',
                        maxLines: 3,
                        lineHeight: 1.4,
                        textAlign: TextAlign.center,
                        weight: FontWeight.bold,
                      ),
                      MyText(
                        '(and you just did the healthy body bit!)',
                        maxLines: 3,
                        lineHeight: 1.4,
                        textAlign: TextAlign.center,
                        weight: FontWeight.bold,
                        subtext: true,
                      ),
                    ],
                  ),
                  PrimaryButton(
                      text: 'DONE',
                      onPressed: () {
                        context.pop();
                        widget.onExit();
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

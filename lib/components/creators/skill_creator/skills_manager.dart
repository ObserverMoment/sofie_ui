import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/animated_slidable.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/creators/skill_creator/skill_creator.dart';
import 'package:sofie_ui/components/fab_page.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/media/multi_media_viewer.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/pages/authed/home/components/your_content_empty_placeholder.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/uploadcare.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:uploadcare_flutter/uploadcare_flutter.dart';

class SkillsManager extends StatefulWidget {
  const SkillsManager({Key? key}) : super(key: key);

  @override
  State<SkillsManager> createState() => _SkillsManagerState();
}

class _SkillsManagerState extends State<SkillsManager> {
  String? _processingDocForSkillId;

  /// Network only operation because we do not normalize skills into the store.
  /// They live nested in the UserProfile only so we do a manual store update.
  Future<void> _handleDeleteSkill(Skill skill, String authedUserId) async {
    final variables = DeleteSkillByIdArguments(id: skill.id);

    final result = await context.graphQLStore.networkOnlyOperation(
        operation: DeleteSkillByIdMutation(variables: variables));

    checkOperationResult(context, result,
        onFail: () => context.showToast(
            message: 'Sorry, there was a problem.',
            toastType: ToastType.destructive),
        onSuccess: () {
          final prev = context.graphQLStore
              .readDenomalized('$kUserProfileTypename:$authedUserId');
          final profile = UserProfile.fromJson(prev);

          profile.skills.removeWhere((s) => s.id == skill.id);

          context.graphQLStore.writeDataToStore(
              data: profile.toJson(),
              broadcastQueryIds: [GQLVarParamKeys.userProfile(authedUserId)]);
        });
  }

  Future<void> _uploadDocument(Skill skill) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['heic', 'avif', 'jpg', 'jpeg', 'pdf'],
    );

    if (result != null && result.files.single.path != null) {
      final file = SharedFile(File(result.files.single.path!));
      setState(() {
        _processingDocForSkillId = skill.id;
      });
      UploadcareService().uploadFile(
          file: file,
          onComplete: (uri) => saveDocumentUri(skill, uri),
          onFail: (e) {
            printLog(e.toString());
            context.showToast(
                message: 'Sorry, there was a problem',
                toastType: ToastType.destructive);
          });
    }
  }

  Future<void> saveDocumentUri(Skill skill, String uri) async {
    final variables = AddDocumentToSkillArguments(
        data: AddDocumentToSkillInput(id: skill.id, uri: uri));

    final result = await context.graphQLStore.networkOnlyOperation<
        AddDocumentToSkill$Mutation, AddDocumentToSkillArguments>(
      operation: AddDocumentToSkillMutation(variables: variables),
    );

    checkOperationResult(context, result, onFail: () async {
      /// Remove the failed upload from server.
      await UploadcareService().deleteFiles(fileIds: [uri]);

      context.showErrorAlert(
          'Sorry there was a problem, the Skill was not updated.');
    }, onSuccess: () {
      _writeSkillUpdateToStore(result.data!.addDocumentToSkill);
    });

    setState(() {
      _processingDocForSkillId = null;
    });
  }

  void _confirmRemoveDocument(Skill skill) {
    context.showConfirmDeleteDialog(
        itemType: 'Document',
        verb: 'Remove',
        onConfirm: () => _removeDocumentFromSkill(skill));
  }

  Future<void> _removeDocumentFromSkill(Skill skill) async {
    setState(() {
      _processingDocForSkillId = skill.id;
    });

    final variables = RemoveDocumentFromSkillArguments(
        data: RemoveDocumentFromSkillInput(id: skill.id));

    final result = await context.graphQLStore.networkOnlyOperation<
        RemoveDocumentFromSkill$Mutation, RemoveDocumentFromSkillArguments>(
      operation: RemoveDocumentFromSkillMutation(variables: variables),
    );

    checkOperationResult(context, result, onFail: () async {
      context.showErrorAlert(
          'Sorry there was a problem, the Skill was not updated.');
    }, onSuccess: () {
      _writeSkillUpdateToStore(result.data!.removeDocumentFromSkill);
    });

    setState(() {
      _processingDocForSkillId = null;
    });
  }

  void _writeSkillUpdateToStore(Skill updated) {
    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;
    final prev = context.graphQLStore
        .readDenomalized('$kUserProfileTypename:$authedUserId');
    final profile = UserProfile.fromJson(prev);

    profile.skills =
        profile.skills.map((s) => s.id == updated.id ? updated : s).toList();

    context.graphQLStore.writeDataToStore(
        data: profile.toJson(),
        broadcastQueryIds: [GQLVarParamKeys.userProfile(authedUserId)]);
  }

  @override
  Widget build(BuildContext context) {
    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;
    final query =
        UserProfileQuery(variables: UserProfileArguments(userId: authedUserId));

    return QueryObserver<UserProfile$Query, UserProfileArguments>(
      key: Key('SkillsManager-${query.operationName}'),
      query: query,
      parameterizeQuery: true,
      fetchPolicy: QueryFetchPolicy.storeFirst,
      builder: (data) {
        if (data.userProfile == null) {
          return const ObjectNotFoundIndicator();
        }

        final skills = data.userProfile!.skills;

        return MyPageScaffold(
            child: NestedScrollView(
          headerSliverBuilder: (c, i) =>
              [const MySliverNavbar(title: 'Skills Manager')],
          body: skills.isEmpty
              ? YourContentEmptyPlaceholder(
                  message: 'No skills added',
                  explainer:
                      'Add skills, qualifications, experience and areas of special interest to your profile. Help people looking for your skill to find you and check out what do!',
                  actions: [
                      EmptyPlaceholderAction(
                          action: () => context.push(
                              fullscreenDialog: true,
                              child: const SkillCreator()),
                          buttonIcon: CupertinoIcons.add,
                          buttonText: 'Add Skill'),
                    ])
              : FABPage(
                  rowButtons: [
                      FloatingButton(
                        icon: CupertinoIcons.add,
                        iconSize: 18,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        text: 'Add Skill',
                        onTap: () => context.push(
                            fullscreenDialog: true,
                            child: const SkillCreator()),
                      )
                    ],
                  child: ImplicitlyAnimatedList<Skill>(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12),
                    items: skills,
                    areItemsTheSame: (a, b) => a == b,
                    itemBuilder: (context, animation, skill, index) =>
                        MySlidable(
                      removeItem: (_) =>
                          _handleDeleteSkill(skill, authedUserId),
                      index: index,
                      itemType: 'Skill',
                      confirmMessage:
                          'This will also remove any certification documents that you have uploaded.',
                      key: Key(skill.id),
                      secondaryActions: const [],
                      child: SizeFadeTransition(
                        animation: animation,
                        sizeFraction: 0.7,
                        curve: Curves.easeInOut,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: GestureDetector(
                              onTap: () => context.push(
                                      child: SkillCreator(
                                    skill: skill,
                                  )),
                              child: _SkillManagerListItem(
                                skill: skill,
                                removeDocument: _confirmRemoveDocument,
                                uploadDocument: (s) => _uploadDocument(s),
                                isUploading:
                                    _processingDocForSkillId == skill.id,
                              )),
                        ),
                      ),
                    ),
                  )),
        ));
      },
    );
  }
}

class _SkillManagerListItem extends StatelessWidget {
  final Skill skill;
  final void Function(Skill skill) uploadDocument;
  final void Function(Skill skill) removeDocument;

  final bool isUploading;
  const _SkillManagerListItem(
      {Key? key,
      required this.skill,
      required this.uploadDocument,
      required this.removeDocument,
      required this.isUploading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentBox(
      backgroundColor: context.theme.cardBackground.withOpacity(0.5),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/graphics/award_icon.svg',
                        width: 24, color: Styles.primaryAccent),
                    const SizedBox(width: 8),
                    MyText(
                      skill.name,
                      size: FONTSIZE.four,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (Utils.textNotNull(skill.certification))
            MyText(
              'Certification: ${skill.certification!}',
              lineHeight: 1.4,
            ),
          if (Utils.textNotNull(skill.awardingBody))
            MyText(
              'From: ${skill.awardingBody!}',
              lineHeight: 1.4,
            ),
          if (Utils.textNotNull(skill.certificateRef))
            MyText(
              'Reference: ${skill.certificateRef!}',
              lineHeight: 1.4,
            ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isUploading
                  ? const FadeIn(
                      child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: LoadingIndicator(size: 14),
                    ))
                  : Utils.textNotNull(skill.documentUri)
                      ? FadeIn(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TertiaryButton(
                                  onPressed: () => context.push(
                                          child: MultiMediaViewer(
                                        uri: skill.documentUri!,
                                        title: skill.certification,
                                      )),
                                  text: 'View Document'),
                              const SizedBox(width: 8),
                              TertiaryButton(
                                  onPressed: () => removeDocument(skill),
                                  text: 'Remove Document'),
                            ],
                          ),
                        )
                      : FadeIn(
                          child: TertiaryButton(
                              onPressed: () => uploadDocument(skill),
                              text: 'Upload Document'),
                        )
            ],
          )
        ],
      ),
    );
  }
}

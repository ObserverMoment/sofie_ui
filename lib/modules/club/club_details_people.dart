import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sofie_ui/blocs/auth_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/buttons.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/lists.dart';
import 'package:sofie_ui/modules/club/invites/club_details_invites_manager.dart';
import 'package:sofie_ui/modules/club/member_notes/club_details_member_notes.dart';
import 'package:sofie_ui/modules/profile/user_avatar/user_avatar.dart';
import 'package:sofie_ui/components/tags.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/menus/bottom_sheet_menu.dart';
import 'package:sofie_ui/components/user_input/my_cupertino_search_text_field.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/model/country.dart';
import 'package:sofie_ui/model/enum.dart';
import 'package:sofie_ui/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sofie_ui/services/graphql_operation_names.dart';
import 'package:sofie_ui/services/store/query_observer.dart';
import 'package:sofie_ui/services/store/store_utils.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';
import 'package:sofie_ui/services/store/graphql_store.dart';

class ClubDetailsPeople extends StatefulWidget {
  final String clubId;
  final UserClubMemberStatus authedUserMemberType;
  const ClubDetailsPeople(
      {Key? key, required this.clubId, required this.authedUserMemberType})
      : super(key: key);

  @override
  State<ClubDetailsPeople> createState() => _ClubDetailsPeopleState();
}

class _ClubDetailsPeopleState extends State<ClubDetailsPeople> {
  bool _loading = false;

  bool get _userIsOwnerOrAdmin => [
        UserClubMemberStatus.owner,
        UserClubMemberStatus.admin,
      ].contains(widget.authedUserMemberType);

  void _handleMemberTap(
      ClubMemberSummary member, UserClubMemberStatus memberType) {
    final authedUserId = GetIt.I<AuthBloc>().authedUser!.id;

    if (_userIsOwnerOrAdmin) {
      openBottomSheetMenu(
          context: context,
          child: BottomSheetMenu(
              header: BottomSheetMenuHeader(
                  name: member.displayName, imageUri: member.avatarUri),
              items: [
                BottomSheetMenuItem(
                    text: 'View Notes',
                    onPressed: () => context.push(
                        child: ClubDetailsMemberNotes(
                            clubId: widget.clubId, clubMemberSummary: member))),
                BottomSheetMenuItem(
                    text: 'View Profile',
                    onPressed: () => _navigateToProfile(member)),
                // Don't try and message yourself...
                if (authedUserId != member.id)
                  BottomSheetMenuItem(
                      text: 'Send Message',
                      onPressed: () => context.navigateTo(
                            OneToOneChatRoute(
                              otherUserId: member.id,
                            ),
                          )),
                if (widget.authedUserMemberType == UserClubMemberStatus.owner &&
                    memberType == UserClubMemberStatus.member)
                  BottomSheetMenuItem(
                    text: 'Promote to Admin',
                    onPressed: () => _giveMemberAdminStatus(member.id),
                  ),
                if (widget.authedUserMemberType == UserClubMemberStatus.owner &&
                    memberType == UserClubMemberStatus.admin)
                  BottomSheetMenuItem(
                    text: 'Remove Admin Status',
                    onPressed: () => _removeMemberAdminStatus(member.id),
                  ),
                // Cannot remove owners from clubs - clubs needs to be deleted first.
                // Owners can remove anyone else from the club.
                // Admins can remove members, but not other admins.
                if (memberType != UserClubMemberStatus.owner &&
                    (widget.authedUserMemberType ==
                            UserClubMemberStatus.owner ||
                        memberType == UserClubMemberStatus.member))
                  BottomSheetMenuItem(
                    text: 'Remove from Club',
                    isDestructive: true,
                    onPressed: () => _confirmRemoveUserFromClub(
                        context, member.id, memberType),
                  ),
              ]));
    } else {
      _navigateToProfile(member);
    }
  }

  Future<void> _giveMemberAdminStatus(String userId) async {
    setState(() => _loading = true);

    final result = await GraphQLStore.store
        .mutate<GiveMemberAdminStatus$Mutation, GiveMemberAdminStatusArguments>(
            mutation: GiveMemberAdminStatusMutation(
                variables: GiveMemberAdminStatusArguments(
                    userId: userId, clubId: widget.clubId)),
            refetchQueryIds: [GQLVarParamKeys.clubSummary(widget.clubId)],
            broadcastQueryIds: [GQLVarParamKeys.clubMembers(widget.clubId)]);

    setState(() => _loading = false);

    checkOperationResult(result,
        onFail: () => context.showToast(
            message: 'Sorry, there was a problem adding admin status!',
            toastType: ToastType.destructive),
        onSuccess: () => context.showToast(
              message: 'Member given admin status.',
            ));
  }

  Future<void> _removeMemberAdminStatus(String userId) async {
    setState(() => _loading = true);

    final result = await GraphQLStore.store.mutate<
            RemoveMemberAdminStatus$Mutation, RemoveMemberAdminStatusArguments>(
        mutation: RemoveMemberAdminStatusMutation(
            variables: RemoveMemberAdminStatusArguments(
                userId: userId, clubId: widget.clubId)),
        refetchQueryIds: [GQLVarParamKeys.clubSummary(widget.clubId)],
        broadcastQueryIds: [GQLVarParamKeys.clubMembers(widget.clubId)]);

    setState(() => _loading = false);

    checkOperationResult(result,
        onFail: () => context.showToast(
            message: 'Sorry, there was a problem removing admin status!',
            toastType: ToastType.destructive),
        onSuccess: () => context.showToast(
              message: 'Member admin status removed',
            ));
  }

  void _confirmRemoveUserFromClub(
      BuildContext context, String userId, UserClubMemberStatus memberType) {
    context.showConfirmDialog(
        title: 'Remove from Club?',
        verb: 'Remove',
        message:
            'Are you sure you want to remove this person from the club? They will no longer have access to club chat, feeds or content.',
        onConfirm: () => _removeUserFromClub(userId, memberType));
  }

  Future<void> _removeUserFromClub(
      String userId, UserClubMemberStatus memberType) async {
    if (memberType == UserClubMemberStatus.owner) {
      throw Exception(
          'ClubCreatorPage._removeUserFromClub: Cannot remove an Owner from the club.');
    }

    setState(() => _loading = true);

    final result = await GraphQLStore.store
        .mutate<RemoveUserFromClub$Mutation, RemoveUserFromClubArguments>(
            mutation: RemoveUserFromClubMutation(
                variables: RemoveUserFromClubArguments(
                    userToRemoveId: userId, clubId: widget.clubId)),
            refetchQueryIds: [GQLVarParamKeys.clubSummary(widget.clubId)],
            broadcastQueryIds: [GQLVarParamKeys.clubMembers(widget.clubId)]);

    setState(() => _loading = false);

    checkOperationResult(result,
        onFail: () => context.showToast(
            message: 'Sorry, there was a problem removing this person!',
            toastType: ToastType.destructive),
        onSuccess: () => context.showToast(
              message: 'Person removed from Club',
            ));
  }

  void _navigateToProfile(ClubMemberSummary member) {
    context.navigateTo(UserPublicProfileDetailsRoute(userId: member.id));
  }

  @override
  Widget build(BuildContext context) {
    final query = ClubMembersQuery(
        variables: ClubMembersArguments(clubId: widget.clubId));

    return QueryObserver<ClubMembers$Query, ClubMembersArguments>(
        key: Key('ClubDetailsPeople - ${query.operationName}'),
        query: query,
        parameterizeQuery: true,
        builder: (data) {
          final clubMembers = data.clubMembers;

          return MyPageScaffold(
              navigationBar: MyNavBar(
                middle: const NavBarTitle('Members'),
                trailing: _loading
                    ? const NavBarTrailingRow(
                        children: [
                          NavBarLoadingIndicator(),
                        ],
                      )
                    : _userIsOwnerOrAdmin
                        ? TertiaryButton(
                            onPressed: () => context.push(
                                child: ClubDetailsInvitesManager(
                              clubId: widget.clubId,
                            )),
                            prefixIconData: CupertinoIcons.envelope_open,
                            iconSize: 12,
                            text: 'Invites',
                          )
                        : null,
              ),
              child: _ClubMembersList(
                handleMemberTap: _handleMemberTap,
                owner: clubMembers.owner,
                admins: clubMembers.admins,
                members: clubMembers.members,
              ));
        });
  }
}

class _ClubMembersList extends StatefulWidget {
  final ClubMemberSummary owner;
  final List<ClubMemberSummary> admins;
  final List<ClubMemberSummary> members;
  final void Function(ClubMemberSummary member, UserClubMemberStatus type)
      handleMemberTap;
  const _ClubMembersList(
      {Key? key,
      required this.handleMemberTap,
      required this.owner,
      required this.admins,
      required this.members})
      : super(key: key);

  @override
  State<_ClubMembersList> createState() => _ClubMembersListState();
}

class _ClubMembersListState extends State<_ClubMembersList> {
  String _lowercaseSearch = '';

  bool _matchDisplayName(ClubMemberSummary member) =>
      member.displayName.toLowerCase().contains(_lowercaseSearch);

  bool _matchSkills(ClubMemberSummary member) =>
      member.skills.any((s) => s.toLowerCase().contains(_lowercaseSearch));

  bool _matchTownCity(ClubMemberSummary member) =>
      member.townCity != null &&
      member.townCity!.toLowerCase().contains(_lowercaseSearch);

  bool _matchCountry(ClubMemberSummary member) => member.countryCode != null
      ? Country.fromIsoCode(member.countryCode!)
          .name
          .toLowerCase()
          .contains(_lowercaseSearch)
      : false;

  bool _textSearchFilterMember(ClubMemberSummary m) {
    return _matchDisplayName(m) ||
        _matchSkills(m) ||
        _matchTownCity(m) ||
        _matchCountry(m);
  }

  Widget _buildHeading(String text) => Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 4, top: 12),
        child: MyHeaderText(text),
      );

  @override
  Widget build(BuildContext context) {
    final filteredMembers = Utils.textNotNull(_lowercaseSearch)
        ? widget.members.where((m) => _textSearchFilterMember(m))
        : widget.members;

    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeading('Owner'),
                const HorizontalLine(),
                GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => widget.handleMemberTap(
                        widget.owner, UserClubMemberStatus.owner),
                    child: FadeIn(
                        child: _ClubOwnerSummaryCard(member: widget.owner))),
              ],
            ),
          ),
          if (widget.admins.isNotEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeading('Admins'),
                  const HorizontalLine(),
                ],
              ),
            ),
          if (widget.admins.isNotEmpty)
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              delegate: SliverChildBuilderDelegate(
                (c, i) => GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => widget.handleMemberTap(
                        widget.admins[i], UserClubMemberStatus.admin),
                    child: FadeIn(
                        child: _ClubAdminSummaryCard(
                            member: widget.admins[i],
                            avatarSize: screenWidth / 3))),
                childCount: widget.admins.length,
              ),
            ),
          if (widget.members.isNotEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeading('Members'),
                  const HorizontalLine(),
                ],
              ),
            ),
          if (widget.members.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0, top: 4),
                child: MyCupertinoSearchTextField(
                    onChanged: (t) =>
                        setState(() => _lowercaseSearch = t.toLowerCase())),
              ),
            ),
          if (filteredMembers.isNotEmpty)
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              delegate: SliverChildBuilderDelegate(
                (c, i) => GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => widget.handleMemberTap(
                        widget.members[i], UserClubMemberStatus.member),
                    child: FadeIn(
                        child: _ClubMemberSummaryCard(
                            member: widget.members[i],
                            avatarSize: screenWidth / 5))),
                childCount: widget.members.length,
              ),
            )
        ],
      ),
    );
  }
}

class _ClubOwnerSummaryCard extends StatelessWidget {
  final ClubMemberSummary member;
  const _ClubOwnerSummaryCard({Key? key, required this.member})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  UserAvatar(
                    avatarUri: member.avatarUri,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyHeaderText(member.displayName),
                          const SizedBox(height: 2),
                          if (member.countryCode != null)
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: MyText(
                                  Country.fromIsoCode(member.countryCode!)
                                      .name),
                            ),
                          if (Utils.textNotNull(member.townCity))
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: MyText(member.townCity!),
                            ),
                          if (Utils.textNotNull(member.tagline))
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: MyText(
                                member.tagline!,
                                maxLines: 2,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (member.skills.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0, bottom: 4, left: 8, right: 8),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 6,
                    children: member.skills.map((s) => Tag(tag: s)).toList(),
                  ),
                ),
            ],
          ),
          if (member.countryCode != null)
            Positioned(
                top: 0, right: 0, child: CountryFlag(member.countryCode!, 30))
        ],
      ),
    );
  }
}

class _ClubAdminSummaryCard extends StatelessWidget {
  final ClubMemberSummary member;
  final double avatarSize;
  const _ClubAdminSummaryCard(
      {Key? key, required this.member, required this.avatarSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentBox(
      backgroundColor: context.theme.cardBackground.withOpacity(0.4),
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserAvatar(avatarUri: member.avatarUri, size: avatarSize),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: MyText(
                  member.displayName,
                  size: FONTSIZE.two,
                ),
              ),
              if (Utils.textNotNull(member.tagline))
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3),
                  child: MyText(
                    member.tagline!,
                    size: FONTSIZE.one,
                  ),
                ),
              if (member.skills.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CommaSeparatedList(
                    member.skills,
                    fontSize: FONTSIZE.two,
                  ),
                )
            ],
          ),
          if (member.countryCode != null)
            Positioned(
                top: 0, right: 0, child: CountryFlag(member.countryCode!, 30))
        ],
      ),
    );
  }
}

class _ClubMemberSummaryCard extends StatelessWidget {
  final ClubMemberSummary member;
  final double avatarSize;
  const _ClubMemberSummaryCard(
      {Key? key, required this.member, required this.avatarSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentBox(
      backgroundColor: context.theme.cardBackground.withOpacity(0.4),
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserAvatar(avatarUri: member.avatarUri, size: avatarSize),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: MyText(
                  member.displayName,
                  size: FONTSIZE.one,
                ),
              ),
              if (member.skills.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CommaSeparatedList(
                    member.skills,
                    fontSize: FONTSIZE.one,
                  ),
                )
            ],
          ),
          if (member.countryCode != null)
            Positioned(
                top: 0, right: 0, child: CountryFlag(member.countryCode!, 26))
        ],
      ),
    );
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.12

part of 'graphql_api.graphql.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSummary _$UserSummaryFromJson(Map<String, dynamic> json) => UserSummary()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..avatarUri = json['avatarUri'] as String?
  ..displayName = json['displayName'] as String
  ..userProfileScope = _$enumDecode(
      _$UserProfileScopeEnumMap, json['userProfileScope'],
      unknownValue: UserProfileScope.artemisUnknown);

Map<String, dynamic> _$UserSummaryToJson(UserSummary instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'avatarUri': instance.avatarUri,
      'displayName': instance.displayName,
      'userProfileScope': _$UserProfileScopeEnumMap[instance.userProfileScope],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$UserProfileScopeEnumMap = {
  UserProfileScope.private: 'PRIVATE',
  UserProfileScope.public: 'PUBLIC',
  UserProfileScope.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

ClubSummary _$ClubSummaryFromJson(Map<String, dynamic> json) => ClubSummary()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..name = json['name'] as String
  ..description = json['description'] as String?
  ..coverImageUri = json['coverImageUri'] as String?
  ..location = json['location'] as String?
  ..owner = UserSummary.fromJson(json['Owner'] as Map<String, dynamic>)
  ..admins = (json['Admins'] as List<dynamic>)
      .map((e) => UserSummary.fromJson(e as Map<String, dynamic>))
      .toList()
  ..members = (json['Members'] as List<dynamic>)
      .map((e) => UserSummary.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$ClubSummaryToJson(ClubSummary instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'coverImageUri': instance.coverImageUri,
      'location': instance.location,
      'Owner': instance.owner.toJson(),
      'Admins': instance.admins.map((e) => e.toJson()).toList(),
      'Members': instance.members.map((e) => e.toJson()).toList(),
    };

ClubSummariesById$Query _$ClubSummariesById$QueryFromJson(
        Map<String, dynamic> json) =>
    ClubSummariesById$Query()
      ..clubSummariesById = (json['clubSummariesById'] as List<dynamic>)
          .map((e) => ClubSummary.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ClubSummariesById$QueryToJson(
        ClubSummariesById$Query instance) =>
    <String, dynamic>{
      'clubSummariesById':
          instance.clubSummariesById.map((e) => e.toJson()).toList(),
    };

ClubInviteToken _$ClubInviteTokenFromJson(Map<String, dynamic> json) =>
    ClubInviteToken()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..name = json['name'] as String
      ..active = json['active'] as bool
      ..inviteLimit = json['inviteLimit'] as int
      ..joinedUserIds = (json['joinedUserIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList();

Map<String, dynamic> _$ClubInviteTokenToJson(ClubInviteToken instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'name': instance.name,
      'active': instance.active,
      'inviteLimit': instance.inviteLimit,
      'joinedUserIds': instance.joinedUserIds,
    };

JoinClubInvite _$JoinClubInviteFromJson(Map<String, dynamic> json) =>
    JoinClubInvite()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..respondedAt = fromGraphQLDateTimeNullableToDartDateTimeNullable(
          json['respondedAt'] as int?)
      ..status = _$enumDecode(_$JoinClubRequestStatusEnumMap, json['status'],
          unknownValue: JoinClubRequestStatus.artemisUnknown)
      ..invited = UserSummary.fromJson(json['Invited'] as Map<String, dynamic>);

Map<String, dynamic> _$JoinClubInviteToJson(JoinClubInvite instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'respondedAt': fromDartDateTimeNullableToGraphQLDateTimeNullable(
          instance.respondedAt),
      'status': _$JoinClubRequestStatusEnumMap[instance.status],
      'Invited': instance.invited.toJson(),
    };

const _$JoinClubRequestStatusEnumMap = {
  JoinClubRequestStatus.accepted: 'ACCEPTED',
  JoinClubRequestStatus.pending: 'PENDING',
  JoinClubRequestStatus.rejected: 'REJECTED',
  JoinClubRequestStatus.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

JoinClubRequest _$JoinClubRequestFromJson(Map<String, dynamic> json) =>
    JoinClubRequest()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..respondedAt = fromGraphQLDateTimeNullableToDartDateTimeNullable(
          json['respondedAt'] as int?)
      ..status = _$enumDecode(_$JoinClubRequestStatusEnumMap, json['status'],
          unknownValue: JoinClubRequestStatus.artemisUnknown)
      ..applicant =
          UserSummary.fromJson(json['Applicant'] as Map<String, dynamic>);

Map<String, dynamic> _$JoinClubRequestToJson(JoinClubRequest instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'respondedAt': fromDartDateTimeNullableToGraphQLDateTimeNullable(
          instance.respondedAt),
      'status': _$JoinClubRequestStatusEnumMap[instance.status],
      'Applicant': instance.applicant.toJson(),
    };

Workout _$WorkoutFromJson(Map<String, dynamic> json) => Workout()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
  ..archived = json['archived'] as bool
  ..name = json['name'] as String
  ..description = json['description'] as String?
  ..lengthMinutes = json['lengthMinutes'] as int?
  ..difficultyLevel = _$enumDecode(
      _$DifficultyLevelEnumMap, json['difficultyLevel'],
      unknownValue: DifficultyLevel.artemisUnknown)
  ..coverImageUri = json['coverImageUri'] as String?
  ..contentAccessScope = _$enumDecode(
      _$ContentAccessScopeEnumMap, json['contentAccessScope'],
      unknownValue: ContentAccessScope.artemisUnknown)
  ..introVideoUri = json['introVideoUri'] as String?
  ..introVideoThumbUri = json['introVideoThumbUri'] as String?
  ..introAudioUri = json['introAudioUri'] as String?
  ..user = UserSummary.fromJson(json['User'] as Map<String, dynamic>)
  ..workoutGoals = (json['WorkoutGoals'] as List<dynamic>)
      .map((e) => WorkoutGoal.fromJson(e as Map<String, dynamic>))
      .toList()
  ..workoutTags = (json['WorkoutTags'] as List<dynamic>)
      .map((e) => WorkoutTag.fromJson(e as Map<String, dynamic>))
      .toList()
  ..workoutSections = (json['WorkoutSections'] as List<dynamic>)
      .map((e) => WorkoutSection.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$WorkoutToJson(Workout instance) => <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'archived': instance.archived,
      'name': instance.name,
      'description': instance.description,
      'lengthMinutes': instance.lengthMinutes,
      'difficultyLevel': _$DifficultyLevelEnumMap[instance.difficultyLevel],
      'coverImageUri': instance.coverImageUri,
      'contentAccessScope':
          _$ContentAccessScopeEnumMap[instance.contentAccessScope],
      'introVideoUri': instance.introVideoUri,
      'introVideoThumbUri': instance.introVideoThumbUri,
      'introAudioUri': instance.introAudioUri,
      'User': instance.user.toJson(),
      'WorkoutGoals': instance.workoutGoals.map((e) => e.toJson()).toList(),
      'WorkoutTags': instance.workoutTags.map((e) => e.toJson()).toList(),
      'WorkoutSections':
          instance.workoutSections.map((e) => e.toJson()).toList(),
    };

const _$DifficultyLevelEnumMap = {
  DifficultyLevel.advanced: 'ADVANCED',
  DifficultyLevel.challenging: 'CHALLENGING',
  DifficultyLevel.elite: 'ELITE',
  DifficultyLevel.intermediate: 'INTERMEDIATE',
  DifficultyLevel.light: 'LIGHT',
  DifficultyLevel.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

const _$ContentAccessScopeEnumMap = {
  ContentAccessScope.private: 'PRIVATE',
  ContentAccessScope.public: 'PUBLIC',
  ContentAccessScope.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

WorkoutPlan _$WorkoutPlanFromJson(Map<String, dynamic> json) => WorkoutPlan()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
  ..archived = json['archived'] as bool
  ..name = json['name'] as String
  ..description = json['description'] as String?
  ..lengthWeeks = json['lengthWeeks'] as int
  ..daysPerWeek = json['daysPerWeek'] as int
  ..coverImageUri = json['coverImageUri'] as String?
  ..introVideoUri = json['introVideoUri'] as String?
  ..introVideoThumbUri = json['introVideoThumbUri'] as String?
  ..introAudioUri = json['introAudioUri'] as String?
  ..contentAccessScope = _$enumDecode(
      _$ContentAccessScopeEnumMap, json['contentAccessScope'],
      unknownValue: ContentAccessScope.artemisUnknown)
  ..user = UserSummary.fromJson(json['User'] as Map<String, dynamic>)
  ..workoutPlanDays = (json['WorkoutPlanDays'] as List<dynamic>)
      .map((e) => WorkoutPlanDay.fromJson(e as Map<String, dynamic>))
      .toList()
  ..workoutPlanReviews = (json['WorkoutPlanReviews'] as List<dynamic>)
      .map((e) => WorkoutPlanReview.fromJson(e as Map<String, dynamic>))
      .toList()
  ..workoutTags = (json['WorkoutTags'] as List<dynamic>)
      .map((e) => WorkoutTag.fromJson(e as Map<String, dynamic>))
      .toList()
  ..workoutPlanEnrolments = (json['WorkoutPlanEnrolments'] as List<dynamic>)
      .map((e) => WorkoutPlanEnrolment.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$WorkoutPlanToJson(WorkoutPlan instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'archived': instance.archived,
      'name': instance.name,
      'description': instance.description,
      'lengthWeeks': instance.lengthWeeks,
      'daysPerWeek': instance.daysPerWeek,
      'coverImageUri': instance.coverImageUri,
      'introVideoUri': instance.introVideoUri,
      'introVideoThumbUri': instance.introVideoThumbUri,
      'introAudioUri': instance.introAudioUri,
      'contentAccessScope':
          _$ContentAccessScopeEnumMap[instance.contentAccessScope],
      'User': instance.user.toJson(),
      'WorkoutPlanDays':
          instance.workoutPlanDays.map((e) => e.toJson()).toList(),
      'WorkoutPlanReviews':
          instance.workoutPlanReviews.map((e) => e.toJson()).toList(),
      'WorkoutTags': instance.workoutTags.map((e) => e.toJson()).toList(),
      'WorkoutPlanEnrolments':
          instance.workoutPlanEnrolments.map((e) => e.toJson()).toList(),
    };

Club _$ClubFromJson(Map<String, dynamic> json) => Club()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
  ..name = json['name'] as String
  ..description = json['description'] as String?
  ..location = json['location'] as String?
  ..coverImageUri = json['coverImageUri'] as String?
  ..introVideoUri = json['introVideoUri'] as String?
  ..introVideoThumbUri = json['introVideoThumbUri'] as String?
  ..introAudioUri = json['introAudioUri'] as String?
  ..contentAccessScope = _$enumDecode(
      _$ContentAccessScopeEnumMap, json['contentAccessScope'],
      unknownValue: ContentAccessScope.artemisUnknown)
  ..owner = UserSummary.fromJson(json['Owner'] as Map<String, dynamic>)
  ..admins = (json['Admins'] as List<dynamic>)
      .map((e) => UserSummary.fromJson(e as Map<String, dynamic>))
      .toList()
  ..members = (json['Members'] as List<dynamic>)
      .map((e) => UserSummary.fromJson(e as Map<String, dynamic>))
      .toList()
  ..clubInviteTokens = (json['ClubInviteTokens'] as List<dynamic>?)
      ?.map((e) => ClubInviteToken.fromJson(e as Map<String, dynamic>))
      .toList()
  ..joinClubInvites = (json['JoinClubInvites'] as List<dynamic>?)
      ?.map((e) => JoinClubInvite.fromJson(e as Map<String, dynamic>))
      .toList()
  ..joinClubRequests = (json['JoinClubRequests'] as List<dynamic>?)
      ?.map((e) => JoinClubRequest.fromJson(e as Map<String, dynamic>))
      .toList()
  ..workouts = (json['Workouts'] as List<dynamic>?)
      ?.map((e) => Workout.fromJson(e as Map<String, dynamic>))
      .toList()
  ..workoutPlans = (json['WorkoutPlans'] as List<dynamic>?)
      ?.map((e) => WorkoutPlan.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$ClubToJson(Club instance) => <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'name': instance.name,
      'description': instance.description,
      'location': instance.location,
      'coverImageUri': instance.coverImageUri,
      'introVideoUri': instance.introVideoUri,
      'introVideoThumbUri': instance.introVideoThumbUri,
      'introAudioUri': instance.introAudioUri,
      'contentAccessScope':
          _$ContentAccessScopeEnumMap[instance.contentAccessScope],
      'Owner': instance.owner.toJson(),
      'Admins': instance.admins.map((e) => e.toJson()).toList(),
      'Members': instance.members.map((e) => e.toJson()).toList(),
      'ClubInviteTokens':
          instance.clubInviteTokens?.map((e) => e.toJson()).toList(),
      'JoinClubInvites':
          instance.joinClubInvites?.map((e) => e.toJson()).toList(),
      'JoinClubRequests':
          instance.joinClubRequests?.map((e) => e.toJson()).toList(),
      'Workouts': instance.workouts?.map((e) => e.toJson()).toList(),
      'WorkoutPlans': instance.workoutPlans?.map((e) => e.toJson()).toList(),
    };

CreateClub$Mutation _$CreateClub$MutationFromJson(Map<String, dynamic> json) =>
    CreateClub$Mutation()
      ..createClub = Club.fromJson(json['createClub'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateClub$MutationToJson(
        CreateClub$Mutation instance) =>
    <String, dynamic>{
      'createClub': instance.createClub.toJson(),
    };

WorkoutDataMixin$UserSummary _$WorkoutDataMixin$UserSummaryFromJson(
        Map<String, dynamic> json) =>
    WorkoutDataMixin$UserSummary()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..avatarUri = json['avatarUri'] as String?
      ..displayName = json['displayName'] as String
      ..userProfileScope = _$enumDecode(
          _$UserProfileScopeEnumMap, json['userProfileScope'],
          unknownValue: UserProfileScope.artemisUnknown);

Map<String, dynamic> _$WorkoutDataMixin$UserSummaryToJson(
        WorkoutDataMixin$UserSummary instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'avatarUri': instance.avatarUri,
      'displayName': instance.displayName,
      'userProfileScope': _$UserProfileScopeEnumMap[instance.userProfileScope],
    };

WorkoutDataMixin$WorkoutGoal _$WorkoutDataMixin$WorkoutGoalFromJson(
        Map<String, dynamic> json) =>
    WorkoutDataMixin$WorkoutGoal()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..name = json['name'] as String
      ..description = json['description'] as String
      ..hexColor = json['hexColor'] as String;

Map<String, dynamic> _$WorkoutDataMixin$WorkoutGoalToJson(
        WorkoutDataMixin$WorkoutGoal instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'hexColor': instance.hexColor,
    };

WorkoutDataMixin$WorkoutTag _$WorkoutDataMixin$WorkoutTagFromJson(
        Map<String, dynamic> json) =>
    WorkoutDataMixin$WorkoutTag()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..tag = json['tag'] as String;

Map<String, dynamic> _$WorkoutDataMixin$WorkoutTagToJson(
        WorkoutDataMixin$WorkoutTag instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'tag': instance.tag,
    };

WorkoutSectionType _$WorkoutSectionTypeFromJson(Map<String, dynamic> json) =>
    WorkoutSectionType()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..name = json['name'] as String
      ..description = json['description'] as String;

Map<String, dynamic> _$WorkoutSectionTypeToJson(WorkoutSectionType instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };

Equipment _$EquipmentFromJson(Map<String, dynamic> json) => Equipment()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..name = json['name'] as String
  ..loadAdjustable = json['loadAdjustable'] as bool;

Map<String, dynamic> _$EquipmentToJson(Equipment instance) => <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'name': instance.name,
      'loadAdjustable': instance.loadAdjustable,
    };

MoveType _$MoveTypeFromJson(Map<String, dynamic> json) => MoveType()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..name = json['name'] as String
  ..description = json['description'] as String?
  ..imageUri = json['imageUri'] as String?;

Map<String, dynamic> _$MoveTypeToJson(MoveType instance) => <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imageUri': instance.imageUri,
    };

BodyArea _$BodyAreaFromJson(Map<String, dynamic> json) => BodyArea()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..name = json['name'] as String
  ..frontBack = _$enumDecode(_$BodyAreaFrontBackEnumMap, json['frontBack'],
      unknownValue: BodyAreaFrontBack.artemisUnknown)
  ..upperLower = _$enumDecode(_$BodyAreaUpperLowerEnumMap, json['upperLower'],
      unknownValue: BodyAreaUpperLower.artemisUnknown);

Map<String, dynamic> _$BodyAreaToJson(BodyArea instance) => <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'name': instance.name,
      'frontBack': _$BodyAreaFrontBackEnumMap[instance.frontBack],
      'upperLower': _$BodyAreaUpperLowerEnumMap[instance.upperLower],
    };

const _$BodyAreaFrontBackEnumMap = {
  BodyAreaFrontBack.back: 'BACK',
  BodyAreaFrontBack.both: 'BOTH',
  BodyAreaFrontBack.front: 'FRONT',
  BodyAreaFrontBack.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

const _$BodyAreaUpperLowerEnumMap = {
  BodyAreaUpperLower.core: 'CORE',
  BodyAreaUpperLower.lower: 'LOWER',
  BodyAreaUpperLower.upper: 'UPPER',
  BodyAreaUpperLower.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

BodyAreaMoveScore _$BodyAreaMoveScoreFromJson(Map<String, dynamic> json) =>
    BodyAreaMoveScore()
      ..score = json['score'] as int
      ..bodyArea = BodyArea.fromJson(json['BodyArea'] as Map<String, dynamic>);

Map<String, dynamic> _$BodyAreaMoveScoreToJson(BodyAreaMoveScore instance) =>
    <String, dynamic>{
      'score': instance.score,
      'BodyArea': instance.bodyArea.toJson(),
    };

Move _$MoveFromJson(Map<String, dynamic> json) => Move()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..name = json['name'] as String
  ..searchTerms = json['searchTerms'] as String?
  ..description = json['description'] as String?
  ..demoVideoUri = json['demoVideoUri'] as String?
  ..demoVideoThumbUri = json['demoVideoThumbUri'] as String?
  ..scope = _$enumDecode(_$MoveScopeEnumMap, json['scope'],
      unknownValue: MoveScope.artemisUnknown)
  ..validRepTypes = (json['validRepTypes'] as List<dynamic>)
      .map((e) => _$enumDecode(_$WorkoutMoveRepTypeEnumMap, e,
          unknownValue: WorkoutMoveRepType.artemisUnknown))
      .toList()
  ..moveType = MoveType.fromJson(json['MoveType'] as Map<String, dynamic>)
  ..bodyAreaMoveScores = (json['BodyAreaMoveScores'] as List<dynamic>)
      .map((e) => BodyAreaMoveScore.fromJson(e as Map<String, dynamic>))
      .toList()
  ..requiredEquipments = (json['RequiredEquipments'] as List<dynamic>)
      .map((e) => Equipment.fromJson(e as Map<String, dynamic>))
      .toList()
  ..selectableEquipments = (json['SelectableEquipments'] as List<dynamic>)
      .map((e) => Equipment.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$MoveToJson(Move instance) => <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'name': instance.name,
      'searchTerms': instance.searchTerms,
      'description': instance.description,
      'demoVideoUri': instance.demoVideoUri,
      'demoVideoThumbUri': instance.demoVideoThumbUri,
      'scope': _$MoveScopeEnumMap[instance.scope],
      'validRepTypes': instance.validRepTypes
          .map((e) => _$WorkoutMoveRepTypeEnumMap[e])
          .toList(),
      'MoveType': instance.moveType.toJson(),
      'BodyAreaMoveScores':
          instance.bodyAreaMoveScores.map((e) => e.toJson()).toList(),
      'RequiredEquipments':
          instance.requiredEquipments.map((e) => e.toJson()).toList(),
      'SelectableEquipments':
          instance.selectableEquipments.map((e) => e.toJson()).toList(),
    };

const _$MoveScopeEnumMap = {
  MoveScope.custom: 'CUSTOM',
  MoveScope.standard: 'STANDARD',
  MoveScope.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

const _$WorkoutMoveRepTypeEnumMap = {
  WorkoutMoveRepType.calories: 'CALORIES',
  WorkoutMoveRepType.distance: 'DISTANCE',
  WorkoutMoveRepType.reps: 'REPS',
  WorkoutMoveRepType.time: 'TIME',
  WorkoutMoveRepType.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

WorkoutMove _$WorkoutMoveFromJson(Map<String, dynamic> json) => WorkoutMove()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..sortPosition = json['sortPosition'] as int
  ..reps = (json['reps'] as num).toDouble()
  ..repType = _$enumDecode(_$WorkoutMoveRepTypeEnumMap, json['repType'],
      unknownValue: WorkoutMoveRepType.artemisUnknown)
  ..distanceUnit = _$enumDecode(_$DistanceUnitEnumMap, json['distanceUnit'],
      unknownValue: DistanceUnit.artemisUnknown)
  ..loadAmount = (json['loadAmount'] as num).toDouble()
  ..loadUnit = _$enumDecode(_$LoadUnitEnumMap, json['loadUnit'],
      unknownValue: LoadUnit.artemisUnknown)
  ..timeUnit = _$enumDecode(_$TimeUnitEnumMap, json['timeUnit'],
      unknownValue: TimeUnit.artemisUnknown)
  ..equipment = json['Equipment'] == null
      ? null
      : Equipment.fromJson(json['Equipment'] as Map<String, dynamic>)
  ..move = Move.fromJson(json['Move'] as Map<String, dynamic>);

Map<String, dynamic> _$WorkoutMoveToJson(WorkoutMove instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'sortPosition': instance.sortPosition,
      'reps': instance.reps,
      'repType': _$WorkoutMoveRepTypeEnumMap[instance.repType],
      'distanceUnit': _$DistanceUnitEnumMap[instance.distanceUnit],
      'loadAmount': instance.loadAmount,
      'loadUnit': _$LoadUnitEnumMap[instance.loadUnit],
      'timeUnit': _$TimeUnitEnumMap[instance.timeUnit],
      'Equipment': instance.equipment?.toJson(),
      'Move': instance.move.toJson(),
    };

const _$DistanceUnitEnumMap = {
  DistanceUnit.kilometres: 'KILOMETRES',
  DistanceUnit.metres: 'METRES',
  DistanceUnit.miles: 'MILES',
  DistanceUnit.yards: 'YARDS',
  DistanceUnit.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

const _$LoadUnitEnumMap = {
  LoadUnit.bodyweightpercent: 'BODYWEIGHTPERCENT',
  LoadUnit.kg: 'KG',
  LoadUnit.lb: 'LB',
  LoadUnit.percentmax: 'PERCENTMAX',
  LoadUnit.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

const _$TimeUnitEnumMap = {
  TimeUnit.hours: 'HOURS',
  TimeUnit.minutes: 'MINUTES',
  TimeUnit.seconds: 'SECONDS',
  TimeUnit.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

WorkoutSet _$WorkoutSetFromJson(Map<String, dynamic> json) => WorkoutSet()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..sortPosition = json['sortPosition'] as int
  ..rounds = json['rounds'] as int
  ..duration = json['duration'] as int
  ..workoutMoves = (json['WorkoutMoves'] as List<dynamic>)
      .map((e) => WorkoutMove.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$WorkoutSetToJson(WorkoutSet instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'sortPosition': instance.sortPosition,
      'rounds': instance.rounds,
      'duration': instance.duration,
      'WorkoutMoves': instance.workoutMoves.map((e) => e.toJson()).toList(),
    };

WorkoutDataMixin$WorkoutSection _$WorkoutDataMixin$WorkoutSectionFromJson(
        Map<String, dynamic> json) =>
    WorkoutDataMixin$WorkoutSection()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..name = json['name'] as String?
      ..note = json['note'] as String?
      ..rounds = json['rounds'] as int
      ..timecap = json['timecap'] as int
      ..sortPosition = json['sortPosition'] as int
      ..introVideoUri = json['introVideoUri'] as String?
      ..introVideoThumbUri = json['introVideoThumbUri'] as String?
      ..introAudioUri = json['introAudioUri'] as String?
      ..classVideoUri = json['classVideoUri'] as String?
      ..classVideoThumbUri = json['classVideoThumbUri'] as String?
      ..classAudioUri = json['classAudioUri'] as String?
      ..workoutSectionType = WorkoutSectionType.fromJson(
          json['WorkoutSectionType'] as Map<String, dynamic>)
      ..workoutSets = (json['WorkoutSets'] as List<dynamic>)
          .map((e) => WorkoutSet.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$WorkoutDataMixin$WorkoutSectionToJson(
        WorkoutDataMixin$WorkoutSection instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'name': instance.name,
      'note': instance.note,
      'rounds': instance.rounds,
      'timecap': instance.timecap,
      'sortPosition': instance.sortPosition,
      'introVideoUri': instance.introVideoUri,
      'introVideoThumbUri': instance.introVideoThumbUri,
      'introAudioUri': instance.introAudioUri,
      'classVideoUri': instance.classVideoUri,
      'classVideoThumbUri': instance.classVideoThumbUri,
      'classAudioUri': instance.classAudioUri,
      'WorkoutSectionType': instance.workoutSectionType.toJson(),
      'WorkoutSets': instance.workoutSets.map((e) => e.toJson()).toList(),
    };

WorkoutPlanDataMixin$UserSummary _$WorkoutPlanDataMixin$UserSummaryFromJson(
        Map<String, dynamic> json) =>
    WorkoutPlanDataMixin$UserSummary()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..avatarUri = json['avatarUri'] as String?
      ..displayName = json['displayName'] as String
      ..userProfileScope = _$enumDecode(
          _$UserProfileScopeEnumMap, json['userProfileScope'],
          unknownValue: UserProfileScope.artemisUnknown);

Map<String, dynamic> _$WorkoutPlanDataMixin$UserSummaryToJson(
        WorkoutPlanDataMixin$UserSummary instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'avatarUri': instance.avatarUri,
      'displayName': instance.displayName,
      'userProfileScope': _$UserProfileScopeEnumMap[instance.userProfileScope],
    };

WorkoutPlanDayWorkout _$WorkoutPlanDayWorkoutFromJson(
        Map<String, dynamic> json) =>
    WorkoutPlanDayWorkout()
      ..id = json['id'] as String
      ..$$typename = json['__typename'] as String?
      ..note = json['note'] as String?
      ..sortPosition = json['sortPosition'] as int
      ..workout = Workout.fromJson(json['Workout'] as Map<String, dynamic>);

Map<String, dynamic> _$WorkoutPlanDayWorkoutToJson(
        WorkoutPlanDayWorkout instance) =>
    <String, dynamic>{
      'id': instance.id,
      '__typename': instance.$$typename,
      'note': instance.note,
      'sortPosition': instance.sortPosition,
      'Workout': instance.workout.toJson(),
    };

WorkoutPlanDataMixin$WorkoutPlanDay
    _$WorkoutPlanDataMixin$WorkoutPlanDayFromJson(Map<String, dynamic> json) =>
        WorkoutPlanDataMixin$WorkoutPlanDay()
          ..id = json['id'] as String
          ..$$typename = json['__typename'] as String?
          ..note = json['note'] as String?
          ..dayNumber = json['dayNumber'] as int
          ..workoutPlanDayWorkouts =
              (json['WorkoutPlanDayWorkouts'] as List<dynamic>)
                  .map((e) =>
                      WorkoutPlanDayWorkout.fromJson(e as Map<String, dynamic>))
                  .toList();

Map<String, dynamic> _$WorkoutPlanDataMixin$WorkoutPlanDayToJson(
        WorkoutPlanDataMixin$WorkoutPlanDay instance) =>
    <String, dynamic>{
      'id': instance.id,
      '__typename': instance.$$typename,
      'note': instance.note,
      'dayNumber': instance.dayNumber,
      'WorkoutPlanDayWorkouts':
          instance.workoutPlanDayWorkouts.map((e) => e.toJson()).toList(),
    };

WorkoutPlanDataMixin$WorkoutPlanReview
    _$WorkoutPlanDataMixin$WorkoutPlanReviewFromJson(
            Map<String, dynamic> json) =>
        WorkoutPlanDataMixin$WorkoutPlanReview()
          ..id = json['id'] as String
          ..$$typename = json['__typename'] as String?
          ..createdAt =
              fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
          ..score = (json['score'] as num).toDouble()
          ..comment = json['comment'] as String?
          ..user = UserSummary.fromJson(json['User'] as Map<String, dynamic>);

Map<String, dynamic> _$WorkoutPlanDataMixin$WorkoutPlanReviewToJson(
        WorkoutPlanDataMixin$WorkoutPlanReview instance) =>
    <String, dynamic>{
      'id': instance.id,
      '__typename': instance.$$typename,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'score': instance.score,
      'comment': instance.comment,
      'User': instance.user.toJson(),
    };

WorkoutPlanDataMixin$WorkoutTag _$WorkoutPlanDataMixin$WorkoutTagFromJson(
        Map<String, dynamic> json) =>
    WorkoutPlanDataMixin$WorkoutTag()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..tag = json['tag'] as String;

Map<String, dynamic> _$WorkoutPlanDataMixin$WorkoutTagToJson(
        WorkoutPlanDataMixin$WorkoutTag instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'tag': instance.tag,
    };

WorkoutPlanDataMixin$WorkoutPlanEnrolment
    _$WorkoutPlanDataMixin$WorkoutPlanEnrolmentFromJson(
            Map<String, dynamic> json) =>
        WorkoutPlanDataMixin$WorkoutPlanEnrolment()
          ..$$typename = json['__typename'] as String?
          ..id = json['id'] as String
          ..startDate =
              fromGraphQLDateTimeToDartDateTime(json['startDate'] as int)
          ..completedPlanDayWorkoutIds =
              (json['completedPlanDayWorkoutIds'] as List<dynamic>)
                  .map((e) => e as String)
                  .toList()
          ..user = UserSummary.fromJson(json['User'] as Map<String, dynamic>);

Map<String, dynamic> _$WorkoutPlanDataMixin$WorkoutPlanEnrolmentToJson(
        WorkoutPlanDataMixin$WorkoutPlanEnrolment instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'startDate': fromDartDateTimeToGraphQLDateTime(instance.startDate),
      'completedPlanDayWorkoutIds': instance.completedPlanDayWorkoutIds,
      'User': instance.user.toJson(),
    };

CreateClubInput _$CreateClubInputFromJson(Map<String, dynamic> json) =>
    CreateClubInput(
      description: json['description'] as String?,
      location: json['location'] as String?,
      name: json['name'] as String,
    );

Map<String, dynamic> _$CreateClubInputToJson(CreateClubInput instance) =>
    <String, dynamic>{
      'description': instance.description,
      'location': instance.location,
      'name': instance.name,
    };

PublicClubs$Query _$PublicClubs$QueryFromJson(Map<String, dynamic> json) =>
    PublicClubs$Query()
      ..publicClubs = (json['publicClubs'] as List<dynamic>)
          .map((e) => ClubSummary.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$PublicClubs$QueryToJson(PublicClubs$Query instance) =>
    <String, dynamic>{
      'publicClubs': instance.publicClubs.map((e) => e.toJson()).toList(),
    };

DeleteClubById$Mutation _$DeleteClubById$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteClubById$Mutation()
      ..deleteClubById = json['deleteClubById'] as String;

Map<String, dynamic> _$DeleteClubById$MutationToJson(
        DeleteClubById$Mutation instance) =>
    <String, dynamic>{
      'deleteClubById': instance.deleteClubById,
    };

UpdateClub$Mutation _$UpdateClub$MutationFromJson(Map<String, dynamic> json) =>
    UpdateClub$Mutation()
      ..updateClub = Club.fromJson(json['updateClub'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateClub$MutationToJson(
        UpdateClub$Mutation instance) =>
    <String, dynamic>{
      'updateClub': instance.updateClub.toJson(),
    };

UpdateClubInput _$UpdateClubInputFromJson(Map<String, dynamic> json) =>
    UpdateClubInput(
      contentAccessScope: _$enumDecodeNullable(
          _$ContentAccessScopeEnumMap, json['contentAccessScope'],
          unknownValue: ContentAccessScope.artemisUnknown),
      coverImageUri: json['coverImageUri'] as String?,
      description: json['description'] as String?,
      id: json['id'] as String,
      introAudioUri: json['introAudioUri'] as String?,
      introVideoThumbUri: json['introVideoThumbUri'] as String?,
      introVideoUri: json['introVideoUri'] as String?,
      location: json['location'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$UpdateClubInputToJson(UpdateClubInput instance) =>
    <String, dynamic>{
      'contentAccessScope':
          _$ContentAccessScopeEnumMap[instance.contentAccessScope],
      'coverImageUri': instance.coverImageUri,
      'description': instance.description,
      'id': instance.id,
      'introAudioUri': instance.introAudioUri,
      'introVideoThumbUri': instance.introVideoThumbUri,
      'introVideoUri': instance.introVideoUri,
      'location': instance.location,
      'name': instance.name,
    };

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

ClubById$Query _$ClubById$QueryFromJson(Map<String, dynamic> json) =>
    ClubById$Query()
      ..clubById = Club.fromJson(json['clubById'] as Map<String, dynamic>);

Map<String, dynamic> _$ClubById$QueryToJson(ClubById$Query instance) =>
    <String, dynamic>{
      'clubById': instance.clubById.toJson(),
    };

UserClubs$Query _$UserClubs$QueryFromJson(Map<String, dynamic> json) =>
    UserClubs$Query()
      ..userClubs = (json['userClubs'] as List<dynamic>)
          .map((e) => ClubSummary.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserClubs$QueryToJson(UserClubs$Query instance) =>
    <String, dynamic>{
      'userClubs': instance.userClubs.map((e) => e.toJson()).toList(),
    };

CreateWorkoutMove$Mutation _$CreateWorkoutMove$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateWorkoutMove$Mutation()
      ..createWorkoutMove = WorkoutMove.fromJson(
          json['createWorkoutMove'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateWorkoutMove$MutationToJson(
        CreateWorkoutMove$Mutation instance) =>
    <String, dynamic>{
      'createWorkoutMove': instance.createWorkoutMove.toJson(),
    };

CreateWorkoutMoveInput _$CreateWorkoutMoveInputFromJson(
        Map<String, dynamic> json) =>
    CreateWorkoutMoveInput(
      equipment: json['Equipment'] == null
          ? null
          : ConnectRelationInput.fromJson(
              json['Equipment'] as Map<String, dynamic>),
      move: ConnectRelationInput.fromJson(json['Move'] as Map<String, dynamic>),
      workoutSet: ConnectRelationInput.fromJson(
          json['WorkoutSet'] as Map<String, dynamic>),
      distanceUnit: _$enumDecodeNullable(
          _$DistanceUnitEnumMap, json['distanceUnit'],
          unknownValue: DistanceUnit.artemisUnknown),
      loadAmount: (json['loadAmount'] as num).toDouble(),
      loadUnit: _$enumDecodeNullable(_$LoadUnitEnumMap, json['loadUnit'],
          unknownValue: LoadUnit.artemisUnknown),
      repType: _$enumDecode(_$WorkoutMoveRepTypeEnumMap, json['repType'],
          unknownValue: WorkoutMoveRepType.artemisUnknown),
      reps: (json['reps'] as num).toDouble(),
      sortPosition: json['sortPosition'] as int,
      timeUnit: _$enumDecodeNullable(_$TimeUnitEnumMap, json['timeUnit'],
          unknownValue: TimeUnit.artemisUnknown),
    );

Map<String, dynamic> _$CreateWorkoutMoveInputToJson(
        CreateWorkoutMoveInput instance) =>
    <String, dynamic>{
      'Equipment': instance.equipment?.toJson(),
      'Move': instance.move.toJson(),
      'WorkoutSet': instance.workoutSet.toJson(),
      'distanceUnit': _$DistanceUnitEnumMap[instance.distanceUnit],
      'loadAmount': instance.loadAmount,
      'loadUnit': _$LoadUnitEnumMap[instance.loadUnit],
      'repType': _$WorkoutMoveRepTypeEnumMap[instance.repType],
      'reps': instance.reps,
      'sortPosition': instance.sortPosition,
      'timeUnit': _$TimeUnitEnumMap[instance.timeUnit],
    };

ConnectRelationInput _$ConnectRelationInputFromJson(
        Map<String, dynamic> json) =>
    ConnectRelationInput(
      id: json['id'] as String,
    );

Map<String, dynamic> _$ConnectRelationInputToJson(
        ConnectRelationInput instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

DuplicateWorkoutMoveById$Mutation _$DuplicateWorkoutMoveById$MutationFromJson(
        Map<String, dynamic> json) =>
    DuplicateWorkoutMoveById$Mutation()
      ..duplicateWorkoutMoveById = WorkoutMove.fromJson(
          json['duplicateWorkoutMoveById'] as Map<String, dynamic>);

Map<String, dynamic> _$DuplicateWorkoutMoveById$MutationToJson(
        DuplicateWorkoutMoveById$Mutation instance) =>
    <String, dynamic>{
      'duplicateWorkoutMoveById': instance.duplicateWorkoutMoveById.toJson(),
    };

DeleteWorkoutMoveById$Mutation _$DeleteWorkoutMoveById$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteWorkoutMoveById$Mutation()
      ..deleteWorkoutMoveById = json['deleteWorkoutMoveById'] as String;

Map<String, dynamic> _$DeleteWorkoutMoveById$MutationToJson(
        DeleteWorkoutMoveById$Mutation instance) =>
    <String, dynamic>{
      'deleteWorkoutMoveById': instance.deleteWorkoutMoveById,
    };

SortPositionUpdated _$SortPositionUpdatedFromJson(Map<String, dynamic> json) =>
    SortPositionUpdated()
      ..id = json['id'] as String
      ..sortPosition = json['sortPosition'] as int;

Map<String, dynamic> _$SortPositionUpdatedToJson(
        SortPositionUpdated instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sortPosition': instance.sortPosition,
    };

ReorderWorkoutMoves$Mutation _$ReorderWorkoutMoves$MutationFromJson(
        Map<String, dynamic> json) =>
    ReorderWorkoutMoves$Mutation()
      ..reorderWorkoutMoves = (json['reorderWorkoutMoves'] as List<dynamic>)
          .map((e) => SortPositionUpdated.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ReorderWorkoutMoves$MutationToJson(
        ReorderWorkoutMoves$Mutation instance) =>
    <String, dynamic>{
      'reorderWorkoutMoves':
          instance.reorderWorkoutMoves.map((e) => e.toJson()).toList(),
    };

UpdateSortPositionInput _$UpdateSortPositionInputFromJson(
        Map<String, dynamic> json) =>
    UpdateSortPositionInput(
      id: json['id'] as String,
      sortPosition: json['sortPosition'] as int,
    );

Map<String, dynamic> _$UpdateSortPositionInputToJson(
        UpdateSortPositionInput instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sortPosition': instance.sortPosition,
    };

UpdateWorkoutMove$Mutation _$UpdateWorkoutMove$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutMove$Mutation()
      ..updateWorkoutMove = WorkoutMove.fromJson(
          json['updateWorkoutMove'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateWorkoutMove$MutationToJson(
        UpdateWorkoutMove$Mutation instance) =>
    <String, dynamic>{
      'updateWorkoutMove': instance.updateWorkoutMove.toJson(),
    };

UpdateWorkoutMoveInput _$UpdateWorkoutMoveInputFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutMoveInput(
      equipment: json['Equipment'] == null
          ? null
          : ConnectRelationInput.fromJson(
              json['Equipment'] as Map<String, dynamic>),
      move: json['Move'] == null
          ? null
          : ConnectRelationInput.fromJson(json['Move'] as Map<String, dynamic>),
      distanceUnit: _$enumDecodeNullable(
          _$DistanceUnitEnumMap, json['distanceUnit'],
          unknownValue: DistanceUnit.artemisUnknown),
      id: json['id'] as String,
      loadAmount: (json['loadAmount'] as num?)?.toDouble(),
      loadUnit: _$enumDecodeNullable(_$LoadUnitEnumMap, json['loadUnit'],
          unknownValue: LoadUnit.artemisUnknown),
      repType: _$enumDecodeNullable(
          _$WorkoutMoveRepTypeEnumMap, json['repType'],
          unknownValue: WorkoutMoveRepType.artemisUnknown),
      reps: (json['reps'] as num?)?.toDouble(),
      timeUnit: _$enumDecodeNullable(_$TimeUnitEnumMap, json['timeUnit'],
          unknownValue: TimeUnit.artemisUnknown),
    );

Map<String, dynamic> _$UpdateWorkoutMoveInputToJson(
        UpdateWorkoutMoveInput instance) =>
    <String, dynamic>{
      'Equipment': instance.equipment?.toJson(),
      'Move': instance.move?.toJson(),
      'distanceUnit': _$DistanceUnitEnumMap[instance.distanceUnit],
      'id': instance.id,
      'loadAmount': instance.loadAmount,
      'loadUnit': _$LoadUnitEnumMap[instance.loadUnit],
      'repType': _$WorkoutMoveRepTypeEnumMap[instance.repType],
      'reps': instance.reps,
      'timeUnit': _$TimeUnitEnumMap[instance.timeUnit],
    };

DeleteCollectionById$Mutation _$DeleteCollectionById$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteCollectionById$Mutation()
      ..deleteCollectionById = json['deleteCollectionById'] as String;

Map<String, dynamic> _$DeleteCollectionById$MutationToJson(
        DeleteCollectionById$Mutation instance) =>
    <String, dynamic>{
      'deleteCollectionById': instance.deleteCollectionById,
    };

Collection _$CollectionFromJson(Map<String, dynamic> json) => Collection()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
  ..name = json['name'] as String
  ..description = json['description'] as String?
  ..user = UserSummary.fromJson(json['User'] as Map<String, dynamic>)
  ..workouts = (json['Workouts'] as List<dynamic>)
      .map((e) => Workout.fromJson(e as Map<String, dynamic>))
      .toList()
  ..workoutPlans = (json['WorkoutPlans'] as List<dynamic>)
      .map((e) => WorkoutPlan.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$CollectionToJson(Collection instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'name': instance.name,
      'description': instance.description,
      'User': instance.user.toJson(),
      'Workouts': instance.workouts.map((e) => e.toJson()).toList(),
      'WorkoutPlans': instance.workoutPlans.map((e) => e.toJson()).toList(),
    };

AddWorkoutPlanToCollection$Mutation
    _$AddWorkoutPlanToCollection$MutationFromJson(Map<String, dynamic> json) =>
        AddWorkoutPlanToCollection$Mutation()
          ..addWorkoutPlanToCollection = Collection.fromJson(
              json['addWorkoutPlanToCollection'] as Map<String, dynamic>);

Map<String, dynamic> _$AddWorkoutPlanToCollection$MutationToJson(
        AddWorkoutPlanToCollection$Mutation instance) =>
    <String, dynamic>{
      'addWorkoutPlanToCollection':
          instance.addWorkoutPlanToCollection.toJson(),
    };

AddWorkoutPlanToCollectionInput _$AddWorkoutPlanToCollectionInputFromJson(
        Map<String, dynamic> json) =>
    AddWorkoutPlanToCollectionInput(
      workoutPlan: ConnectRelationInput.fromJson(
          json['WorkoutPlan'] as Map<String, dynamic>),
      collectionId: json['collectionId'] as String,
    );

Map<String, dynamic> _$AddWorkoutPlanToCollectionInputToJson(
        AddWorkoutPlanToCollectionInput instance) =>
    <String, dynamic>{
      'WorkoutPlan': instance.workoutPlan.toJson(),
      'collectionId': instance.collectionId,
    };

CreateCollection$Mutation _$CreateCollection$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateCollection$Mutation()
      ..createCollection =
          Collection.fromJson(json['createCollection'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateCollection$MutationToJson(
        CreateCollection$Mutation instance) =>
    <String, dynamic>{
      'createCollection': instance.createCollection.toJson(),
    };

CreateCollectionInput _$CreateCollectionInputFromJson(
        Map<String, dynamic> json) =>
    CreateCollectionInput(
      description: json['description'] as String?,
      name: json['name'] as String,
    );

Map<String, dynamic> _$CreateCollectionInputToJson(
        CreateCollectionInput instance) =>
    <String, dynamic>{
      'description': instance.description,
      'name': instance.name,
    };

UserCollectionById$Query _$UserCollectionById$QueryFromJson(
        Map<String, dynamic> json) =>
    UserCollectionById$Query()
      ..userCollectionById = Collection.fromJson(
          json['userCollectionById'] as Map<String, dynamic>);

Map<String, dynamic> _$UserCollectionById$QueryToJson(
        UserCollectionById$Query instance) =>
    <String, dynamic>{
      'userCollectionById': instance.userCollectionById.toJson(),
    };

AddWorkoutToCollection$Mutation _$AddWorkoutToCollection$MutationFromJson(
        Map<String, dynamic> json) =>
    AddWorkoutToCollection$Mutation()
      ..addWorkoutToCollection = Collection.fromJson(
          json['addWorkoutToCollection'] as Map<String, dynamic>);

Map<String, dynamic> _$AddWorkoutToCollection$MutationToJson(
        AddWorkoutToCollection$Mutation instance) =>
    <String, dynamic>{
      'addWorkoutToCollection': instance.addWorkoutToCollection.toJson(),
    };

AddWorkoutToCollectionInput _$AddWorkoutToCollectionInputFromJson(
        Map<String, dynamic> json) =>
    AddWorkoutToCollectionInput(
      workout: ConnectRelationInput.fromJson(
          json['Workout'] as Map<String, dynamic>),
      collectionId: json['collectionId'] as String,
    );

Map<String, dynamic> _$AddWorkoutToCollectionInputToJson(
        AddWorkoutToCollectionInput instance) =>
    <String, dynamic>{
      'Workout': instance.workout.toJson(),
      'collectionId': instance.collectionId,
    };

UserCollections$Query _$UserCollections$QueryFromJson(
        Map<String, dynamic> json) =>
    UserCollections$Query()
      ..userCollections = (json['userCollections'] as List<dynamic>)
          .map((e) => Collection.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserCollections$QueryToJson(
        UserCollections$Query instance) =>
    <String, dynamic>{
      'userCollections':
          instance.userCollections.map((e) => e.toJson()).toList(),
    };

UpdateCollection$Mutation _$UpdateCollection$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateCollection$Mutation()
      ..updateCollection =
          Collection.fromJson(json['updateCollection'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateCollection$MutationToJson(
        UpdateCollection$Mutation instance) =>
    <String, dynamic>{
      'updateCollection': instance.updateCollection.toJson(),
    };

UpdateCollectionInput _$UpdateCollectionInputFromJson(
        Map<String, dynamic> json) =>
    UpdateCollectionInput(
      description: json['description'] as String?,
      id: json['id'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$UpdateCollectionInputToJson(
        UpdateCollectionInput instance) =>
    <String, dynamic>{
      'description': instance.description,
      'id': instance.id,
      'name': instance.name,
    };

RemoveWorkoutPlanFromCollection$Mutation
    _$RemoveWorkoutPlanFromCollection$MutationFromJson(
            Map<String, dynamic> json) =>
        RemoveWorkoutPlanFromCollection$Mutation()
          ..removeWorkoutPlanFromCollection = Collection.fromJson(
              json['removeWorkoutPlanFromCollection'] as Map<String, dynamic>);

Map<String, dynamic> _$RemoveWorkoutPlanFromCollection$MutationToJson(
        RemoveWorkoutPlanFromCollection$Mutation instance) =>
    <String, dynamic>{
      'removeWorkoutPlanFromCollection':
          instance.removeWorkoutPlanFromCollection.toJson(),
    };

RemoveWorkoutPlanFromCollectionInput
    _$RemoveWorkoutPlanFromCollectionInputFromJson(Map<String, dynamic> json) =>
        RemoveWorkoutPlanFromCollectionInput(
          workoutPlan: ConnectRelationInput.fromJson(
              json['WorkoutPlan'] as Map<String, dynamic>),
          collectionId: json['collectionId'] as String,
        );

Map<String, dynamic> _$RemoveWorkoutPlanFromCollectionInputToJson(
        RemoveWorkoutPlanFromCollectionInput instance) =>
    <String, dynamic>{
      'WorkoutPlan': instance.workoutPlan.toJson(),
      'collectionId': instance.collectionId,
    };

RemoveWorkoutFromCollection$Mutation
    _$RemoveWorkoutFromCollection$MutationFromJson(Map<String, dynamic> json) =>
        RemoveWorkoutFromCollection$Mutation()
          ..removeWorkoutFromCollection = Collection.fromJson(
              json['removeWorkoutFromCollection'] as Map<String, dynamic>);

Map<String, dynamic> _$RemoveWorkoutFromCollection$MutationToJson(
        RemoveWorkoutFromCollection$Mutation instance) =>
    <String, dynamic>{
      'removeWorkoutFromCollection':
          instance.removeWorkoutFromCollection.toJson(),
    };

RemoveWorkoutFromCollectionInput _$RemoveWorkoutFromCollectionInputFromJson(
        Map<String, dynamic> json) =>
    RemoveWorkoutFromCollectionInput(
      workout: ConnectRelationInput.fromJson(
          json['Workout'] as Map<String, dynamic>),
      collectionId: json['collectionId'] as String,
    );

Map<String, dynamic> _$RemoveWorkoutFromCollectionInputToJson(
        RemoveWorkoutFromCollectionInput instance) =>
    <String, dynamic>{
      'Workout': instance.workout.toJson(),
      'collectionId': instance.collectionId,
    };

ReorderWorkoutPlanDayWorkouts$Mutation
    _$ReorderWorkoutPlanDayWorkouts$MutationFromJson(
            Map<String, dynamic> json) =>
        ReorderWorkoutPlanDayWorkouts$Mutation()
          ..reorderWorkoutPlanDayWorkouts =
              (json['reorderWorkoutPlanDayWorkouts'] as List<dynamic>)
                  .map((e) =>
                      SortPositionUpdated.fromJson(e as Map<String, dynamic>))
                  .toList();

Map<String, dynamic> _$ReorderWorkoutPlanDayWorkouts$MutationToJson(
        ReorderWorkoutPlanDayWorkouts$Mutation instance) =>
    <String, dynamic>{
      'reorderWorkoutPlanDayWorkouts': instance.reorderWorkoutPlanDayWorkouts
          .map((e) => e.toJson())
          .toList(),
    };

CreateWorkoutPlanDayWorkout$Mutation
    _$CreateWorkoutPlanDayWorkout$MutationFromJson(Map<String, dynamic> json) =>
        CreateWorkoutPlanDayWorkout$Mutation()
          ..createWorkoutPlanDayWorkout = WorkoutPlanDayWorkout.fromJson(
              json['createWorkoutPlanDayWorkout'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateWorkoutPlanDayWorkout$MutationToJson(
        CreateWorkoutPlanDayWorkout$Mutation instance) =>
    <String, dynamic>{
      'createWorkoutPlanDayWorkout':
          instance.createWorkoutPlanDayWorkout.toJson(),
    };

CreateWorkoutPlanDayWorkoutInput _$CreateWorkoutPlanDayWorkoutInputFromJson(
        Map<String, dynamic> json) =>
    CreateWorkoutPlanDayWorkoutInput(
      workout: ConnectRelationInput.fromJson(
          json['Workout'] as Map<String, dynamic>),
      workoutPlanDay: ConnectRelationInput.fromJson(
          json['WorkoutPlanDay'] as Map<String, dynamic>),
      note: json['note'] as String?,
      sortPosition: json['sortPosition'] as int,
    );

Map<String, dynamic> _$CreateWorkoutPlanDayWorkoutInputToJson(
        CreateWorkoutPlanDayWorkoutInput instance) =>
    <String, dynamic>{
      'Workout': instance.workout.toJson(),
      'WorkoutPlanDay': instance.workoutPlanDay.toJson(),
      'note': instance.note,
      'sortPosition': instance.sortPosition,
    };

UpdateWorkoutPlanDayWorkout$Mutation
    _$UpdateWorkoutPlanDayWorkout$MutationFromJson(Map<String, dynamic> json) =>
        UpdateWorkoutPlanDayWorkout$Mutation()
          ..updateWorkoutPlanDayWorkout = WorkoutPlanDayWorkout.fromJson(
              json['updateWorkoutPlanDayWorkout'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateWorkoutPlanDayWorkout$MutationToJson(
        UpdateWorkoutPlanDayWorkout$Mutation instance) =>
    <String, dynamic>{
      'updateWorkoutPlanDayWorkout':
          instance.updateWorkoutPlanDayWorkout.toJson(),
    };

UpdateWorkoutPlanDayWorkoutInput _$UpdateWorkoutPlanDayWorkoutInputFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutPlanDayWorkoutInput(
      workout: json['Workout'] == null
          ? null
          : ConnectRelationInput.fromJson(
              json['Workout'] as Map<String, dynamic>),
      workoutPlanDay: json['WorkoutPlanDay'] == null
          ? null
          : ConnectRelationInput.fromJson(
              json['WorkoutPlanDay'] as Map<String, dynamic>),
      id: json['id'] as String,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$UpdateWorkoutPlanDayWorkoutInputToJson(
        UpdateWorkoutPlanDayWorkoutInput instance) =>
    <String, dynamic>{
      'Workout': instance.workout?.toJson(),
      'WorkoutPlanDay': instance.workoutPlanDay?.toJson(),
      'id': instance.id,
      'note': instance.note,
    };

DeleteWorkoutPlanDayWorkoutById$Mutation
    _$DeleteWorkoutPlanDayWorkoutById$MutationFromJson(
            Map<String, dynamic> json) =>
        DeleteWorkoutPlanDayWorkoutById$Mutation()
          ..deleteWorkoutPlanDayWorkoutById =
              json['deleteWorkoutPlanDayWorkoutById'] as String;

Map<String, dynamic> _$DeleteWorkoutPlanDayWorkoutById$MutationToJson(
        DeleteWorkoutPlanDayWorkoutById$Mutation instance) =>
    <String, dynamic>{
      'deleteWorkoutPlanDayWorkoutById':
          instance.deleteWorkoutPlanDayWorkoutById,
    };

WorkoutPlanEnrolment _$WorkoutPlanEnrolmentFromJson(
        Map<String, dynamic> json) =>
    WorkoutPlanEnrolment()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..startDate = fromGraphQLDateTimeToDartDateTime(json['startDate'] as int)
      ..completedPlanDayWorkoutIds =
          (json['completedPlanDayWorkoutIds'] as List<dynamic>)
              .map((e) => e as String)
              .toList()
      ..user = UserSummary.fromJson(json['User'] as Map<String, dynamic>);

Map<String, dynamic> _$WorkoutPlanEnrolmentToJson(
        WorkoutPlanEnrolment instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'startDate': fromDartDateTimeToGraphQLDateTime(instance.startDate),
      'completedPlanDayWorkoutIds': instance.completedPlanDayWorkoutIds,
      'User': instance.user.toJson(),
    };

UpdateWorkoutPlanEnrolment$Mutation
    _$UpdateWorkoutPlanEnrolment$MutationFromJson(Map<String, dynamic> json) =>
        UpdateWorkoutPlanEnrolment$Mutation()
          ..updateWorkoutPlanEnrolment = WorkoutPlanEnrolment.fromJson(
              json['updateWorkoutPlanEnrolment'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateWorkoutPlanEnrolment$MutationToJson(
        UpdateWorkoutPlanEnrolment$Mutation instance) =>
    <String, dynamic>{
      'updateWorkoutPlanEnrolment':
          instance.updateWorkoutPlanEnrolment.toJson(),
    };

UpdateWorkoutPlanEnrolmentInput _$UpdateWorkoutPlanEnrolmentInputFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutPlanEnrolmentInput(
      completedPlanDayWorkoutIds:
          (json['completedPlanDayWorkoutIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      id: json['id'] as String,
      startDate: fromGraphQLDateTimeNullableToDartDateTimeNullable(
          json['startDate'] as int?),
    );

Map<String, dynamic> _$UpdateWorkoutPlanEnrolmentInputToJson(
        UpdateWorkoutPlanEnrolmentInput instance) =>
    <String, dynamic>{
      'completedPlanDayWorkoutIds': instance.completedPlanDayWorkoutIds,
      'id': instance.id,
      'startDate':
          fromDartDateTimeNullableToGraphQLDateTimeNullable(instance.startDate),
    };

DeleteWorkoutPlanEnrolmentById$Mutation
    _$DeleteWorkoutPlanEnrolmentById$MutationFromJson(
            Map<String, dynamic> json) =>
        DeleteWorkoutPlanEnrolmentById$Mutation()
          ..deleteWorkoutPlanEnrolmentById =
              json['deleteWorkoutPlanEnrolmentById'] as String;

Map<String, dynamic> _$DeleteWorkoutPlanEnrolmentById$MutationToJson(
        DeleteWorkoutPlanEnrolmentById$Mutation instance) =>
    <String, dynamic>{
      'deleteWorkoutPlanEnrolmentById': instance.deleteWorkoutPlanEnrolmentById,
    };

EnrolledWorkoutPlans$Query _$EnrolledWorkoutPlans$QueryFromJson(
        Map<String, dynamic> json) =>
    EnrolledWorkoutPlans$Query()
      ..enrolledWorkoutPlans = (json['enrolledWorkoutPlans'] as List<dynamic>)
          .map((e) => WorkoutPlan.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$EnrolledWorkoutPlans$QueryToJson(
        EnrolledWorkoutPlans$Query instance) =>
    <String, dynamic>{
      'enrolledWorkoutPlans':
          instance.enrolledWorkoutPlans.map((e) => e.toJson()).toList(),
    };

CreateWorkoutPlanEnrolment$Mutation
    _$CreateWorkoutPlanEnrolment$MutationFromJson(Map<String, dynamic> json) =>
        CreateWorkoutPlanEnrolment$Mutation()
          ..createWorkoutPlanEnrolment = WorkoutPlanEnrolment.fromJson(
              json['createWorkoutPlanEnrolment'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateWorkoutPlanEnrolment$MutationToJson(
        CreateWorkoutPlanEnrolment$Mutation instance) =>
    <String, dynamic>{
      'createWorkoutPlanEnrolment':
          instance.createWorkoutPlanEnrolment.toJson(),
    };

WorkoutPlanByEnrolmentId$Query _$WorkoutPlanByEnrolmentId$QueryFromJson(
        Map<String, dynamic> json) =>
    WorkoutPlanByEnrolmentId$Query()
      ..workoutPlanByEnrolmentId = WorkoutPlan.fromJson(
          json['workoutPlanByEnrolmentId'] as Map<String, dynamic>);

Map<String, dynamic> _$WorkoutPlanByEnrolmentId$QueryToJson(
        WorkoutPlanByEnrolmentId$Query instance) =>
    <String, dynamic>{
      'workoutPlanByEnrolmentId': instance.workoutPlanByEnrolmentId.toJson(),
    };

ProgressJournalGoalTag _$ProgressJournalGoalTagFromJson(
        Map<String, dynamic> json) =>
    ProgressJournalGoalTag()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..tag = json['tag'] as String
      ..hexColor = json['hexColor'] as String;

Map<String, dynamic> _$ProgressJournalGoalTagToJson(
        ProgressJournalGoalTag instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'tag': instance.tag,
      'hexColor': instance.hexColor,
    };

UpdateProgressJournalGoalTag$Mutation
    _$UpdateProgressJournalGoalTag$MutationFromJson(
            Map<String, dynamic> json) =>
        UpdateProgressJournalGoalTag$Mutation()
          ..updateProgressJournalGoalTag = ProgressJournalGoalTag.fromJson(
              json['updateProgressJournalGoalTag'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateProgressJournalGoalTag$MutationToJson(
        UpdateProgressJournalGoalTag$Mutation instance) =>
    <String, dynamic>{
      'updateProgressJournalGoalTag':
          instance.updateProgressJournalGoalTag.toJson(),
    };

UpdateProgressJournalGoalTagInput _$UpdateProgressJournalGoalTagInputFromJson(
        Map<String, dynamic> json) =>
    UpdateProgressJournalGoalTagInput(
      hexColor: json['hexColor'] as String?,
      id: json['id'] as String,
      tag: json['tag'] as String?,
    );

Map<String, dynamic> _$UpdateProgressJournalGoalTagInputToJson(
        UpdateProgressJournalGoalTagInput instance) =>
    <String, dynamic>{
      'hexColor': instance.hexColor,
      'id': instance.id,
      'tag': instance.tag,
    };

ProgressJournalEntry _$ProgressJournalEntryFromJson(
        Map<String, dynamic> json) =>
    ProgressJournalEntry()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..note = json['note'] as String?
      ..voiceNoteUri = json['voiceNoteUri'] as String?
      ..bodyweight = (json['bodyweight'] as num?)?.toDouble()
      ..moodScore = (json['moodScore'] as num?)?.toDouble()
      ..energyScore = (json['energyScore'] as num?)?.toDouble()
      ..confidenceScore = (json['confidenceScore'] as num?)?.toDouble()
      ..motivationScore = (json['motivationScore'] as num?)?.toDouble();

Map<String, dynamic> _$ProgressJournalEntryToJson(
        ProgressJournalEntry instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'note': instance.note,
      'voiceNoteUri': instance.voiceNoteUri,
      'bodyweight': instance.bodyweight,
      'moodScore': instance.moodScore,
      'energyScore': instance.energyScore,
      'confidenceScore': instance.confidenceScore,
      'motivationScore': instance.motivationScore,
    };

ProgressJournalGoal _$ProgressJournalGoalFromJson(Map<String, dynamic> json) =>
    ProgressJournalGoal()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..name = json['name'] as String
      ..description = json['description'] as String?
      ..deadline = fromGraphQLDateTimeNullableToDartDateTimeNullable(
          json['deadline'] as int?)
      ..completedDate = fromGraphQLDateTimeNullableToDartDateTimeNullable(
          json['completedDate'] as int?)
      ..progressJournalGoalTags = (json['ProgressJournalGoalTags']
              as List<dynamic>)
          .map(
              (e) => ProgressJournalGoalTag.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ProgressJournalGoalToJson(
        ProgressJournalGoal instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'name': instance.name,
      'description': instance.description,
      'deadline':
          fromDartDateTimeNullableToGraphQLDateTimeNullable(instance.deadline),
      'completedDate': fromDartDateTimeNullableToGraphQLDateTimeNullable(
          instance.completedDate),
      'ProgressJournalGoalTags':
          instance.progressJournalGoalTags.map((e) => e.toJson()).toList(),
    };

ProgressJournal _$ProgressJournalFromJson(Map<String, dynamic> json) =>
    ProgressJournal()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..name = json['name'] as String
      ..description = json['description'] as String?
      ..coverImageUri = json['coverImageUri'] as String?
      ..bodyweightUnit = _$enumDecode(
          _$BodyweightUnitEnumMap, json['bodyweightUnit'],
          unknownValue: BodyweightUnit.artemisUnknown)
      ..progressJournalEntries = (json['ProgressJournalEntries']
              as List<dynamic>)
          .map((e) => ProgressJournalEntry.fromJson(e as Map<String, dynamic>))
          .toList()
      ..progressJournalGoals = (json['ProgressJournalGoals'] as List<dynamic>)
          .map((e) => ProgressJournalGoal.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ProgressJournalToJson(ProgressJournal instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'name': instance.name,
      'description': instance.description,
      'coverImageUri': instance.coverImageUri,
      'bodyweightUnit': _$BodyweightUnitEnumMap[instance.bodyweightUnit],
      'ProgressJournalEntries':
          instance.progressJournalEntries.map((e) => e.toJson()).toList(),
      'ProgressJournalGoals':
          instance.progressJournalGoals.map((e) => e.toJson()).toList(),
    };

const _$BodyweightUnitEnumMap = {
  BodyweightUnit.kg: 'KG',
  BodyweightUnit.lb: 'LB',
  BodyweightUnit.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

ProgressJournalById$Query _$ProgressJournalById$QueryFromJson(
        Map<String, dynamic> json) =>
    ProgressJournalById$Query()
      ..progressJournalById = ProgressJournal.fromJson(
          json['progressJournalById'] as Map<String, dynamic>);

Map<String, dynamic> _$ProgressJournalById$QueryToJson(
        ProgressJournalById$Query instance) =>
    <String, dynamic>{
      'progressJournalById': instance.progressJournalById.toJson(),
    };

CreateProgressJournalEntry$Mutation
    _$CreateProgressJournalEntry$MutationFromJson(Map<String, dynamic> json) =>
        CreateProgressJournalEntry$Mutation()
          ..createProgressJournalEntry = ProgressJournalEntry.fromJson(
              json['createProgressJournalEntry'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateProgressJournalEntry$MutationToJson(
        CreateProgressJournalEntry$Mutation instance) =>
    <String, dynamic>{
      'createProgressJournalEntry':
          instance.createProgressJournalEntry.toJson(),
    };

CreateProgressJournalEntryInput _$CreateProgressJournalEntryInputFromJson(
        Map<String, dynamic> json) =>
    CreateProgressJournalEntryInput(
      progressJournal: ConnectRelationInput.fromJson(
          json['ProgressJournal'] as Map<String, dynamic>),
      bodyweight: (json['bodyweight'] as num?)?.toDouble(),
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble(),
      energyScore: (json['energyScore'] as num?)?.toDouble(),
      moodScore: (json['moodScore'] as num?)?.toDouble(),
      motivationScore: (json['motivationScore'] as num?)?.toDouble(),
      note: json['note'] as String?,
      voiceNoteUri: json['voiceNoteUri'] as String?,
    );

Map<String, dynamic> _$CreateProgressJournalEntryInputToJson(
        CreateProgressJournalEntryInput instance) =>
    <String, dynamic>{
      'ProgressJournal': instance.progressJournal.toJson(),
      'bodyweight': instance.bodyweight,
      'confidenceScore': instance.confidenceScore,
      'energyScore': instance.energyScore,
      'moodScore': instance.moodScore,
      'motivationScore': instance.motivationScore,
      'note': instance.note,
      'voiceNoteUri': instance.voiceNoteUri,
    };

DeleteProgressJournalById$Mutation _$DeleteProgressJournalById$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteProgressJournalById$Mutation()
      ..deleteProgressJournalById = json['deleteProgressJournalById'] as String;

Map<String, dynamic> _$DeleteProgressJournalById$MutationToJson(
        DeleteProgressJournalById$Mutation instance) =>
    <String, dynamic>{
      'deleteProgressJournalById': instance.deleteProgressJournalById,
    };

CreateProgressJournal$Mutation _$CreateProgressJournal$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateProgressJournal$Mutation()
      ..createProgressJournal = ProgressJournal.fromJson(
          json['createProgressJournal'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateProgressJournal$MutationToJson(
        CreateProgressJournal$Mutation instance) =>
    <String, dynamic>{
      'createProgressJournal': instance.createProgressJournal.toJson(),
    };

CreateProgressJournalInput _$CreateProgressJournalInputFromJson(
        Map<String, dynamic> json) =>
    CreateProgressJournalInput(
      bodyweightUnit: _$enumDecodeNullable(
          _$BodyweightUnitEnumMap, json['bodyweightUnit'],
          unknownValue: BodyweightUnit.artemisUnknown),
      coverImageUri: json['coverImageUri'] as String?,
      description: json['description'] as String?,
      name: json['name'] as String,
    );

Map<String, dynamic> _$CreateProgressJournalInputToJson(
        CreateProgressJournalInput instance) =>
    <String, dynamic>{
      'bodyweightUnit': _$BodyweightUnitEnumMap[instance.bodyweightUnit],
      'coverImageUri': instance.coverImageUri,
      'description': instance.description,
      'name': instance.name,
    };

UpdateProgressJournal$Mutation _$UpdateProgressJournal$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateProgressJournal$Mutation()
      ..updateProgressJournal = ProgressJournal.fromJson(
          json['updateProgressJournal'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateProgressJournal$MutationToJson(
        UpdateProgressJournal$Mutation instance) =>
    <String, dynamic>{
      'updateProgressJournal': instance.updateProgressJournal.toJson(),
    };

UpdateProgressJournalInput _$UpdateProgressJournalInputFromJson(
        Map<String, dynamic> json) =>
    UpdateProgressJournalInput(
      bodyweightUnit: _$enumDecodeNullable(
          _$BodyweightUnitEnumMap, json['bodyweightUnit'],
          unknownValue: BodyweightUnit.artemisUnknown),
      coverImageUri: json['coverImageUri'] as String?,
      description: json['description'] as String?,
      id: json['id'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$UpdateProgressJournalInputToJson(
        UpdateProgressJournalInput instance) =>
    <String, dynamic>{
      'bodyweightUnit': _$BodyweightUnitEnumMap[instance.bodyweightUnit],
      'coverImageUri': instance.coverImageUri,
      'description': instance.description,
      'id': instance.id,
      'name': instance.name,
    };

DeleteProgressJournalEntryById$Mutation
    _$DeleteProgressJournalEntryById$MutationFromJson(
            Map<String, dynamic> json) =>
        DeleteProgressJournalEntryById$Mutation()
          ..deleteProgressJournalEntryById =
              json['deleteProgressJournalEntryById'] as String;

Map<String, dynamic> _$DeleteProgressJournalEntryById$MutationToJson(
        DeleteProgressJournalEntryById$Mutation instance) =>
    <String, dynamic>{
      'deleteProgressJournalEntryById': instance.deleteProgressJournalEntryById,
    };

UpdateProgressJournalEntry$Mutation
    _$UpdateProgressJournalEntry$MutationFromJson(Map<String, dynamic> json) =>
        UpdateProgressJournalEntry$Mutation()
          ..updateProgressJournalEntry = ProgressJournalEntry.fromJson(
              json['updateProgressJournalEntry'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateProgressJournalEntry$MutationToJson(
        UpdateProgressJournalEntry$Mutation instance) =>
    <String, dynamic>{
      'updateProgressJournalEntry':
          instance.updateProgressJournalEntry.toJson(),
    };

UpdateProgressJournalEntryInput _$UpdateProgressJournalEntryInputFromJson(
        Map<String, dynamic> json) =>
    UpdateProgressJournalEntryInput(
      bodyweight: (json['bodyweight'] as num?)?.toDouble(),
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble(),
      energyScore: (json['energyScore'] as num?)?.toDouble(),
      id: json['id'] as String,
      moodScore: (json['moodScore'] as num?)?.toDouble(),
      motivationScore: (json['motivationScore'] as num?)?.toDouble(),
      note: json['note'] as String?,
      voiceNoteUri: json['voiceNoteUri'] as String?,
    );

Map<String, dynamic> _$UpdateProgressJournalEntryInputToJson(
        UpdateProgressJournalEntryInput instance) =>
    <String, dynamic>{
      'bodyweight': instance.bodyweight,
      'confidenceScore': instance.confidenceScore,
      'energyScore': instance.energyScore,
      'id': instance.id,
      'moodScore': instance.moodScore,
      'motivationScore': instance.motivationScore,
      'note': instance.note,
      'voiceNoteUri': instance.voiceNoteUri,
    };

CreateProgressJournalGoal$Mutation _$CreateProgressJournalGoal$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateProgressJournalGoal$Mutation()
      ..createProgressJournalGoal = ProgressJournalGoal.fromJson(
          json['createProgressJournalGoal'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateProgressJournalGoal$MutationToJson(
        CreateProgressJournalGoal$Mutation instance) =>
    <String, dynamic>{
      'createProgressJournalGoal': instance.createProgressJournalGoal.toJson(),
    };

CreateProgressJournalGoalInput _$CreateProgressJournalGoalInputFromJson(
        Map<String, dynamic> json) =>
    CreateProgressJournalGoalInput(
      progressJournal: ConnectRelationInput.fromJson(
          json['ProgressJournal'] as Map<String, dynamic>),
      progressJournalGoalTags: (json['ProgressJournalGoalTags']
              as List<dynamic>?)
          ?.map((e) => ConnectRelationInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      deadline: fromGraphQLDateTimeNullableToDartDateTimeNullable(
          json['deadline'] as int?),
      description: json['description'] as String?,
      name: json['name'] as String,
    );

Map<String, dynamic> _$CreateProgressJournalGoalInputToJson(
        CreateProgressJournalGoalInput instance) =>
    <String, dynamic>{
      'ProgressJournal': instance.progressJournal.toJson(),
      'ProgressJournalGoalTags':
          instance.progressJournalGoalTags?.map((e) => e.toJson()).toList(),
      'deadline':
          fromDartDateTimeNullableToGraphQLDateTimeNullable(instance.deadline),
      'description': instance.description,
      'name': instance.name,
    };

UserProgressJournals$Query _$UserProgressJournals$QueryFromJson(
        Map<String, dynamic> json) =>
    UserProgressJournals$Query()
      ..userProgressJournals = (json['userProgressJournals'] as List<dynamic>)
          .map((e) => ProgressJournal.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserProgressJournals$QueryToJson(
        UserProgressJournals$Query instance) =>
    <String, dynamic>{
      'userProgressJournals':
          instance.userProgressJournals.map((e) => e.toJson()).toList(),
    };

UpdateProgressJournalGoal$Mutation _$UpdateProgressJournalGoal$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateProgressJournalGoal$Mutation()
      ..updateProgressJournalGoal = ProgressJournalGoal.fromJson(
          json['updateProgressJournalGoal'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateProgressJournalGoal$MutationToJson(
        UpdateProgressJournalGoal$Mutation instance) =>
    <String, dynamic>{
      'updateProgressJournalGoal': instance.updateProgressJournalGoal.toJson(),
    };

UpdateProgressJournalGoalInput _$UpdateProgressJournalGoalInputFromJson(
        Map<String, dynamic> json) =>
    UpdateProgressJournalGoalInput(
      progressJournalGoalTags: (json['ProgressJournalGoalTags']
              as List<dynamic>?)
          ?.map((e) => ConnectRelationInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      completedDate: fromGraphQLDateTimeNullableToDartDateTimeNullable(
          json['completedDate'] as int?),
      deadline: fromGraphQLDateTimeNullableToDartDateTimeNullable(
          json['deadline'] as int?),
      description: json['description'] as String?,
      id: json['id'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$UpdateProgressJournalGoalInputToJson(
        UpdateProgressJournalGoalInput instance) =>
    <String, dynamic>{
      'ProgressJournalGoalTags':
          instance.progressJournalGoalTags?.map((e) => e.toJson()).toList(),
      'completedDate': fromDartDateTimeNullableToGraphQLDateTimeNullable(
          instance.completedDate),
      'deadline':
          fromDartDateTimeNullableToGraphQLDateTimeNullable(instance.deadline),
      'description': instance.description,
      'id': instance.id,
      'name': instance.name,
    };

CreateProgressJournalGoalTag$Mutation
    _$CreateProgressJournalGoalTag$MutationFromJson(
            Map<String, dynamic> json) =>
        CreateProgressJournalGoalTag$Mutation()
          ..createProgressJournalGoalTag = ProgressJournalGoalTag.fromJson(
              json['createProgressJournalGoalTag'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateProgressJournalGoalTag$MutationToJson(
        CreateProgressJournalGoalTag$Mutation instance) =>
    <String, dynamic>{
      'createProgressJournalGoalTag':
          instance.createProgressJournalGoalTag.toJson(),
    };

CreateProgressJournalGoalTagInput _$CreateProgressJournalGoalTagInputFromJson(
        Map<String, dynamic> json) =>
    CreateProgressJournalGoalTagInput(
      hexColor: json['hexColor'] as String,
      tag: json['tag'] as String,
    );

Map<String, dynamic> _$CreateProgressJournalGoalTagInputToJson(
        CreateProgressJournalGoalTagInput instance) =>
    <String, dynamic>{
      'hexColor': instance.hexColor,
      'tag': instance.tag,
    };

DeleteProgressJournalGoalById$Mutation
    _$DeleteProgressJournalGoalById$MutationFromJson(
            Map<String, dynamic> json) =>
        DeleteProgressJournalGoalById$Mutation()
          ..deleteProgressJournalGoalById =
              json['deleteProgressJournalGoalById'] as String;

Map<String, dynamic> _$DeleteProgressJournalGoalById$MutationToJson(
        DeleteProgressJournalGoalById$Mutation instance) =>
    <String, dynamic>{
      'deleteProgressJournalGoalById': instance.deleteProgressJournalGoalById,
    };

DeleteProgressJournalGoalTagById$Mutation
    _$DeleteProgressJournalGoalTagById$MutationFromJson(
            Map<String, dynamic> json) =>
        DeleteProgressJournalGoalTagById$Mutation()
          ..deleteProgressJournalGoalTagById =
              json['deleteProgressJournalGoalTagById'] as String;

Map<String, dynamic> _$DeleteProgressJournalGoalTagById$MutationToJson(
        DeleteProgressJournalGoalTagById$Mutation instance) =>
    <String, dynamic>{
      'deleteProgressJournalGoalTagById':
          instance.deleteProgressJournalGoalTagById,
    };

ProgressJournalGoalTags$Query _$ProgressJournalGoalTags$QueryFromJson(
        Map<String, dynamic> json) =>
    ProgressJournalGoalTags$Query()
      ..progressJournalGoalTags = (json['progressJournalGoalTags']
              as List<dynamic>)
          .map(
              (e) => ProgressJournalGoalTag.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ProgressJournalGoalTags$QueryToJson(
        ProgressJournalGoalTags$Query instance) =>
    <String, dynamic>{
      'progressJournalGoalTags':
          instance.progressJournalGoalTags.map((e) => e.toJson()).toList(),
    };

WorkoutPlanDay _$WorkoutPlanDayFromJson(Map<String, dynamic> json) =>
    WorkoutPlanDay()
      ..id = json['id'] as String
      ..$$typename = json['__typename'] as String?
      ..note = json['note'] as String?
      ..dayNumber = json['dayNumber'] as int
      ..workoutPlanDayWorkouts = (json['WorkoutPlanDayWorkouts']
              as List<dynamic>)
          .map((e) => WorkoutPlanDayWorkout.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$WorkoutPlanDayToJson(WorkoutPlanDay instance) =>
    <String, dynamic>{
      'id': instance.id,
      '__typename': instance.$$typename,
      'note': instance.note,
      'dayNumber': instance.dayNumber,
      'WorkoutPlanDayWorkouts':
          instance.workoutPlanDayWorkouts.map((e) => e.toJson()).toList(),
    };

MoveWorkoutPlanDayToAnotherDay$Mutation
    _$MoveWorkoutPlanDayToAnotherDay$MutationFromJson(
            Map<String, dynamic> json) =>
        MoveWorkoutPlanDayToAnotherDay$Mutation()
          ..moveWorkoutPlanDayToAnotherDay = WorkoutPlanDay.fromJson(
              json['moveWorkoutPlanDayToAnotherDay'] as Map<String, dynamic>);

Map<String, dynamic> _$MoveWorkoutPlanDayToAnotherDay$MutationToJson(
        MoveWorkoutPlanDayToAnotherDay$Mutation instance) =>
    <String, dynamic>{
      'moveWorkoutPlanDayToAnotherDay':
          instance.moveWorkoutPlanDayToAnotherDay.toJson(),
    };

MoveWorkoutPlanDayToAnotherDayInput
    _$MoveWorkoutPlanDayToAnotherDayInputFromJson(Map<String, dynamic> json) =>
        MoveWorkoutPlanDayToAnotherDayInput(
          id: json['id'] as String,
          moveToDay: json['moveToDay'] as int,
        );

Map<String, dynamic> _$MoveWorkoutPlanDayToAnotherDayInputToJson(
        MoveWorkoutPlanDayToAnotherDayInput instance) =>
    <String, dynamic>{
      'id': instance.id,
      'moveToDay': instance.moveToDay,
    };

DeleteWorkoutPlanDaysById$Mutation _$DeleteWorkoutPlanDaysById$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteWorkoutPlanDaysById$Mutation()
      ..deleteWorkoutPlanDaysById =
          (json['deleteWorkoutPlanDaysById'] as List<dynamic>)
              .map((e) => e as String)
              .toList();

Map<String, dynamic> _$DeleteWorkoutPlanDaysById$MutationToJson(
        DeleteWorkoutPlanDaysById$Mutation instance) =>
    <String, dynamic>{
      'deleteWorkoutPlanDaysById': instance.deleteWorkoutPlanDaysById,
    };

UpdateWorkoutPlanDay$Mutation _$UpdateWorkoutPlanDay$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutPlanDay$Mutation()
      ..updateWorkoutPlanDay = WorkoutPlanDay.fromJson(
          json['updateWorkoutPlanDay'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateWorkoutPlanDay$MutationToJson(
        UpdateWorkoutPlanDay$Mutation instance) =>
    <String, dynamic>{
      'updateWorkoutPlanDay': instance.updateWorkoutPlanDay.toJson(),
    };

UpdateWorkoutPlanDayInput _$UpdateWorkoutPlanDayInputFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutPlanDayInput(
      dayNumber: json['dayNumber'] as int?,
      id: json['id'] as String,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$UpdateWorkoutPlanDayInputToJson(
        UpdateWorkoutPlanDayInput instance) =>
    <String, dynamic>{
      'dayNumber': instance.dayNumber,
      'id': instance.id,
      'note': instance.note,
    };

CreateWorkoutPlanDayWithWorkout$Mutation
    _$CreateWorkoutPlanDayWithWorkout$MutationFromJson(
            Map<String, dynamic> json) =>
        CreateWorkoutPlanDayWithWorkout$Mutation()
          ..createWorkoutPlanDayWithWorkout = WorkoutPlanDay.fromJson(
              json['createWorkoutPlanDayWithWorkout'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateWorkoutPlanDayWithWorkout$MutationToJson(
        CreateWorkoutPlanDayWithWorkout$Mutation instance) =>
    <String, dynamic>{
      'createWorkoutPlanDayWithWorkout':
          instance.createWorkoutPlanDayWithWorkout.toJson(),
    };

CreateWorkoutPlanDayWithWorkoutInput
    _$CreateWorkoutPlanDayWithWorkoutInputFromJson(Map<String, dynamic> json) =>
        CreateWorkoutPlanDayWithWorkoutInput(
          workout: ConnectRelationInput.fromJson(
              json['Workout'] as Map<String, dynamic>),
          workoutPlan: ConnectRelationInput.fromJson(
              json['WorkoutPlan'] as Map<String, dynamic>),
          dayNumber: json['dayNumber'] as int,
        );

Map<String, dynamic> _$CreateWorkoutPlanDayWithWorkoutInputToJson(
        CreateWorkoutPlanDayWithWorkoutInput instance) =>
    <String, dynamic>{
      'Workout': instance.workout.toJson(),
      'WorkoutPlan': instance.workoutPlan.toJson(),
      'dayNumber': instance.dayNumber,
    };

CopyWorkoutPlanDayToAnotherDay$Mutation
    _$CopyWorkoutPlanDayToAnotherDay$MutationFromJson(
            Map<String, dynamic> json) =>
        CopyWorkoutPlanDayToAnotherDay$Mutation()
          ..copyWorkoutPlanDayToAnotherDay = WorkoutPlanDay.fromJson(
              json['copyWorkoutPlanDayToAnotherDay'] as Map<String, dynamic>);

Map<String, dynamic> _$CopyWorkoutPlanDayToAnotherDay$MutationToJson(
        CopyWorkoutPlanDayToAnotherDay$Mutation instance) =>
    <String, dynamic>{
      'copyWorkoutPlanDayToAnotherDay':
          instance.copyWorkoutPlanDayToAnotherDay.toJson(),
    };

CopyWorkoutPlanDayToAnotherDayInput
    _$CopyWorkoutPlanDayToAnotherDayInputFromJson(Map<String, dynamic> json) =>
        CopyWorkoutPlanDayToAnotherDayInput(
          copyToDay: json['copyToDay'] as int,
          id: json['id'] as String,
        );

Map<String, dynamic> _$CopyWorkoutPlanDayToAnotherDayInputToJson(
        CopyWorkoutPlanDayToAnotherDayInput instance) =>
    <String, dynamic>{
      'copyToDay': instance.copyToDay,
      'id': instance.id,
    };

GymProfile _$GymProfileFromJson(Map<String, dynamic> json) => GymProfile()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..name = json['name'] as String
  ..description = json['description'] as String?
  ..equipments = (json['Equipments'] as List<dynamic>)
      .map((e) => Equipment.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$GymProfileToJson(GymProfile instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'Equipments': instance.equipments.map((e) => e.toJson()).toList(),
    };

WorkoutGoal _$WorkoutGoalFromJson(Map<String, dynamic> json) => WorkoutGoal()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..name = json['name'] as String
  ..description = json['description'] as String
  ..hexColor = json['hexColor'] as String;

Map<String, dynamic> _$WorkoutGoalToJson(WorkoutGoal instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'hexColor': instance.hexColor,
    };

WorkoutSectionRoundSetData _$WorkoutSectionRoundSetDataFromJson(
        Map<String, dynamic> json) =>
    WorkoutSectionRoundSetData()
      ..rounds = json['rounds'] as int
      ..timeTakenSeconds = json['timeTakenSeconds'] as int
      ..moves = json['moves'] as String;

Map<String, dynamic> _$WorkoutSectionRoundSetDataToJson(
        WorkoutSectionRoundSetData instance) =>
    <String, dynamic>{
      'rounds': instance.rounds,
      'timeTakenSeconds': instance.timeTakenSeconds,
      'moves': instance.moves,
    };

WorkoutSectionRoundData _$WorkoutSectionRoundDataFromJson(
        Map<String, dynamic> json) =>
    WorkoutSectionRoundData()
      ..timeTakenSeconds = json['timeTakenSeconds'] as int
      ..sets = (json['sets'] as List<dynamic>)
          .map((e) =>
              WorkoutSectionRoundSetData.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$WorkoutSectionRoundDataToJson(
        WorkoutSectionRoundData instance) =>
    <String, dynamic>{
      'timeTakenSeconds': instance.timeTakenSeconds,
      'sets': instance.sets.map((e) => e.toJson()).toList(),
    };

LoggedWorkoutSectionData _$LoggedWorkoutSectionDataFromJson(
        Map<String, dynamic> json) =>
    LoggedWorkoutSectionData()
      ..rounds = (json['rounds'] as List<dynamic>)
          .map((e) =>
              WorkoutSectionRoundData.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$LoggedWorkoutSectionDataToJson(
        LoggedWorkoutSectionData instance) =>
    <String, dynamic>{
      'rounds': instance.rounds.map((e) => e.toJson()).toList(),
    };

LoggedWorkoutSection _$LoggedWorkoutSectionFromJson(
        Map<String, dynamic> json) =>
    LoggedWorkoutSection()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..name = json['name'] as String?
      ..repScore = json['repScore'] as int?
      ..timeTakenSeconds = json['timeTakenSeconds'] as int
      ..sortPosition = json['sortPosition'] as int
      ..workoutSectionType = WorkoutSectionType.fromJson(
          json['WorkoutSectionType'] as Map<String, dynamic>)
      ..bodyAreas = (json['BodyAreas'] as List<dynamic>)
          .map((e) => BodyArea.fromJson(e as Map<String, dynamic>))
          .toList()
      ..moveTypes = (json['MoveTypes'] as List<dynamic>)
          .map((e) => MoveType.fromJson(e as Map<String, dynamic>))
          .toList()
      ..loggedWorkoutSectionData = json['loggedWorkoutSectionData'] == null
          ? null
          : LoggedWorkoutSectionData.fromJson(
              json['loggedWorkoutSectionData'] as Map<String, dynamic>);

Map<String, dynamic> _$LoggedWorkoutSectionToJson(
        LoggedWorkoutSection instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'name': instance.name,
      'repScore': instance.repScore,
      'timeTakenSeconds': instance.timeTakenSeconds,
      'sortPosition': instance.sortPosition,
      'WorkoutSectionType': instance.workoutSectionType.toJson(),
      'BodyAreas': instance.bodyAreas.map((e) => e.toJson()).toList(),
      'MoveTypes': instance.moveTypes.map((e) => e.toJson()).toList(),
      'loggedWorkoutSectionData': instance.loggedWorkoutSectionData?.toJson(),
    };

LoggedWorkout _$LoggedWorkoutFromJson(Map<String, dynamic> json) =>
    LoggedWorkout()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..completedOn =
          fromGraphQLDateTimeToDartDateTime(json['completedOn'] as int)
      ..note = json['note'] as String?
      ..name = json['name'] as String
      ..gymProfile = json['GymProfile'] == null
          ? null
          : GymProfile.fromJson(json['GymProfile'] as Map<String, dynamic>)
      ..workoutGoals = (json['WorkoutGoals'] as List<dynamic>)
          .map((e) => WorkoutGoal.fromJson(e as Map<String, dynamic>))
          .toList()
      ..loggedWorkoutSections = (json['LoggedWorkoutSections'] as List<dynamic>)
          .map((e) => LoggedWorkoutSection.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$LoggedWorkoutToJson(LoggedWorkout instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'completedOn': fromDartDateTimeToGraphQLDateTime(instance.completedOn),
      'note': instance.note,
      'name': instance.name,
      'GymProfile': instance.gymProfile?.toJson(),
      'WorkoutGoals': instance.workoutGoals.map((e) => e.toJson()).toList(),
      'LoggedWorkoutSections':
          instance.loggedWorkoutSections.map((e) => e.toJson()).toList(),
    };

LoggedWorkoutById$Query _$LoggedWorkoutById$QueryFromJson(
        Map<String, dynamic> json) =>
    LoggedWorkoutById$Query()
      ..loggedWorkoutById = LoggedWorkout.fromJson(
          json['loggedWorkoutById'] as Map<String, dynamic>);

Map<String, dynamic> _$LoggedWorkoutById$QueryToJson(
        LoggedWorkoutById$Query instance) =>
    <String, dynamic>{
      'loggedWorkoutById': instance.loggedWorkoutById.toJson(),
    };

DeleteLoggedWorkoutById$Mutation _$DeleteLoggedWorkoutById$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteLoggedWorkoutById$Mutation()
      ..deleteLoggedWorkoutById = json['deleteLoggedWorkoutById'] as String;

Map<String, dynamic> _$DeleteLoggedWorkoutById$MutationToJson(
        DeleteLoggedWorkoutById$Mutation instance) =>
    <String, dynamic>{
      'deleteLoggedWorkoutById': instance.deleteLoggedWorkoutById,
    };

UserLoggedWorkouts$Query _$UserLoggedWorkouts$QueryFromJson(
        Map<String, dynamic> json) =>
    UserLoggedWorkouts$Query()
      ..userLoggedWorkouts = (json['userLoggedWorkouts'] as List<dynamic>)
          .map((e) => LoggedWorkout.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserLoggedWorkouts$QueryToJson(
        UserLoggedWorkouts$Query instance) =>
    <String, dynamic>{
      'userLoggedWorkouts':
          instance.userLoggedWorkouts.map((e) => e.toJson()).toList(),
    };

UpdateLoggedWorkout _$UpdateLoggedWorkoutFromJson(Map<String, dynamic> json) =>
    UpdateLoggedWorkout()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..completedOn =
          fromGraphQLDateTimeToDartDateTime(json['completedOn'] as int)
      ..note = json['note'] as String?
      ..name = json['name'] as String;

Map<String, dynamic> _$UpdateLoggedWorkoutToJson(
        UpdateLoggedWorkout instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'completedOn': fromDartDateTimeToGraphQLDateTime(instance.completedOn),
      'note': instance.note,
      'name': instance.name,
    };

UpdateLoggedWorkout$Mutation _$UpdateLoggedWorkout$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateLoggedWorkout$Mutation()
      ..updateLoggedWorkout = UpdateLoggedWorkout.fromJson(
          json['updateLoggedWorkout'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateLoggedWorkout$MutationToJson(
        UpdateLoggedWorkout$Mutation instance) =>
    <String, dynamic>{
      'updateLoggedWorkout': instance.updateLoggedWorkout.toJson(),
    };

UpdateLoggedWorkoutInput _$UpdateLoggedWorkoutInputFromJson(
        Map<String, dynamic> json) =>
    UpdateLoggedWorkoutInput(
      gymProfile: json['GymProfile'] == null
          ? null
          : ConnectRelationInput.fromJson(
              json['GymProfile'] as Map<String, dynamic>),
      workoutGoals: (json['WorkoutGoals'] as List<dynamic>)
          .map((e) => ConnectRelationInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      completedOn: fromGraphQLDateTimeNullableToDartDateTimeNullable(
          json['completedOn'] as int?),
      id: json['id'] as String,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$UpdateLoggedWorkoutInputToJson(
        UpdateLoggedWorkoutInput instance) =>
    <String, dynamic>{
      'GymProfile': instance.gymProfile?.toJson(),
      'WorkoutGoals': instance.workoutGoals.map((e) => e.toJson()).toList(),
      'completedOn': fromDartDateTimeNullableToGraphQLDateTimeNullable(
          instance.completedOn),
      'id': instance.id,
      'note': instance.note,
    };

CreateLoggedWorkout$Mutation _$CreateLoggedWorkout$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateLoggedWorkout$Mutation()
      ..createLoggedWorkout = LoggedWorkout.fromJson(
          json['createLoggedWorkout'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateLoggedWorkout$MutationToJson(
        CreateLoggedWorkout$Mutation instance) =>
    <String, dynamic>{
      'createLoggedWorkout': instance.createLoggedWorkout.toJson(),
    };

CreateLoggedWorkoutInput _$CreateLoggedWorkoutInputFromJson(
        Map<String, dynamic> json) =>
    CreateLoggedWorkoutInput(
      gymProfile: json['GymProfile'] == null
          ? null
          : ConnectRelationInput.fromJson(
              json['GymProfile'] as Map<String, dynamic>),
      loggedWorkoutSections: (json['LoggedWorkoutSections'] as List<dynamic>)
          .map((e) => CreateLoggedWorkoutSectionInLoggedWorkoutInput.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      scheduledWorkout: json['ScheduledWorkout'] == null
          ? null
          : ConnectRelationInput.fromJson(
              json['ScheduledWorkout'] as Map<String, dynamic>),
      workout: json['Workout'] == null
          ? null
          : ConnectRelationInput.fromJson(
              json['Workout'] as Map<String, dynamic>),
      workoutGoals: (json['WorkoutGoals'] as List<dynamic>)
          .map((e) => ConnectRelationInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      completedOn:
          fromGraphQLDateTimeToDartDateTime(json['completedOn'] as int),
      name: json['name'] as String,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$CreateLoggedWorkoutInputToJson(
        CreateLoggedWorkoutInput instance) =>
    <String, dynamic>{
      'GymProfile': instance.gymProfile?.toJson(),
      'LoggedWorkoutSections':
          instance.loggedWorkoutSections.map((e) => e.toJson()).toList(),
      'ScheduledWorkout': instance.scheduledWorkout?.toJson(),
      'Workout': instance.workout?.toJson(),
      'WorkoutGoals': instance.workoutGoals.map((e) => e.toJson()).toList(),
      'completedOn': fromDartDateTimeToGraphQLDateTime(instance.completedOn),
      'name': instance.name,
      'note': instance.note,
    };

CreateLoggedWorkoutSectionInLoggedWorkoutInput
    _$CreateLoggedWorkoutSectionInLoggedWorkoutInputFromJson(
            Map<String, dynamic> json) =>
        CreateLoggedWorkoutSectionInLoggedWorkoutInput(
          bodyAreas: (json['BodyAreas'] as List<dynamic>)
              .map((e) =>
                  ConnectRelationInput.fromJson(e as Map<String, dynamic>))
              .toList(),
          moveTypes: (json['MoveTypes'] as List<dynamic>)
              .map((e) =>
                  ConnectRelationInput.fromJson(e as Map<String, dynamic>))
              .toList(),
          workoutSectionType: ConnectRelationInput.fromJson(
              json['WorkoutSectionType'] as Map<String, dynamic>),
          loggedWorkoutSectionData: LoggedWorkoutSectionDataInput.fromJson(
              json['loggedWorkoutSectionData'] as Map<String, dynamic>),
          name: json['name'] as String?,
          repScore: json['repScore'] as int?,
          sortPosition: json['sortPosition'] as int,
          timeTakenSeconds: json['timeTakenSeconds'] as int,
        );

Map<String, dynamic> _$CreateLoggedWorkoutSectionInLoggedWorkoutInputToJson(
        CreateLoggedWorkoutSectionInLoggedWorkoutInput instance) =>
    <String, dynamic>{
      'BodyAreas': instance.bodyAreas.map((e) => e.toJson()).toList(),
      'MoveTypes': instance.moveTypes.map((e) => e.toJson()).toList(),
      'WorkoutSectionType': instance.workoutSectionType.toJson(),
      'loggedWorkoutSectionData': instance.loggedWorkoutSectionData.toJson(),
      'name': instance.name,
      'repScore': instance.repScore,
      'sortPosition': instance.sortPosition,
      'timeTakenSeconds': instance.timeTakenSeconds,
    };

LoggedWorkoutSectionDataInput _$LoggedWorkoutSectionDataInputFromJson(
        Map<String, dynamic> json) =>
    LoggedWorkoutSectionDataInput(
      rounds: (json['rounds'] as List<dynamic>)
          .map((e) =>
              WorkoutSectionRoundDataInput.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LoggedWorkoutSectionDataInputToJson(
        LoggedWorkoutSectionDataInput instance) =>
    <String, dynamic>{
      'rounds': instance.rounds.map((e) => e.toJson()).toList(),
    };

WorkoutSectionRoundDataInput _$WorkoutSectionRoundDataInputFromJson(
        Map<String, dynamic> json) =>
    WorkoutSectionRoundDataInput(
      sets: (json['sets'] as List<dynamic>)
          .map((e) => WorkoutSectionRoundSetDataInput.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      timeTakenSeconds: json['timeTakenSeconds'] as int,
    );

Map<String, dynamic> _$WorkoutSectionRoundDataInputToJson(
        WorkoutSectionRoundDataInput instance) =>
    <String, dynamic>{
      'sets': instance.sets.map((e) => e.toJson()).toList(),
      'timeTakenSeconds': instance.timeTakenSeconds,
    };

WorkoutSectionRoundSetDataInput _$WorkoutSectionRoundSetDataInputFromJson(
        Map<String, dynamic> json) =>
    WorkoutSectionRoundSetDataInput(
      moves: json['moves'] as String,
      rounds: json['rounds'] as int,
      timeTakenSeconds: json['timeTakenSeconds'] as int,
    );

Map<String, dynamic> _$WorkoutSectionRoundSetDataInputToJson(
        WorkoutSectionRoundSetDataInput instance) =>
    <String, dynamic>{
      'moves': instance.moves,
      'rounds': instance.rounds,
      'timeTakenSeconds': instance.timeTakenSeconds,
    };

UpdateLoggedWorkoutSection _$UpdateLoggedWorkoutSectionFromJson(
        Map<String, dynamic> json) =>
    UpdateLoggedWorkoutSection()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..name = json['name'] as String?
      ..repScore = json['repScore'] as int?
      ..timeTakenSeconds = json['timeTakenSeconds'] as int
      ..sortPosition = json['sortPosition'] as int
      ..workoutSectionType = WorkoutSectionType.fromJson(
          json['WorkoutSectionType'] as Map<String, dynamic>)
      ..bodyAreas = (json['BodyAreas'] as List<dynamic>)
          .map((e) => BodyArea.fromJson(e as Map<String, dynamic>))
          .toList()
      ..moveTypes = (json['MoveTypes'] as List<dynamic>)
          .map((e) => MoveType.fromJson(e as Map<String, dynamic>))
          .toList()
      ..loggedWorkoutSectionData = json['loggedWorkoutSectionData'] == null
          ? null
          : LoggedWorkoutSectionData.fromJson(
              json['loggedWorkoutSectionData'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateLoggedWorkoutSectionToJson(
        UpdateLoggedWorkoutSection instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'name': instance.name,
      'repScore': instance.repScore,
      'timeTakenSeconds': instance.timeTakenSeconds,
      'sortPosition': instance.sortPosition,
      'WorkoutSectionType': instance.workoutSectionType.toJson(),
      'BodyAreas': instance.bodyAreas.map((e) => e.toJson()).toList(),
      'MoveTypes': instance.moveTypes.map((e) => e.toJson()).toList(),
      'loggedWorkoutSectionData': instance.loggedWorkoutSectionData?.toJson(),
    };

UpdateLoggedWorkoutSection$Mutation
    _$UpdateLoggedWorkoutSection$MutationFromJson(Map<String, dynamic> json) =>
        UpdateLoggedWorkoutSection$Mutation()
          ..updateLoggedWorkoutSection = UpdateLoggedWorkoutSection.fromJson(
              json['updateLoggedWorkoutSection'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateLoggedWorkoutSection$MutationToJson(
        UpdateLoggedWorkoutSection$Mutation instance) =>
    <String, dynamic>{
      'updateLoggedWorkoutSection':
          instance.updateLoggedWorkoutSection.toJson(),
    };

UpdateLoggedWorkoutSectionInput _$UpdateLoggedWorkoutSectionInputFromJson(
        Map<String, dynamic> json) =>
    UpdateLoggedWorkoutSectionInput(
      bodyAreas: (json['BodyAreas'] as List<dynamic>)
          .map((e) => ConnectRelationInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      moveTypes: (json['MoveTypes'] as List<dynamic>)
          .map((e) => ConnectRelationInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as String,
      loggedWorkoutSectionData: json['loggedWorkoutSectionData'] == null
          ? null
          : LoggedWorkoutSectionDataInput.fromJson(
              json['loggedWorkoutSectionData'] as Map<String, dynamic>),
      repScore: json['repScore'] as int?,
      timeTakenSeconds: json['timeTakenSeconds'] as int?,
    );

Map<String, dynamic> _$UpdateLoggedWorkoutSectionInputToJson(
        UpdateLoggedWorkoutSectionInput instance) =>
    <String, dynamic>{
      'BodyAreas': instance.bodyAreas.map((e) => e.toJson()).toList(),
      'MoveTypes': instance.moveTypes.map((e) => e.toJson()).toList(),
      'id': instance.id,
      'loggedWorkoutSectionData': instance.loggedWorkoutSectionData?.toJson(),
      'repScore': instance.repScore,
      'timeTakenSeconds': instance.timeTakenSeconds,
    };

DeleteWorkoutPlanReviewById$Mutation
    _$DeleteWorkoutPlanReviewById$MutationFromJson(Map<String, dynamic> json) =>
        DeleteWorkoutPlanReviewById$Mutation()
          ..deleteWorkoutPlanReviewById =
              json['deleteWorkoutPlanReviewById'] as String;

Map<String, dynamic> _$DeleteWorkoutPlanReviewById$MutationToJson(
        DeleteWorkoutPlanReviewById$Mutation instance) =>
    <String, dynamic>{
      'deleteWorkoutPlanReviewById': instance.deleteWorkoutPlanReviewById,
    };

WorkoutPlanReview _$WorkoutPlanReviewFromJson(Map<String, dynamic> json) =>
    WorkoutPlanReview()
      ..id = json['id'] as String
      ..$$typename = json['__typename'] as String?
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..score = (json['score'] as num).toDouble()
      ..comment = json['comment'] as String?
      ..user = UserSummary.fromJson(json['User'] as Map<String, dynamic>);

Map<String, dynamic> _$WorkoutPlanReviewToJson(WorkoutPlanReview instance) =>
    <String, dynamic>{
      'id': instance.id,
      '__typename': instance.$$typename,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'score': instance.score,
      'comment': instance.comment,
      'User': instance.user.toJson(),
    };

UpdateWorkoutPlanReview$Mutation _$UpdateWorkoutPlanReview$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutPlanReview$Mutation()
      ..updateWorkoutPlanReview = WorkoutPlanReview.fromJson(
          json['updateWorkoutPlanReview'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateWorkoutPlanReview$MutationToJson(
        UpdateWorkoutPlanReview$Mutation instance) =>
    <String, dynamic>{
      'updateWorkoutPlanReview': instance.updateWorkoutPlanReview.toJson(),
    };

UpdateWorkoutPlanReviewInput _$UpdateWorkoutPlanReviewInputFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutPlanReviewInput(
      comment: json['comment'] as String?,
      id: json['id'] as String,
      score: (json['score'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UpdateWorkoutPlanReviewInputToJson(
        UpdateWorkoutPlanReviewInput instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'id': instance.id,
      'score': instance.score,
    };

CreateWorkoutPlanReview$Mutation _$CreateWorkoutPlanReview$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateWorkoutPlanReview$Mutation()
      ..createWorkoutPlanReview = WorkoutPlanReview.fromJson(
          json['createWorkoutPlanReview'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateWorkoutPlanReview$MutationToJson(
        CreateWorkoutPlanReview$Mutation instance) =>
    <String, dynamic>{
      'createWorkoutPlanReview': instance.createWorkoutPlanReview.toJson(),
    };

CreateWorkoutPlanReviewInput _$CreateWorkoutPlanReviewInputFromJson(
        Map<String, dynamic> json) =>
    CreateWorkoutPlanReviewInput(
      workoutPlan: ConnectRelationInput.fromJson(
          json['WorkoutPlan'] as Map<String, dynamic>),
      comment: json['comment'] as String?,
      score: (json['score'] as num).toDouble(),
    );

Map<String, dynamic> _$CreateWorkoutPlanReviewInputToJson(
        CreateWorkoutPlanReviewInput instance) =>
    <String, dynamic>{
      'WorkoutPlan': instance.workoutPlan.toJson(),
      'comment': instance.comment,
      'score': instance.score,
    };

RemoveWorkoutFromClub$Mutation _$RemoveWorkoutFromClub$MutationFromJson(
        Map<String, dynamic> json) =>
    RemoveWorkoutFromClub$Mutation()
      ..removeWorkoutFromClub =
          Club.fromJson(json['removeWorkoutFromClub'] as Map<String, dynamic>);

Map<String, dynamic> _$RemoveWorkoutFromClub$MutationToJson(
        RemoveWorkoutFromClub$Mutation instance) =>
    <String, dynamic>{
      'removeWorkoutFromClub': instance.removeWorkoutFromClub.toJson(),
    };

RemoveWorkoutPlanFromClub$Mutation _$RemoveWorkoutPlanFromClub$MutationFromJson(
        Map<String, dynamic> json) =>
    RemoveWorkoutPlanFromClub$Mutation()
      ..removeWorkoutPlanFromClub = Club.fromJson(
          json['removeWorkoutPlanFromClub'] as Map<String, dynamic>);

Map<String, dynamic> _$RemoveWorkoutPlanFromClub$MutationToJson(
        RemoveWorkoutPlanFromClub$Mutation instance) =>
    <String, dynamic>{
      'removeWorkoutPlanFromClub': instance.removeWorkoutPlanFromClub.toJson(),
    };

AddWorkoutToClub$Mutation _$AddWorkoutToClub$MutationFromJson(
        Map<String, dynamic> json) =>
    AddWorkoutToClub$Mutation()
      ..addWorkoutToClub =
          Club.fromJson(json['addWorkoutToClub'] as Map<String, dynamic>);

Map<String, dynamic> _$AddWorkoutToClub$MutationToJson(
        AddWorkoutToClub$Mutation instance) =>
    <String, dynamic>{
      'addWorkoutToClub': instance.addWorkoutToClub.toJson(),
    };

AddWorkoutPlanToClub$Mutation _$AddWorkoutPlanToClub$MutationFromJson(
        Map<String, dynamic> json) =>
    AddWorkoutPlanToClub$Mutation()
      ..addWorkoutPlanToClub =
          Club.fromJson(json['addWorkoutPlanToClub'] as Map<String, dynamic>);

Map<String, dynamic> _$AddWorkoutPlanToClub$MutationToJson(
        AddWorkoutPlanToClub$Mutation instance) =>
    <String, dynamic>{
      'addWorkoutPlanToClub': instance.addWorkoutPlanToClub.toJson(),
    };

UserWorkoutPlans$Query _$UserWorkoutPlans$QueryFromJson(
        Map<String, dynamic> json) =>
    UserWorkoutPlans$Query()
      ..userWorkoutPlans = (json['userWorkoutPlans'] as List<dynamic>)
          .map((e) => WorkoutPlan.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserWorkoutPlans$QueryToJson(
        UserWorkoutPlans$Query instance) =>
    <String, dynamic>{
      'userWorkoutPlans':
          instance.userWorkoutPlans.map((e) => e.toJson()).toList(),
    };

PublicWorkoutPlans$Query _$PublicWorkoutPlans$QueryFromJson(
        Map<String, dynamic> json) =>
    PublicWorkoutPlans$Query()
      ..publicWorkoutPlans = (json['publicWorkoutPlans'] as List<dynamic>)
          .map((e) => WorkoutPlan.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$PublicWorkoutPlans$QueryToJson(
        PublicWorkoutPlans$Query instance) =>
    <String, dynamic>{
      'publicWorkoutPlans':
          instance.publicWorkoutPlans.map((e) => e.toJson()).toList(),
    };

WorkoutPlanFiltersInput _$WorkoutPlanFiltersInputFromJson(
        Map<String, dynamic> json) =>
    WorkoutPlanFiltersInput(
      bodyweightOnly: json['bodyweightOnly'] as bool?,
      daysPerWeek: json['daysPerWeek'] as int?,
      difficultyLevel: _$enumDecodeNullable(
          _$DifficultyLevelEnumMap, json['difficultyLevel'],
          unknownValue: DifficultyLevel.artemisUnknown),
      lengthWeeks: json['lengthWeeks'] as int?,
      workoutGoals: (json['workoutGoals'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$WorkoutPlanFiltersInputToJson(
        WorkoutPlanFiltersInput instance) =>
    <String, dynamic>{
      'bodyweightOnly': instance.bodyweightOnly,
      'daysPerWeek': instance.daysPerWeek,
      'difficultyLevel': _$DifficultyLevelEnumMap[instance.difficultyLevel],
      'lengthWeeks': instance.lengthWeeks,
      'workoutGoals': instance.workoutGoals,
    };

WorkoutPlanById$Query _$WorkoutPlanById$QueryFromJson(
        Map<String, dynamic> json) =>
    WorkoutPlanById$Query()
      ..workoutPlanById =
          WorkoutPlan.fromJson(json['workoutPlanById'] as Map<String, dynamic>);

Map<String, dynamic> _$WorkoutPlanById$QueryToJson(
        WorkoutPlanById$Query instance) =>
    <String, dynamic>{
      'workoutPlanById': instance.workoutPlanById.toJson(),
    };

WorkoutTag _$WorkoutTagFromJson(Map<String, dynamic> json) => WorkoutTag()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..tag = json['tag'] as String;

Map<String, dynamic> _$WorkoutTagToJson(WorkoutTag instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'tag': instance.tag,
    };

UpdateWorkoutPlan _$UpdateWorkoutPlanFromJson(Map<String, dynamic> json) =>
    UpdateWorkoutPlan()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..archived = json['archived'] as bool
      ..name = json['name'] as String
      ..description = json['description'] as String?
      ..lengthWeeks = json['lengthWeeks'] as int
      ..daysPerWeek = json['daysPerWeek'] as int
      ..coverImageUri = json['coverImageUri'] as String?
      ..introVideoUri = json['introVideoUri'] as String?
      ..introVideoThumbUri = json['introVideoThumbUri'] as String?
      ..introAudioUri = json['introAudioUri'] as String?
      ..contentAccessScope = _$enumDecode(
          _$ContentAccessScopeEnumMap, json['contentAccessScope'],
          unknownValue: ContentAccessScope.artemisUnknown)
      ..workoutTags = (json['WorkoutTags'] as List<dynamic>)
          .map((e) => WorkoutTag.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UpdateWorkoutPlanToJson(UpdateWorkoutPlan instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'archived': instance.archived,
      'name': instance.name,
      'description': instance.description,
      'lengthWeeks': instance.lengthWeeks,
      'daysPerWeek': instance.daysPerWeek,
      'coverImageUri': instance.coverImageUri,
      'introVideoUri': instance.introVideoUri,
      'introVideoThumbUri': instance.introVideoThumbUri,
      'introAudioUri': instance.introAudioUri,
      'contentAccessScope':
          _$ContentAccessScopeEnumMap[instance.contentAccessScope],
      'WorkoutTags': instance.workoutTags.map((e) => e.toJson()).toList(),
    };

UpdateWorkoutPlan$Mutation _$UpdateWorkoutPlan$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutPlan$Mutation()
      ..updateWorkoutPlan = UpdateWorkoutPlan.fromJson(
          json['updateWorkoutPlan'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateWorkoutPlan$MutationToJson(
        UpdateWorkoutPlan$Mutation instance) =>
    <String, dynamic>{
      'updateWorkoutPlan': instance.updateWorkoutPlan.toJson(),
    };

UpdateWorkoutPlanInput _$UpdateWorkoutPlanInputFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutPlanInput(
      workoutTags: (json['WorkoutTags'] as List<dynamic>?)
          ?.map((e) => ConnectRelationInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      contentAccessScope: _$enumDecodeNullable(
          _$ContentAccessScopeEnumMap, json['contentAccessScope'],
          unknownValue: ContentAccessScope.artemisUnknown),
      coverImageUri: json['coverImageUri'] as String?,
      daysPerWeek: json['daysPerWeek'] as int?,
      description: json['description'] as String?,
      id: json['id'] as String,
      introAudioUri: json['introAudioUri'] as String?,
      introVideoThumbUri: json['introVideoThumbUri'] as String?,
      introVideoUri: json['introVideoUri'] as String?,
      lengthWeeks: json['lengthWeeks'] as int?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$UpdateWorkoutPlanInputToJson(
        UpdateWorkoutPlanInput instance) =>
    <String, dynamic>{
      'WorkoutTags': instance.workoutTags?.map((e) => e.toJson()).toList(),
      'contentAccessScope':
          _$ContentAccessScopeEnumMap[instance.contentAccessScope],
      'coverImageUri': instance.coverImageUri,
      'daysPerWeek': instance.daysPerWeek,
      'description': instance.description,
      'id': instance.id,
      'introAudioUri': instance.introAudioUri,
      'introVideoThumbUri': instance.introVideoThumbUri,
      'introVideoUri': instance.introVideoUri,
      'lengthWeeks': instance.lengthWeeks,
      'name': instance.name,
    };

CreateWorkoutPlan$Mutation _$CreateWorkoutPlan$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateWorkoutPlan$Mutation()
      ..createWorkoutPlan = WorkoutPlan.fromJson(
          json['createWorkoutPlan'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateWorkoutPlan$MutationToJson(
        CreateWorkoutPlan$Mutation instance) =>
    <String, dynamic>{
      'createWorkoutPlan': instance.createWorkoutPlan.toJson(),
    };

CreateWorkoutPlanInput _$CreateWorkoutPlanInputFromJson(
        Map<String, dynamic> json) =>
    CreateWorkoutPlanInput(
      contentAccessScope: _$enumDecode(
          _$ContentAccessScopeEnumMap, json['contentAccessScope'],
          unknownValue: ContentAccessScope.artemisUnknown),
      name: json['name'] as String,
    );

Map<String, dynamic> _$CreateWorkoutPlanInputToJson(
        CreateWorkoutPlanInput instance) =>
    <String, dynamic>{
      'contentAccessScope':
          _$ContentAccessScopeEnumMap[instance.contentAccessScope],
      'name': instance.name,
    };

User _$UserFromJson(Map<String, dynamic> json) => User()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..avatarUri = json['avatarUri'] as String?
  ..bio = json['bio'] as String?
  ..birthdate = fromGraphQLDateTimeNullableToDartDateTimeNullable(
      json['birthdate'] as int?)
  ..countryCode = json['countryCode'] as String?
  ..displayName = json['displayName'] as String
  ..introVideoUri = json['introVideoUri'] as String?
  ..introVideoThumbUri = json['introVideoThumbUri'] as String?
  ..gender = _$enumDecode(_$GenderEnumMap, json['gender'],
      unknownValue: Gender.artemisUnknown)
  ..userProfileScope = _$enumDecode(
      _$UserProfileScopeEnumMap, json['userProfileScope'],
      unknownValue: UserProfileScope.artemisUnknown);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'avatarUri': instance.avatarUri,
      'bio': instance.bio,
      'birthdate':
          fromDartDateTimeNullableToGraphQLDateTimeNullable(instance.birthdate),
      'countryCode': instance.countryCode,
      'displayName': instance.displayName,
      'introVideoUri': instance.introVideoUri,
      'introVideoThumbUri': instance.introVideoThumbUri,
      'gender': _$GenderEnumMap[instance.gender],
      'userProfileScope': _$UserProfileScopeEnumMap[instance.userProfileScope],
    };

const _$GenderEnumMap = {
  Gender.female: 'FEMALE',
  Gender.male: 'MALE',
  Gender.nonbinary: 'NONBINARY',
  Gender.pnts: 'PNTS',
  Gender.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

AuthedUser$Query _$AuthedUser$QueryFromJson(Map<String, dynamic> json) =>
    AuthedUser$Query()
      ..authedUser = User.fromJson(json['authedUser'] as Map<String, dynamic>);

Map<String, dynamic> _$AuthedUser$QueryToJson(AuthedUser$Query instance) =>
    <String, dynamic>{
      'authedUser': instance.authedUser.toJson(),
    };

UpdateUser$Mutation _$UpdateUser$MutationFromJson(Map<String, dynamic> json) =>
    UpdateUser$Mutation()
      ..updateUser = User.fromJson(json['updateUser'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateUser$MutationToJson(
        UpdateUser$Mutation instance) =>
    <String, dynamic>{
      'updateUser': instance.updateUser.toJson(),
    };

UpdateUserInput _$UpdateUserInputFromJson(Map<String, dynamic> json) =>
    UpdateUserInput(
      avatarUri: json['avatarUri'] as String?,
      bio: json['bio'] as String?,
      birthdate: fromGraphQLDateTimeNullableToDartDateTimeNullable(
          json['birthdate'] as int?),
      countryCode: json['countryCode'] as String?,
      displayName: json['displayName'] as String?,
      firstname: json['firstname'] as String?,
      gender: _$enumDecodeNullable(_$GenderEnumMap, json['gender'],
          unknownValue: Gender.artemisUnknown),
      hasOnboarded: json['hasOnboarded'] as bool?,
      instagramUrl: json['instagramUrl'] as String?,
      introVideoThumbUri: json['introVideoThumbUri'] as String?,
      introVideoUri: json['introVideoUri'] as String?,
      lastname: json['lastname'] as String?,
      linkedinUrl: json['linkedinUrl'] as String?,
      snapUrl: json['snapUrl'] as String?,
      tagline: json['tagline'] as String?,
      tiktokUrl: json['tiktokUrl'] as String?,
      townCity: json['townCity'] as String?,
      userProfileScope: _$enumDecodeNullable(
          _$UserProfileScopeEnumMap, json['userProfileScope'],
          unknownValue: UserProfileScope.artemisUnknown),
      youtubeUrl: json['youtubeUrl'] as String?,
    );

Map<String, dynamic> _$UpdateUserInputToJson(UpdateUserInput instance) =>
    <String, dynamic>{
      'avatarUri': instance.avatarUri,
      'bio': instance.bio,
      'birthdate':
          fromDartDateTimeNullableToGraphQLDateTimeNullable(instance.birthdate),
      'countryCode': instance.countryCode,
      'displayName': instance.displayName,
      'firstname': instance.firstname,
      'gender': _$GenderEnumMap[instance.gender],
      'hasOnboarded': instance.hasOnboarded,
      'instagramUrl': instance.instagramUrl,
      'introVideoThumbUri': instance.introVideoThumbUri,
      'introVideoUri': instance.introVideoUri,
      'lastname': instance.lastname,
      'linkedinUrl': instance.linkedinUrl,
      'snapUrl': instance.snapUrl,
      'tagline': instance.tagline,
      'tiktokUrl': instance.tiktokUrl,
      'townCity': instance.townCity,
      'userProfileScope': _$UserProfileScopeEnumMap[instance.userProfileScope],
      'youtubeUrl': instance.youtubeUrl,
    };

UserAvatarData _$UserAvatarDataFromJson(Map<String, dynamic> json) =>
    UserAvatarData()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..avatarUri = json['avatarUri'] as String?
      ..displayName = json['displayName'] as String;

Map<String, dynamic> _$UserAvatarDataToJson(UserAvatarData instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'avatarUri': instance.avatarUri,
      'displayName': instance.displayName,
    };

UserAvatarById$Query _$UserAvatarById$QueryFromJson(
        Map<String, dynamic> json) =>
    UserAvatarById$Query()
      ..userAvatarById = UserAvatarData.fromJson(
          json['userAvatarById'] as Map<String, dynamic>);

Map<String, dynamic> _$UserAvatarById$QueryToJson(
        UserAvatarById$Query instance) =>
    <String, dynamic>{
      'userAvatarById': instance.userAvatarById.toJson(),
    };

UnarchiveWorkoutPlanById$Mutation _$UnarchiveWorkoutPlanById$MutationFromJson(
        Map<String, dynamic> json) =>
    UnarchiveWorkoutPlanById$Mutation()
      ..unarchiveWorkoutPlanById = WorkoutPlan.fromJson(
          json['unarchiveWorkoutPlanById'] as Map<String, dynamic>);

Map<String, dynamic> _$UnarchiveWorkoutPlanById$MutationToJson(
        UnarchiveWorkoutPlanById$Mutation instance) =>
    <String, dynamic>{
      'unarchiveWorkoutPlanById': instance.unarchiveWorkoutPlanById.toJson(),
    };

ArchivedMove _$ArchivedMoveFromJson(Map<String, dynamic> json) => ArchivedMove()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..name = json['name'] as String
  ..archived = json['archived'] as bool;

Map<String, dynamic> _$ArchivedMoveToJson(ArchivedMove instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'name': instance.name,
      'archived': instance.archived,
    };

UserArchivedCustomMoves$Query _$UserArchivedCustomMoves$QueryFromJson(
        Map<String, dynamic> json) =>
    UserArchivedCustomMoves$Query()
      ..archivedMove = (json['archivedMove'] as List<dynamic>)
          .map((e) => ArchivedMove.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserArchivedCustomMoves$QueryToJson(
        UserArchivedCustomMoves$Query instance) =>
    <String, dynamic>{
      'archivedMove': instance.archivedMove.map((e) => e.toJson()).toList(),
    };

UnarchiveCustomMoveById$Mutation _$UnarchiveCustomMoveById$MutationFromJson(
        Map<String, dynamic> json) =>
    UnarchiveCustomMoveById$Mutation()
      ..unarchiveCustomMoveById = Move.fromJson(
          json['unarchiveCustomMoveById'] as Map<String, dynamic>);

Map<String, dynamic> _$UnarchiveCustomMoveById$MutationToJson(
        UnarchiveCustomMoveById$Mutation instance) =>
    <String, dynamic>{
      'unarchiveCustomMoveById': instance.unarchiveCustomMoveById.toJson(),
    };

ArchivedWorkoutPlan _$ArchivedWorkoutPlanFromJson(Map<String, dynamic> json) =>
    ArchivedWorkoutPlan()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..name = json['name'] as String
      ..archived = json['archived'] as bool;

Map<String, dynamic> _$ArchivedWorkoutPlanToJson(
        ArchivedWorkoutPlan instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'name': instance.name,
      'archived': instance.archived,
    };

ArchiveWorkoutPlanById$Mutation _$ArchiveWorkoutPlanById$MutationFromJson(
        Map<String, dynamic> json) =>
    ArchiveWorkoutPlanById$Mutation()
      ..archivedWorkoutPlan = ArchivedWorkoutPlan.fromJson(
          json['archivedWorkoutPlan'] as Map<String, dynamic>);

Map<String, dynamic> _$ArchiveWorkoutPlanById$MutationToJson(
        ArchiveWorkoutPlanById$Mutation instance) =>
    <String, dynamic>{
      'archivedWorkoutPlan': instance.archivedWorkoutPlan.toJson(),
    };

UnarchiveWorkoutById$Mutation _$UnarchiveWorkoutById$MutationFromJson(
        Map<String, dynamic> json) =>
    UnarchiveWorkoutById$Mutation()
      ..unarchiveWorkoutById = Workout.fromJson(
          json['unarchiveWorkoutById'] as Map<String, dynamic>);

Map<String, dynamic> _$UnarchiveWorkoutById$MutationToJson(
        UnarchiveWorkoutById$Mutation instance) =>
    <String, dynamic>{
      'unarchiveWorkoutById': instance.unarchiveWorkoutById.toJson(),
    };

UserArchivedWorkoutPlans$Query _$UserArchivedWorkoutPlans$QueryFromJson(
        Map<String, dynamic> json) =>
    UserArchivedWorkoutPlans$Query()
      ..archivedWorkoutPlan = (json['archivedWorkoutPlan'] as List<dynamic>)
          .map((e) => ArchivedWorkoutPlan.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserArchivedWorkoutPlans$QueryToJson(
        UserArchivedWorkoutPlans$Query instance) =>
    <String, dynamic>{
      'archivedWorkoutPlan':
          instance.archivedWorkoutPlan.map((e) => e.toJson()).toList(),
    };

ArchivedWorkout _$ArchivedWorkoutFromJson(Map<String, dynamic> json) =>
    ArchivedWorkout()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..name = json['name'] as String
      ..archived = json['archived'] as bool;

Map<String, dynamic> _$ArchivedWorkoutToJson(ArchivedWorkout instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'name': instance.name,
      'archived': instance.archived,
    };

UserArchivedWorkouts$Query _$UserArchivedWorkouts$QueryFromJson(
        Map<String, dynamic> json) =>
    UserArchivedWorkouts$Query()
      ..archivedWorkout = (json['archivedWorkout'] as List<dynamic>)
          .map((e) => ArchivedWorkout.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserArchivedWorkouts$QueryToJson(
        UserArchivedWorkouts$Query instance) =>
    <String, dynamic>{
      'archivedWorkout':
          instance.archivedWorkout.map((e) => e.toJson()).toList(),
    };

ArchiveWorkoutById$Mutation _$ArchiveWorkoutById$MutationFromJson(
        Map<String, dynamic> json) =>
    ArchiveWorkoutById$Mutation()
      ..archivedWorkout = ArchivedWorkout.fromJson(
          json['archivedWorkout'] as Map<String, dynamic>);

Map<String, dynamic> _$ArchiveWorkoutById$MutationToJson(
        ArchiveWorkoutById$Mutation instance) =>
    <String, dynamic>{
      'archivedWorkout': instance.archivedWorkout.toJson(),
    };

ArchiveCustomMoveById$Mutation _$ArchiveCustomMoveById$MutationFromJson(
        Map<String, dynamic> json) =>
    ArchiveCustomMoveById$Mutation()
      ..archivedMove =
          ArchivedMove.fromJson(json['archivedMove'] as Map<String, dynamic>);

Map<String, dynamic> _$ArchiveCustomMoveById$MutationToJson(
        ArchiveCustomMoveById$Mutation instance) =>
    <String, dynamic>{
      'archivedMove': instance.archivedMove.toJson(),
    };

UserAvatars$Query _$UserAvatars$QueryFromJson(Map<String, dynamic> json) =>
    UserAvatars$Query()
      ..userAvatars = (json['userAvatars'] as List<dynamic>)
          .map((e) => UserAvatarData.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserAvatars$QueryToJson(UserAvatars$Query instance) =>
    <String, dynamic>{
      'userAvatars': instance.userAvatars.map((e) => e.toJson()).toList(),
    };

CreateMove$Mutation _$CreateMove$MutationFromJson(Map<String, dynamic> json) =>
    CreateMove$Mutation()
      ..createMove = Move.fromJson(json['createMove'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateMove$MutationToJson(
        CreateMove$Mutation instance) =>
    <String, dynamic>{
      'createMove': instance.createMove.toJson(),
    };

CreateMoveInput _$CreateMoveInputFromJson(Map<String, dynamic> json) =>
    CreateMoveInput(
      bodyAreaMoveScores: (json['BodyAreaMoveScores'] as List<dynamic>?)
          ?.map(
              (e) => BodyAreaMoveScoreInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      moveType: ConnectRelationInput.fromJson(
          json['MoveType'] as Map<String, dynamic>),
      requiredEquipments: (json['RequiredEquipments'] as List<dynamic>?)
          ?.map((e) => ConnectRelationInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      selectableEquipments: (json['SelectableEquipments'] as List<dynamic>?)
          ?.map((e) => ConnectRelationInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      demoVideoThumbUri: json['demoVideoThumbUri'] as String?,
      demoVideoUri: json['demoVideoUri'] as String?,
      description: json['description'] as String?,
      name: json['name'] as String,
      scope: _$enumDecodeNullable(_$MoveScopeEnumMap, json['scope'],
          unknownValue: MoveScope.artemisUnknown),
      searchTerms: json['searchTerms'] as String?,
      validRepTypes: (json['validRepTypes'] as List<dynamic>)
          .map((e) => _$enumDecode(_$WorkoutMoveRepTypeEnumMap, e,
              unknownValue: WorkoutMoveRepType.artemisUnknown))
          .toList(),
    );

Map<String, dynamic> _$CreateMoveInputToJson(CreateMoveInput instance) =>
    <String, dynamic>{
      'BodyAreaMoveScores':
          instance.bodyAreaMoveScores?.map((e) => e.toJson()).toList(),
      'MoveType': instance.moveType.toJson(),
      'RequiredEquipments':
          instance.requiredEquipments?.map((e) => e.toJson()).toList(),
      'SelectableEquipments':
          instance.selectableEquipments?.map((e) => e.toJson()).toList(),
      'demoVideoThumbUri': instance.demoVideoThumbUri,
      'demoVideoUri': instance.demoVideoUri,
      'description': instance.description,
      'name': instance.name,
      'scope': _$MoveScopeEnumMap[instance.scope],
      'searchTerms': instance.searchTerms,
      'validRepTypes': instance.validRepTypes
          .map((e) => _$WorkoutMoveRepTypeEnumMap[e])
          .toList(),
    };

BodyAreaMoveScoreInput _$BodyAreaMoveScoreInputFromJson(
        Map<String, dynamic> json) =>
    BodyAreaMoveScoreInput(
      bodyArea: ConnectRelationInput.fromJson(
          json['BodyArea'] as Map<String, dynamic>),
      score: (json['score'] as num).toDouble(),
    );

Map<String, dynamic> _$BodyAreaMoveScoreInputToJson(
        BodyAreaMoveScoreInput instance) =>
    <String, dynamic>{
      'BodyArea': instance.bodyArea.toJson(),
      'score': instance.score,
    };

UpdateMove$Mutation _$UpdateMove$MutationFromJson(Map<String, dynamic> json) =>
    UpdateMove$Mutation()
      ..updateMove = Move.fromJson(json['updateMove'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateMove$MutationToJson(
        UpdateMove$Mutation instance) =>
    <String, dynamic>{
      'updateMove': instance.updateMove.toJson(),
    };

UpdateMoveInput _$UpdateMoveInputFromJson(Map<String, dynamic> json) =>
    UpdateMoveInput(
      bodyAreaMoveScores: (json['BodyAreaMoveScores'] as List<dynamic>?)
          ?.map(
              (e) => BodyAreaMoveScoreInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      moveType: json['MoveType'] == null
          ? null
          : ConnectRelationInput.fromJson(
              json['MoveType'] as Map<String, dynamic>),
      requiredEquipments: (json['RequiredEquipments'] as List<dynamic>?)
          ?.map((e) => ConnectRelationInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      selectableEquipments: (json['SelectableEquipments'] as List<dynamic>?)
          ?.map((e) => ConnectRelationInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      demoVideoThumbUri: json['demoVideoThumbUri'] as String?,
      demoVideoUri: json['demoVideoUri'] as String?,
      description: json['description'] as String?,
      id: json['id'] as String,
      name: json['name'] as String?,
      scope: _$enumDecodeNullable(_$MoveScopeEnumMap, json['scope'],
          unknownValue: MoveScope.artemisUnknown),
      searchTerms: json['searchTerms'] as String?,
      validRepTypes: (json['validRepTypes'] as List<dynamic>?)
          ?.map((e) => _$enumDecode(_$WorkoutMoveRepTypeEnumMap, e,
              unknownValue: WorkoutMoveRepType.artemisUnknown))
          .toList(),
    );

Map<String, dynamic> _$UpdateMoveInputToJson(UpdateMoveInput instance) =>
    <String, dynamic>{
      'BodyAreaMoveScores':
          instance.bodyAreaMoveScores?.map((e) => e.toJson()).toList(),
      'MoveType': instance.moveType?.toJson(),
      'RequiredEquipments':
          instance.requiredEquipments?.map((e) => e.toJson()).toList(),
      'SelectableEquipments':
          instance.selectableEquipments?.map((e) => e.toJson()).toList(),
      'demoVideoThumbUri': instance.demoVideoThumbUri,
      'demoVideoUri': instance.demoVideoUri,
      'description': instance.description,
      'id': instance.id,
      'name': instance.name,
      'scope': _$MoveScopeEnumMap[instance.scope],
      'searchTerms': instance.searchTerms,
      'validRepTypes': instance.validRepTypes
          ?.map((e) => _$WorkoutMoveRepTypeEnumMap[e])
          .toList(),
    };

DeleteMoveById$Mutation _$DeleteMoveById$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteMoveById$Mutation()
      ..softDeleteMoveById = json['softDeleteMoveById'] as String;

Map<String, dynamic> _$DeleteMoveById$MutationToJson(
        DeleteMoveById$Mutation instance) =>
    <String, dynamic>{
      'softDeleteMoveById': instance.softDeleteMoveById,
    };

UserCustomMoves$Query _$UserCustomMoves$QueryFromJson(
        Map<String, dynamic> json) =>
    UserCustomMoves$Query()
      ..userCustomMoves = (json['userCustomMoves'] as List<dynamic>)
          .map((e) => Move.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserCustomMoves$QueryToJson(
        UserCustomMoves$Query instance) =>
    <String, dynamic>{
      'userCustomMoves':
          instance.userCustomMoves.map((e) => e.toJson()).toList(),
    };

DeleteGymProfileById$Mutation _$DeleteGymProfileById$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteGymProfileById$Mutation()
      ..deleteGymProfileById = json['deleteGymProfileById'] as String?;

Map<String, dynamic> _$DeleteGymProfileById$MutationToJson(
        DeleteGymProfileById$Mutation instance) =>
    <String, dynamic>{
      'deleteGymProfileById': instance.deleteGymProfileById,
    };

CreateGymProfile$Mutation _$CreateGymProfile$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateGymProfile$Mutation()
      ..createGymProfile =
          GymProfile.fromJson(json['createGymProfile'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateGymProfile$MutationToJson(
        CreateGymProfile$Mutation instance) =>
    <String, dynamic>{
      'createGymProfile': instance.createGymProfile.toJson(),
    };

CreateGymProfileInput _$CreateGymProfileInputFromJson(
        Map<String, dynamic> json) =>
    CreateGymProfileInput(
      equipments: (json['Equipments'] as List<dynamic>?)
          ?.map((e) => ConnectRelationInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String?,
      name: json['name'] as String,
    );

Map<String, dynamic> _$CreateGymProfileInputToJson(
        CreateGymProfileInput instance) =>
    <String, dynamic>{
      'Equipments': instance.equipments?.map((e) => e.toJson()).toList(),
      'description': instance.description,
      'name': instance.name,
    };

GymProfiles$Query _$GymProfiles$QueryFromJson(Map<String, dynamic> json) =>
    GymProfiles$Query()
      ..gymProfiles = (json['gymProfiles'] as List<dynamic>)
          .map((e) => GymProfile.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$GymProfiles$QueryToJson(GymProfiles$Query instance) =>
    <String, dynamic>{
      'gymProfiles': instance.gymProfiles.map((e) => e.toJson()).toList(),
    };

UpdateGymProfile$Mutation _$UpdateGymProfile$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateGymProfile$Mutation()
      ..updateGymProfile =
          GymProfile.fromJson(json['updateGymProfile'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateGymProfile$MutationToJson(
        UpdateGymProfile$Mutation instance) =>
    <String, dynamic>{
      'updateGymProfile': instance.updateGymProfile.toJson(),
    };

UpdateGymProfileInput _$UpdateGymProfileInputFromJson(
        Map<String, dynamic> json) =>
    UpdateGymProfileInput(
      equipments: (json['Equipments'] as List<dynamic>?)
          ?.map((e) => ConnectRelationInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String?,
      id: json['id'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$UpdateGymProfileInputToJson(
        UpdateGymProfileInput instance) =>
    <String, dynamic>{
      'Equipments': instance.equipments?.map((e) => e.toJson()).toList(),
      'description': instance.description,
      'id': instance.id,
      'name': instance.name,
    };

UserPublicProfileSummary _$UserPublicProfileSummaryFromJson(
        Map<String, dynamic> json) =>
    UserPublicProfileSummary()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..avatarUri = json['avatarUri'] as String?
      ..tagline = json['tagline'] as String?
      ..townCity = json['townCity'] as String?
      ..countryCode = json['countryCode'] as String?
      ..displayName = json['displayName'] as String
      ..numberPublicWorkouts = json['numberPublicWorkouts'] as int
      ..numberPublicPlans = json['numberPublicPlans'] as int;

Map<String, dynamic> _$UserPublicProfileSummaryToJson(
        UserPublicProfileSummary instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'avatarUri': instance.avatarUri,
      'tagline': instance.tagline,
      'townCity': instance.townCity,
      'countryCode': instance.countryCode,
      'displayName': instance.displayName,
      'numberPublicWorkouts': instance.numberPublicWorkouts,
      'numberPublicPlans': instance.numberPublicPlans,
    };

UserPublicProfiles$Query _$UserPublicProfiles$QueryFromJson(
        Map<String, dynamic> json) =>
    UserPublicProfiles$Query()
      ..userPublicProfiles = (json['userPublicProfiles'] as List<dynamic>)
          .map((e) =>
              UserPublicProfileSummary.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserPublicProfiles$QueryToJson(
        UserPublicProfiles$Query instance) =>
    <String, dynamic>{
      'userPublicProfiles':
          instance.userPublicProfiles.map((e) => e.toJson()).toList(),
    };

UserPublicProfile _$UserPublicProfileFromJson(Map<String, dynamic> json) =>
    UserPublicProfile()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..userProfileScope = _$enumDecode(
          _$UserProfileScopeEnumMap, json['userProfileScope'],
          unknownValue: UserProfileScope.artemisUnknown)
      ..avatarUri = json['avatarUri'] as String?
      ..introVideoUri = json['introVideoUri'] as String?
      ..introVideoThumbUri = json['introVideoThumbUri'] as String?
      ..bio = json['bio'] as String?
      ..tagline = json['tagline'] as String?
      ..townCity = json['townCity'] as String?
      ..instagramUrl = json['instagramUrl'] as String?
      ..tiktokUrl = json['tiktokUrl'] as String?
      ..youtubeUrl = json['youtubeUrl'] as String?
      ..snapUrl = json['snapUrl'] as String?
      ..linkedinUrl = json['linkedinUrl'] as String?
      ..countryCode = json['countryCode'] as String?
      ..displayName = json['displayName'] as String
      ..workouts = (json['Workouts'] as List<dynamic>)
          .map((e) => Workout.fromJson(e as Map<String, dynamic>))
          .toList()
      ..workoutPlans = (json['WorkoutPlans'] as List<dynamic>)
          .map((e) => WorkoutPlan.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserPublicProfileToJson(UserPublicProfile instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'userProfileScope': _$UserProfileScopeEnumMap[instance.userProfileScope],
      'avatarUri': instance.avatarUri,
      'introVideoUri': instance.introVideoUri,
      'introVideoThumbUri': instance.introVideoThumbUri,
      'bio': instance.bio,
      'tagline': instance.tagline,
      'townCity': instance.townCity,
      'instagramUrl': instance.instagramUrl,
      'tiktokUrl': instance.tiktokUrl,
      'youtubeUrl': instance.youtubeUrl,
      'snapUrl': instance.snapUrl,
      'linkedinUrl': instance.linkedinUrl,
      'countryCode': instance.countryCode,
      'displayName': instance.displayName,
      'Workouts': instance.workouts.map((e) => e.toJson()).toList(),
      'WorkoutPlans': instance.workoutPlans.map((e) => e.toJson()).toList(),
    };

UserPublicProfileById$Query _$UserPublicProfileById$QueryFromJson(
        Map<String, dynamic> json) =>
    UserPublicProfileById$Query()
      ..userPublicProfileById = UserPublicProfile.fromJson(
          json['userPublicProfileById'] as Map<String, dynamic>);

Map<String, dynamic> _$UserPublicProfileById$QueryToJson(
        UserPublicProfileById$Query instance) =>
    <String, dynamic>{
      'userPublicProfileById': instance.userPublicProfileById.toJson(),
    };

DeleteWorkoutTagById$Mutation _$DeleteWorkoutTagById$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteWorkoutTagById$Mutation()
      ..deleteWorkoutTagById = json['deleteWorkoutTagById'] as String;

Map<String, dynamic> _$DeleteWorkoutTagById$MutationToJson(
        DeleteWorkoutTagById$Mutation instance) =>
    <String, dynamic>{
      'deleteWorkoutTagById': instance.deleteWorkoutTagById,
    };

UpdateWorkoutTag$Mutation _$UpdateWorkoutTag$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutTag$Mutation()
      ..updateWorkoutTag =
          WorkoutTag.fromJson(json['updateWorkoutTag'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateWorkoutTag$MutationToJson(
        UpdateWorkoutTag$Mutation instance) =>
    <String, dynamic>{
      'updateWorkoutTag': instance.updateWorkoutTag.toJson(),
    };

UpdateWorkoutTagInput _$UpdateWorkoutTagInputFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutTagInput(
      id: json['id'] as String,
      tag: json['tag'] as String,
    );

Map<String, dynamic> _$UpdateWorkoutTagInputToJson(
        UpdateWorkoutTagInput instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tag': instance.tag,
    };

UserWorkoutTags$Query _$UserWorkoutTags$QueryFromJson(
        Map<String, dynamic> json) =>
    UserWorkoutTags$Query()
      ..userWorkoutTags = (json['userWorkoutTags'] as List<dynamic>)
          .map((e) => WorkoutTag.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserWorkoutTags$QueryToJson(
        UserWorkoutTags$Query instance) =>
    <String, dynamic>{
      'userWorkoutTags':
          instance.userWorkoutTags.map((e) => e.toJson()).toList(),
    };

CreateWorkoutTag$Mutation _$CreateWorkoutTag$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateWorkoutTag$Mutation()
      ..createWorkoutTag =
          WorkoutTag.fromJson(json['createWorkoutTag'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateWorkoutTag$MutationToJson(
        CreateWorkoutTag$Mutation instance) =>
    <String, dynamic>{
      'createWorkoutTag': instance.createWorkoutTag.toJson(),
    };

CreateWorkoutTagInput _$CreateWorkoutTagInputFromJson(
        Map<String, dynamic> json) =>
    CreateWorkoutTagInput(
      tag: json['tag'] as String,
    );

Map<String, dynamic> _$CreateWorkoutTagInputToJson(
        CreateWorkoutTagInput instance) =>
    <String, dynamic>{
      'tag': instance.tag,
    };

UpdateWorkoutSet _$UpdateWorkoutSetFromJson(Map<String, dynamic> json) =>
    UpdateWorkoutSet()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..sortPosition = json['sortPosition'] as int
      ..rounds = json['rounds'] as int
      ..duration = json['duration'] as int;

Map<String, dynamic> _$UpdateWorkoutSetToJson(UpdateWorkoutSet instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'sortPosition': instance.sortPosition,
      'rounds': instance.rounds,
      'duration': instance.duration,
    };

UpdateWorkoutSet$Mutation _$UpdateWorkoutSet$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutSet$Mutation()
      ..updateWorkoutSet = UpdateWorkoutSet.fromJson(
          json['updateWorkoutSet'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateWorkoutSet$MutationToJson(
        UpdateWorkoutSet$Mutation instance) =>
    <String, dynamic>{
      'updateWorkoutSet': instance.updateWorkoutSet.toJson(),
    };

UpdateWorkoutSetInput _$UpdateWorkoutSetInputFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutSetInput(
      duration: json['duration'] as int?,
      id: json['id'] as String,
      rounds: json['rounds'] as int?,
    );

Map<String, dynamic> _$UpdateWorkoutSetInputToJson(
        UpdateWorkoutSetInput instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'id': instance.id,
      'rounds': instance.rounds,
    };

DuplicateWorkoutSetById$Mutation _$DuplicateWorkoutSetById$MutationFromJson(
        Map<String, dynamic> json) =>
    DuplicateWorkoutSetById$Mutation()
      ..duplicateWorkoutSetById = WorkoutSet.fromJson(
          json['duplicateWorkoutSetById'] as Map<String, dynamic>);

Map<String, dynamic> _$DuplicateWorkoutSetById$MutationToJson(
        DuplicateWorkoutSetById$Mutation instance) =>
    <String, dynamic>{
      'duplicateWorkoutSetById': instance.duplicateWorkoutSetById.toJson(),
    };

ReorderWorkoutSets$Mutation _$ReorderWorkoutSets$MutationFromJson(
        Map<String, dynamic> json) =>
    ReorderWorkoutSets$Mutation()
      ..reorderWorkoutSets = (json['reorderWorkoutSets'] as List<dynamic>)
          .map((e) => SortPositionUpdated.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ReorderWorkoutSets$MutationToJson(
        ReorderWorkoutSets$Mutation instance) =>
    <String, dynamic>{
      'reorderWorkoutSets':
          instance.reorderWorkoutSets.map((e) => e.toJson()).toList(),
    };

CreateWorkoutSet _$CreateWorkoutSetFromJson(Map<String, dynamic> json) =>
    CreateWorkoutSet()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..sortPosition = json['sortPosition'] as int
      ..rounds = json['rounds'] as int
      ..duration = json['duration'] as int;

Map<String, dynamic> _$CreateWorkoutSetToJson(CreateWorkoutSet instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'sortPosition': instance.sortPosition,
      'rounds': instance.rounds,
      'duration': instance.duration,
    };

CreateWorkoutSet$Mutation _$CreateWorkoutSet$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateWorkoutSet$Mutation()
      ..createWorkoutSet = CreateWorkoutSet.fromJson(
          json['createWorkoutSet'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateWorkoutSet$MutationToJson(
        CreateWorkoutSet$Mutation instance) =>
    <String, dynamic>{
      'createWorkoutSet': instance.createWorkoutSet.toJson(),
    };

CreateWorkoutSetInput _$CreateWorkoutSetInputFromJson(
        Map<String, dynamic> json) =>
    CreateWorkoutSetInput(
      workoutSection: ConnectRelationInput.fromJson(
          json['WorkoutSection'] as Map<String, dynamic>),
      duration: json['duration'] as int?,
      rounds: json['rounds'] as int?,
      sortPosition: json['sortPosition'] as int,
    );

Map<String, dynamic> _$CreateWorkoutSetInputToJson(
        CreateWorkoutSetInput instance) =>
    <String, dynamic>{
      'WorkoutSection': instance.workoutSection.toJson(),
      'duration': instance.duration,
      'rounds': instance.rounds,
      'sortPosition': instance.sortPosition,
    };

DeleteWorkoutSetById$Mutation _$DeleteWorkoutSetById$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteWorkoutSetById$Mutation()
      ..deleteWorkoutSetById = json['deleteWorkoutSetById'] as String;

Map<String, dynamic> _$DeleteWorkoutSetById$MutationToJson(
        DeleteWorkoutSetById$Mutation instance) =>
    <String, dynamic>{
      'deleteWorkoutSetById': instance.deleteWorkoutSetById,
    };

DeleteBodyTransformationPhotosById$Mutation
    _$DeleteBodyTransformationPhotosById$MutationFromJson(
            Map<String, dynamic> json) =>
        DeleteBodyTransformationPhotosById$Mutation()
          ..deleteBodyTransformationPhotosById =
              (json['deleteBodyTransformationPhotosById'] as List<dynamic>)
                  .map((e) => e as String)
                  .toList();

Map<String, dynamic> _$DeleteBodyTransformationPhotosById$MutationToJson(
        DeleteBodyTransformationPhotosById$Mutation instance) =>
    <String, dynamic>{
      'deleteBodyTransformationPhotosById':
          instance.deleteBodyTransformationPhotosById,
    };

BodyTransformationPhoto _$BodyTransformationPhotoFromJson(
        Map<String, dynamic> json) =>
    BodyTransformationPhoto()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..takenOnDate =
          fromGraphQLDateTimeToDartDateTime(json['takenOnDate'] as int)
      ..bodyweight = (json['bodyweight'] as num?)?.toDouble()
      ..note = json['note'] as String?
      ..photoUri = json['photoUri'] as String;

Map<String, dynamic> _$BodyTransformationPhotoToJson(
        BodyTransformationPhoto instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'takenOnDate': fromDartDateTimeToGraphQLDateTime(instance.takenOnDate),
      'bodyweight': instance.bodyweight,
      'note': instance.note,
      'photoUri': instance.photoUri,
    };

UpdateBodyTransformationPhoto$Mutation
    _$UpdateBodyTransformationPhoto$MutationFromJson(
            Map<String, dynamic> json) =>
        UpdateBodyTransformationPhoto$Mutation()
          ..updateBodyTransformationPhoto = BodyTransformationPhoto.fromJson(
              json['updateBodyTransformationPhoto'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateBodyTransformationPhoto$MutationToJson(
        UpdateBodyTransformationPhoto$Mutation instance) =>
    <String, dynamic>{
      'updateBodyTransformationPhoto':
          instance.updateBodyTransformationPhoto.toJson(),
    };

UpdateBodyTransformationPhotoInput _$UpdateBodyTransformationPhotoInputFromJson(
        Map<String, dynamic> json) =>
    UpdateBodyTransformationPhotoInput(
      bodyweight: (json['bodyweight'] as num?)?.toDouble(),
      id: json['id'] as String,
      note: json['note'] as String?,
      photoUri: json['photoUri'] as String?,
      takenOnDate: fromGraphQLDateTimeNullableToDartDateTimeNullable(
          json['takenOnDate'] as int?),
    );

Map<String, dynamic> _$UpdateBodyTransformationPhotoInputToJson(
        UpdateBodyTransformationPhotoInput instance) =>
    <String, dynamic>{
      'bodyweight': instance.bodyweight,
      'id': instance.id,
      'note': instance.note,
      'photoUri': instance.photoUri,
      'takenOnDate': fromDartDateTimeNullableToGraphQLDateTimeNullable(
          instance.takenOnDate),
    };

CreateBodyTransformationPhotos$Mutation
    _$CreateBodyTransformationPhotos$MutationFromJson(
            Map<String, dynamic> json) =>
        CreateBodyTransformationPhotos$Mutation()
          ..createBodyTransformationPhotos =
              (json['createBodyTransformationPhotos'] as List<dynamic>)
                  .map((e) => BodyTransformationPhoto.fromJson(
                      e as Map<String, dynamic>))
                  .toList();

Map<String, dynamic> _$CreateBodyTransformationPhotos$MutationToJson(
        CreateBodyTransformationPhotos$Mutation instance) =>
    <String, dynamic>{
      'createBodyTransformationPhotos': instance.createBodyTransformationPhotos
          .map((e) => e.toJson())
          .toList(),
    };

CreateBodyTransformationPhotoInput _$CreateBodyTransformationPhotoInputFromJson(
        Map<String, dynamic> json) =>
    CreateBodyTransformationPhotoInput(
      bodyweight: (json['bodyweight'] as num?)?.toDouble(),
      note: json['note'] as String?,
      photoUri: json['photoUri'] as String,
      takenOnDate:
          fromGraphQLDateTimeToDartDateTime(json['takenOnDate'] as int),
    );

Map<String, dynamic> _$CreateBodyTransformationPhotoInputToJson(
        CreateBodyTransformationPhotoInput instance) =>
    <String, dynamic>{
      'bodyweight': instance.bodyweight,
      'note': instance.note,
      'photoUri': instance.photoUri,
      'takenOnDate': fromDartDateTimeToGraphQLDateTime(instance.takenOnDate),
    };

BodyTransformationPhotos$Query _$BodyTransformationPhotos$QueryFromJson(
        Map<String, dynamic> json) =>
    BodyTransformationPhotos$Query()
      ..bodyTransformationPhotos =
          (json['bodyTransformationPhotos'] as List<dynamic>)
              .map((e) =>
                  BodyTransformationPhoto.fromJson(e as Map<String, dynamic>))
              .toList();

Map<String, dynamic> _$BodyTransformationPhotos$QueryToJson(
        BodyTransformationPhotos$Query instance) =>
    <String, dynamic>{
      'bodyTransformationPhotos':
          instance.bodyTransformationPhotos.map((e) => e.toJson()).toList(),
    };

MoveTypes$Query _$MoveTypes$QueryFromJson(Map<String, dynamic> json) =>
    MoveTypes$Query()
      ..moveTypes = (json['moveTypes'] as List<dynamic>)
          .map((e) => MoveType.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$MoveTypes$QueryToJson(MoveTypes$Query instance) =>
    <String, dynamic>{
      'moveTypes': instance.moveTypes.map((e) => e.toJson()).toList(),
    };

StandardMoves$Query _$StandardMoves$QueryFromJson(Map<String, dynamic> json) =>
    StandardMoves$Query()
      ..standardMoves = (json['standardMoves'] as List<dynamic>)
          .map((e) => Move.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$StandardMoves$QueryToJson(
        StandardMoves$Query instance) =>
    <String, dynamic>{
      'standardMoves': instance.standardMoves.map((e) => e.toJson()).toList(),
    };

WorkoutGoals$Query _$WorkoutGoals$QueryFromJson(Map<String, dynamic> json) =>
    WorkoutGoals$Query()
      ..workoutGoals = (json['workoutGoals'] as List<dynamic>)
          .map((e) => WorkoutGoal.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$WorkoutGoals$QueryToJson(WorkoutGoals$Query instance) =>
    <String, dynamic>{
      'workoutGoals': instance.workoutGoals.map((e) => e.toJson()).toList(),
    };

CheckUniqueDisplayName$Query _$CheckUniqueDisplayName$QueryFromJson(
        Map<String, dynamic> json) =>
    CheckUniqueDisplayName$Query()
      ..checkUniqueDisplayName = json['checkUniqueDisplayName'] as bool;

Map<String, dynamic> _$CheckUniqueDisplayName$QueryToJson(
        CheckUniqueDisplayName$Query instance) =>
    <String, dynamic>{
      'checkUniqueDisplayName': instance.checkUniqueDisplayName,
    };

WorkoutSectionTypes$Query _$WorkoutSectionTypes$QueryFromJson(
        Map<String, dynamic> json) =>
    WorkoutSectionTypes$Query()
      ..workoutSectionTypes = (json['workoutSectionTypes'] as List<dynamic>)
          .map((e) => WorkoutSectionType.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$WorkoutSectionTypes$QueryToJson(
        WorkoutSectionTypes$Query instance) =>
    <String, dynamic>{
      'workoutSectionTypes':
          instance.workoutSectionTypes.map((e) => e.toJson()).toList(),
    };

BodyAreas$Query _$BodyAreas$QueryFromJson(Map<String, dynamic> json) =>
    BodyAreas$Query()
      ..bodyAreas = (json['bodyAreas'] as List<dynamic>)
          .map((e) => BodyArea.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$BodyAreas$QueryToJson(BodyAreas$Query instance) =>
    <String, dynamic>{
      'bodyAreas': instance.bodyAreas.map((e) => e.toJson()).toList(),
    };

Equipments$Query _$Equipments$QueryFromJson(Map<String, dynamic> json) =>
    Equipments$Query()
      ..equipments = (json['equipments'] as List<dynamic>)
          .map((e) => Equipment.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$Equipments$QueryToJson(Equipments$Query instance) =>
    <String, dynamic>{
      'equipments': instance.equipments.map((e) => e.toJson()).toList(),
    };

DeleteUserBenchmarkTagById$Mutation
    _$DeleteUserBenchmarkTagById$MutationFromJson(Map<String, dynamic> json) =>
        DeleteUserBenchmarkTagById$Mutation()
          ..deleteUserBenchmarkTagById =
              json['deleteUserBenchmarkTagById'] as String;

Map<String, dynamic> _$DeleteUserBenchmarkTagById$MutationToJson(
        DeleteUserBenchmarkTagById$Mutation instance) =>
    <String, dynamic>{
      'deleteUserBenchmarkTagById': instance.deleteUserBenchmarkTagById,
    };

UserBenchmarkEntry _$UserBenchmarkEntryFromJson(Map<String, dynamic> json) =>
    UserBenchmarkEntry()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..completedOn =
          fromGraphQLDateTimeToDartDateTime(json['completedOn'] as int)
      ..score = (json['score'] as num).toDouble()
      ..note = json['note'] as String?
      ..videoUri = json['videoUri'] as String?
      ..videoThumbUri = json['videoThumbUri'] as String?;

Map<String, dynamic> _$UserBenchmarkEntryToJson(UserBenchmarkEntry instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'completedOn': fromDartDateTimeToGraphQLDateTime(instance.completedOn),
      'score': instance.score,
      'note': instance.note,
      'videoUri': instance.videoUri,
      'videoThumbUri': instance.videoThumbUri,
    };

CreateUserBenchmarkEntry$Mutation _$CreateUserBenchmarkEntry$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateUserBenchmarkEntry$Mutation()
      ..createUserBenchmarkEntry = UserBenchmarkEntry.fromJson(
          json['createUserBenchmarkEntry'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateUserBenchmarkEntry$MutationToJson(
        CreateUserBenchmarkEntry$Mutation instance) =>
    <String, dynamic>{
      'createUserBenchmarkEntry': instance.createUserBenchmarkEntry.toJson(),
    };

CreateUserBenchmarkEntryInput _$CreateUserBenchmarkEntryInputFromJson(
        Map<String, dynamic> json) =>
    CreateUserBenchmarkEntryInput(
      userBenchmark: ConnectRelationInput.fromJson(
          json['UserBenchmark'] as Map<String, dynamic>),
      completedOn:
          fromGraphQLDateTimeToDartDateTime(json['completedOn'] as int),
      note: json['note'] as String?,
      score: (json['score'] as num).toDouble(),
      videoThumbUri: json['videoThumbUri'] as String?,
      videoUri: json['videoUri'] as String?,
    );

Map<String, dynamic> _$CreateUserBenchmarkEntryInputToJson(
        CreateUserBenchmarkEntryInput instance) =>
    <String, dynamic>{
      'UserBenchmark': instance.userBenchmark.toJson(),
      'completedOn': fromDartDateTimeToGraphQLDateTime(instance.completedOn),
      'note': instance.note,
      'score': instance.score,
      'videoThumbUri': instance.videoThumbUri,
      'videoUri': instance.videoUri,
    };

UserBenchmarkTag _$UserBenchmarkTagFromJson(Map<String, dynamic> json) =>
    UserBenchmarkTag()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..name = json['name'] as String
      ..description = json['description'] as String?;

Map<String, dynamic> _$UserBenchmarkTagToJson(UserBenchmarkTag instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };

CreateUserBenchmarkTag$Mutation _$CreateUserBenchmarkTag$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateUserBenchmarkTag$Mutation()
      ..createUserBenchmarkTag = UserBenchmarkTag.fromJson(
          json['createUserBenchmarkTag'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateUserBenchmarkTag$MutationToJson(
        CreateUserBenchmarkTag$Mutation instance) =>
    <String, dynamic>{
      'createUserBenchmarkTag': instance.createUserBenchmarkTag.toJson(),
    };

CreateUserBenchmarkTagInput _$CreateUserBenchmarkTagInputFromJson(
        Map<String, dynamic> json) =>
    CreateUserBenchmarkTagInput(
      description: json['description'] as String?,
      name: json['name'] as String,
    );

Map<String, dynamic> _$CreateUserBenchmarkTagInputToJson(
        CreateUserBenchmarkTagInput instance) =>
    <String, dynamic>{
      'description': instance.description,
      'name': instance.name,
    };

UserBenchmarkTags$Query _$UserBenchmarkTags$QueryFromJson(
        Map<String, dynamic> json) =>
    UserBenchmarkTags$Query()
      ..userBenchmarkTags = (json['userBenchmarkTags'] as List<dynamic>)
          .map((e) => UserBenchmarkTag.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserBenchmarkTags$QueryToJson(
        UserBenchmarkTags$Query instance) =>
    <String, dynamic>{
      'userBenchmarkTags':
          instance.userBenchmarkTags.map((e) => e.toJson()).toList(),
    };

UpdateUserBenchmarkTag$Mutation _$UpdateUserBenchmarkTag$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateUserBenchmarkTag$Mutation()
      ..updateUserBenchmarkTag = UserBenchmarkTag.fromJson(
          json['updateUserBenchmarkTag'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateUserBenchmarkTag$MutationToJson(
        UpdateUserBenchmarkTag$Mutation instance) =>
    <String, dynamic>{
      'updateUserBenchmarkTag': instance.updateUserBenchmarkTag.toJson(),
    };

UpdateUserBenchmarkTagInput _$UpdateUserBenchmarkTagInputFromJson(
        Map<String, dynamic> json) =>
    UpdateUserBenchmarkTagInput(
      description: json['description'] as String?,
      id: json['id'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$UpdateUserBenchmarkTagInputToJson(
        UpdateUserBenchmarkTagInput instance) =>
    <String, dynamic>{
      'description': instance.description,
      'id': instance.id,
      'name': instance.name,
    };

UpdateUserBenchmarkEntry$Mutation _$UpdateUserBenchmarkEntry$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateUserBenchmarkEntry$Mutation()
      ..updateUserBenchmarkEntry = UserBenchmarkEntry.fromJson(
          json['updateUserBenchmarkEntry'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateUserBenchmarkEntry$MutationToJson(
        UpdateUserBenchmarkEntry$Mutation instance) =>
    <String, dynamic>{
      'updateUserBenchmarkEntry': instance.updateUserBenchmarkEntry.toJson(),
    };

UpdateUserBenchmarkEntryInput _$UpdateUserBenchmarkEntryInputFromJson(
        Map<String, dynamic> json) =>
    UpdateUserBenchmarkEntryInput(
      completedOn: fromGraphQLDateTimeNullableToDartDateTimeNullable(
          json['completedOn'] as int?),
      id: json['id'] as String,
      note: json['note'] as String?,
      score: (json['score'] as num?)?.toDouble(),
      videoThumbUri: json['videoThumbUri'] as String?,
      videoUri: json['videoUri'] as String?,
    );

Map<String, dynamic> _$UpdateUserBenchmarkEntryInputToJson(
        UpdateUserBenchmarkEntryInput instance) =>
    <String, dynamic>{
      'completedOn': fromDartDateTimeNullableToGraphQLDateTimeNullable(
          instance.completedOn),
      'id': instance.id,
      'note': instance.note,
      'score': instance.score,
      'videoThumbUri': instance.videoThumbUri,
      'videoUri': instance.videoUri,
    };

DeleteUserBenchmarkEntryById$Mutation
    _$DeleteUserBenchmarkEntryById$MutationFromJson(
            Map<String, dynamic> json) =>
        DeleteUserBenchmarkEntryById$Mutation()
          ..deleteUserBenchmarkEntryById =
              json['deleteUserBenchmarkEntryById'] as String;

Map<String, dynamic> _$DeleteUserBenchmarkEntryById$MutationToJson(
        DeleteUserBenchmarkEntryById$Mutation instance) =>
    <String, dynamic>{
      'deleteUserBenchmarkEntryById': instance.deleteUserBenchmarkEntryById,
    };

UserBenchmark _$UserBenchmarkFromJson(Map<String, dynamic> json) =>
    UserBenchmark()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..lastEntryAt =
          fromGraphQLDateTimeToDartDateTime(json['lastEntryAt'] as int)
      ..name = json['name'] as String
      ..description = json['description'] as String?
      ..equipmentInfo = json['equipmentInfo'] as String?
      ..benchmarkType = _$enumDecode(
          _$BenchmarkTypeEnumMap, json['benchmarkType'],
          unknownValue: BenchmarkType.artemisUnknown)
      ..loadUnit = _$enumDecode(_$LoadUnitEnumMap, json['loadUnit'],
          unknownValue: LoadUnit.artemisUnknown)
      ..userBenchmarkEntries = (json['UserBenchmarkEntries'] as List<dynamic>)
          .map((e) => UserBenchmarkEntry.fromJson(e as Map<String, dynamic>))
          .toList()
      ..userBenchmarkTags = (json['UserBenchmarkTags'] as List<dynamic>)
          .map((e) => UserBenchmarkTag.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserBenchmarkToJson(UserBenchmark instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'lastEntryAt': fromDartDateTimeToGraphQLDateTime(instance.lastEntryAt),
      'name': instance.name,
      'description': instance.description,
      'equipmentInfo': instance.equipmentInfo,
      'benchmarkType': _$BenchmarkTypeEnumMap[instance.benchmarkType],
      'loadUnit': _$LoadUnitEnumMap[instance.loadUnit],
      'UserBenchmarkEntries':
          instance.userBenchmarkEntries.map((e) => e.toJson()).toList(),
      'UserBenchmarkTags':
          instance.userBenchmarkTags.map((e) => e.toJson()).toList(),
    };

const _$BenchmarkTypeEnumMap = {
  BenchmarkType.amrap: 'AMRAP',
  BenchmarkType.fastesttime: 'FASTESTTIME',
  BenchmarkType.maxload: 'MAXLOAD',
  BenchmarkType.unbrokenreps: 'UNBROKENREPS',
  BenchmarkType.unbrokentime: 'UNBROKENTIME',
  BenchmarkType.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

UpdateUserBenchmark$Mutation _$UpdateUserBenchmark$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateUserBenchmark$Mutation()
      ..updateUserBenchmark = UserBenchmark.fromJson(
          json['updateUserBenchmark'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateUserBenchmark$MutationToJson(
        UpdateUserBenchmark$Mutation instance) =>
    <String, dynamic>{
      'updateUserBenchmark': instance.updateUserBenchmark.toJson(),
    };

UpdateUserBenchmarkInput _$UpdateUserBenchmarkInputFromJson(
        Map<String, dynamic> json) =>
    UpdateUserBenchmarkInput(
      userBenchmarkTags: (json['UserBenchmarkTags'] as List<dynamic>?)
          ?.map((e) => ConnectRelationInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      benchmarkType: _$enumDecode(_$BenchmarkTypeEnumMap, json['benchmarkType'],
          unknownValue: BenchmarkType.artemisUnknown),
      description: json['description'] as String?,
      equipmentInfo: json['equipmentInfo'] as String?,
      id: json['id'] as String,
      loadUnit: _$enumDecodeNullable(_$LoadUnitEnumMap, json['loadUnit'],
          unknownValue: LoadUnit.artemisUnknown),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$UpdateUserBenchmarkInputToJson(
        UpdateUserBenchmarkInput instance) =>
    <String, dynamic>{
      'UserBenchmarkTags':
          instance.userBenchmarkTags?.map((e) => e.toJson()).toList(),
      'benchmarkType': _$BenchmarkTypeEnumMap[instance.benchmarkType],
      'description': instance.description,
      'equipmentInfo': instance.equipmentInfo,
      'id': instance.id,
      'loadUnit': _$LoadUnitEnumMap[instance.loadUnit],
      'name': instance.name,
    };

CreateUserBenchmark$Mutation _$CreateUserBenchmark$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateUserBenchmark$Mutation()
      ..createUserBenchmark = UserBenchmark.fromJson(
          json['createUserBenchmark'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateUserBenchmark$MutationToJson(
        CreateUserBenchmark$Mutation instance) =>
    <String, dynamic>{
      'createUserBenchmark': instance.createUserBenchmark.toJson(),
    };

CreateUserBenchmarkInput _$CreateUserBenchmarkInputFromJson(
        Map<String, dynamic> json) =>
    CreateUserBenchmarkInput(
      userBenchmarkTags: (json['UserBenchmarkTags'] as List<dynamic>?)
          ?.map((e) => ConnectRelationInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      benchmarkType: _$enumDecode(_$BenchmarkTypeEnumMap, json['benchmarkType'],
          unknownValue: BenchmarkType.artemisUnknown),
      description: json['description'] as String?,
      equipmentInfo: json['equipmentInfo'] as String?,
      loadUnit: _$enumDecodeNullable(_$LoadUnitEnumMap, json['loadUnit'],
          unknownValue: LoadUnit.artemisUnknown),
      name: json['name'] as String,
    );

Map<String, dynamic> _$CreateUserBenchmarkInputToJson(
        CreateUserBenchmarkInput instance) =>
    <String, dynamic>{
      'UserBenchmarkTags':
          instance.userBenchmarkTags?.map((e) => e.toJson()).toList(),
      'benchmarkType': _$BenchmarkTypeEnumMap[instance.benchmarkType],
      'description': instance.description,
      'equipmentInfo': instance.equipmentInfo,
      'loadUnit': _$LoadUnitEnumMap[instance.loadUnit],
      'name': instance.name,
    };

DeleteUserBenchmarkById$Mutation _$DeleteUserBenchmarkById$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteUserBenchmarkById$Mutation()
      ..deleteUserBenchmarkById = json['deleteUserBenchmarkById'] as String;

Map<String, dynamic> _$DeleteUserBenchmarkById$MutationToJson(
        DeleteUserBenchmarkById$Mutation instance) =>
    <String, dynamic>{
      'deleteUserBenchmarkById': instance.deleteUserBenchmarkById,
    };

UserBenchmarks$Query _$UserBenchmarks$QueryFromJson(
        Map<String, dynamic> json) =>
    UserBenchmarks$Query()
      ..userBenchmarks = (json['userBenchmarks'] as List<dynamic>)
          .map((e) => UserBenchmark.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserBenchmarks$QueryToJson(
        UserBenchmarks$Query instance) =>
    <String, dynamic>{
      'userBenchmarks': instance.userBenchmarks.map((e) => e.toJson()).toList(),
    };

UserBenchmarkById$Query _$UserBenchmarkById$QueryFromJson(
        Map<String, dynamic> json) =>
    UserBenchmarkById$Query()
      ..userBenchmarkById = UserBenchmark.fromJson(
          json['userBenchmarkById'] as Map<String, dynamic>);

Map<String, dynamic> _$UserBenchmarkById$QueryToJson(
        UserBenchmarkById$Query instance) =>
    <String, dynamic>{
      'userBenchmarkById': instance.userBenchmarkById.toJson(),
    };

TextSearchWorkoutPlans$Query _$TextSearchWorkoutPlans$QueryFromJson(
        Map<String, dynamic> json) =>
    TextSearchWorkoutPlans$Query()
      ..textSearchWorkoutPlans =
          (json['textSearchWorkoutPlans'] as List<dynamic>?)
              ?.map((e) => WorkoutPlan.fromJson(e as Map<String, dynamic>))
              .toList();

Map<String, dynamic> _$TextSearchWorkoutPlans$QueryToJson(
        TextSearchWorkoutPlans$Query instance) =>
    <String, dynamic>{
      'textSearchWorkoutPlans':
          instance.textSearchWorkoutPlans?.map((e) => e.toJson()).toList(),
    };

TextSearchResult _$TextSearchResultFromJson(Map<String, dynamic> json) =>
    TextSearchResult()
      ..id = json['id'] as String
      ..$$typename = json['__typename'] as String?
      ..name = json['name'] as String;

Map<String, dynamic> _$TextSearchResultToJson(TextSearchResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      '__typename': instance.$$typename,
      'name': instance.name,
    };

TextSearchWorkoutPlanNames$Query _$TextSearchWorkoutPlanNames$QueryFromJson(
        Map<String, dynamic> json) =>
    TextSearchWorkoutPlanNames$Query()
      ..textSearchWorkoutPlanNames =
          (json['textSearchWorkoutPlanNames'] as List<dynamic>?)
              ?.map((e) => TextSearchResult.fromJson(e as Map<String, dynamic>))
              .toList();

Map<String, dynamic> _$TextSearchWorkoutPlanNames$QueryToJson(
        TextSearchWorkoutPlanNames$Query instance) =>
    <String, dynamic>{
      'textSearchWorkoutPlanNames':
          instance.textSearchWorkoutPlanNames?.map((e) => e.toJson()).toList(),
    };

TextSearchWorkouts$Query _$TextSearchWorkouts$QueryFromJson(
        Map<String, dynamic> json) =>
    TextSearchWorkouts$Query()
      ..textSearchWorkouts = (json['textSearchWorkouts'] as List<dynamic>?)
          ?.map((e) => Workout.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$TextSearchWorkouts$QueryToJson(
        TextSearchWorkouts$Query instance) =>
    <String, dynamic>{
      'textSearchWorkouts':
          instance.textSearchWorkouts?.map((e) => e.toJson()).toList(),
    };

TextSearchWorkoutNames$Query _$TextSearchWorkoutNames$QueryFromJson(
        Map<String, dynamic> json) =>
    TextSearchWorkoutNames$Query()
      ..textSearchWorkoutNames =
          (json['textSearchWorkoutNames'] as List<dynamic>?)
              ?.map((e) => TextSearchResult.fromJson(e as Map<String, dynamic>))
              .toList();

Map<String, dynamic> _$TextSearchWorkoutNames$QueryToJson(
        TextSearchWorkoutNames$Query instance) =>
    <String, dynamic>{
      'textSearchWorkoutNames':
          instance.textSearchWorkoutNames?.map((e) => e.toJson()).toList(),
    };

UpdateWorkoutSection _$UpdateWorkoutSectionFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutSection()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..name = json['name'] as String?
      ..note = json['note'] as String?
      ..rounds = json['rounds'] as int
      ..timecap = json['timecap'] as int
      ..sortPosition = json['sortPosition'] as int
      ..introVideoUri = json['introVideoUri'] as String?
      ..introVideoThumbUri = json['introVideoThumbUri'] as String?
      ..introAudioUri = json['introAudioUri'] as String?
      ..classVideoUri = json['classVideoUri'] as String?
      ..classVideoThumbUri = json['classVideoThumbUri'] as String?
      ..classAudioUri = json['classAudioUri'] as String?
      ..workoutSectionType = WorkoutSectionType.fromJson(
          json['WorkoutSectionType'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateWorkoutSectionToJson(
        UpdateWorkoutSection instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'name': instance.name,
      'note': instance.note,
      'rounds': instance.rounds,
      'timecap': instance.timecap,
      'sortPosition': instance.sortPosition,
      'introVideoUri': instance.introVideoUri,
      'introVideoThumbUri': instance.introVideoThumbUri,
      'introAudioUri': instance.introAudioUri,
      'classVideoUri': instance.classVideoUri,
      'classVideoThumbUri': instance.classVideoThumbUri,
      'classAudioUri': instance.classAudioUri,
      'WorkoutSectionType': instance.workoutSectionType.toJson(),
    };

UpdateWorkoutSection$Mutation _$UpdateWorkoutSection$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutSection$Mutation()
      ..updateWorkoutSection = UpdateWorkoutSection.fromJson(
          json['updateWorkoutSection'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateWorkoutSection$MutationToJson(
        UpdateWorkoutSection$Mutation instance) =>
    <String, dynamic>{
      'updateWorkoutSection': instance.updateWorkoutSection.toJson(),
    };

UpdateWorkoutSectionInput _$UpdateWorkoutSectionInputFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutSectionInput(
      workoutSectionType: json['WorkoutSectionType'] == null
          ? null
          : ConnectRelationInput.fromJson(
              json['WorkoutSectionType'] as Map<String, dynamic>),
      classAudioUri: json['classAudioUri'] as String?,
      classVideoThumbUri: json['classVideoThumbUri'] as String?,
      classVideoUri: json['classVideoUri'] as String?,
      id: json['id'] as String,
      introAudioUri: json['introAudioUri'] as String?,
      introVideoThumbUri: json['introVideoThumbUri'] as String?,
      introVideoUri: json['introVideoUri'] as String?,
      name: json['name'] as String?,
      note: json['note'] as String?,
      rounds: json['rounds'] as int?,
      timecap: json['timecap'] as int?,
    );

Map<String, dynamic> _$UpdateWorkoutSectionInputToJson(
        UpdateWorkoutSectionInput instance) =>
    <String, dynamic>{
      'WorkoutSectionType': instance.workoutSectionType?.toJson(),
      'classAudioUri': instance.classAudioUri,
      'classVideoThumbUri': instance.classVideoThumbUri,
      'classVideoUri': instance.classVideoUri,
      'id': instance.id,
      'introAudioUri': instance.introAudioUri,
      'introVideoThumbUri': instance.introVideoThumbUri,
      'introVideoUri': instance.introVideoUri,
      'name': instance.name,
      'note': instance.note,
      'rounds': instance.rounds,
      'timecap': instance.timecap,
    };

WorkoutSection _$WorkoutSectionFromJson(Map<String, dynamic> json) =>
    WorkoutSection()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..name = json['name'] as String?
      ..note = json['note'] as String?
      ..rounds = json['rounds'] as int
      ..timecap = json['timecap'] as int
      ..sortPosition = json['sortPosition'] as int
      ..introVideoUri = json['introVideoUri'] as String?
      ..introVideoThumbUri = json['introVideoThumbUri'] as String?
      ..introAudioUri = json['introAudioUri'] as String?
      ..classVideoUri = json['classVideoUri'] as String?
      ..classVideoThumbUri = json['classVideoThumbUri'] as String?
      ..classAudioUri = json['classAudioUri'] as String?
      ..workoutSectionType = WorkoutSectionType.fromJson(
          json['WorkoutSectionType'] as Map<String, dynamic>)
      ..workoutSets = (json['WorkoutSets'] as List<dynamic>)
          .map((e) => WorkoutSet.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$WorkoutSectionToJson(WorkoutSection instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'name': instance.name,
      'note': instance.note,
      'rounds': instance.rounds,
      'timecap': instance.timecap,
      'sortPosition': instance.sortPosition,
      'introVideoUri': instance.introVideoUri,
      'introVideoThumbUri': instance.introVideoThumbUri,
      'introAudioUri': instance.introAudioUri,
      'classVideoUri': instance.classVideoUri,
      'classVideoThumbUri': instance.classVideoThumbUri,
      'classAudioUri': instance.classAudioUri,
      'WorkoutSectionType': instance.workoutSectionType.toJson(),
      'WorkoutSets': instance.workoutSets.map((e) => e.toJson()).toList(),
    };

CreateWorkoutSection$Mutation _$CreateWorkoutSection$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateWorkoutSection$Mutation()
      ..createWorkoutSection = WorkoutSection.fromJson(
          json['createWorkoutSection'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateWorkoutSection$MutationToJson(
        CreateWorkoutSection$Mutation instance) =>
    <String, dynamic>{
      'createWorkoutSection': instance.createWorkoutSection.toJson(),
    };

CreateWorkoutSectionInput _$CreateWorkoutSectionInputFromJson(
        Map<String, dynamic> json) =>
    CreateWorkoutSectionInput(
      workout: ConnectRelationInput.fromJson(
          json['Workout'] as Map<String, dynamic>),
      workoutSectionType: ConnectRelationInput.fromJson(
          json['WorkoutSectionType'] as Map<String, dynamic>),
      classAudioUri: json['classAudioUri'] as String?,
      classVideoThumbUri: json['classVideoThumbUri'] as String?,
      classVideoUri: json['classVideoUri'] as String?,
      introAudioUri: json['introAudioUri'] as String?,
      introVideoThumbUri: json['introVideoThumbUri'] as String?,
      introVideoUri: json['introVideoUri'] as String?,
      name: json['name'] as String?,
      note: json['note'] as String?,
      rounds: json['rounds'] as int?,
      sortPosition: json['sortPosition'] as int,
      timecap: json['timecap'] as int?,
    );

Map<String, dynamic> _$CreateWorkoutSectionInputToJson(
        CreateWorkoutSectionInput instance) =>
    <String, dynamic>{
      'Workout': instance.workout.toJson(),
      'WorkoutSectionType': instance.workoutSectionType.toJson(),
      'classAudioUri': instance.classAudioUri,
      'classVideoThumbUri': instance.classVideoThumbUri,
      'classVideoUri': instance.classVideoUri,
      'introAudioUri': instance.introAudioUri,
      'introVideoThumbUri': instance.introVideoThumbUri,
      'introVideoUri': instance.introVideoUri,
      'name': instance.name,
      'note': instance.note,
      'rounds': instance.rounds,
      'sortPosition': instance.sortPosition,
      'timecap': instance.timecap,
    };

ReorderWorkoutSections$Mutation _$ReorderWorkoutSections$MutationFromJson(
        Map<String, dynamic> json) =>
    ReorderWorkoutSections$Mutation()
      ..reorderWorkoutSections = (json['reorderWorkoutSections']
              as List<dynamic>)
          .map((e) => SortPositionUpdated.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ReorderWorkoutSections$MutationToJson(
        ReorderWorkoutSections$Mutation instance) =>
    <String, dynamic>{
      'reorderWorkoutSections':
          instance.reorderWorkoutSections.map((e) => e.toJson()).toList(),
    };

DeleteWorkoutSectionById$Mutation _$DeleteWorkoutSectionById$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteWorkoutSectionById$Mutation()
      ..deleteWorkoutSectionById = json['deleteWorkoutSectionById'] as String;

Map<String, dynamic> _$DeleteWorkoutSectionById$MutationToJson(
        DeleteWorkoutSectionById$Mutation instance) =>
    <String, dynamic>{
      'deleteWorkoutSectionById': instance.deleteWorkoutSectionById,
    };

TimelinePostObjectDataUser _$TimelinePostObjectDataUserFromJson(
        Map<String, dynamic> json) =>
    TimelinePostObjectDataUser()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..displayName = json['displayName'] as String
      ..avatarUri = json['avatarUri'] as String?;

Map<String, dynamic> _$TimelinePostObjectDataUserToJson(
        TimelinePostObjectDataUser instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'displayName': instance.displayName,
      'avatarUri': instance.avatarUri,
    };

TimelinePostObjectDataObject _$TimelinePostObjectDataObjectFromJson(
        Map<String, dynamic> json) =>
    TimelinePostObjectDataObject()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..type = _$enumDecode(_$TimelinePostTypeEnumMap, json['type'],
          unknownValue: TimelinePostType.artemisUnknown)
      ..name = json['name'] as String
      ..introAudioUri = json['introAudioUri'] as String?
      ..coverImageUri = json['coverImageUri'] as String?
      ..introVideoUri = json['introVideoUri'] as String?
      ..introVideoThumbUri = json['introVideoThumbUri'] as String?;

Map<String, dynamic> _$TimelinePostObjectDataObjectToJson(
        TimelinePostObjectDataObject instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'type': _$TimelinePostTypeEnumMap[instance.type],
      'name': instance.name,
      'introAudioUri': instance.introAudioUri,
      'coverImageUri': instance.coverImageUri,
      'introVideoUri': instance.introVideoUri,
      'introVideoThumbUri': instance.introVideoThumbUri,
    };

const _$TimelinePostTypeEnumMap = {
  TimelinePostType.workout: 'WORKOUT',
  TimelinePostType.workoutplan: 'WORKOUTPLAN',
  TimelinePostType.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

TimelinePostFullData _$TimelinePostFullDataFromJson(
        Map<String, dynamic> json) =>
    TimelinePostFullData()
      ..activityId = json['activityId'] as String
      ..postedAt = fromGraphQLDateTimeToDartDateTime(json['postedAt'] as int)
      ..caption = json['caption'] as String?
      ..tags = (json['tags'] as List<dynamic>).map((e) => e as String).toList()
      ..poster = TimelinePostObjectDataUser.fromJson(
          json['poster'] as Map<String, dynamic>)
      ..creator = TimelinePostObjectDataUser.fromJson(
          json['creator'] as Map<String, dynamic>)
      ..object = TimelinePostObjectDataObject.fromJson(
          json['object'] as Map<String, dynamic>);

Map<String, dynamic> _$TimelinePostFullDataToJson(
        TimelinePostFullData instance) =>
    <String, dynamic>{
      'activityId': instance.activityId,
      'postedAt': fromDartDateTimeToGraphQLDateTime(instance.postedAt),
      'caption': instance.caption,
      'tags': instance.tags,
      'poster': instance.poster.toJson(),
      'creator': instance.creator.toJson(),
      'object': instance.object.toJson(),
    };

CreateClubTimelinePost$Mutation _$CreateClubTimelinePost$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateClubTimelinePost$Mutation()
      ..createClubTimelinePost = TimelinePostFullData.fromJson(
          json['createClubTimelinePost'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateClubTimelinePost$MutationToJson(
        CreateClubTimelinePost$Mutation instance) =>
    <String, dynamic>{
      'createClubTimelinePost': instance.createClubTimelinePost.toJson(),
    };

CreateClubTimelinePostInput _$CreateClubTimelinePostInputFromJson(
        Map<String, dynamic> json) =>
    CreateClubTimelinePostInput(
      caption: json['caption'] as String?,
      clubId: json['clubId'] as String,
      object: json['object'] as String,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$CreateClubTimelinePostInputToJson(
        CreateClubTimelinePostInput instance) =>
    <String, dynamic>{
      'caption': instance.caption,
      'clubId': instance.clubId,
      'object': instance.object,
      'tags': instance.tags,
    };

DeleteClubTimelinePost$Mutation _$DeleteClubTimelinePost$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteClubTimelinePost$Mutation()
      ..deleteClubTimelinePost = json['deleteClubTimelinePost'] as String;

Map<String, dynamic> _$DeleteClubTimelinePost$MutationToJson(
        DeleteClubTimelinePost$Mutation instance) =>
    <String, dynamic>{
      'deleteClubTimelinePost': instance.deleteClubTimelinePost,
    };

TimelinePostObjectData _$TimelinePostObjectDataFromJson(
        Map<String, dynamic> json) =>
    TimelinePostObjectData()
      ..activityId = json['activityId'] as String
      ..poster = TimelinePostObjectDataUser.fromJson(
          json['poster'] as Map<String, dynamic>)
      ..creator = TimelinePostObjectDataUser.fromJson(
          json['creator'] as Map<String, dynamic>)
      ..object = TimelinePostObjectDataObject.fromJson(
          json['object'] as Map<String, dynamic>);

Map<String, dynamic> _$TimelinePostObjectDataToJson(
        TimelinePostObjectData instance) =>
    <String, dynamic>{
      'activityId': instance.activityId,
      'poster': instance.poster.toJson(),
      'creator': instance.creator.toJson(),
      'object': instance.object.toJson(),
    };

TimelinePostsData$Query _$TimelinePostsData$QueryFromJson(
        Map<String, dynamic> json) =>
    TimelinePostsData$Query()
      ..timelinePostsData = (json['timelinePostsData'] as List<dynamic>)
          .map(
              (e) => TimelinePostObjectData.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$TimelinePostsData$QueryToJson(
        TimelinePostsData$Query instance) =>
    <String, dynamic>{
      'timelinePostsData':
          instance.timelinePostsData.map((e) => e.toJson()).toList(),
    };

TimelinePostDataRequestInput _$TimelinePostDataRequestInputFromJson(
        Map<String, dynamic> json) =>
    TimelinePostDataRequestInput(
      activityId: json['activityId'] as String,
      objectId: json['objectId'] as String,
      objectType: _$enumDecode(_$TimelinePostTypeEnumMap, json['objectType'],
          unknownValue: TimelinePostType.artemisUnknown),
      posterId: json['posterId'] as String,
    );

Map<String, dynamic> _$TimelinePostDataRequestInputToJson(
        TimelinePostDataRequestInput instance) =>
    <String, dynamic>{
      'activityId': instance.activityId,
      'objectId': instance.objectId,
      'objectType': _$TimelinePostTypeEnumMap[instance.objectType],
      'posterId': instance.posterId,
    };

ClubMembersFeedPosts$Query _$ClubMembersFeedPosts$QueryFromJson(
        Map<String, dynamic> json) =>
    ClubMembersFeedPosts$Query()
      ..clubMembersFeedPosts = (json['clubMembersFeedPosts'] as List<dynamic>)
          .map((e) => TimelinePostFullData.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ClubMembersFeedPosts$QueryToJson(
        ClubMembersFeedPosts$Query instance) =>
    <String, dynamic>{
      'clubMembersFeedPosts':
          instance.clubMembersFeedPosts.map((e) => e.toJson()).toList(),
    };

PublicWorkouts$Query _$PublicWorkouts$QueryFromJson(
        Map<String, dynamic> json) =>
    PublicWorkouts$Query()
      ..publicWorkouts = (json['publicWorkouts'] as List<dynamic>)
          .map((e) => Workout.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$PublicWorkouts$QueryToJson(
        PublicWorkouts$Query instance) =>
    <String, dynamic>{
      'publicWorkouts': instance.publicWorkouts.map((e) => e.toJson()).toList(),
    };

WorkoutFiltersInput _$WorkoutFiltersInputFromJson(Map<String, dynamic> json) =>
    WorkoutFiltersInput(
      availableEquipments: (json['availableEquipments'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      bodyweightOnly: json['bodyweightOnly'] as bool?,
      difficultyLevel: _$enumDecodeNullable(
          _$DifficultyLevelEnumMap, json['difficultyLevel'],
          unknownValue: DifficultyLevel.artemisUnknown),
      excludedMoves: (json['excludedMoves'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      hasClassAudio: json['hasClassAudio'] as bool?,
      hasClassVideo: json['hasClassVideo'] as bool?,
      maxLength: json['maxLength'] as int?,
      minLength: json['minLength'] as int?,
      requiredMoves: (json['requiredMoves'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      targetedBodyAreas: (json['targetedBodyAreas'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      workoutGoals: (json['workoutGoals'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      workoutSectionTypes: (json['workoutSectionTypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$WorkoutFiltersInputToJson(
        WorkoutFiltersInput instance) =>
    <String, dynamic>{
      'availableEquipments': instance.availableEquipments,
      'bodyweightOnly': instance.bodyweightOnly,
      'difficultyLevel': _$DifficultyLevelEnumMap[instance.difficultyLevel],
      'excludedMoves': instance.excludedMoves,
      'hasClassAudio': instance.hasClassAudio,
      'hasClassVideo': instance.hasClassVideo,
      'maxLength': instance.maxLength,
      'minLength': instance.minLength,
      'requiredMoves': instance.requiredMoves,
      'targetedBodyAreas': instance.targetedBodyAreas,
      'workoutGoals': instance.workoutGoals,
      'workoutSectionTypes': instance.workoutSectionTypes,
    };

UpdateWorkout _$UpdateWorkoutFromJson(Map<String, dynamic> json) =>
    UpdateWorkout()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..archived = json['archived'] as bool
      ..name = json['name'] as String
      ..description = json['description'] as String?
      ..lengthMinutes = json['lengthMinutes'] as int?
      ..difficultyLevel = _$enumDecode(
          _$DifficultyLevelEnumMap, json['difficultyLevel'],
          unknownValue: DifficultyLevel.artemisUnknown)
      ..coverImageUri = json['coverImageUri'] as String?
      ..contentAccessScope = _$enumDecode(
          _$ContentAccessScopeEnumMap, json['contentAccessScope'],
          unknownValue: ContentAccessScope.artemisUnknown)
      ..introVideoUri = json['introVideoUri'] as String?
      ..introVideoThumbUri = json['introVideoThumbUri'] as String?
      ..introAudioUri = json['introAudioUri'] as String?
      ..workoutGoals = (json['WorkoutGoals'] as List<dynamic>)
          .map((e) => WorkoutGoal.fromJson(e as Map<String, dynamic>))
          .toList()
      ..workoutTags = (json['WorkoutTags'] as List<dynamic>)
          .map((e) => WorkoutTag.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UpdateWorkoutToJson(UpdateWorkout instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'archived': instance.archived,
      'name': instance.name,
      'description': instance.description,
      'lengthMinutes': instance.lengthMinutes,
      'difficultyLevel': _$DifficultyLevelEnumMap[instance.difficultyLevel],
      'coverImageUri': instance.coverImageUri,
      'contentAccessScope':
          _$ContentAccessScopeEnumMap[instance.contentAccessScope],
      'introVideoUri': instance.introVideoUri,
      'introVideoThumbUri': instance.introVideoThumbUri,
      'introAudioUri': instance.introAudioUri,
      'WorkoutGoals': instance.workoutGoals.map((e) => e.toJson()).toList(),
      'WorkoutTags': instance.workoutTags.map((e) => e.toJson()).toList(),
    };

UpdateWorkout$Mutation _$UpdateWorkout$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkout$Mutation()
      ..updateWorkout =
          UpdateWorkout.fromJson(json['updateWorkout'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateWorkout$MutationToJson(
        UpdateWorkout$Mutation instance) =>
    <String, dynamic>{
      'updateWorkout': instance.updateWorkout.toJson(),
    };

UpdateWorkoutInput _$UpdateWorkoutInputFromJson(Map<String, dynamic> json) =>
    UpdateWorkoutInput(
      workoutGoals: (json['WorkoutGoals'] as List<dynamic>?)
          ?.map((e) => ConnectRelationInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      workoutTags: (json['WorkoutTags'] as List<dynamic>?)
          ?.map((e) => ConnectRelationInput.fromJson(e as Map<String, dynamic>))
          .toList(),
      contentAccessScope: _$enumDecodeNullable(
          _$ContentAccessScopeEnumMap, json['contentAccessScope'],
          unknownValue: ContentAccessScope.artemisUnknown),
      coverImageUri: json['coverImageUri'] as String?,
      description: json['description'] as String?,
      difficultyLevel: _$enumDecodeNullable(
          _$DifficultyLevelEnumMap, json['difficultyLevel'],
          unknownValue: DifficultyLevel.artemisUnknown),
      id: json['id'] as String,
      introAudioUri: json['introAudioUri'] as String?,
      introVideoThumbUri: json['introVideoThumbUri'] as String?,
      introVideoUri: json['introVideoUri'] as String?,
      lengthMinutes: json['lengthMinutes'] as int?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$UpdateWorkoutInputToJson(UpdateWorkoutInput instance) =>
    <String, dynamic>{
      'WorkoutGoals': instance.workoutGoals?.map((e) => e.toJson()).toList(),
      'WorkoutTags': instance.workoutTags?.map((e) => e.toJson()).toList(),
      'contentAccessScope':
          _$ContentAccessScopeEnumMap[instance.contentAccessScope],
      'coverImageUri': instance.coverImageUri,
      'description': instance.description,
      'difficultyLevel': _$DifficultyLevelEnumMap[instance.difficultyLevel],
      'id': instance.id,
      'introAudioUri': instance.introAudioUri,
      'introVideoThumbUri': instance.introVideoThumbUri,
      'introVideoUri': instance.introVideoUri,
      'lengthMinutes': instance.lengthMinutes,
      'name': instance.name,
    };

UserWorkouts$Query _$UserWorkouts$QueryFromJson(Map<String, dynamic> json) =>
    UserWorkouts$Query()
      ..userWorkouts = (json['userWorkouts'] as List<dynamic>)
          .map((e) => Workout.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserWorkouts$QueryToJson(UserWorkouts$Query instance) =>
    <String, dynamic>{
      'userWorkouts': instance.userWorkouts.map((e) => e.toJson()).toList(),
    };

DuplicateWorkoutById$Mutation _$DuplicateWorkoutById$MutationFromJson(
        Map<String, dynamic> json) =>
    DuplicateWorkoutById$Mutation()
      ..duplicateWorkoutById = Workout.fromJson(
          json['duplicateWorkoutById'] as Map<String, dynamic>);

Map<String, dynamic> _$DuplicateWorkoutById$MutationToJson(
        DuplicateWorkoutById$Mutation instance) =>
    <String, dynamic>{
      'duplicateWorkoutById': instance.duplicateWorkoutById.toJson(),
    };

CreateWorkout$Mutation _$CreateWorkout$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateWorkout$Mutation()
      ..createWorkout =
          Workout.fromJson(json['createWorkout'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateWorkout$MutationToJson(
        CreateWorkout$Mutation instance) =>
    <String, dynamic>{
      'createWorkout': instance.createWorkout.toJson(),
    };

CreateWorkoutInput _$CreateWorkoutInputFromJson(Map<String, dynamic> json) =>
    CreateWorkoutInput(
      contentAccessScope: _$enumDecode(
          _$ContentAccessScopeEnumMap, json['contentAccessScope'],
          unknownValue: ContentAccessScope.artemisUnknown),
      difficultyLevel: _$enumDecode(
          _$DifficultyLevelEnumMap, json['difficultyLevel'],
          unknownValue: DifficultyLevel.artemisUnknown),
      name: json['name'] as String,
    );

Map<String, dynamic> _$CreateWorkoutInputToJson(CreateWorkoutInput instance) =>
    <String, dynamic>{
      'contentAccessScope':
          _$ContentAccessScopeEnumMap[instance.contentAccessScope],
      'difficultyLevel': _$DifficultyLevelEnumMap[instance.difficultyLevel],
      'name': instance.name,
    };

WorkoutById$Query _$WorkoutById$QueryFromJson(Map<String, dynamic> json) =>
    WorkoutById$Query()
      ..workoutById =
          Workout.fromJson(json['workoutById'] as Map<String, dynamic>);

Map<String, dynamic> _$WorkoutById$QueryToJson(WorkoutById$Query instance) =>
    <String, dynamic>{
      'workoutById': instance.workoutById.toJson(),
    };

RemoveMemberAdminStatus$Mutation _$RemoveMemberAdminStatus$MutationFromJson(
        Map<String, dynamic> json) =>
    RemoveMemberAdminStatus$Mutation()
      ..removeMemberAdminStatus = Club.fromJson(
          json['removeMemberAdminStatus'] as Map<String, dynamic>);

Map<String, dynamic> _$RemoveMemberAdminStatus$MutationToJson(
        RemoveMemberAdminStatus$Mutation instance) =>
    <String, dynamic>{
      'removeMemberAdminStatus': instance.removeMemberAdminStatus.toJson(),
    };

AddUserToClubViaInviteToken$Mutation
    _$AddUserToClubViaInviteToken$MutationFromJson(Map<String, dynamic> json) =>
        AddUserToClubViaInviteToken$Mutation()
          ..addUserToClubViaInviteToken = Club.fromJson(
              json['addUserToClubViaInviteToken'] as Map<String, dynamic>);

Map<String, dynamic> _$AddUserToClubViaInviteToken$MutationToJson(
        AddUserToClubViaInviteToken$Mutation instance) =>
    <String, dynamic>{
      'addUserToClubViaInviteToken':
          instance.addUserToClubViaInviteToken.toJson(),
    };

ClubInviteTokenData _$ClubInviteTokenDataFromJson(Map<String, dynamic> json) =>
    ClubInviteTokenData()
      ..$$typename = json['__typename'] as String?
      ..token = json['token'] as String
      ..club = Club.fromJson(json['Club'] as Map<String, dynamic>);

Map<String, dynamic> _$ClubInviteTokenDataToJson(
        ClubInviteTokenData instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'token': instance.token,
      'Club': instance.club.toJson(),
    };

InviteTokenError _$InviteTokenErrorFromJson(Map<String, dynamic> json) =>
    InviteTokenError()
      ..$$typename = json['__typename'] as String?
      ..message = json['message'] as String;

Map<String, dynamic> _$InviteTokenErrorToJson(InviteTokenError instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'message': instance.message,
    };

CheckClubInviteTokenResult _$CheckClubInviteTokenResultFromJson(
        Map<String, dynamic> json) =>
    CheckClubInviteTokenResult()..$$typename = json['__typename'] as String?;

Map<String, dynamic> _$CheckClubInviteTokenResultToJson(
        CheckClubInviteTokenResult instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
    };

CheckClubInviteToken$Query _$CheckClubInviteToken$QueryFromJson(
        Map<String, dynamic> json) =>
    CheckClubInviteToken$Query()
      ..checkClubInviteToken = CheckClubInviteTokenResult.fromJson(
          json['checkClubInviteToken'] as Map<String, dynamic>);

Map<String, dynamic> _$CheckClubInviteToken$QueryToJson(
        CheckClubInviteToken$Query instance) =>
    <String, dynamic>{
      'checkClubInviteToken': instance.checkClubInviteToken.toJson(),
    };

RemoveUserFromClub$Mutation _$RemoveUserFromClub$MutationFromJson(
        Map<String, dynamic> json) =>
    RemoveUserFromClub$Mutation()
      ..removeUserFromClub =
          Club.fromJson(json['removeUserFromClub'] as Map<String, dynamic>);

Map<String, dynamic> _$RemoveUserFromClub$MutationToJson(
        RemoveUserFromClub$Mutation instance) =>
    <String, dynamic>{
      'removeUserFromClub': instance.removeUserFromClub.toJson(),
    };

ClubMembers _$ClubMembersFromJson(Map<String, dynamic> json) => ClubMembers()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
  ..name = json['name'] as String
  ..description = json['description'] as String?
  ..location = json['location'] as String?
  ..coverImageUri = json['coverImageUri'] as String?
  ..introVideoUri = json['introVideoUri'] as String?
  ..introVideoThumbUri = json['introVideoThumbUri'] as String?
  ..introAudioUri = json['introAudioUri'] as String?
  ..contentAccessScope = _$enumDecode(
      _$ContentAccessScopeEnumMap, json['contentAccessScope'],
      unknownValue: ContentAccessScope.artemisUnknown)
  ..owner = UserSummary.fromJson(json['Owner'] as Map<String, dynamic>)
  ..admins = (json['Admins'] as List<dynamic>)
      .map((e) => UserSummary.fromJson(e as Map<String, dynamic>))
      .toList()
  ..members = (json['Members'] as List<dynamic>)
      .map((e) => UserSummary.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$ClubMembersToJson(ClubMembers instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'name': instance.name,
      'description': instance.description,
      'location': instance.location,
      'coverImageUri': instance.coverImageUri,
      'introVideoUri': instance.introVideoUri,
      'introVideoThumbUri': instance.introVideoThumbUri,
      'introAudioUri': instance.introAudioUri,
      'contentAccessScope':
          _$ContentAccessScopeEnumMap[instance.contentAccessScope],
      'Owner': instance.owner.toJson(),
      'Admins': instance.admins.map((e) => e.toJson()).toList(),
      'Members': instance.members.map((e) => e.toJson()).toList(),
    };

ClubMembers$Query _$ClubMembers$QueryFromJson(Map<String, dynamic> json) =>
    ClubMembers$Query()
      ..clubMembers =
          ClubMembers.fromJson(json['clubMembers'] as Map<String, dynamic>);

Map<String, dynamic> _$ClubMembers$QueryToJson(ClubMembers$Query instance) =>
    <String, dynamic>{
      'clubMembers': instance.clubMembers.toJson(),
    };

UpdateClubInviteToken$Mutation _$UpdateClubInviteToken$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateClubInviteToken$Mutation()
      ..updateClubInviteToken = ClubInviteToken.fromJson(
          json['updateClubInviteToken'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateClubInviteToken$MutationToJson(
        UpdateClubInviteToken$Mutation instance) =>
    <String, dynamic>{
      'updateClubInviteToken': instance.updateClubInviteToken.toJson(),
    };

UpdateClubInviteTokenInput _$UpdateClubInviteTokenInputFromJson(
        Map<String, dynamic> json) =>
    UpdateClubInviteTokenInput(
      active: json['active'] as bool?,
      id: json['id'] as String,
      inviteLimit: json['inviteLimit'] as int?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$UpdateClubInviteTokenInputToJson(
        UpdateClubInviteTokenInput instance) =>
    <String, dynamic>{
      'active': instance.active,
      'id': instance.id,
      'inviteLimit': instance.inviteLimit,
      'name': instance.name,
    };

GiveMemberAdminStatus$Mutation _$GiveMemberAdminStatus$MutationFromJson(
        Map<String, dynamic> json) =>
    GiveMemberAdminStatus$Mutation()
      ..giveMemberAdminStatus =
          Club.fromJson(json['giveMemberAdminStatus'] as Map<String, dynamic>);

Map<String, dynamic> _$GiveMemberAdminStatus$MutationToJson(
        GiveMemberAdminStatus$Mutation instance) =>
    <String, dynamic>{
      'giveMemberAdminStatus': instance.giveMemberAdminStatus.toJson(),
    };

CreateClubInviteToken$Mutation _$CreateClubInviteToken$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateClubInviteToken$Mutation()
      ..createClubInviteToken = ClubInviteToken.fromJson(
          json['createClubInviteToken'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateClubInviteToken$MutationToJson(
        CreateClubInviteToken$Mutation instance) =>
    <String, dynamic>{
      'createClubInviteToken': instance.createClubInviteToken.toJson(),
    };

CreateClubInviteTokenInput _$CreateClubInviteTokenInputFromJson(
        Map<String, dynamic> json) =>
    CreateClubInviteTokenInput(
      club: ConnectRelationInput.fromJson(json['Club'] as Map<String, dynamic>),
      inviteLimit: json['inviteLimit'] as int,
      name: json['name'] as String,
    );

Map<String, dynamic> _$CreateClubInviteTokenInputToJson(
        CreateClubInviteTokenInput instance) =>
    <String, dynamic>{
      'Club': instance.club.toJson(),
      'inviteLimit': instance.inviteLimit,
      'name': instance.name,
    };

DeleteClubInviteTokenById$Mutation _$DeleteClubInviteTokenById$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteClubInviteTokenById$Mutation()
      ..deleteClubInviteTokenById = json['deleteClubInviteTokenById'] as String;

Map<String, dynamic> _$DeleteClubInviteTokenById$MutationToJson(
        DeleteClubInviteTokenById$Mutation instance) =>
    <String, dynamic>{
      'deleteClubInviteTokenById': instance.deleteClubInviteTokenById,
    };

ScheduledWorkout _$ScheduledWorkoutFromJson(Map<String, dynamic> json) =>
    ScheduledWorkout()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..scheduledAt =
          fromGraphQLDateTimeToDartDateTime(json['scheduledAt'] as int)
      ..note = json['note'] as String?
      ..workout = json['Workout'] == null
          ? null
          : Workout.fromJson(json['Workout'] as Map<String, dynamic>)
      ..gymProfile = json['GymProfile'] == null
          ? null
          : GymProfile.fromJson(json['GymProfile'] as Map<String, dynamic>)
      ..loggedWorkoutId = json['loggedWorkoutId'] as String?
      ..workoutPlanEnrolmentId = json['workoutPlanEnrolmentId'] as String?;

Map<String, dynamic> _$ScheduledWorkoutToJson(ScheduledWorkout instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'scheduledAt': fromDartDateTimeToGraphQLDateTime(instance.scheduledAt),
      'note': instance.note,
      'Workout': instance.workout?.toJson(),
      'GymProfile': instance.gymProfile?.toJson(),
      'loggedWorkoutId': instance.loggedWorkoutId,
      'workoutPlanEnrolmentId': instance.workoutPlanEnrolmentId,
    };

UpdateScheduledWorkout$Mutation _$UpdateScheduledWorkout$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateScheduledWorkout$Mutation()
      ..updateScheduledWorkout = ScheduledWorkout.fromJson(
          json['updateScheduledWorkout'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateScheduledWorkout$MutationToJson(
        UpdateScheduledWorkout$Mutation instance) =>
    <String, dynamic>{
      'updateScheduledWorkout': instance.updateScheduledWorkout.toJson(),
    };

UpdateScheduledWorkoutInput _$UpdateScheduledWorkoutInputFromJson(
        Map<String, dynamic> json) =>
    UpdateScheduledWorkoutInput(
      gymProfile: json['GymProfile'] == null
          ? null
          : ConnectRelationInput.fromJson(
              json['GymProfile'] as Map<String, dynamic>),
      loggedWorkout: json['LoggedWorkout'] == null
          ? null
          : ConnectRelationInput.fromJson(
              json['LoggedWorkout'] as Map<String, dynamic>),
      workout: json['Workout'] == null
          ? null
          : ConnectRelationInput.fromJson(
              json['Workout'] as Map<String, dynamic>),
      workoutPlanEnrolment: json['WorkoutPlanEnrolment'] == null
          ? null
          : ConnectRelationInput.fromJson(
              json['WorkoutPlanEnrolment'] as Map<String, dynamic>),
      id: json['id'] as String,
      note: json['note'] as String?,
      scheduledAt: fromGraphQLDateTimeNullableToDartDateTimeNullable(
          json['scheduledAt'] as int?),
    );

Map<String, dynamic> _$UpdateScheduledWorkoutInputToJson(
        UpdateScheduledWorkoutInput instance) =>
    <String, dynamic>{
      'GymProfile': instance.gymProfile?.toJson(),
      'LoggedWorkout': instance.loggedWorkout?.toJson(),
      'Workout': instance.workout?.toJson(),
      'WorkoutPlanEnrolment': instance.workoutPlanEnrolment?.toJson(),
      'id': instance.id,
      'note': instance.note,
      'scheduledAt': fromDartDateTimeNullableToGraphQLDateTimeNullable(
          instance.scheduledAt),
    };

CreateScheduledWorkout$Mutation _$CreateScheduledWorkout$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateScheduledWorkout$Mutation()
      ..createScheduledWorkout = ScheduledWorkout.fromJson(
          json['createScheduledWorkout'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateScheduledWorkout$MutationToJson(
        CreateScheduledWorkout$Mutation instance) =>
    <String, dynamic>{
      'createScheduledWorkout': instance.createScheduledWorkout.toJson(),
    };

CreateScheduledWorkoutInput _$CreateScheduledWorkoutInputFromJson(
        Map<String, dynamic> json) =>
    CreateScheduledWorkoutInput(
      gymProfile: json['GymProfile'] == null
          ? null
          : ConnectRelationInput.fromJson(
              json['GymProfile'] as Map<String, dynamic>),
      workout: ConnectRelationInput.fromJson(
          json['Workout'] as Map<String, dynamic>),
      workoutPlanEnrolment: json['WorkoutPlanEnrolment'] == null
          ? null
          : ConnectRelationInput.fromJson(
              json['WorkoutPlanEnrolment'] as Map<String, dynamic>),
      note: json['note'] as String?,
      scheduledAt:
          fromGraphQLDateTimeToDartDateTime(json['scheduledAt'] as int),
    );

Map<String, dynamic> _$CreateScheduledWorkoutInputToJson(
        CreateScheduledWorkoutInput instance) =>
    <String, dynamic>{
      'GymProfile': instance.gymProfile?.toJson(),
      'Workout': instance.workout.toJson(),
      'WorkoutPlanEnrolment': instance.workoutPlanEnrolment?.toJson(),
      'note': instance.note,
      'scheduledAt': fromDartDateTimeToGraphQLDateTime(instance.scheduledAt),
    };

UserScheduledWorkouts$Query _$UserScheduledWorkouts$QueryFromJson(
        Map<String, dynamic> json) =>
    UserScheduledWorkouts$Query()
      ..userScheduledWorkouts = (json['userScheduledWorkouts'] as List<dynamic>)
          .map((e) => ScheduledWorkout.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserScheduledWorkouts$QueryToJson(
        UserScheduledWorkouts$Query instance) =>
    <String, dynamic>{
      'userScheduledWorkouts':
          instance.userScheduledWorkouts.map((e) => e.toJson()).toList(),
    };

DeleteScheduledWorkoutById$Mutation
    _$DeleteScheduledWorkoutById$MutationFromJson(Map<String, dynamic> json) =>
        DeleteScheduledWorkoutById$Mutation()
          ..deleteScheduledWorkoutById =
              json['deleteScheduledWorkoutById'] as String;

Map<String, dynamic> _$DeleteScheduledWorkoutById$MutationToJson(
        DeleteScheduledWorkoutById$Mutation instance) =>
    <String, dynamic>{
      'deleteScheduledWorkoutById': instance.deleteScheduledWorkoutById,
    };

UserJoinPublicClub$Mutation _$UserJoinPublicClub$MutationFromJson(
        Map<String, dynamic> json) =>
    UserJoinPublicClub$Mutation()
      ..userJoinPublicClub = json['userJoinPublicClub'] as String;

Map<String, dynamic> _$UserJoinPublicClub$MutationToJson(
        UserJoinPublicClub$Mutation instance) =>
    <String, dynamic>{
      'userJoinPublicClub': instance.userJoinPublicClub,
    };

LifetimeLogStatsSummary _$LifetimeLogStatsSummaryFromJson(
        Map<String, dynamic> json) =>
    LifetimeLogStatsSummary()
      ..sessionsLogged = json['sessionsLogged'] as int
      ..minutesWorked = json['minutesWorked'] as int;

Map<String, dynamic> _$LifetimeLogStatsSummaryToJson(
        LifetimeLogStatsSummary instance) =>
    <String, dynamic>{
      'sessionsLogged': instance.sessionsLogged,
      'minutesWorked': instance.minutesWorked,
    };

LifetimeLogStatsSummary$Query _$LifetimeLogStatsSummary$QueryFromJson(
        Map<String, dynamic> json) =>
    LifetimeLogStatsSummary$Query()
      ..lifetimeLogStatsSummary = LifetimeLogStatsSummary.fromJson(
          json['lifetimeLogStatsSummary'] as Map<String, dynamic>);

Map<String, dynamic> _$LifetimeLogStatsSummary$QueryToJson(
        LifetimeLogStatsSummary$Query instance) =>
    <String, dynamic>{
      'lifetimeLogStatsSummary': instance.lifetimeLogStatsSummary.toJson(),
    };

ClubSummariesByIdArguments _$ClubSummariesByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    ClubSummariesByIdArguments(
      ids: (json['ids'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ClubSummariesByIdArgumentsToJson(
        ClubSummariesByIdArguments instance) =>
    <String, dynamic>{
      'ids': instance.ids,
    };

CreateClubArguments _$CreateClubArgumentsFromJson(Map<String, dynamic> json) =>
    CreateClubArguments(
      data: CreateClubInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateClubArgumentsToJson(
        CreateClubArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DeleteClubByIdArguments _$DeleteClubByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    DeleteClubByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DeleteClubByIdArgumentsToJson(
        DeleteClubByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

UpdateClubArguments _$UpdateClubArgumentsFromJson(Map<String, dynamic> json) =>
    UpdateClubArguments(
      data: UpdateClubInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateClubArgumentsToJson(
        UpdateClubArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

ClubByIdArguments _$ClubByIdArgumentsFromJson(Map<String, dynamic> json) =>
    ClubByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$ClubByIdArgumentsToJson(ClubByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

CreateWorkoutMoveArguments _$CreateWorkoutMoveArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateWorkoutMoveArguments(
      data:
          CreateWorkoutMoveInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateWorkoutMoveArgumentsToJson(
        CreateWorkoutMoveArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DuplicateWorkoutMoveByIdArguments _$DuplicateWorkoutMoveByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    DuplicateWorkoutMoveByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DuplicateWorkoutMoveByIdArgumentsToJson(
        DuplicateWorkoutMoveByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

DeleteWorkoutMoveByIdArguments _$DeleteWorkoutMoveByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    DeleteWorkoutMoveByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DeleteWorkoutMoveByIdArgumentsToJson(
        DeleteWorkoutMoveByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

ReorderWorkoutMovesArguments _$ReorderWorkoutMovesArgumentsFromJson(
        Map<String, dynamic> json) =>
    ReorderWorkoutMovesArguments(
      data: (json['data'] as List<dynamic>)
          .map((e) =>
              UpdateSortPositionInput.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReorderWorkoutMovesArgumentsToJson(
        ReorderWorkoutMovesArguments instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

UpdateWorkoutMoveArguments _$UpdateWorkoutMoveArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutMoveArguments(
      data:
          UpdateWorkoutMoveInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateWorkoutMoveArgumentsToJson(
        UpdateWorkoutMoveArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DeleteCollectionByIdArguments _$DeleteCollectionByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    DeleteCollectionByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DeleteCollectionByIdArgumentsToJson(
        DeleteCollectionByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

AddWorkoutPlanToCollectionArguments
    _$AddWorkoutPlanToCollectionArgumentsFromJson(Map<String, dynamic> json) =>
        AddWorkoutPlanToCollectionArguments(
          data: AddWorkoutPlanToCollectionInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$AddWorkoutPlanToCollectionArgumentsToJson(
        AddWorkoutPlanToCollectionArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

CreateCollectionArguments _$CreateCollectionArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateCollectionArguments(
      data:
          CreateCollectionInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateCollectionArgumentsToJson(
        CreateCollectionArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

UserCollectionByIdArguments _$UserCollectionByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    UserCollectionByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$UserCollectionByIdArgumentsToJson(
        UserCollectionByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

AddWorkoutToCollectionArguments _$AddWorkoutToCollectionArgumentsFromJson(
        Map<String, dynamic> json) =>
    AddWorkoutToCollectionArguments(
      data: AddWorkoutToCollectionInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AddWorkoutToCollectionArgumentsToJson(
        AddWorkoutToCollectionArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

UpdateCollectionArguments _$UpdateCollectionArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateCollectionArguments(
      data:
          UpdateCollectionInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateCollectionArgumentsToJson(
        UpdateCollectionArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

RemoveWorkoutPlanFromCollectionArguments
    _$RemoveWorkoutPlanFromCollectionArgumentsFromJson(
            Map<String, dynamic> json) =>
        RemoveWorkoutPlanFromCollectionArguments(
          data: RemoveWorkoutPlanFromCollectionInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$RemoveWorkoutPlanFromCollectionArgumentsToJson(
        RemoveWorkoutPlanFromCollectionArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

RemoveWorkoutFromCollectionArguments
    _$RemoveWorkoutFromCollectionArgumentsFromJson(Map<String, dynamic> json) =>
        RemoveWorkoutFromCollectionArguments(
          data: RemoveWorkoutFromCollectionInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$RemoveWorkoutFromCollectionArgumentsToJson(
        RemoveWorkoutFromCollectionArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

ReorderWorkoutPlanDayWorkoutsArguments
    _$ReorderWorkoutPlanDayWorkoutsArgumentsFromJson(
            Map<String, dynamic> json) =>
        ReorderWorkoutPlanDayWorkoutsArguments(
          data: (json['data'] as List<dynamic>)
              .map((e) =>
                  UpdateSortPositionInput.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$ReorderWorkoutPlanDayWorkoutsArgumentsToJson(
        ReorderWorkoutPlanDayWorkoutsArguments instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

CreateWorkoutPlanDayWorkoutArguments
    _$CreateWorkoutPlanDayWorkoutArgumentsFromJson(Map<String, dynamic> json) =>
        CreateWorkoutPlanDayWorkoutArguments(
          data: CreateWorkoutPlanDayWorkoutInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$CreateWorkoutPlanDayWorkoutArgumentsToJson(
        CreateWorkoutPlanDayWorkoutArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

UpdateWorkoutPlanDayWorkoutArguments
    _$UpdateWorkoutPlanDayWorkoutArgumentsFromJson(Map<String, dynamic> json) =>
        UpdateWorkoutPlanDayWorkoutArguments(
          data: UpdateWorkoutPlanDayWorkoutInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$UpdateWorkoutPlanDayWorkoutArgumentsToJson(
        UpdateWorkoutPlanDayWorkoutArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DeleteWorkoutPlanDayWorkoutByIdArguments
    _$DeleteWorkoutPlanDayWorkoutByIdArgumentsFromJson(
            Map<String, dynamic> json) =>
        DeleteWorkoutPlanDayWorkoutByIdArguments(
          id: json['id'] as String,
        );

Map<String, dynamic> _$DeleteWorkoutPlanDayWorkoutByIdArgumentsToJson(
        DeleteWorkoutPlanDayWorkoutByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

UpdateWorkoutPlanEnrolmentArguments
    _$UpdateWorkoutPlanEnrolmentArgumentsFromJson(Map<String, dynamic> json) =>
        UpdateWorkoutPlanEnrolmentArguments(
          data: UpdateWorkoutPlanEnrolmentInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$UpdateWorkoutPlanEnrolmentArgumentsToJson(
        UpdateWorkoutPlanEnrolmentArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DeleteWorkoutPlanEnrolmentByIdArguments
    _$DeleteWorkoutPlanEnrolmentByIdArgumentsFromJson(
            Map<String, dynamic> json) =>
        DeleteWorkoutPlanEnrolmentByIdArguments(
          id: json['id'] as String,
        );

Map<String, dynamic> _$DeleteWorkoutPlanEnrolmentByIdArgumentsToJson(
        DeleteWorkoutPlanEnrolmentByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

CreateWorkoutPlanEnrolmentArguments
    _$CreateWorkoutPlanEnrolmentArgumentsFromJson(Map<String, dynamic> json) =>
        CreateWorkoutPlanEnrolmentArguments(
          workoutPlanId: json['workoutPlanId'] as String,
        );

Map<String, dynamic> _$CreateWorkoutPlanEnrolmentArgumentsToJson(
        CreateWorkoutPlanEnrolmentArguments instance) =>
    <String, dynamic>{
      'workoutPlanId': instance.workoutPlanId,
    };

WorkoutPlanByEnrolmentIdArguments _$WorkoutPlanByEnrolmentIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    WorkoutPlanByEnrolmentIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$WorkoutPlanByEnrolmentIdArgumentsToJson(
        WorkoutPlanByEnrolmentIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

UpdateProgressJournalGoalTagArguments
    _$UpdateProgressJournalGoalTagArgumentsFromJson(
            Map<String, dynamic> json) =>
        UpdateProgressJournalGoalTagArguments(
          data: UpdateProgressJournalGoalTagInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$UpdateProgressJournalGoalTagArgumentsToJson(
        UpdateProgressJournalGoalTagArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

ProgressJournalByIdArguments _$ProgressJournalByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    ProgressJournalByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$ProgressJournalByIdArgumentsToJson(
        ProgressJournalByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

CreateProgressJournalEntryArguments
    _$CreateProgressJournalEntryArgumentsFromJson(Map<String, dynamic> json) =>
        CreateProgressJournalEntryArguments(
          data: CreateProgressJournalEntryInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$CreateProgressJournalEntryArgumentsToJson(
        CreateProgressJournalEntryArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DeleteProgressJournalByIdArguments _$DeleteProgressJournalByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    DeleteProgressJournalByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DeleteProgressJournalByIdArgumentsToJson(
        DeleteProgressJournalByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

CreateProgressJournalArguments _$CreateProgressJournalArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateProgressJournalArguments(
      data: CreateProgressJournalInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateProgressJournalArgumentsToJson(
        CreateProgressJournalArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

UpdateProgressJournalArguments _$UpdateProgressJournalArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateProgressJournalArguments(
      data: UpdateProgressJournalInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateProgressJournalArgumentsToJson(
        UpdateProgressJournalArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DeleteProgressJournalEntryByIdArguments
    _$DeleteProgressJournalEntryByIdArgumentsFromJson(
            Map<String, dynamic> json) =>
        DeleteProgressJournalEntryByIdArguments(
          id: json['id'] as String,
        );

Map<String, dynamic> _$DeleteProgressJournalEntryByIdArgumentsToJson(
        DeleteProgressJournalEntryByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

UpdateProgressJournalEntryArguments
    _$UpdateProgressJournalEntryArgumentsFromJson(Map<String, dynamic> json) =>
        UpdateProgressJournalEntryArguments(
          data: UpdateProgressJournalEntryInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$UpdateProgressJournalEntryArgumentsToJson(
        UpdateProgressJournalEntryArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

CreateProgressJournalGoalArguments _$CreateProgressJournalGoalArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateProgressJournalGoalArguments(
      data: CreateProgressJournalGoalInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateProgressJournalGoalArgumentsToJson(
        CreateProgressJournalGoalArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

UpdateProgressJournalGoalArguments _$UpdateProgressJournalGoalArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateProgressJournalGoalArguments(
      data: UpdateProgressJournalGoalInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateProgressJournalGoalArgumentsToJson(
        UpdateProgressJournalGoalArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

CreateProgressJournalGoalTagArguments
    _$CreateProgressJournalGoalTagArgumentsFromJson(
            Map<String, dynamic> json) =>
        CreateProgressJournalGoalTagArguments(
          data: CreateProgressJournalGoalTagInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$CreateProgressJournalGoalTagArgumentsToJson(
        CreateProgressJournalGoalTagArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DeleteProgressJournalGoalByIdArguments
    _$DeleteProgressJournalGoalByIdArgumentsFromJson(
            Map<String, dynamic> json) =>
        DeleteProgressJournalGoalByIdArguments(
          id: json['id'] as String,
        );

Map<String, dynamic> _$DeleteProgressJournalGoalByIdArgumentsToJson(
        DeleteProgressJournalGoalByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

DeleteProgressJournalGoalTagByIdArguments
    _$DeleteProgressJournalGoalTagByIdArgumentsFromJson(
            Map<String, dynamic> json) =>
        DeleteProgressJournalGoalTagByIdArguments(
          id: json['id'] as String,
        );

Map<String, dynamic> _$DeleteProgressJournalGoalTagByIdArgumentsToJson(
        DeleteProgressJournalGoalTagByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

MoveWorkoutPlanDayToAnotherDayArguments
    _$MoveWorkoutPlanDayToAnotherDayArgumentsFromJson(
            Map<String, dynamic> json) =>
        MoveWorkoutPlanDayToAnotherDayArguments(
          data: MoveWorkoutPlanDayToAnotherDayInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$MoveWorkoutPlanDayToAnotherDayArgumentsToJson(
        MoveWorkoutPlanDayToAnotherDayArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DeleteWorkoutPlanDaysByIdArguments _$DeleteWorkoutPlanDaysByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    DeleteWorkoutPlanDaysByIdArguments(
      ids: (json['ids'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$DeleteWorkoutPlanDaysByIdArgumentsToJson(
        DeleteWorkoutPlanDaysByIdArguments instance) =>
    <String, dynamic>{
      'ids': instance.ids,
    };

UpdateWorkoutPlanDayArguments _$UpdateWorkoutPlanDayArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutPlanDayArguments(
      data: UpdateWorkoutPlanDayInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateWorkoutPlanDayArgumentsToJson(
        UpdateWorkoutPlanDayArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

CreateWorkoutPlanDayWithWorkoutArguments
    _$CreateWorkoutPlanDayWithWorkoutArgumentsFromJson(
            Map<String, dynamic> json) =>
        CreateWorkoutPlanDayWithWorkoutArguments(
          data: CreateWorkoutPlanDayWithWorkoutInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$CreateWorkoutPlanDayWithWorkoutArgumentsToJson(
        CreateWorkoutPlanDayWithWorkoutArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

CopyWorkoutPlanDayToAnotherDayArguments
    _$CopyWorkoutPlanDayToAnotherDayArgumentsFromJson(
            Map<String, dynamic> json) =>
        CopyWorkoutPlanDayToAnotherDayArguments(
          data: CopyWorkoutPlanDayToAnotherDayInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$CopyWorkoutPlanDayToAnotherDayArgumentsToJson(
        CopyWorkoutPlanDayToAnotherDayArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

LoggedWorkoutByIdArguments _$LoggedWorkoutByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    LoggedWorkoutByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$LoggedWorkoutByIdArgumentsToJson(
        LoggedWorkoutByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

DeleteLoggedWorkoutByIdArguments _$DeleteLoggedWorkoutByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    DeleteLoggedWorkoutByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DeleteLoggedWorkoutByIdArgumentsToJson(
        DeleteLoggedWorkoutByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

UserLoggedWorkoutsArguments _$UserLoggedWorkoutsArgumentsFromJson(
        Map<String, dynamic> json) =>
    UserLoggedWorkoutsArguments(
      take: json['take'] as int?,
    );

Map<String, dynamic> _$UserLoggedWorkoutsArgumentsToJson(
        UserLoggedWorkoutsArguments instance) =>
    <String, dynamic>{
      'take': instance.take,
    };

UpdateLoggedWorkoutArguments _$UpdateLoggedWorkoutArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateLoggedWorkoutArguments(
      data: UpdateLoggedWorkoutInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateLoggedWorkoutArgumentsToJson(
        UpdateLoggedWorkoutArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

CreateLoggedWorkoutArguments _$CreateLoggedWorkoutArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateLoggedWorkoutArguments(
      data: CreateLoggedWorkoutInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateLoggedWorkoutArgumentsToJson(
        CreateLoggedWorkoutArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

UpdateLoggedWorkoutSectionArguments
    _$UpdateLoggedWorkoutSectionArgumentsFromJson(Map<String, dynamic> json) =>
        UpdateLoggedWorkoutSectionArguments(
          data: UpdateLoggedWorkoutSectionInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$UpdateLoggedWorkoutSectionArgumentsToJson(
        UpdateLoggedWorkoutSectionArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DeleteWorkoutPlanReviewByIdArguments
    _$DeleteWorkoutPlanReviewByIdArgumentsFromJson(Map<String, dynamic> json) =>
        DeleteWorkoutPlanReviewByIdArguments(
          id: json['id'] as String,
        );

Map<String, dynamic> _$DeleteWorkoutPlanReviewByIdArgumentsToJson(
        DeleteWorkoutPlanReviewByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

UpdateWorkoutPlanReviewArguments _$UpdateWorkoutPlanReviewArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutPlanReviewArguments(
      data: UpdateWorkoutPlanReviewInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateWorkoutPlanReviewArgumentsToJson(
        UpdateWorkoutPlanReviewArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

CreateWorkoutPlanReviewArguments _$CreateWorkoutPlanReviewArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateWorkoutPlanReviewArguments(
      data: CreateWorkoutPlanReviewInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateWorkoutPlanReviewArgumentsToJson(
        CreateWorkoutPlanReviewArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

RemoveWorkoutFromClubArguments _$RemoveWorkoutFromClubArgumentsFromJson(
        Map<String, dynamic> json) =>
    RemoveWorkoutFromClubArguments(
      workoutId: json['workoutId'] as String,
      clubId: json['clubId'] as String,
    );

Map<String, dynamic> _$RemoveWorkoutFromClubArgumentsToJson(
        RemoveWorkoutFromClubArguments instance) =>
    <String, dynamic>{
      'workoutId': instance.workoutId,
      'clubId': instance.clubId,
    };

RemoveWorkoutPlanFromClubArguments _$RemoveWorkoutPlanFromClubArgumentsFromJson(
        Map<String, dynamic> json) =>
    RemoveWorkoutPlanFromClubArguments(
      workoutPlanId: json['workoutPlanId'] as String,
      clubId: json['clubId'] as String,
    );

Map<String, dynamic> _$RemoveWorkoutPlanFromClubArgumentsToJson(
        RemoveWorkoutPlanFromClubArguments instance) =>
    <String, dynamic>{
      'workoutPlanId': instance.workoutPlanId,
      'clubId': instance.clubId,
    };

AddWorkoutToClubArguments _$AddWorkoutToClubArgumentsFromJson(
        Map<String, dynamic> json) =>
    AddWorkoutToClubArguments(
      workoutId: json['workoutId'] as String,
      clubId: json['clubId'] as String,
    );

Map<String, dynamic> _$AddWorkoutToClubArgumentsToJson(
        AddWorkoutToClubArguments instance) =>
    <String, dynamic>{
      'workoutId': instance.workoutId,
      'clubId': instance.clubId,
    };

AddWorkoutPlanToClubArguments _$AddWorkoutPlanToClubArgumentsFromJson(
        Map<String, dynamic> json) =>
    AddWorkoutPlanToClubArguments(
      workoutPlanId: json['workoutPlanId'] as String,
      clubId: json['clubId'] as String,
    );

Map<String, dynamic> _$AddWorkoutPlanToClubArgumentsToJson(
        AddWorkoutPlanToClubArguments instance) =>
    <String, dynamic>{
      'workoutPlanId': instance.workoutPlanId,
      'clubId': instance.clubId,
    };

PublicWorkoutPlansArguments _$PublicWorkoutPlansArgumentsFromJson(
        Map<String, dynamic> json) =>
    PublicWorkoutPlansArguments(
      cursor: json['cursor'] as String?,
      filters: json['filters'] == null
          ? null
          : WorkoutPlanFiltersInput.fromJson(
              json['filters'] as Map<String, dynamic>),
      take: json['take'] as int?,
    );

Map<String, dynamic> _$PublicWorkoutPlansArgumentsToJson(
        PublicWorkoutPlansArguments instance) =>
    <String, dynamic>{
      'cursor': instance.cursor,
      'filters': instance.filters?.toJson(),
      'take': instance.take,
    };

WorkoutPlanByIdArguments _$WorkoutPlanByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    WorkoutPlanByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$WorkoutPlanByIdArgumentsToJson(
        WorkoutPlanByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

UpdateWorkoutPlanArguments _$UpdateWorkoutPlanArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutPlanArguments(
      data:
          UpdateWorkoutPlanInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateWorkoutPlanArgumentsToJson(
        UpdateWorkoutPlanArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

CreateWorkoutPlanArguments _$CreateWorkoutPlanArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateWorkoutPlanArguments(
      data:
          CreateWorkoutPlanInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateWorkoutPlanArgumentsToJson(
        CreateWorkoutPlanArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

UpdateUserArguments _$UpdateUserArgumentsFromJson(Map<String, dynamic> json) =>
    UpdateUserArguments(
      data: UpdateUserInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateUserArgumentsToJson(
        UpdateUserArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

UserAvatarByIdArguments _$UserAvatarByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    UserAvatarByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$UserAvatarByIdArgumentsToJson(
        UserAvatarByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

UnarchiveWorkoutPlanByIdArguments _$UnarchiveWorkoutPlanByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    UnarchiveWorkoutPlanByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$UnarchiveWorkoutPlanByIdArgumentsToJson(
        UnarchiveWorkoutPlanByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

UnarchiveCustomMoveByIdArguments _$UnarchiveCustomMoveByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    UnarchiveCustomMoveByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$UnarchiveCustomMoveByIdArgumentsToJson(
        UnarchiveCustomMoveByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

ArchiveWorkoutPlanByIdArguments _$ArchiveWorkoutPlanByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    ArchiveWorkoutPlanByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$ArchiveWorkoutPlanByIdArgumentsToJson(
        ArchiveWorkoutPlanByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

UnarchiveWorkoutByIdArguments _$UnarchiveWorkoutByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    UnarchiveWorkoutByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$UnarchiveWorkoutByIdArgumentsToJson(
        UnarchiveWorkoutByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

ArchiveWorkoutByIdArguments _$ArchiveWorkoutByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    ArchiveWorkoutByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$ArchiveWorkoutByIdArgumentsToJson(
        ArchiveWorkoutByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

ArchiveCustomMoveByIdArguments _$ArchiveCustomMoveByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    ArchiveCustomMoveByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$ArchiveCustomMoveByIdArgumentsToJson(
        ArchiveCustomMoveByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

UserAvatarsArguments _$UserAvatarsArgumentsFromJson(
        Map<String, dynamic> json) =>
    UserAvatarsArguments(
      ids: (json['ids'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UserAvatarsArgumentsToJson(
        UserAvatarsArguments instance) =>
    <String, dynamic>{
      'ids': instance.ids,
    };

CreateMoveArguments _$CreateMoveArgumentsFromJson(Map<String, dynamic> json) =>
    CreateMoveArguments(
      data: CreateMoveInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateMoveArgumentsToJson(
        CreateMoveArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

UpdateMoveArguments _$UpdateMoveArgumentsFromJson(Map<String, dynamic> json) =>
    UpdateMoveArguments(
      data: UpdateMoveInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateMoveArgumentsToJson(
        UpdateMoveArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DeleteMoveByIdArguments _$DeleteMoveByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    DeleteMoveByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DeleteMoveByIdArgumentsToJson(
        DeleteMoveByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

DeleteGymProfileByIdArguments _$DeleteGymProfileByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    DeleteGymProfileByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DeleteGymProfileByIdArgumentsToJson(
        DeleteGymProfileByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

CreateGymProfileArguments _$CreateGymProfileArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateGymProfileArguments(
      data:
          CreateGymProfileInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateGymProfileArgumentsToJson(
        CreateGymProfileArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

UpdateGymProfileArguments _$UpdateGymProfileArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateGymProfileArguments(
      data:
          UpdateGymProfileInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateGymProfileArgumentsToJson(
        UpdateGymProfileArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

UserPublicProfilesArguments _$UserPublicProfilesArgumentsFromJson(
        Map<String, dynamic> json) =>
    UserPublicProfilesArguments(
      cursor: json['cursor'] as String?,
      take: json['take'] as int?,
    );

Map<String, dynamic> _$UserPublicProfilesArgumentsToJson(
        UserPublicProfilesArguments instance) =>
    <String, dynamic>{
      'cursor': instance.cursor,
      'take': instance.take,
    };

UserPublicProfileByIdArguments _$UserPublicProfileByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    UserPublicProfileByIdArguments(
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$UserPublicProfileByIdArgumentsToJson(
        UserPublicProfileByIdArguments instance) =>
    <String, dynamic>{
      'userId': instance.userId,
    };

DeleteWorkoutTagByIdArguments _$DeleteWorkoutTagByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    DeleteWorkoutTagByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DeleteWorkoutTagByIdArgumentsToJson(
        DeleteWorkoutTagByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

UpdateWorkoutTagArguments _$UpdateWorkoutTagArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutTagArguments(
      data:
          UpdateWorkoutTagInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateWorkoutTagArgumentsToJson(
        UpdateWorkoutTagArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

CreateWorkoutTagArguments _$CreateWorkoutTagArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateWorkoutTagArguments(
      data:
          CreateWorkoutTagInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateWorkoutTagArgumentsToJson(
        CreateWorkoutTagArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

UpdateWorkoutSetArguments _$UpdateWorkoutSetArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutSetArguments(
      data:
          UpdateWorkoutSetInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateWorkoutSetArgumentsToJson(
        UpdateWorkoutSetArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DuplicateWorkoutSetByIdArguments _$DuplicateWorkoutSetByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    DuplicateWorkoutSetByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DuplicateWorkoutSetByIdArgumentsToJson(
        DuplicateWorkoutSetByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

ReorderWorkoutSetsArguments _$ReorderWorkoutSetsArgumentsFromJson(
        Map<String, dynamic> json) =>
    ReorderWorkoutSetsArguments(
      data: (json['data'] as List<dynamic>)
          .map((e) =>
              UpdateSortPositionInput.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReorderWorkoutSetsArgumentsToJson(
        ReorderWorkoutSetsArguments instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

CreateWorkoutSetArguments _$CreateWorkoutSetArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateWorkoutSetArguments(
      data:
          CreateWorkoutSetInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateWorkoutSetArgumentsToJson(
        CreateWorkoutSetArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DeleteWorkoutSetByIdArguments _$DeleteWorkoutSetByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    DeleteWorkoutSetByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DeleteWorkoutSetByIdArgumentsToJson(
        DeleteWorkoutSetByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

DeleteBodyTransformationPhotosByIdArguments
    _$DeleteBodyTransformationPhotosByIdArgumentsFromJson(
            Map<String, dynamic> json) =>
        DeleteBodyTransformationPhotosByIdArguments(
          ids: (json['ids'] as List<dynamic>).map((e) => e as String).toList(),
        );

Map<String, dynamic> _$DeleteBodyTransformationPhotosByIdArgumentsToJson(
        DeleteBodyTransformationPhotosByIdArguments instance) =>
    <String, dynamic>{
      'ids': instance.ids,
    };

UpdateBodyTransformationPhotoArguments
    _$UpdateBodyTransformationPhotoArgumentsFromJson(
            Map<String, dynamic> json) =>
        UpdateBodyTransformationPhotoArguments(
          data: UpdateBodyTransformationPhotoInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$UpdateBodyTransformationPhotoArgumentsToJson(
        UpdateBodyTransformationPhotoArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

CreateBodyTransformationPhotosArguments
    _$CreateBodyTransformationPhotosArgumentsFromJson(
            Map<String, dynamic> json) =>
        CreateBodyTransformationPhotosArguments(
          data: (json['data'] as List<dynamic>)
              .map((e) => CreateBodyTransformationPhotoInput.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$CreateBodyTransformationPhotosArgumentsToJson(
        CreateBodyTransformationPhotosArguments instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

CheckUniqueDisplayNameArguments _$CheckUniqueDisplayNameArgumentsFromJson(
        Map<String, dynamic> json) =>
    CheckUniqueDisplayNameArguments(
      displayName: json['displayName'] as String,
    );

Map<String, dynamic> _$CheckUniqueDisplayNameArgumentsToJson(
        CheckUniqueDisplayNameArguments instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
    };

DeleteUserBenchmarkTagByIdArguments
    _$DeleteUserBenchmarkTagByIdArgumentsFromJson(Map<String, dynamic> json) =>
        DeleteUserBenchmarkTagByIdArguments(
          id: json['id'] as String,
        );

Map<String, dynamic> _$DeleteUserBenchmarkTagByIdArgumentsToJson(
        DeleteUserBenchmarkTagByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

CreateUserBenchmarkEntryArguments _$CreateUserBenchmarkEntryArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateUserBenchmarkEntryArguments(
      data: CreateUserBenchmarkEntryInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateUserBenchmarkEntryArgumentsToJson(
        CreateUserBenchmarkEntryArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

CreateUserBenchmarkTagArguments _$CreateUserBenchmarkTagArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateUserBenchmarkTagArguments(
      data: CreateUserBenchmarkTagInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateUserBenchmarkTagArgumentsToJson(
        CreateUserBenchmarkTagArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

UpdateUserBenchmarkTagArguments _$UpdateUserBenchmarkTagArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateUserBenchmarkTagArguments(
      data: UpdateUserBenchmarkTagInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateUserBenchmarkTagArgumentsToJson(
        UpdateUserBenchmarkTagArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

UpdateUserBenchmarkEntryArguments _$UpdateUserBenchmarkEntryArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateUserBenchmarkEntryArguments(
      data: UpdateUserBenchmarkEntryInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateUserBenchmarkEntryArgumentsToJson(
        UpdateUserBenchmarkEntryArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DeleteUserBenchmarkEntryByIdArguments
    _$DeleteUserBenchmarkEntryByIdArgumentsFromJson(
            Map<String, dynamic> json) =>
        DeleteUserBenchmarkEntryByIdArguments(
          id: json['id'] as String,
        );

Map<String, dynamic> _$DeleteUserBenchmarkEntryByIdArgumentsToJson(
        DeleteUserBenchmarkEntryByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

UpdateUserBenchmarkArguments _$UpdateUserBenchmarkArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateUserBenchmarkArguments(
      data: UpdateUserBenchmarkInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateUserBenchmarkArgumentsToJson(
        UpdateUserBenchmarkArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

CreateUserBenchmarkArguments _$CreateUserBenchmarkArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateUserBenchmarkArguments(
      data: CreateUserBenchmarkInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateUserBenchmarkArgumentsToJson(
        CreateUserBenchmarkArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DeleteUserBenchmarkByIdArguments _$DeleteUserBenchmarkByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    DeleteUserBenchmarkByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DeleteUserBenchmarkByIdArgumentsToJson(
        DeleteUserBenchmarkByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

UserBenchmarkByIdArguments _$UserBenchmarkByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    UserBenchmarkByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$UserBenchmarkByIdArgumentsToJson(
        UserBenchmarkByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

TextSearchWorkoutPlansArguments _$TextSearchWorkoutPlansArgumentsFromJson(
        Map<String, dynamic> json) =>
    TextSearchWorkoutPlansArguments(
      text: json['text'] as String,
    );

Map<String, dynamic> _$TextSearchWorkoutPlansArgumentsToJson(
        TextSearchWorkoutPlansArguments instance) =>
    <String, dynamic>{
      'text': instance.text,
    };

TextSearchWorkoutPlanNamesArguments
    _$TextSearchWorkoutPlanNamesArgumentsFromJson(Map<String, dynamic> json) =>
        TextSearchWorkoutPlanNamesArguments(
          text: json['text'] as String,
        );

Map<String, dynamic> _$TextSearchWorkoutPlanNamesArgumentsToJson(
        TextSearchWorkoutPlanNamesArguments instance) =>
    <String, dynamic>{
      'text': instance.text,
    };

TextSearchWorkoutsArguments _$TextSearchWorkoutsArgumentsFromJson(
        Map<String, dynamic> json) =>
    TextSearchWorkoutsArguments(
      text: json['text'] as String,
    );

Map<String, dynamic> _$TextSearchWorkoutsArgumentsToJson(
        TextSearchWorkoutsArguments instance) =>
    <String, dynamic>{
      'text': instance.text,
    };

TextSearchWorkoutNamesArguments _$TextSearchWorkoutNamesArgumentsFromJson(
        Map<String, dynamic> json) =>
    TextSearchWorkoutNamesArguments(
      text: json['text'] as String,
    );

Map<String, dynamic> _$TextSearchWorkoutNamesArgumentsToJson(
        TextSearchWorkoutNamesArguments instance) =>
    <String, dynamic>{
      'text': instance.text,
    };

UpdateWorkoutSectionArguments _$UpdateWorkoutSectionArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutSectionArguments(
      data: UpdateWorkoutSectionInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateWorkoutSectionArgumentsToJson(
        UpdateWorkoutSectionArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

CreateWorkoutSectionArguments _$CreateWorkoutSectionArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateWorkoutSectionArguments(
      data: CreateWorkoutSectionInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateWorkoutSectionArgumentsToJson(
        CreateWorkoutSectionArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

ReorderWorkoutSectionsArguments _$ReorderWorkoutSectionsArgumentsFromJson(
        Map<String, dynamic> json) =>
    ReorderWorkoutSectionsArguments(
      data: (json['data'] as List<dynamic>)
          .map((e) =>
              UpdateSortPositionInput.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReorderWorkoutSectionsArgumentsToJson(
        ReorderWorkoutSectionsArguments instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

DeleteWorkoutSectionByIdArguments _$DeleteWorkoutSectionByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    DeleteWorkoutSectionByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DeleteWorkoutSectionByIdArgumentsToJson(
        DeleteWorkoutSectionByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

CreateClubTimelinePostArguments _$CreateClubTimelinePostArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateClubTimelinePostArguments(
      data: CreateClubTimelinePostInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateClubTimelinePostArgumentsToJson(
        CreateClubTimelinePostArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DeleteClubTimelinePostArguments _$DeleteClubTimelinePostArgumentsFromJson(
        Map<String, dynamic> json) =>
    DeleteClubTimelinePostArguments(
      activityId: json['activityId'] as String,
    );

Map<String, dynamic> _$DeleteClubTimelinePostArgumentsToJson(
        DeleteClubTimelinePostArguments instance) =>
    <String, dynamic>{
      'activityId': instance.activityId,
    };

TimelinePostsDataArguments _$TimelinePostsDataArgumentsFromJson(
        Map<String, dynamic> json) =>
    TimelinePostsDataArguments(
      postDataRequests: (json['postDataRequests'] as List<dynamic>)
          .map((e) =>
              TimelinePostDataRequestInput.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TimelinePostsDataArgumentsToJson(
        TimelinePostsDataArguments instance) =>
    <String, dynamic>{
      'postDataRequests':
          instance.postDataRequests.map((e) => e.toJson()).toList(),
    };

ClubMembersFeedPostsArguments _$ClubMembersFeedPostsArgumentsFromJson(
        Map<String, dynamic> json) =>
    ClubMembersFeedPostsArguments(
      clubId: json['clubId'] as String,
      limit: json['limit'] as int,
      offset: json['offset'] as int,
    );

Map<String, dynamic> _$ClubMembersFeedPostsArgumentsToJson(
        ClubMembersFeedPostsArguments instance) =>
    <String, dynamic>{
      'clubId': instance.clubId,
      'limit': instance.limit,
      'offset': instance.offset,
    };

PublicWorkoutsArguments _$PublicWorkoutsArgumentsFromJson(
        Map<String, dynamic> json) =>
    PublicWorkoutsArguments(
      cursor: json['cursor'] as String?,
      filters: json['filters'] == null
          ? null
          : WorkoutFiltersInput.fromJson(
              json['filters'] as Map<String, dynamic>),
      take: json['take'] as int?,
    );

Map<String, dynamic> _$PublicWorkoutsArgumentsToJson(
        PublicWorkoutsArguments instance) =>
    <String, dynamic>{
      'cursor': instance.cursor,
      'filters': instance.filters?.toJson(),
      'take': instance.take,
    };

UpdateWorkoutArguments _$UpdateWorkoutArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutArguments(
      data: UpdateWorkoutInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateWorkoutArgumentsToJson(
        UpdateWorkoutArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DuplicateWorkoutByIdArguments _$DuplicateWorkoutByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    DuplicateWorkoutByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DuplicateWorkoutByIdArgumentsToJson(
        DuplicateWorkoutByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

CreateWorkoutArguments _$CreateWorkoutArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateWorkoutArguments(
      data: CreateWorkoutInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateWorkoutArgumentsToJson(
        CreateWorkoutArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

WorkoutByIdArguments _$WorkoutByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    WorkoutByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$WorkoutByIdArgumentsToJson(
        WorkoutByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

RemoveMemberAdminStatusArguments _$RemoveMemberAdminStatusArgumentsFromJson(
        Map<String, dynamic> json) =>
    RemoveMemberAdminStatusArguments(
      userId: json['userId'] as String,
      clubId: json['clubId'] as String,
    );

Map<String, dynamic> _$RemoveMemberAdminStatusArgumentsToJson(
        RemoveMemberAdminStatusArguments instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'clubId': instance.clubId,
    };

AddUserToClubViaInviteTokenArguments
    _$AddUserToClubViaInviteTokenArgumentsFromJson(Map<String, dynamic> json) =>
        AddUserToClubViaInviteTokenArguments(
          userId: json['userId'] as String,
          clubInviteTokenId: json['clubInviteTokenId'] as String,
        );

Map<String, dynamic> _$AddUserToClubViaInviteTokenArgumentsToJson(
        AddUserToClubViaInviteTokenArguments instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'clubInviteTokenId': instance.clubInviteTokenId,
    };

CheckClubInviteTokenArguments _$CheckClubInviteTokenArgumentsFromJson(
        Map<String, dynamic> json) =>
    CheckClubInviteTokenArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$CheckClubInviteTokenArgumentsToJson(
        CheckClubInviteTokenArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

RemoveUserFromClubArguments _$RemoveUserFromClubArgumentsFromJson(
        Map<String, dynamic> json) =>
    RemoveUserFromClubArguments(
      userToRemoveId: json['userToRemoveId'] as String,
      clubId: json['clubId'] as String,
    );

Map<String, dynamic> _$RemoveUserFromClubArgumentsToJson(
        RemoveUserFromClubArguments instance) =>
    <String, dynamic>{
      'userToRemoveId': instance.userToRemoveId,
      'clubId': instance.clubId,
    };

ClubMembersArguments _$ClubMembersArgumentsFromJson(
        Map<String, dynamic> json) =>
    ClubMembersArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$ClubMembersArgumentsToJson(
        ClubMembersArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

UpdateClubInviteTokenArguments _$UpdateClubInviteTokenArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateClubInviteTokenArguments(
      data: UpdateClubInviteTokenInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateClubInviteTokenArgumentsToJson(
        UpdateClubInviteTokenArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

GiveMemberAdminStatusArguments _$GiveMemberAdminStatusArgumentsFromJson(
        Map<String, dynamic> json) =>
    GiveMemberAdminStatusArguments(
      userId: json['userId'] as String,
      clubId: json['clubId'] as String,
    );

Map<String, dynamic> _$GiveMemberAdminStatusArgumentsToJson(
        GiveMemberAdminStatusArguments instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'clubId': instance.clubId,
    };

CreateClubInviteTokenArguments _$CreateClubInviteTokenArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateClubInviteTokenArguments(
      data: CreateClubInviteTokenInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateClubInviteTokenArgumentsToJson(
        CreateClubInviteTokenArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DeleteClubInviteTokenByIdArguments _$DeleteClubInviteTokenByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    DeleteClubInviteTokenByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DeleteClubInviteTokenByIdArgumentsToJson(
        DeleteClubInviteTokenByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

UpdateScheduledWorkoutArguments _$UpdateScheduledWorkoutArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateScheduledWorkoutArguments(
      data: UpdateScheduledWorkoutInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateScheduledWorkoutArgumentsToJson(
        UpdateScheduledWorkoutArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

CreateScheduledWorkoutArguments _$CreateScheduledWorkoutArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateScheduledWorkoutArguments(
      data: CreateScheduledWorkoutInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateScheduledWorkoutArgumentsToJson(
        CreateScheduledWorkoutArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DeleteScheduledWorkoutByIdArguments
    _$DeleteScheduledWorkoutByIdArgumentsFromJson(Map<String, dynamic> json) =>
        DeleteScheduledWorkoutByIdArguments(
          id: json['id'] as String,
        );

Map<String, dynamic> _$DeleteScheduledWorkoutByIdArgumentsToJson(
        DeleteScheduledWorkoutByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

UserJoinPublicClubArguments _$UserJoinPublicClubArgumentsFromJson(
        Map<String, dynamic> json) =>
    UserJoinPublicClubArguments(
      clubId: json['clubId'] as String,
    );

Map<String, dynamic> _$UserJoinPublicClubArgumentsToJson(
        UserJoinPublicClubArguments instance) =>
    <String, dynamic>{
      'clubId': instance.clubId,
    };

LifetimeLogStatsSummaryArguments _$LifetimeLogStatsSummaryArgumentsFromJson(
        Map<String, dynamic> json) =>
    LifetimeLogStatsSummaryArguments(
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$LifetimeLogStatsSummaryArgumentsToJson(
        LifetimeLogStatsSummaryArguments instance) =>
    <String, dynamic>{
      'userId': instance.userId,
    };

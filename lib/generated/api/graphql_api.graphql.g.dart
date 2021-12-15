// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.12

part of 'graphql_api.graphql.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteJournalGoalById$Mutation _$DeleteJournalGoalById$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteJournalGoalById$Mutation()
      ..deleteJournalGoalById = json['deleteJournalGoalById'] as String;

Map<String, dynamic> _$DeleteJournalGoalById$MutationToJson(
        DeleteJournalGoalById$Mutation instance) =>
    <String, dynamic>{
      'deleteJournalGoalById': instance.deleteJournalGoalById,
    };

JournalMood _$JournalMoodFromJson(Map<String, dynamic> json) => JournalMood()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
  ..moodScore = (json['moodScore'] as num?)?.toDouble()
  ..energyScore = (json['energyScore'] as num?)?.toDouble()
  ..confidenceScore = (json['confidenceScore'] as num?)?.toDouble()
  ..motivationScore = (json['motivationScore'] as num?)?.toDouble();

Map<String, dynamic> _$JournalMoodToJson(JournalMood instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'moodScore': instance.moodScore,
      'energyScore': instance.energyScore,
      'confidenceScore': instance.confidenceScore,
      'motivationScore': instance.motivationScore,
    };

JournalMoods$Query _$JournalMoods$QueryFromJson(Map<String, dynamic> json) =>
    JournalMoods$Query()
      ..journalMoods = (json['journalMoods'] as List<dynamic>)
          .map((e) => JournalMood.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$JournalMoods$QueryToJson(JournalMoods$Query instance) =>
    <String, dynamic>{
      'journalMoods': instance.journalMoods.map((e) => e.toJson()).toList(),
    };

UpdateJournalMood$Mutation _$UpdateJournalMood$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateJournalMood$Mutation()
      ..updateJournalMood = JournalMood.fromJson(
          json['updateJournalMood'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateJournalMood$MutationToJson(
        UpdateJournalMood$Mutation instance) =>
    <String, dynamic>{
      'updateJournalMood': instance.updateJournalMood.toJson(),
    };

UpdateJournalMoodInput _$UpdateJournalMoodInputFromJson(
        Map<String, dynamic> json) =>
    UpdateJournalMoodInput(
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble(),
      energyScore: (json['energyScore'] as num?)?.toDouble(),
      id: json['id'] as String,
      moodScore: (json['moodScore'] as num?)?.toDouble(),
      motivationScore: (json['motivationScore'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UpdateJournalMoodInputToJson(
        UpdateJournalMoodInput instance) =>
    <String, dynamic>{
      'confidenceScore': instance.confidenceScore,
      'energyScore': instance.energyScore,
      'id': instance.id,
      'moodScore': instance.moodScore,
      'motivationScore': instance.motivationScore,
    };

JournalGoal _$JournalGoalFromJson(Map<String, dynamic> json) => JournalGoal()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
  ..name = json['name'] as String
  ..description = json['description'] as String?
  ..deadline = fromGraphQLDateTimeNullableToDartDateTimeNullable(
      json['deadline'] as int?)
  ..completedDate = fromGraphQLDateTimeNullableToDartDateTimeNullable(
      json['completedDate'] as int?);

Map<String, dynamic> _$JournalGoalToJson(JournalGoal instance) =>
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
    };

JournalGoals$Query _$JournalGoals$QueryFromJson(Map<String, dynamic> json) =>
    JournalGoals$Query()
      ..journalGoals = (json['journalGoals'] as List<dynamic>)
          .map((e) => JournalGoal.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$JournalGoals$QueryToJson(JournalGoals$Query instance) =>
    <String, dynamic>{
      'journalGoals': instance.journalGoals.map((e) => e.toJson()).toList(),
    };

CreateJournalGoal$Mutation _$CreateJournalGoal$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateJournalGoal$Mutation()
      ..createJournalGoal = JournalGoal.fromJson(
          json['createJournalGoal'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateJournalGoal$MutationToJson(
        CreateJournalGoal$Mutation instance) =>
    <String, dynamic>{
      'createJournalGoal': instance.createJournalGoal.toJson(),
    };

CreateJournalGoalInput _$CreateJournalGoalInputFromJson(
        Map<String, dynamic> json) =>
    CreateJournalGoalInput(
      deadline: fromGraphQLDateTimeNullableToDartDateTimeNullable(
          json['deadline'] as int?),
      description: json['description'] as String?,
      name: json['name'] as String,
    );

Map<String, dynamic> _$CreateJournalGoalInputToJson(
        CreateJournalGoalInput instance) =>
    <String, dynamic>{
      'deadline':
          fromDartDateTimeNullableToGraphQLDateTimeNullable(instance.deadline),
      'description': instance.description,
      'name': instance.name,
    };

DeleteJournalNoteById$Mutation _$DeleteJournalNoteById$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteJournalNoteById$Mutation()
      ..deleteJournalNoteById = json['deleteJournalNoteById'] as String;

Map<String, dynamic> _$DeleteJournalNoteById$MutationToJson(
        DeleteJournalNoteById$Mutation instance) =>
    <String, dynamic>{
      'deleteJournalNoteById': instance.deleteJournalNoteById,
    };

JournalNote _$JournalNoteFromJson(Map<String, dynamic> json) => JournalNote()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
  ..textNote = json['textNote'] as String?
  ..voiceNoteUri = json['voiceNoteUri'] as String?;

Map<String, dynamic> _$JournalNoteToJson(JournalNote instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'textNote': instance.textNote,
      'voiceNoteUri': instance.voiceNoteUri,
    };

UpdateJournalNote$Mutation _$UpdateJournalNote$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateJournalNote$Mutation()
      ..updateJournalNote = JournalNote.fromJson(
          json['updateJournalNote'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateJournalNote$MutationToJson(
        UpdateJournalNote$Mutation instance) =>
    <String, dynamic>{
      'updateJournalNote': instance.updateJournalNote.toJson(),
    };

UpdateJournalNoteInput _$UpdateJournalNoteInputFromJson(
        Map<String, dynamic> json) =>
    UpdateJournalNoteInput(
      id: json['id'] as String,
      textNote: json['textNote'] as String?,
      voiceNoteUri: json['voiceNoteUri'] as String?,
    );

Map<String, dynamic> _$UpdateJournalNoteInputToJson(
        UpdateJournalNoteInput instance) =>
    <String, dynamic>{
      'id': instance.id,
      'textNote': instance.textNote,
      'voiceNoteUri': instance.voiceNoteUri,
    };

DeleteJournalMoodById$Mutation _$DeleteJournalMoodById$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteJournalMoodById$Mutation()
      ..deleteJournalMoodById = json['deleteJournalMoodById'] as String;

Map<String, dynamic> _$DeleteJournalMoodById$MutationToJson(
        DeleteJournalMoodById$Mutation instance) =>
    <String, dynamic>{
      'deleteJournalMoodById': instance.deleteJournalMoodById,
    };

UpdateJournalGoal$Mutation _$UpdateJournalGoal$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateJournalGoal$Mutation()
      ..updateJournalGoal = JournalGoal.fromJson(
          json['updateJournalGoal'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateJournalGoal$MutationToJson(
        UpdateJournalGoal$Mutation instance) =>
    <String, dynamic>{
      'updateJournalGoal': instance.updateJournalGoal.toJson(),
    };

UpdateJournalGoalInput _$UpdateJournalGoalInputFromJson(
        Map<String, dynamic> json) =>
    UpdateJournalGoalInput(
      completedDate: fromGraphQLDateTimeNullableToDartDateTimeNullable(
          json['completedDate'] as int?),
      deadline: fromGraphQLDateTimeNullableToDartDateTimeNullable(
          json['deadline'] as int?),
      description: json['description'] as String?,
      id: json['id'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$UpdateJournalGoalInputToJson(
        UpdateJournalGoalInput instance) =>
    <String, dynamic>{
      'completedDate': fromDartDateTimeNullableToGraphQLDateTimeNullable(
          instance.completedDate),
      'deadline':
          fromDartDateTimeNullableToGraphQLDateTimeNullable(instance.deadline),
      'description': instance.description,
      'id': instance.id,
      'name': instance.name,
    };

CreateJournalMood$Mutation _$CreateJournalMood$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateJournalMood$Mutation()
      ..createJournalMood = JournalMood.fromJson(
          json['createJournalMood'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateJournalMood$MutationToJson(
        CreateJournalMood$Mutation instance) =>
    <String, dynamic>{
      'createJournalMood': instance.createJournalMood.toJson(),
    };

CreateJournalMoodInput _$CreateJournalMoodInputFromJson(
        Map<String, dynamic> json) =>
    CreateJournalMoodInput(
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble(),
      energyScore: (json['energyScore'] as num?)?.toDouble(),
      moodScore: (json['moodScore'] as num?)?.toDouble(),
      motivationScore: (json['motivationScore'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CreateJournalMoodInputToJson(
        CreateJournalMoodInput instance) =>
    <String, dynamic>{
      'confidenceScore': instance.confidenceScore,
      'energyScore': instance.energyScore,
      'moodScore': instance.moodScore,
      'motivationScore': instance.motivationScore,
    };

CreateJournalNote$Mutation _$CreateJournalNote$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateJournalNote$Mutation()
      ..createJournalNote = JournalNote.fromJson(
          json['createJournalNote'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateJournalNote$MutationToJson(
        CreateJournalNote$Mutation instance) =>
    <String, dynamic>{
      'createJournalNote': instance.createJournalNote.toJson(),
    };

CreateJournalNoteInput _$CreateJournalNoteInputFromJson(
        Map<String, dynamic> json) =>
    CreateJournalNoteInput(
      textNote: json['textNote'] as String?,
      voiceNoteUri: json['voiceNoteUri'] as String?,
    );

Map<String, dynamic> _$CreateJournalNoteInputToJson(
        CreateJournalNoteInput instance) =>
    <String, dynamic>{
      'textNote': instance.textNote,
      'voiceNoteUri': instance.voiceNoteUri,
    };

JournalNotes$Query _$JournalNotes$QueryFromJson(Map<String, dynamic> json) =>
    JournalNotes$Query()
      ..journalNotes = (json['journalNotes'] as List<dynamic>)
          .map((e) => JournalNote.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$JournalNotes$QueryToJson(JournalNotes$Query instance) =>
    <String, dynamic>{
      'journalNotes': instance.journalNotes.map((e) => e.toJson()).toList(),
    };

UserSummary _$UserSummaryFromJson(Map<String, dynamic> json) => UserSummary()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..avatarUri = json['avatarUri'] as String?
  ..displayName = json['displayName'] as String
  ..userProfileScope = $enumDecode(
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

const _$UserProfileScopeEnumMap = {
  UserProfileScope.private: 'PRIVATE',
  UserProfileScope.public: 'PUBLIC',
  UserProfileScope.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

ClubSummary _$ClubSummaryFromJson(Map<String, dynamic> json) => ClubSummary()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
  ..name = json['name'] as String
  ..description = json['description'] as String?
  ..coverImageUri = json['coverImageUri'] as String?
  ..location = json['location'] as String?
  ..memberCount = json['memberCount'] as int
  ..owner = UserSummary.fromJson(json['Owner'] as Map<String, dynamic>);

Map<String, dynamic> _$ClubSummaryToJson(ClubSummary instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'name': instance.name,
      'description': instance.description,
      'coverImageUri': instance.coverImageUri,
      'location': instance.location,
      'memberCount': instance.memberCount,
      'Owner': instance.owner.toJson(),
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

WorkoutSummary _$WorkoutSummaryFromJson(Map<String, dynamic> json) =>
    WorkoutSummary()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..archived = json['archived'] as bool
      ..name = json['name'] as String
      ..user = UserSummary.fromJson(json['User'] as Map<String, dynamic>)
      ..lengthMinutes = json['lengthMinutes'] as int?
      ..coverImageUri = json['coverImageUri'] as String?
      ..description = json['description'] as String?
      ..difficultyLevel = $enumDecodeNullable(
          _$DifficultyLevelEnumMap, json['difficultyLevel'],
          unknownValue: DifficultyLevel.artemisUnknown)
      ..loggedSessionsCount = json['loggedSessionsCount'] as int
      ..hasClassVideo = json['hasClassVideo'] as bool
      ..hasClassAudio = json['hasClassAudio'] as bool
      ..equipments =
          (json['equipments'] as List<dynamic>).map((e) => e as String).toList()
      ..tags = (json['tags'] as List<dynamic>).map((e) => e as String).toList();

Map<String, dynamic> _$WorkoutSummaryToJson(WorkoutSummary instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'archived': instance.archived,
      'name': instance.name,
      'User': instance.user.toJson(),
      'lengthMinutes': instance.lengthMinutes,
      'coverImageUri': instance.coverImageUri,
      'description': instance.description,
      'difficultyLevel': _$DifficultyLevelEnumMap[instance.difficultyLevel],
      'loggedSessionsCount': instance.loggedSessionsCount,
      'hasClassVideo': instance.hasClassVideo,
      'hasClassAudio': instance.hasClassAudio,
      'equipments': instance.equipments,
      'tags': instance.tags,
    };

const _$DifficultyLevelEnumMap = {
  DifficultyLevel.advanced: 'ADVANCED',
  DifficultyLevel.challenging: 'CHALLENGING',
  DifficultyLevel.elite: 'ELITE',
  DifficultyLevel.intermediate: 'INTERMEDIATE',
  DifficultyLevel.light: 'LIGHT',
  DifficultyLevel.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

WorkoutPlanSummary _$WorkoutPlanSummaryFromJson(Map<String, dynamic> json) =>
    WorkoutPlanSummary()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..archived = json['archived'] as bool
      ..name = json['name'] as String
      ..description = json['description'] as String?
      ..coverImageUri = json['coverImageUri'] as String?
      ..lengthWeeks = json['lengthWeeks'] as int
      ..daysPerWeek = json['daysPerWeek'] as int
      ..workoutsCount = json['workoutsCount'] as int
      ..user = UserSummary.fromJson(json['User'] as Map<String, dynamic>)
      ..enrolmentsCount = json['enrolmentsCount'] as int
      ..goals = (json['goals'] as List<dynamic>)
          .map((e) => WorkoutGoal.fromJson(e as Map<String, dynamic>))
          .toList()
      ..tags = (json['tags'] as List<dynamic>).map((e) => e as String).toList()
      ..reviewScore = (json['reviewScore'] as num?)?.toDouble()
      ..reviewCount = json['reviewCount'] as int;

Map<String, dynamic> _$WorkoutPlanSummaryToJson(WorkoutPlanSummary instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'archived': instance.archived,
      'name': instance.name,
      'description': instance.description,
      'coverImageUri': instance.coverImageUri,
      'lengthWeeks': instance.lengthWeeks,
      'daysPerWeek': instance.daysPerWeek,
      'workoutsCount': instance.workoutsCount,
      'User': instance.user.toJson(),
      'enrolmentsCount': instance.enrolmentsCount,
      'goals': instance.goals.map((e) => e.toJson()).toList(),
      'tags': instance.tags,
      'reviewScore': instance.reviewScore,
      'reviewCount': instance.reviewCount,
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
  ..contentAccessScope = $enumDecode(
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
  ..workouts = (json['Workouts'] as List<dynamic>?)
      ?.map((e) => WorkoutSummary.fromJson(e as Map<String, dynamic>))
      .toList()
  ..workoutPlans = (json['WorkoutPlans'] as List<dynamic>?)
      ?.map((e) => WorkoutPlanSummary.fromJson(e as Map<String, dynamic>))
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
      'Workouts': instance.workouts?.map((e) => e.toJson()).toList(),
      'WorkoutPlans': instance.workoutPlans?.map((e) => e.toJson()).toList(),
    };

const _$ContentAccessScopeEnumMap = {
  ContentAccessScope.private: 'PRIVATE',
  ContentAccessScope.public: 'PUBLIC',
  ContentAccessScope.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

CreateClub$Mutation _$CreateClub$MutationFromJson(Map<String, dynamic> json) =>
    CreateClub$Mutation()
      ..createClub = Club.fromJson(json['createClub'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateClub$MutationToJson(
        CreateClub$Mutation instance) =>
    <String, dynamic>{
      'createClub': instance.createClub.toJson(),
    };

WorkoutSummaryMixin$UserSummary _$WorkoutSummaryMixin$UserSummaryFromJson(
        Map<String, dynamic> json) =>
    WorkoutSummaryMixin$UserSummary()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..avatarUri = json['avatarUri'] as String?
      ..displayName = json['displayName'] as String
      ..userProfileScope = $enumDecode(
          _$UserProfileScopeEnumMap, json['userProfileScope'],
          unknownValue: UserProfileScope.artemisUnknown);

Map<String, dynamic> _$WorkoutSummaryMixin$UserSummaryToJson(
        WorkoutSummaryMixin$UserSummary instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'avatarUri': instance.avatarUri,
      'displayName': instance.displayName,
      'userProfileScope': _$UserProfileScopeEnumMap[instance.userProfileScope],
    };

WorkoutPlanSummaryMixin$UserSummary
    _$WorkoutPlanSummaryMixin$UserSummaryFromJson(Map<String, dynamic> json) =>
        WorkoutPlanSummaryMixin$UserSummary()
          ..$$typename = json['__typename'] as String?
          ..id = json['id'] as String
          ..avatarUri = json['avatarUri'] as String?
          ..displayName = json['displayName'] as String
          ..userProfileScope = $enumDecode(
              _$UserProfileScopeEnumMap, json['userProfileScope'],
              unknownValue: UserProfileScope.artemisUnknown);

Map<String, dynamic> _$WorkoutPlanSummaryMixin$UserSummaryToJson(
        WorkoutPlanSummaryMixin$UserSummary instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'avatarUri': instance.avatarUri,
      'displayName': instance.displayName,
      'userProfileScope': _$UserProfileScopeEnumMap[instance.userProfileScope],
    };

WorkoutPlanSummaryMixin$WorkoutGoal
    _$WorkoutPlanSummaryMixin$WorkoutGoalFromJson(Map<String, dynamic> json) =>
        WorkoutPlanSummaryMixin$WorkoutGoal()
          ..$$typename = json['__typename'] as String?
          ..id = json['id'] as String
          ..name = json['name'] as String
          ..description = json['description'] as String
          ..hexColor = json['hexColor'] as String;

Map<String, dynamic> _$WorkoutPlanSummaryMixin$WorkoutGoalToJson(
        WorkoutPlanSummaryMixin$WorkoutGoal instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'hexColor': instance.hexColor,
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
      contentAccessScope: $enumDecodeNullable(
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

ClubById$Query _$ClubById$QueryFromJson(Map<String, dynamic> json) =>
    ClubById$Query()
      ..clubById = Club.fromJson(json['clubById'] as Map<String, dynamic>);

Map<String, dynamic> _$ClubById$QueryToJson(ClubById$Query instance) =>
    <String, dynamic>{
      'clubById': instance.clubById.toJson(),
    };

CheckUniqueClubName$Query _$CheckUniqueClubName$QueryFromJson(
        Map<String, dynamic> json) =>
    CheckUniqueClubName$Query()
      ..checkUniqueClubName = json['checkUniqueClubName'] as bool;

Map<String, dynamic> _$CheckUniqueClubName$QueryToJson(
        CheckUniqueClubName$Query instance) =>
    <String, dynamic>{
      'checkUniqueClubName': instance.checkUniqueClubName,
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

BodyTrackingEntry _$BodyTrackingEntryFromJson(Map<String, dynamic> json) =>
    BodyTrackingEntry()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..bodyweightUnit = $enumDecodeNullable(
          _$BodyweightUnitEnumMap, json['bodyweightUnit'],
          unknownValue: BodyweightUnit.artemisUnknown)
      ..bodyweight = (json['bodyweight'] as num?)?.toDouble()
      ..fatPercent = (json['fatPercent'] as num?)?.toDouble()
      ..note = json['note'] as String?
      ..photoUris =
          (json['photoUris'] as List<dynamic>).map((e) => e as String).toList();

Map<String, dynamic> _$BodyTrackingEntryToJson(BodyTrackingEntry instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'bodyweightUnit': _$BodyweightUnitEnumMap[instance.bodyweightUnit],
      'bodyweight': instance.bodyweight,
      'fatPercent': instance.fatPercent,
      'note': instance.note,
      'photoUris': instance.photoUris,
    };

const _$BodyweightUnitEnumMap = {
  BodyweightUnit.kg: 'KG',
  BodyweightUnit.lb: 'LB',
  BodyweightUnit.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

CreateBodyTrackingEntry$Mutation _$CreateBodyTrackingEntry$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateBodyTrackingEntry$Mutation()
      ..createBodyTrackingEntry = BodyTrackingEntry.fromJson(
          json['createBodyTrackingEntry'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateBodyTrackingEntry$MutationToJson(
        CreateBodyTrackingEntry$Mutation instance) =>
    <String, dynamic>{
      'createBodyTrackingEntry': instance.createBodyTrackingEntry.toJson(),
    };

CreateBodyTrackingEntryInput _$CreateBodyTrackingEntryInputFromJson(
        Map<String, dynamic> json) =>
    CreateBodyTrackingEntryInput(
      bodyweight: (json['bodyweight'] as num?)?.toDouble(),
      bodyweightUnit: $enumDecodeNullable(
          _$BodyweightUnitEnumMap, json['bodyweightUnit'],
          unknownValue: BodyweightUnit.artemisUnknown),
      fatPercent: (json['fatPercent'] as num?)?.toDouble(),
      note: json['note'] as String?,
      photoUris: (json['photoUris'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CreateBodyTrackingEntryInputToJson(
        CreateBodyTrackingEntryInput instance) =>
    <String, dynamic>{
      'bodyweight': instance.bodyweight,
      'bodyweightUnit': _$BodyweightUnitEnumMap[instance.bodyweightUnit],
      'fatPercent': instance.fatPercent,
      'note': instance.note,
      'photoUris': instance.photoUris,
    };

UpdateBodyTrackingEntry$Mutation _$UpdateBodyTrackingEntry$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateBodyTrackingEntry$Mutation()
      ..updateBodyTrackingEntry = BodyTrackingEntry.fromJson(
          json['updateBodyTrackingEntry'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateBodyTrackingEntry$MutationToJson(
        UpdateBodyTrackingEntry$Mutation instance) =>
    <String, dynamic>{
      'updateBodyTrackingEntry': instance.updateBodyTrackingEntry.toJson(),
    };

UpdateBodyTrackingEntryInput _$UpdateBodyTrackingEntryInputFromJson(
        Map<String, dynamic> json) =>
    UpdateBodyTrackingEntryInput(
      bodyweight: (json['bodyweight'] as num?)?.toDouble(),
      bodyweightUnit: $enumDecodeNullable(
          _$BodyweightUnitEnumMap, json['bodyweightUnit'],
          unknownValue: BodyweightUnit.artemisUnknown),
      fatPercent: (json['fatPercent'] as num?)?.toDouble(),
      id: json['id'] as String,
      note: json['note'] as String?,
      photoUris: (json['photoUris'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UpdateBodyTrackingEntryInputToJson(
        UpdateBodyTrackingEntryInput instance) =>
    <String, dynamic>{
      'bodyweight': instance.bodyweight,
      'bodyweightUnit': _$BodyweightUnitEnumMap[instance.bodyweightUnit],
      'fatPercent': instance.fatPercent,
      'id': instance.id,
      'note': instance.note,
      'photoUris': instance.photoUris,
    };

DeleteBodyTrackingEntryById$Mutation
    _$DeleteBodyTrackingEntryById$MutationFromJson(Map<String, dynamic> json) =>
        DeleteBodyTrackingEntryById$Mutation()
          ..deleteBodyTrackingEntryById =
              json['deleteBodyTrackingEntryById'] as String;

Map<String, dynamic> _$DeleteBodyTrackingEntryById$MutationToJson(
        DeleteBodyTrackingEntryById$Mutation instance) =>
    <String, dynamic>{
      'deleteBodyTrackingEntryById': instance.deleteBodyTrackingEntryById,
    };

BodyTrackingEntries$Query _$BodyTrackingEntries$QueryFromJson(
        Map<String, dynamic> json) =>
    BodyTrackingEntries$Query()
      ..bodyTrackingEntries = (json['bodyTrackingEntries'] as List<dynamic>)
          .map((e) => BodyTrackingEntry.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$BodyTrackingEntries$QueryToJson(
        BodyTrackingEntries$Query instance) =>
    <String, dynamic>{
      'bodyTrackingEntries':
          instance.bodyTrackingEntries.map((e) => e.toJson()).toList(),
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
  ..frontBack = $enumDecode(_$BodyAreaFrontBackEnumMap, json['frontBack'],
      unknownValue: BodyAreaFrontBack.artemisUnknown)
  ..upperLower = $enumDecode(_$BodyAreaUpperLowerEnumMap, json['upperLower'],
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
  ..scope = $enumDecode(_$MoveScopeEnumMap, json['scope'],
      unknownValue: MoveScope.artemisUnknown)
  ..validRepTypes = (json['validRepTypes'] as List<dynamic>)
      .map((e) => $enumDecode(_$WorkoutMoveRepTypeEnumMap, e,
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
  ..repType = $enumDecode(_$WorkoutMoveRepTypeEnumMap, json['repType'],
      unknownValue: WorkoutMoveRepType.artemisUnknown)
  ..distanceUnit = $enumDecode(_$DistanceUnitEnumMap, json['distanceUnit'],
      unknownValue: DistanceUnit.artemisUnknown)
  ..loadAmount = (json['loadAmount'] as num).toDouble()
  ..loadUnit = $enumDecode(_$LoadUnitEnumMap, json['loadUnit'],
      unknownValue: LoadUnit.artemisUnknown)
  ..timeUnit = $enumDecode(_$TimeUnitEnumMap, json['timeUnit'],
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
      distanceUnit: $enumDecodeNullable(
          _$DistanceUnitEnumMap, json['distanceUnit'],
          unknownValue: DistanceUnit.artemisUnknown),
      loadAmount: (json['loadAmount'] as num).toDouble(),
      loadUnit: $enumDecodeNullable(_$LoadUnitEnumMap, json['loadUnit'],
          unknownValue: LoadUnit.artemisUnknown),
      repType: $enumDecode(_$WorkoutMoveRepTypeEnumMap, json['repType'],
          unknownValue: WorkoutMoveRepType.artemisUnknown),
      reps: (json['reps'] as num).toDouble(),
      sortPosition: json['sortPosition'] as int,
      timeUnit: $enumDecodeNullable(_$TimeUnitEnumMap, json['timeUnit'],
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

UpdateWorkoutMoves$Mutation _$UpdateWorkoutMoves$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutMoves$Mutation()
      ..updateWorkoutMoves = (json['updateWorkoutMoves'] as List<dynamic>)
          .map((e) => WorkoutMove.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UpdateWorkoutMoves$MutationToJson(
        UpdateWorkoutMoves$Mutation instance) =>
    <String, dynamic>{
      'updateWorkoutMoves':
          instance.updateWorkoutMoves.map((e) => e.toJson()).toList(),
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
      distanceUnit: $enumDecodeNullable(
          _$DistanceUnitEnumMap, json['distanceUnit'],
          unknownValue: DistanceUnit.artemisUnknown),
      id: json['id'] as String,
      loadAmount: (json['loadAmount'] as num?)?.toDouble(),
      loadUnit: $enumDecodeNullable(_$LoadUnitEnumMap, json['loadUnit'],
          unknownValue: LoadUnit.artemisUnknown),
      repType: $enumDecodeNullable(_$WorkoutMoveRepTypeEnumMap, json['repType'],
          unknownValue: WorkoutMoveRepType.artemisUnknown),
      reps: (json['reps'] as num?)?.toDouble(),
      timeUnit: $enumDecodeNullable(_$TimeUnitEnumMap, json['timeUnit'],
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
  ..workouts = (json['Workouts'] as List<dynamic>)
      .map((e) => WorkoutSummary.fromJson(e as Map<String, dynamic>))
      .toList()
  ..workoutPlans = (json['WorkoutPlans'] as List<dynamic>)
      .map((e) => WorkoutPlanSummary.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$CollectionToJson(Collection instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'name': instance.name,
      'description': instance.description,
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

Workout _$WorkoutFromJson(Map<String, dynamic> json) => Workout()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
  ..archived = json['archived'] as bool
  ..name = json['name'] as String
  ..description = json['description'] as String?
  ..lengthMinutes = json['lengthMinutes'] as int?
  ..difficultyLevel = $enumDecodeNullable(
      _$DifficultyLevelEnumMap, json['difficultyLevel'],
      unknownValue: DifficultyLevel.artemisUnknown)
  ..coverImageUri = json['coverImageUri'] as String?
  ..contentAccessScope = $enumDecode(
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

WorkoutDataMixin$UserSummary _$WorkoutDataMixin$UserSummaryFromJson(
        Map<String, dynamic> json) =>
    WorkoutDataMixin$UserSummary()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..avatarUri = json['avatarUri'] as String?
      ..displayName = json['displayName'] as String
      ..userProfileScope = $enumDecode(
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

WorkoutPlanEnrolmentSummary _$WorkoutPlanEnrolmentSummaryFromJson(
        Map<String, dynamic> json) =>
    WorkoutPlanEnrolmentSummary()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..startDate = fromGraphQLDateTimeNullableToDartDateTimeNullable(
          json['startDate'] as int?)
      ..completedWorkoutsCount = json['completedWorkoutsCount'] as int
      ..workoutPlan = WorkoutPlanSummary.fromJson(
          json['WorkoutPlan'] as Map<String, dynamic>);

Map<String, dynamic> _$WorkoutPlanEnrolmentSummaryToJson(
        WorkoutPlanEnrolmentSummary instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'startDate':
          fromDartDateTimeNullableToGraphQLDateTimeNullable(instance.startDate),
      'completedWorkoutsCount': instance.completedWorkoutsCount,
      'WorkoutPlan': instance.workoutPlan.toJson(),
    };

WorkoutPlanEnrolments$Query _$WorkoutPlanEnrolments$QueryFromJson(
        Map<String, dynamic> json) =>
    WorkoutPlanEnrolments$Query()
      ..workoutPlanEnrolments = (json['workoutPlanEnrolments'] as List<dynamic>)
          .map((e) =>
              WorkoutPlanEnrolmentSummary.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$WorkoutPlanEnrolments$QueryToJson(
        WorkoutPlanEnrolments$Query instance) =>
    <String, dynamic>{
      'workoutPlanEnrolments':
          instance.workoutPlanEnrolments.map((e) => e.toJson()).toList(),
    };

WorkoutPlanEnrolmentSummaryMixin$WorkoutPlanSummary
    _$WorkoutPlanEnrolmentSummaryMixin$WorkoutPlanSummaryFromJson(
            Map<String, dynamic> json) =>
        WorkoutPlanEnrolmentSummaryMixin$WorkoutPlanSummary()
          ..$$typename = json['__typename'] as String?
          ..id = json['id'] as String
          ..createdAt =
              fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
          ..archived = json['archived'] as bool
          ..name = json['name'] as String
          ..description = json['description'] as String?
          ..coverImageUri = json['coverImageUri'] as String?
          ..lengthWeeks = json['lengthWeeks'] as int
          ..daysPerWeek = json['daysPerWeek'] as int
          ..workoutsCount = json['workoutsCount'] as int
          ..user = UserSummary.fromJson(json['User'] as Map<String, dynamic>)
          ..enrolmentsCount = json['enrolmentsCount'] as int
          ..goals = (json['goals'] as List<dynamic>)
              .map((e) => WorkoutGoal.fromJson(e as Map<String, dynamic>))
              .toList()
          ..tags =
              (json['tags'] as List<dynamic>).map((e) => e as String).toList()
          ..reviewScore = (json['reviewScore'] as num?)?.toDouble()
          ..reviewCount = json['reviewCount'] as int;

Map<String, dynamic>
    _$WorkoutPlanEnrolmentSummaryMixin$WorkoutPlanSummaryToJson(
            WorkoutPlanEnrolmentSummaryMixin$WorkoutPlanSummary instance) =>
        <String, dynamic>{
          '__typename': instance.$$typename,
          'id': instance.id,
          'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
          'archived': instance.archived,
          'name': instance.name,
          'description': instance.description,
          'coverImageUri': instance.coverImageUri,
          'lengthWeeks': instance.lengthWeeks,
          'daysPerWeek': instance.daysPerWeek,
          'workoutsCount': instance.workoutsCount,
          'User': instance.user.toJson(),
          'enrolmentsCount': instance.enrolmentsCount,
          'goals': instance.goals.map((e) => e.toJson()).toList(),
          'tags': instance.tags,
          'reviewScore': instance.reviewScore,
          'reviewCount': instance.reviewCount,
        };

CompletedWorkoutPlanDayWorkout _$CompletedWorkoutPlanDayWorkoutFromJson(
        Map<String, dynamic> json) =>
    CompletedWorkoutPlanDayWorkout()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..loggedWorkoutId = json['loggedWorkoutId'] as String
      ..workoutPlanDayWorkoutId = json['workoutPlanDayWorkoutId'] as String;

Map<String, dynamic> _$CompletedWorkoutPlanDayWorkoutToJson(
        CompletedWorkoutPlanDayWorkout instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'loggedWorkoutId': instance.loggedWorkoutId,
      'workoutPlanDayWorkoutId': instance.workoutPlanDayWorkoutId,
    };

WorkoutPlanEnrolment _$WorkoutPlanEnrolmentFromJson(
        Map<String, dynamic> json) =>
    WorkoutPlanEnrolment()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..startDate = fromGraphQLDateTimeNullableToDartDateTimeNullable(
          json['startDate'] as int?)
      ..completedWorkoutPlanDayWorkouts =
          (json['CompletedWorkoutPlanDayWorkouts'] as List<dynamic>)
              .map((e) => CompletedWorkoutPlanDayWorkout.fromJson(
                  e as Map<String, dynamic>))
              .toList()
      ..user = UserSummary.fromJson(json['User'] as Map<String, dynamic>);

Map<String, dynamic> _$WorkoutPlanEnrolmentToJson(
        WorkoutPlanEnrolment instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'startDate':
          fromDartDateTimeNullableToGraphQLDateTimeNullable(instance.startDate),
      'CompletedWorkoutPlanDayWorkouts': instance
          .completedWorkoutPlanDayWorkouts
          .map((e) => e.toJson())
          .toList(),
      'User': instance.user.toJson(),
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
  ..contentAccessScope = $enumDecode(
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

WorkoutPlanEnrolmentWithPlan _$WorkoutPlanEnrolmentWithPlanFromJson(
        Map<String, dynamic> json) =>
    WorkoutPlanEnrolmentWithPlan()
      ..$$typename = json['__typename'] as String?
      ..workoutPlanEnrolment = WorkoutPlanEnrolment.fromJson(
          json['WorkoutPlanEnrolment'] as Map<String, dynamic>)
      ..workoutPlan =
          WorkoutPlan.fromJson(json['WorkoutPlan'] as Map<String, dynamic>);

Map<String, dynamic> _$WorkoutPlanEnrolmentWithPlanToJson(
        WorkoutPlanEnrolmentWithPlan instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'WorkoutPlanEnrolment': instance.workoutPlanEnrolment.toJson(),
      'WorkoutPlan': instance.workoutPlan.toJson(),
    };

WorkoutPlanEnrolmentById$Query _$WorkoutPlanEnrolmentById$QueryFromJson(
        Map<String, dynamic> json) =>
    WorkoutPlanEnrolmentById$Query()
      ..workoutPlanEnrolmentById = WorkoutPlanEnrolmentWithPlan.fromJson(
          json['workoutPlanEnrolmentById'] as Map<String, dynamic>);

Map<String, dynamic> _$WorkoutPlanEnrolmentById$QueryToJson(
        WorkoutPlanEnrolmentById$Query instance) =>
    <String, dynamic>{
      'workoutPlanEnrolmentById': instance.workoutPlanEnrolmentById.toJson(),
    };

WorkoutPlanDataMixin$UserSummary _$WorkoutPlanDataMixin$UserSummaryFromJson(
        Map<String, dynamic> json) =>
    WorkoutPlanDataMixin$UserSummary()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..avatarUri = json['avatarUri'] as String?
      ..displayName = json['displayName'] as String
      ..userProfileScope = $enumDecode(
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
          ..startDate = fromGraphQLDateTimeNullableToDartDateTimeNullable(
              json['startDate'] as int?)
          ..completedWorkoutPlanDayWorkouts =
              (json['CompletedWorkoutPlanDayWorkouts'] as List<dynamic>)
                  .map((e) => CompletedWorkoutPlanDayWorkout.fromJson(
                      e as Map<String, dynamic>))
                  .toList()
          ..user = UserSummary.fromJson(json['User'] as Map<String, dynamic>);

Map<String, dynamic> _$WorkoutPlanDataMixin$WorkoutPlanEnrolmentToJson(
        WorkoutPlanDataMixin$WorkoutPlanEnrolment instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'startDate':
          fromDartDateTimeNullableToGraphQLDateTimeNullable(instance.startDate),
      'CompletedWorkoutPlanDayWorkouts': instance
          .completedWorkoutPlanDayWorkouts
          .map((e) => e.toJson())
          .toList(),
      'User': instance.user.toJson(),
    };

ClearScheduleForPlanEnrolment$Mutation
    _$ClearScheduleForPlanEnrolment$MutationFromJson(
            Map<String, dynamic> json) =>
        ClearScheduleForPlanEnrolment$Mutation()
          ..clearScheduleForPlanEnrolment = WorkoutPlanEnrolment.fromJson(
              json['clearScheduleForPlanEnrolment'] as Map<String, dynamic>);

Map<String, dynamic> _$ClearScheduleForPlanEnrolment$MutationToJson(
        ClearScheduleForPlanEnrolment$Mutation instance) =>
    <String, dynamic>{
      'clearScheduleForPlanEnrolment':
          instance.clearScheduleForPlanEnrolment.toJson(),
    };

CreateWorkoutPlanEnrolment$Mutation
    _$CreateWorkoutPlanEnrolment$MutationFromJson(Map<String, dynamic> json) =>
        CreateWorkoutPlanEnrolment$Mutation()
          ..createWorkoutPlanEnrolment = WorkoutPlanEnrolmentWithPlan.fromJson(
              json['createWorkoutPlanEnrolment'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateWorkoutPlanEnrolment$MutationToJson(
        CreateWorkoutPlanEnrolment$Mutation instance) =>
    <String, dynamic>{
      'createWorkoutPlanEnrolment':
          instance.createWorkoutPlanEnrolment.toJson(),
    };

DeleteCompletedWorkoutPlanDayWorkout$Mutation
    _$DeleteCompletedWorkoutPlanDayWorkout$MutationFromJson(
            Map<String, dynamic> json) =>
        DeleteCompletedWorkoutPlanDayWorkout$Mutation()
          ..deleteCompletedWorkoutPlanDayWorkout =
              WorkoutPlanEnrolment.fromJson(
                  json['deleteCompletedWorkoutPlanDayWorkout']
                      as Map<String, dynamic>);

Map<String, dynamic> _$DeleteCompletedWorkoutPlanDayWorkout$MutationToJson(
        DeleteCompletedWorkoutPlanDayWorkout$Mutation instance) =>
    <String, dynamic>{
      'deleteCompletedWorkoutPlanDayWorkout':
          instance.deleteCompletedWorkoutPlanDayWorkout.toJson(),
    };

DeleteCompletedWorkoutPlanDayWorkoutInput
    _$DeleteCompletedWorkoutPlanDayWorkoutInputFromJson(
            Map<String, dynamic> json) =>
        DeleteCompletedWorkoutPlanDayWorkoutInput(
          workoutPlanDayWorkoutId: json['workoutPlanDayWorkoutId'] as String,
          workoutPlanEnrolmentId: json['workoutPlanEnrolmentId'] as String,
        );

Map<String, dynamic> _$DeleteCompletedWorkoutPlanDayWorkoutInputToJson(
        DeleteCompletedWorkoutPlanDayWorkoutInput instance) =>
    <String, dynamic>{
      'workoutPlanDayWorkoutId': instance.workoutPlanDayWorkoutId,
      'workoutPlanEnrolmentId': instance.workoutPlanEnrolmentId,
    };

ClearWorkoutPlanEnrolmentProgress$Mutation
    _$ClearWorkoutPlanEnrolmentProgress$MutationFromJson(
            Map<String, dynamic> json) =>
        ClearWorkoutPlanEnrolmentProgress$Mutation()
          ..clearWorkoutPlanEnrolmentProgress = WorkoutPlanEnrolment.fromJson(
              json['clearWorkoutPlanEnrolmentProgress']
                  as Map<String, dynamic>);

Map<String, dynamic> _$ClearWorkoutPlanEnrolmentProgress$MutationToJson(
        ClearWorkoutPlanEnrolmentProgress$Mutation instance) =>
    <String, dynamic>{
      'clearWorkoutPlanEnrolmentProgress':
          instance.clearWorkoutPlanEnrolmentProgress.toJson(),
    };

CreateScheduleForPlanEnrolment$Mutation
    _$CreateScheduleForPlanEnrolment$MutationFromJson(
            Map<String, dynamic> json) =>
        CreateScheduleForPlanEnrolment$Mutation()
          ..createScheduleForPlanEnrolment = WorkoutPlanEnrolment.fromJson(
              json['createScheduleForPlanEnrolment'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateScheduleForPlanEnrolment$MutationToJson(
        CreateScheduleForPlanEnrolment$Mutation instance) =>
    <String, dynamic>{
      'createScheduleForPlanEnrolment':
          instance.createScheduleForPlanEnrolment.toJson(),
    };

CreateScheduleForPlanEnrolmentInput
    _$CreateScheduleForPlanEnrolmentInputFromJson(Map<String, dynamic> json) =>
        CreateScheduleForPlanEnrolmentInput(
          startDate:
              fromGraphQLDateTimeToDartDateTime(json['startDate'] as int),
          workoutPlanEnrolmentId: json['workoutPlanEnrolmentId'] as String,
        );

Map<String, dynamic> _$CreateScheduleForPlanEnrolmentInputToJson(
        CreateScheduleForPlanEnrolmentInput instance) =>
    <String, dynamic>{
      'startDate': fromDartDateTimeToGraphQLDateTime(instance.startDate),
      'workoutPlanEnrolmentId': instance.workoutPlanEnrolmentId,
    };

CreateCompletedWorkoutPlanDayWorkout$Mutation
    _$CreateCompletedWorkoutPlanDayWorkout$MutationFromJson(
            Map<String, dynamic> json) =>
        CreateCompletedWorkoutPlanDayWorkout$Mutation()
          ..createCompletedWorkoutPlanDayWorkout =
              WorkoutPlanEnrolment.fromJson(
                  json['createCompletedWorkoutPlanDayWorkout']
                      as Map<String, dynamic>);

Map<String, dynamic> _$CreateCompletedWorkoutPlanDayWorkout$MutationToJson(
        CreateCompletedWorkoutPlanDayWorkout$Mutation instance) =>
    <String, dynamic>{
      'createCompletedWorkoutPlanDayWorkout':
          instance.createCompletedWorkoutPlanDayWorkout.toJson(),
    };

CreateCompletedWorkoutPlanDayWorkoutInput
    _$CreateCompletedWorkoutPlanDayWorkoutInputFromJson(
            Map<String, dynamic> json) =>
        CreateCompletedWorkoutPlanDayWorkoutInput(
          loggedWorkoutId: json['loggedWorkoutId'] as String,
          workoutPlanDayWorkoutId: json['workoutPlanDayWorkoutId'] as String,
          workoutPlanEnrolmentId: json['workoutPlanEnrolmentId'] as String,
        );

Map<String, dynamic> _$CreateCompletedWorkoutPlanDayWorkoutInputToJson(
        CreateCompletedWorkoutPlanDayWorkoutInput instance) =>
    <String, dynamic>{
      'loggedWorkoutId': instance.loggedWorkoutId,
      'workoutPlanDayWorkoutId': instance.workoutPlanDayWorkoutId,
      'workoutPlanEnrolmentId': instance.workoutPlanEnrolmentId,
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
      ..workoutId = json['workoutId'] as String?
      ..user = json['User'] == null
          ? null
          : UserSummary.fromJson(json['User'] as Map<String, dynamic>)
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
      'workoutId': instance.workoutId,
      'User': instance.user?.toJson(),
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

LifetimeLogStatsSummary _$LifetimeLogStatsSummaryFromJson(
        Map<String, dynamic> json) =>
    LifetimeLogStatsSummary()
      ..$$typename = json['__typename'] as String?
      ..minutesWorked = json['minutesWorked'] as int
      ..sessionsLogged = json['sessionsLogged'] as int;

Map<String, dynamic> _$LifetimeLogStatsSummaryToJson(
        LifetimeLogStatsSummary instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'minutesWorked': instance.minutesWorked,
      'sessionsLogged': instance.sessionsLogged,
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
      ..name = json['name'] as String
      ..workoutId = json['workoutId'] as String?;

Map<String, dynamic> _$UpdateLoggedWorkoutToJson(
        UpdateLoggedWorkout instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'completedOn': fromDartDateTimeToGraphQLDateTime(instance.completedOn),
      'note': instance.note,
      'name': instance.name,
      'workoutId': instance.workoutId,
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
      workoutPlanDayWorkout: json['WorkoutPlanDayWorkout'] == null
          ? null
          : ConnectRelationInput.fromJson(
              json['WorkoutPlanDayWorkout'] as Map<String, dynamic>),
      workoutPlanEnrolment: json['WorkoutPlanEnrolment'] == null
          ? null
          : ConnectRelationInput.fromJson(
              json['WorkoutPlanEnrolment'] as Map<String, dynamic>),
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
      'WorkoutPlanDayWorkout': instance.workoutPlanDayWorkout?.toJson(),
      'WorkoutPlanEnrolment': instance.workoutPlanEnrolment?.toJson(),
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

LogCountByWorkout$Query _$LogCountByWorkout$QueryFromJson(
        Map<String, dynamic> json) =>
    LogCountByWorkout$Query()
      ..logCountByWorkout = json['logCountByWorkout'] as int;

Map<String, dynamic> _$LogCountByWorkout$QueryToJson(
        LogCountByWorkout$Query instance) =>
    <String, dynamic>{
      'logCountByWorkout': instance.logCountByWorkout,
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
          .map((e) => WorkoutPlanSummary.fromJson(e as Map<String, dynamic>))
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
          .map((e) => WorkoutPlanSummary.fromJson(e as Map<String, dynamic>))
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
      difficultyLevel: $enumDecodeNullable(
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
      ..contentAccessScope = $enumDecode(
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
      contentAccessScope: $enumDecodeNullable(
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

UserPublicWorkoutPlans$Query _$UserPublicWorkoutPlans$QueryFromJson(
        Map<String, dynamic> json) =>
    UserPublicWorkoutPlans$Query()
      ..userPublicWorkoutPlans = (json['userPublicWorkoutPlans']
              as List<dynamic>)
          .map((e) => WorkoutPlanSummary.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserPublicWorkoutPlans$QueryToJson(
        UserPublicWorkoutPlans$Query instance) =>
    <String, dynamic>{
      'userPublicWorkoutPlans':
          instance.userPublicWorkoutPlans.map((e) => e.toJson()).toList(),
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
      contentAccessScope: $enumDecode(
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

UserProfileSummary _$UserProfileSummaryFromJson(Map<String, dynamic> json) =>
    UserProfileSummary()
      ..$$typename = json['__typename'] as String?
      ..userProfileScope = $enumDecode(
          _$UserProfileScopeEnumMap, json['userProfileScope'],
          unknownValue: UserProfileScope.artemisUnknown)
      ..id = json['id'] as String
      ..avatarUri = json['avatarUri'] as String?
      ..tagline = json['tagline'] as String?
      ..townCity = json['townCity'] as String?
      ..countryCode = json['countryCode'] as String?
      ..displayName = json['displayName'] as String
      ..workoutCount = json['workoutCount'] as int
      ..planCount = json['planCount'] as int
      ..skills =
          (json['skills'] as List<dynamic>).map((e) => e as String).toList()
      ..clubs = (json['Clubs'] as List<dynamic>)
          .map((e) => ClubSummary.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserProfileSummaryToJson(UserProfileSummary instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'userProfileScope': _$UserProfileScopeEnumMap[instance.userProfileScope],
      'id': instance.id,
      'avatarUri': instance.avatarUri,
      'tagline': instance.tagline,
      'townCity': instance.townCity,
      'countryCode': instance.countryCode,
      'displayName': instance.displayName,
      'workoutCount': instance.workoutCount,
      'planCount': instance.planCount,
      'skills': instance.skills,
      'Clubs': instance.clubs.map((e) => e.toJson()).toList(),
    };

UserProfiles$Query _$UserProfiles$QueryFromJson(Map<String, dynamic> json) =>
    UserProfiles$Query()
      ..userProfiles = (json['userProfiles'] as List<dynamic>)
          .map((e) => UserProfileSummary.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserProfiles$QueryToJson(UserProfiles$Query instance) =>
    <String, dynamic>{
      'userProfiles': instance.userProfiles.map((e) => e.toJson()).toList(),
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
      scope: $enumDecodeNullable(_$MoveScopeEnumMap, json['scope'],
          unknownValue: MoveScope.artemisUnknown),
      searchTerms: json['searchTerms'] as String?,
      validRepTypes: (json['validRepTypes'] as List<dynamic>)
          .map((e) => $enumDecode(_$WorkoutMoveRepTypeEnumMap, e,
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
      scope: $enumDecodeNullable(_$MoveScopeEnumMap, json['scope'],
          unknownValue: MoveScope.artemisUnknown),
      searchTerms: json['searchTerms'] as String?,
      validRepTypes: (json['validRepTypes'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$WorkoutMoveRepTypeEnumMap, e,
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

UpdateUserProfileResult _$UpdateUserProfileResultFromJson(
        Map<String, dynamic> json) =>
    UpdateUserProfileResult()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..userProfileScope = $enumDecodeNullable(
          _$UserProfileScopeEnumMap, json['userProfileScope'],
          unknownValue: UserProfileScope.artemisUnknown)
      ..avatarUri = json['avatarUri'] as String?
      ..introVideoUri = json['introVideoUri'] as String?
      ..introVideoThumbUri = json['introVideoThumbUri'] as String?
      ..bio = json['bio'] as String?
      ..tagline = json['tagline'] as String?
      ..birthdate = fromGraphQLDateTimeNullableToDartDateTimeNullable(
          json['birthdate'] as int?)
      ..townCity = json['townCity'] as String?
      ..countryCode = json['countryCode'] as String?
      ..displayName = json['displayName'] as String?
      ..instagramHandle = json['instagramHandle'] as String?
      ..tiktokHandle = json['tiktokHandle'] as String?
      ..youtubeHandle = json['youtubeHandle'] as String?
      ..linkedinHandle = json['linkedinHandle'] as String?
      ..firstname = json['firstname'] as String?
      ..gender = $enumDecodeNullable(_$GenderEnumMap, json['gender'],
          unknownValue: Gender.artemisUnknown)
      ..hasOnboarded = json['hasOnboarded'] as bool?
      ..lastname = json['lastname'] as String?;

Map<String, dynamic> _$UpdateUserProfileResultToJson(
        UpdateUserProfileResult instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'userProfileScope': _$UserProfileScopeEnumMap[instance.userProfileScope],
      'avatarUri': instance.avatarUri,
      'introVideoUri': instance.introVideoUri,
      'introVideoThumbUri': instance.introVideoThumbUri,
      'bio': instance.bio,
      'tagline': instance.tagline,
      'birthdate':
          fromDartDateTimeNullableToGraphQLDateTimeNullable(instance.birthdate),
      'townCity': instance.townCity,
      'countryCode': instance.countryCode,
      'displayName': instance.displayName,
      'instagramHandle': instance.instagramHandle,
      'tiktokHandle': instance.tiktokHandle,
      'youtubeHandle': instance.youtubeHandle,
      'linkedinHandle': instance.linkedinHandle,
      'firstname': instance.firstname,
      'gender': _$GenderEnumMap[instance.gender],
      'hasOnboarded': instance.hasOnboarded,
      'lastname': instance.lastname,
    };

const _$GenderEnumMap = {
  Gender.female: 'FEMALE',
  Gender.male: 'MALE',
  Gender.nonbinary: 'NONBINARY',
  Gender.pnts: 'PNTS',
  Gender.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

UpdateUserProfile$Mutation _$UpdateUserProfile$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateUserProfile$Mutation()
      ..updateUserProfile = UpdateUserProfileResult.fromJson(
          json['updateUserProfile'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateUserProfile$MutationToJson(
        UpdateUserProfile$Mutation instance) =>
    <String, dynamic>{
      'updateUserProfile': instance.updateUserProfile.toJson(),
    };

UpdateUserProfileInput _$UpdateUserProfileInputFromJson(
        Map<String, dynamic> json) =>
    UpdateUserProfileInput(
      avatarUri: json['avatarUri'] as String?,
      bio: json['bio'] as String?,
      birthdate: fromGraphQLDateTimeNullableToDartDateTimeNullable(
          json['birthdate'] as int?),
      countryCode: json['countryCode'] as String?,
      displayName: json['displayName'] as String?,
      firstname: json['firstname'] as String?,
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender'],
          unknownValue: Gender.artemisUnknown),
      hasOnboarded: json['hasOnboarded'] as bool?,
      instagramHandle: json['instagramHandle'] as String?,
      introVideoThumbUri: json['introVideoThumbUri'] as String?,
      introVideoUri: json['introVideoUri'] as String?,
      lastname: json['lastname'] as String?,
      linkedinHandle: json['linkedinHandle'] as String?,
      tagline: json['tagline'] as String?,
      tiktokHandle: json['tiktokHandle'] as String?,
      townCity: json['townCity'] as String?,
      userProfileScope: $enumDecodeNullable(
          _$UserProfileScopeEnumMap, json['userProfileScope'],
          unknownValue: UserProfileScope.artemisUnknown),
      youtubeHandle: json['youtubeHandle'] as String?,
    );

Map<String, dynamic> _$UpdateUserProfileInputToJson(
        UpdateUserProfileInput instance) =>
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
      'instagramHandle': instance.instagramHandle,
      'introVideoThumbUri': instance.introVideoThumbUri,
      'introVideoUri': instance.introVideoUri,
      'lastname': instance.lastname,
      'linkedinHandle': instance.linkedinHandle,
      'tagline': instance.tagline,
      'tiktokHandle': instance.tiktokHandle,
      'townCity': instance.townCity,
      'userProfileScope': _$UserProfileScopeEnumMap[instance.userProfileScope],
      'youtubeHandle': instance.youtubeHandle,
    };

Skill _$SkillFromJson(Map<String, dynamic> json) => Skill()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
  ..name = json['name'] as String
  ..experience = json['experience'] as String?
  ..certification = json['certification'] as String?
  ..awardingBody = json['awardingBody'] as String?
  ..certificateRef = json['certificateRef'] as String?
  ..documentUri = json['documentUri'] as String?;

Map<String, dynamic> _$SkillToJson(Skill instance) => <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'name': instance.name,
      'experience': instance.experience,
      'certification': instance.certification,
      'awardingBody': instance.awardingBody,
      'certificateRef': instance.certificateRef,
      'documentUri': instance.documentUri,
    };

UserBenchmarkSummary _$UserBenchmarkSummaryFromJson(
        Map<String, dynamic> json) =>
    UserBenchmarkSummary()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..lastEntryAt =
          fromGraphQLDateTimeToDartDateTime(json['lastEntryAt'] as int)
      ..name = json['name'] as String
      ..equipmentInfo = json['equipmentInfo'] as String?
      ..benchmarkType = $enumDecode(
          _$BenchmarkTypeEnumMap, json['benchmarkType'],
          unknownValue: BenchmarkType.artemisUnknown)
      ..loadUnit = $enumDecode(_$LoadUnitEnumMap, json['loadUnit'],
          unknownValue: LoadUnit.artemisUnknown);

Map<String, dynamic> _$UserBenchmarkSummaryToJson(
        UserBenchmarkSummary instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'lastEntryAt': fromDartDateTimeToGraphQLDateTime(instance.lastEntryAt),
      'name': instance.name,
      'equipmentInfo': instance.equipmentInfo,
      'benchmarkType': _$BenchmarkTypeEnumMap[instance.benchmarkType],
      'loadUnit': _$LoadUnitEnumMap[instance.loadUnit],
    };

const _$BenchmarkTypeEnumMap = {
  BenchmarkType.amrap: 'AMRAP',
  BenchmarkType.fastesttime: 'FASTESTTIME',
  BenchmarkType.maxload: 'MAXLOAD',
  BenchmarkType.unbrokenreps: 'UNBROKENREPS',
  BenchmarkType.unbrokentime: 'UNBROKENTIME',
  BenchmarkType.artemisUnknown: 'ARTEMIS_UNKNOWN',
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

UserBenchmarkWithBestEntry _$UserBenchmarkWithBestEntryFromJson(
        Map<String, dynamic> json) =>
    UserBenchmarkWithBestEntry()
      ..userBenchmarkSummary = UserBenchmarkSummary.fromJson(
          json['UserBenchmarkSummary'] as Map<String, dynamic>)
      ..bestEntry = json['BestEntry'] == null
          ? null
          : UserBenchmarkEntry.fromJson(
              json['BestEntry'] as Map<String, dynamic>);

Map<String, dynamic> _$UserBenchmarkWithBestEntryToJson(
        UserBenchmarkWithBestEntry instance) =>
    <String, dynamic>{
      'UserBenchmarkSummary': instance.userBenchmarkSummary.toJson(),
      'BestEntry': instance.bestEntry?.toJson(),
    };

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..userProfileScope = $enumDecode(
      _$UserProfileScopeEnumMap, json['userProfileScope'],
      unknownValue: UserProfileScope.artemisUnknown)
  ..avatarUri = json['avatarUri'] as String?
  ..introVideoUri = json['introVideoUri'] as String?
  ..introVideoThumbUri = json['introVideoThumbUri'] as String?
  ..bio = json['bio'] as String?
  ..tagline = json['tagline'] as String?
  ..townCity = json['townCity'] as String?
  ..instagramHandle = json['instagramHandle'] as String?
  ..tiktokHandle = json['tiktokHandle'] as String?
  ..youtubeHandle = json['youtubeHandle'] as String?
  ..linkedinHandle = json['linkedinHandle'] as String?
  ..countryCode = json['countryCode'] as String?
  ..displayName = json['displayName'] as String
  ..gender = $enumDecodeNullable(_$GenderEnumMap, json['gender'],
      unknownValue: Gender.artemisUnknown)
  ..birthdate = fromGraphQLDateTimeNullableToDartDateTimeNullable(
      json['birthdate'] as int?)
  ..followerCount = json['followerCount'] as int?
  ..workoutCount = json['workoutCount'] as int?
  ..planCount = json['planCount'] as int?
  ..clubs = (json['Clubs'] as List<dynamic>)
      .map((e) => ClubSummary.fromJson(e as Map<String, dynamic>))
      .toList()
  ..lifetimeLogStatsSummary = json['LifetimeLogStatsSummary'] == null
      ? null
      : LifetimeLogStatsSummary.fromJson(
          json['LifetimeLogStatsSummary'] as Map<String, dynamic>)
  ..skills = (json['Skills'] as List<dynamic>)
      .map((e) => Skill.fromJson(e as Map<String, dynamic>))
      .toList()
  ..benchmarksWithBestEntries = (json['BenchmarksWithBestEntries']
          as List<dynamic>)
      .map(
          (e) => UserBenchmarkWithBestEntry.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
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
      'instagramHandle': instance.instagramHandle,
      'tiktokHandle': instance.tiktokHandle,
      'youtubeHandle': instance.youtubeHandle,
      'linkedinHandle': instance.linkedinHandle,
      'countryCode': instance.countryCode,
      'displayName': instance.displayName,
      'gender': _$GenderEnumMap[instance.gender],
      'birthdate':
          fromDartDateTimeNullableToGraphQLDateTimeNullable(instance.birthdate),
      'followerCount': instance.followerCount,
      'workoutCount': instance.workoutCount,
      'planCount': instance.planCount,
      'Clubs': instance.clubs.map((e) => e.toJson()).toList(),
      'LifetimeLogStatsSummary': instance.lifetimeLogStatsSummary?.toJson(),
      'Skills': instance.skills.map((e) => e.toJson()).toList(),
      'BenchmarksWithBestEntries':
          instance.benchmarksWithBestEntries.map((e) => e.toJson()).toList(),
    };

UserProfileById$Query _$UserProfileById$QueryFromJson(
        Map<String, dynamic> json) =>
    UserProfileById$Query()
      ..userProfileById =
          UserProfile.fromJson(json['userProfileById'] as Map<String, dynamic>);

Map<String, dynamic> _$UserProfileById$QueryToJson(
        UserProfileById$Query instance) =>
    <String, dynamic>{
      'userProfileById': instance.userProfileById.toJson(),
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

CreateWorkoutSetWithWorkoutMoves$Mutation
    _$CreateWorkoutSetWithWorkoutMoves$MutationFromJson(
            Map<String, dynamic> json) =>
        CreateWorkoutSetWithWorkoutMoves$Mutation()
          ..createWorkoutSetWithWorkoutMoves = WorkoutSet.fromJson(
              json['createWorkoutSetWithWorkoutMoves'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateWorkoutSetWithWorkoutMoves$MutationToJson(
        CreateWorkoutSetWithWorkoutMoves$Mutation instance) =>
    <String, dynamic>{
      'createWorkoutSetWithWorkoutMoves':
          instance.createWorkoutSetWithWorkoutMoves.toJson(),
    };

CreateWorkoutSetWithWorkoutMovesInput
    _$CreateWorkoutSetWithWorkoutMovesInputFromJson(
            Map<String, dynamic> json) =>
        CreateWorkoutSetWithWorkoutMovesInput(
          workoutMoves: (json['workoutMoves'] as List<dynamic>)
              .map((e) => CreateWorkoutMoveInSetInput.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
          workoutSet: CreateWorkoutSetInput.fromJson(
              json['workoutSet'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$CreateWorkoutSetWithWorkoutMovesInputToJson(
        CreateWorkoutSetWithWorkoutMovesInput instance) =>
    <String, dynamic>{
      'workoutMoves': instance.workoutMoves.map((e) => e.toJson()).toList(),
      'workoutSet': instance.workoutSet.toJson(),
    };

CreateWorkoutMoveInSetInput _$CreateWorkoutMoveInSetInputFromJson(
        Map<String, dynamic> json) =>
    CreateWorkoutMoveInSetInput(
      equipment: json['Equipment'] == null
          ? null
          : ConnectRelationInput.fromJson(
              json['Equipment'] as Map<String, dynamic>),
      move: ConnectRelationInput.fromJson(json['Move'] as Map<String, dynamic>),
      distanceUnit: $enumDecodeNullable(
          _$DistanceUnitEnumMap, json['distanceUnit'],
          unknownValue: DistanceUnit.artemisUnknown),
      loadAmount: (json['loadAmount'] as num).toDouble(),
      loadUnit: $enumDecodeNullable(_$LoadUnitEnumMap, json['loadUnit'],
          unknownValue: LoadUnit.artemisUnknown),
      repType: $enumDecode(_$WorkoutMoveRepTypeEnumMap, json['repType'],
          unknownValue: WorkoutMoveRepType.artemisUnknown),
      reps: (json['reps'] as num).toDouble(),
      sortPosition: json['sortPosition'] as int,
      timeUnit: $enumDecodeNullable(_$TimeUnitEnumMap, json['timeUnit'],
          unknownValue: TimeUnit.artemisUnknown),
    );

Map<String, dynamic> _$CreateWorkoutMoveInSetInputToJson(
        CreateWorkoutMoveInSetInput instance) =>
    <String, dynamic>{
      'Equipment': instance.equipment?.toJson(),
      'Move': instance.move.toJson(),
      'distanceUnit': _$DistanceUnitEnumMap[instance.distanceUnit],
      'loadAmount': instance.loadAmount,
      'loadUnit': _$LoadUnitEnumMap[instance.loadUnit],
      'repType': _$WorkoutMoveRepTypeEnumMap[instance.repType],
      'reps': instance.reps,
      'sortPosition': instance.sortPosition,
      'timeUnit': _$TimeUnitEnumMap[instance.timeUnit],
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

DeleteWorkoutSetById$Mutation _$DeleteWorkoutSetById$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteWorkoutSetById$Mutation()
      ..deleteWorkoutSetById = json['deleteWorkoutSetById'] as String;

Map<String, dynamic> _$DeleteWorkoutSetById$MutationToJson(
        DeleteWorkoutSetById$Mutation instance) =>
    <String, dynamic>{
      'deleteWorkoutSetById': instance.deleteWorkoutSetById,
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
      ..benchmarkType = $enumDecode(
          _$BenchmarkTypeEnumMap, json['benchmarkType'],
          unknownValue: BenchmarkType.artemisUnknown)
      ..loadUnit = $enumDecode(_$LoadUnitEnumMap, json['loadUnit'],
          unknownValue: LoadUnit.artemisUnknown)
      ..userBenchmarkEntries = (json['UserBenchmarkEntries'] as List<dynamic>)
          .map((e) => UserBenchmarkEntry.fromJson(e as Map<String, dynamic>))
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
      benchmarkType: $enumDecode(_$BenchmarkTypeEnumMap, json['benchmarkType'],
          unknownValue: BenchmarkType.artemisUnknown),
      description: json['description'] as String?,
      equipmentInfo: json['equipmentInfo'] as String?,
      id: json['id'] as String,
      loadUnit: $enumDecodeNullable(_$LoadUnitEnumMap, json['loadUnit'],
          unknownValue: LoadUnit.artemisUnknown),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$UpdateUserBenchmarkInputToJson(
        UpdateUserBenchmarkInput instance) =>
    <String, dynamic>{
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
      benchmarkType: $enumDecode(_$BenchmarkTypeEnumMap, json['benchmarkType'],
          unknownValue: BenchmarkType.artemisUnknown),
      description: json['description'] as String?,
      equipmentInfo: json['equipmentInfo'] as String?,
      loadUnit: $enumDecodeNullable(_$LoadUnitEnumMap, json['loadUnit'],
          unknownValue: LoadUnit.artemisUnknown),
      name: json['name'] as String,
    );

Map<String, dynamic> _$CreateUserBenchmarkInputToJson(
        CreateUserBenchmarkInput instance) =>
    <String, dynamic>{
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
      ..textSearchWorkoutPlans = (json['textSearchWorkoutPlans']
              as List<dynamic>?)
          ?.map((e) => WorkoutPlanSummary.fromJson(e as Map<String, dynamic>))
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
          ?.map((e) => WorkoutSummary.fromJson(e as Map<String, dynamic>))
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

ScheduledWorkout _$ScheduledWorkoutFromJson(Map<String, dynamic> json) =>
    ScheduledWorkout()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..scheduledAt =
          fromGraphQLDateTimeToDartDateTime(json['scheduledAt'] as int)
      ..note = json['note'] as String?
      ..workoutPlanName = json['workoutPlanName'] as String?
      ..workoutPlanEnrolmentId = json['workoutPlanEnrolmentId'] as String?
      ..workoutPlanDayWorkoutId = json['workoutPlanDayWorkoutId'] as String?
      ..loggedWorkoutId = json['loggedWorkoutId'] as String?
      ..workout = json['Workout'] == null
          ? null
          : WorkoutSummary.fromJson(json['Workout'] as Map<String, dynamic>)
      ..gymProfile = json['GymProfile'] == null
          ? null
          : GymProfile.fromJson(json['GymProfile'] as Map<String, dynamic>);

Map<String, dynamic> _$ScheduledWorkoutToJson(ScheduledWorkout instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'scheduledAt': fromDartDateTimeToGraphQLDateTime(instance.scheduledAt),
      'note': instance.note,
      'workoutPlanName': instance.workoutPlanName,
      'workoutPlanEnrolmentId': instance.workoutPlanEnrolmentId,
      'workoutPlanDayWorkoutId': instance.workoutPlanDayWorkoutId,
      'loggedWorkoutId': instance.loggedWorkoutId,
      'Workout': instance.workout?.toJson(),
      'GymProfile': instance.gymProfile?.toJson(),
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
      workoutPlanDayWorkout: json['WorkoutPlanDayWorkout'] == null
          ? null
          : ConnectRelationInput.fromJson(
              json['WorkoutPlanDayWorkout'] as Map<String, dynamic>),
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
      'WorkoutPlanDayWorkout': instance.workoutPlanDayWorkout?.toJson(),
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
      ..type = $enumDecode(_$TimelinePostTypeEnumMap, json['type'],
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
      objectType: $enumDecode(_$TimelinePostTypeEnumMap, json['objectType'],
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
          .map((e) => WorkoutSummary.fromJson(e as Map<String, dynamic>))
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
      difficultyLevel: $enumDecodeNullable(
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
      ..difficultyLevel = $enumDecodeNullable(
          _$DifficultyLevelEnumMap, json['difficultyLevel'],
          unknownValue: DifficultyLevel.artemisUnknown)
      ..coverImageUri = json['coverImageUri'] as String?
      ..contentAccessScope = $enumDecode(
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
      contentAccessScope: $enumDecodeNullable(
          _$ContentAccessScopeEnumMap, json['contentAccessScope'],
          unknownValue: ContentAccessScope.artemisUnknown),
      coverImageUri: json['coverImageUri'] as String?,
      description: json['description'] as String?,
      difficultyLevel: $enumDecodeNullable(
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
          .map((e) => WorkoutSummary.fromJson(e as Map<String, dynamic>))
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

UserPublicWorkouts$Query _$UserPublicWorkouts$QueryFromJson(
        Map<String, dynamic> json) =>
    UserPublicWorkouts$Query()
      ..userPublicWorkouts = (json['userPublicWorkouts'] as List<dynamic>)
          .map((e) => WorkoutSummary.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserPublicWorkouts$QueryToJson(
        UserPublicWorkouts$Query instance) =>
    <String, dynamic>{
      'userPublicWorkouts':
          instance.userPublicWorkouts.map((e) => e.toJson()).toList(),
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
      contentAccessScope: $enumDecode(
          _$ContentAccessScopeEnumMap, json['contentAccessScope'],
          unknownValue: ContentAccessScope.artemisUnknown),
      difficultyLevel: $enumDecodeNullable(
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

RemoveDocumentFromSkill$Mutation _$RemoveDocumentFromSkill$MutationFromJson(
        Map<String, dynamic> json) =>
    RemoveDocumentFromSkill$Mutation()
      ..removeDocumentFromSkill = Skill.fromJson(
          json['removeDocumentFromSkill'] as Map<String, dynamic>);

Map<String, dynamic> _$RemoveDocumentFromSkill$MutationToJson(
        RemoveDocumentFromSkill$Mutation instance) =>
    <String, dynamic>{
      'removeDocumentFromSkill': instance.removeDocumentFromSkill.toJson(),
    };

RemoveDocumentFromSkillInput _$RemoveDocumentFromSkillInputFromJson(
        Map<String, dynamic> json) =>
    RemoveDocumentFromSkillInput(
      id: json['id'] as String,
    );

Map<String, dynamic> _$RemoveDocumentFromSkillInputToJson(
        RemoveDocumentFromSkillInput instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

DeleteSkillById$Mutation _$DeleteSkillById$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteSkillById$Mutation()
      ..deleteSkillById = json['deleteSkillById'] as String;

Map<String, dynamic> _$DeleteSkillById$MutationToJson(
        DeleteSkillById$Mutation instance) =>
    <String, dynamic>{
      'deleteSkillById': instance.deleteSkillById,
    };

AddDocumentToSkill$Mutation _$AddDocumentToSkill$MutationFromJson(
        Map<String, dynamic> json) =>
    AddDocumentToSkill$Mutation()
      ..addDocumentToSkill =
          Skill.fromJson(json['addDocumentToSkill'] as Map<String, dynamic>);

Map<String, dynamic> _$AddDocumentToSkill$MutationToJson(
        AddDocumentToSkill$Mutation instance) =>
    <String, dynamic>{
      'addDocumentToSkill': instance.addDocumentToSkill.toJson(),
    };

AddDocumentToSkillInput _$AddDocumentToSkillInputFromJson(
        Map<String, dynamic> json) =>
    AddDocumentToSkillInput(
      id: json['id'] as String,
      uri: json['uri'] as String,
    );

Map<String, dynamic> _$AddDocumentToSkillInputToJson(
        AddDocumentToSkillInput instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uri': instance.uri,
    };

CreateSkill$Mutation _$CreateSkill$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateSkill$Mutation()
      ..createSkill =
          Skill.fromJson(json['createSkill'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateSkill$MutationToJson(
        CreateSkill$Mutation instance) =>
    <String, dynamic>{
      'createSkill': instance.createSkill.toJson(),
    };

CreateSkillInput _$CreateSkillInputFromJson(Map<String, dynamic> json) =>
    CreateSkillInput(
      experience: json['experience'] as String?,
      name: json['name'] as String,
    );

Map<String, dynamic> _$CreateSkillInputToJson(CreateSkillInput instance) =>
    <String, dynamic>{
      'experience': instance.experience,
      'name': instance.name,
    };

UpdateSkill$Mutation _$UpdateSkill$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateSkill$Mutation()
      ..updateSkill =
          Skill.fromJson(json['updateSkill'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateSkill$MutationToJson(
        UpdateSkill$Mutation instance) =>
    <String, dynamic>{
      'updateSkill': instance.updateSkill.toJson(),
    };

UpdateSkillInput _$UpdateSkillInputFromJson(Map<String, dynamic> json) =>
    UpdateSkillInput(
      awardingBody: json['awardingBody'] as String?,
      certificateRef: json['certificateRef'] as String?,
      certification: json['certification'] as String?,
      documentUri: json['documentUri'] as String?,
      experience: json['experience'] as String?,
      id: json['id'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$UpdateSkillInputToJson(UpdateSkillInput instance) =>
    <String, dynamic>{
      'awardingBody': instance.awardingBody,
      'certificateRef': instance.certificateRef,
      'certification': instance.certification,
      'documentUri': instance.documentUri,
      'experience': instance.experience,
      'id': instance.id,
      'name': instance.name,
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

UserJoinPublicClub$Mutation _$UserJoinPublicClub$MutationFromJson(
        Map<String, dynamic> json) =>
    UserJoinPublicClub$Mutation()
      ..userJoinPublicClub = json['userJoinPublicClub'] as String;

Map<String, dynamic> _$UserJoinPublicClub$MutationToJson(
        UserJoinPublicClub$Mutation instance) =>
    <String, dynamic>{
      'userJoinPublicClub': instance.userJoinPublicClub,
    };

ClubInviteTokenData _$ClubInviteTokenDataFromJson(Map<String, dynamic> json) =>
    ClubInviteTokenData()
      ..$$typename = json['__typename'] as String?
      ..token = json['token'] as String
      ..club = ClubSummary.fromJson(json['Club'] as Map<String, dynamic>)
      ..introVideoUri = json['introVideoUri'] as String?
      ..introVideoThumbUri = json['introVideoThumbUri'] as String?
      ..introAudioUri = json['introAudioUri'] as String?;

Map<String, dynamic> _$ClubInviteTokenDataToJson(
        ClubInviteTokenData instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'token': instance.token,
      'Club': instance.club.toJson(),
      'introVideoUri': instance.introVideoUri,
      'introVideoThumbUri': instance.introVideoThumbUri,
      'introAudioUri': instance.introAudioUri,
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
  ..contentAccessScope = $enumDecode(
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

DeleteJournalGoalByIdArguments _$DeleteJournalGoalByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    DeleteJournalGoalByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DeleteJournalGoalByIdArgumentsToJson(
        DeleteJournalGoalByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

UpdateJournalMoodArguments _$UpdateJournalMoodArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateJournalMoodArguments(
      data:
          UpdateJournalMoodInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateJournalMoodArgumentsToJson(
        UpdateJournalMoodArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

CreateJournalGoalArguments _$CreateJournalGoalArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateJournalGoalArguments(
      data:
          CreateJournalGoalInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateJournalGoalArgumentsToJson(
        CreateJournalGoalArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DeleteJournalNoteByIdArguments _$DeleteJournalNoteByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    DeleteJournalNoteByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DeleteJournalNoteByIdArgumentsToJson(
        DeleteJournalNoteByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

UpdateJournalNoteArguments _$UpdateJournalNoteArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateJournalNoteArguments(
      data:
          UpdateJournalNoteInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateJournalNoteArgumentsToJson(
        UpdateJournalNoteArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DeleteJournalMoodByIdArguments _$DeleteJournalMoodByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    DeleteJournalMoodByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DeleteJournalMoodByIdArgumentsToJson(
        DeleteJournalMoodByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

UpdateJournalGoalArguments _$UpdateJournalGoalArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateJournalGoalArguments(
      data:
          UpdateJournalGoalInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateJournalGoalArgumentsToJson(
        UpdateJournalGoalArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

CreateJournalMoodArguments _$CreateJournalMoodArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateJournalMoodArguments(
      data:
          CreateJournalMoodInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateJournalMoodArgumentsToJson(
        CreateJournalMoodArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

CreateJournalNoteArguments _$CreateJournalNoteArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateJournalNoteArguments(
      data:
          CreateJournalNoteInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateJournalNoteArgumentsToJson(
        CreateJournalNoteArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
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

CheckUniqueClubNameArguments _$CheckUniqueClubNameArgumentsFromJson(
        Map<String, dynamic> json) =>
    CheckUniqueClubNameArguments(
      name: json['name'] as String,
    );

Map<String, dynamic> _$CheckUniqueClubNameArgumentsToJson(
        CheckUniqueClubNameArguments instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

CreateBodyTrackingEntryArguments _$CreateBodyTrackingEntryArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateBodyTrackingEntryArguments(
      data: CreateBodyTrackingEntryInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateBodyTrackingEntryArgumentsToJson(
        CreateBodyTrackingEntryArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

UpdateBodyTrackingEntryArguments _$UpdateBodyTrackingEntryArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateBodyTrackingEntryArguments(
      data: UpdateBodyTrackingEntryInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateBodyTrackingEntryArgumentsToJson(
        UpdateBodyTrackingEntryArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DeleteBodyTrackingEntryByIdArguments
    _$DeleteBodyTrackingEntryByIdArgumentsFromJson(Map<String, dynamic> json) =>
        DeleteBodyTrackingEntryByIdArguments(
          id: json['id'] as String,
        );

Map<String, dynamic> _$DeleteBodyTrackingEntryByIdArgumentsToJson(
        DeleteBodyTrackingEntryByIdArguments instance) =>
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

UpdateWorkoutMovesArguments _$UpdateWorkoutMovesArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateWorkoutMovesArguments(
      data: (json['data'] as List<dynamic>)
          .map(
              (e) => UpdateWorkoutMoveInput.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UpdateWorkoutMovesArgumentsToJson(
        UpdateWorkoutMovesArguments instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
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

WorkoutPlanEnrolmentByIdArguments _$WorkoutPlanEnrolmentByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    WorkoutPlanEnrolmentByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$WorkoutPlanEnrolmentByIdArgumentsToJson(
        WorkoutPlanEnrolmentByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

ClearScheduleForPlanEnrolmentArguments
    _$ClearScheduleForPlanEnrolmentArgumentsFromJson(
            Map<String, dynamic> json) =>
        ClearScheduleForPlanEnrolmentArguments(
          enrolmentId: json['enrolmentId'] as String,
        );

Map<String, dynamic> _$ClearScheduleForPlanEnrolmentArgumentsToJson(
        ClearScheduleForPlanEnrolmentArguments instance) =>
    <String, dynamic>{
      'enrolmentId': instance.enrolmentId,
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

DeleteCompletedWorkoutPlanDayWorkoutArguments
    _$DeleteCompletedWorkoutPlanDayWorkoutArgumentsFromJson(
            Map<String, dynamic> json) =>
        DeleteCompletedWorkoutPlanDayWorkoutArguments(
          data: DeleteCompletedWorkoutPlanDayWorkoutInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$DeleteCompletedWorkoutPlanDayWorkoutArgumentsToJson(
        DeleteCompletedWorkoutPlanDayWorkoutArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

ClearWorkoutPlanEnrolmentProgressArguments
    _$ClearWorkoutPlanEnrolmentProgressArgumentsFromJson(
            Map<String, dynamic> json) =>
        ClearWorkoutPlanEnrolmentProgressArguments(
          enrolmentId: json['enrolmentId'] as String,
        );

Map<String, dynamic> _$ClearWorkoutPlanEnrolmentProgressArgumentsToJson(
        ClearWorkoutPlanEnrolmentProgressArguments instance) =>
    <String, dynamic>{
      'enrolmentId': instance.enrolmentId,
    };

CreateScheduleForPlanEnrolmentArguments
    _$CreateScheduleForPlanEnrolmentArgumentsFromJson(
            Map<String, dynamic> json) =>
        CreateScheduleForPlanEnrolmentArguments(
          data: CreateScheduleForPlanEnrolmentInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$CreateScheduleForPlanEnrolmentArgumentsToJson(
        CreateScheduleForPlanEnrolmentArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

CreateCompletedWorkoutPlanDayWorkoutArguments
    _$CreateCompletedWorkoutPlanDayWorkoutArgumentsFromJson(
            Map<String, dynamic> json) =>
        CreateCompletedWorkoutPlanDayWorkoutArguments(
          data: CreateCompletedWorkoutPlanDayWorkoutInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$CreateCompletedWorkoutPlanDayWorkoutArgumentsToJson(
        CreateCompletedWorkoutPlanDayWorkoutArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
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

LogCountByWorkoutArguments _$LogCountByWorkoutArgumentsFromJson(
        Map<String, dynamic> json) =>
    LogCountByWorkoutArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$LogCountByWorkoutArgumentsToJson(
        LogCountByWorkoutArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
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

UserPublicWorkoutPlansArguments _$UserPublicWorkoutPlansArgumentsFromJson(
        Map<String, dynamic> json) =>
    UserPublicWorkoutPlansArguments(
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$UserPublicWorkoutPlansArgumentsToJson(
        UserPublicWorkoutPlansArguments instance) =>
    <String, dynamic>{
      'userId': instance.userId,
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

UserProfilesArguments _$UserProfilesArgumentsFromJson(
        Map<String, dynamic> json) =>
    UserProfilesArguments(
      cursor: json['cursor'] as String?,
      take: json['take'] as int?,
    );

Map<String, dynamic> _$UserProfilesArgumentsToJson(
        UserProfilesArguments instance) =>
    <String, dynamic>{
      'cursor': instance.cursor,
      'take': instance.take,
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

UpdateUserProfileArguments _$UpdateUserProfileArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateUserProfileArguments(
      data:
          UpdateUserProfileInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateUserProfileArgumentsToJson(
        UpdateUserProfileArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

UserProfileByIdArguments _$UserProfileByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    UserProfileByIdArguments(
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$UserProfileByIdArgumentsToJson(
        UserProfileByIdArguments instance) =>
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

CreateWorkoutSetWithWorkoutMovesArguments
    _$CreateWorkoutSetWithWorkoutMovesArgumentsFromJson(
            Map<String, dynamic> json) =>
        CreateWorkoutSetWithWorkoutMovesArguments(
          data: CreateWorkoutSetWithWorkoutMovesInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$CreateWorkoutSetWithWorkoutMovesArgumentsToJson(
        CreateWorkoutSetWithWorkoutMovesArguments instance) =>
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

UserPublicWorkoutsArguments _$UserPublicWorkoutsArgumentsFromJson(
        Map<String, dynamic> json) =>
    UserPublicWorkoutsArguments(
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$UserPublicWorkoutsArgumentsToJson(
        UserPublicWorkoutsArguments instance) =>
    <String, dynamic>{
      'userId': instance.userId,
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

RemoveDocumentFromSkillArguments _$RemoveDocumentFromSkillArgumentsFromJson(
        Map<String, dynamic> json) =>
    RemoveDocumentFromSkillArguments(
      data: RemoveDocumentFromSkillInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RemoveDocumentFromSkillArgumentsToJson(
        RemoveDocumentFromSkillArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DeleteSkillByIdArguments _$DeleteSkillByIdArgumentsFromJson(
        Map<String, dynamic> json) =>
    DeleteSkillByIdArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DeleteSkillByIdArgumentsToJson(
        DeleteSkillByIdArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

AddDocumentToSkillArguments _$AddDocumentToSkillArgumentsFromJson(
        Map<String, dynamic> json) =>
    AddDocumentToSkillArguments(
      data: AddDocumentToSkillInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AddDocumentToSkillArgumentsToJson(
        AddDocumentToSkillArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

CreateSkillArguments _$CreateSkillArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateSkillArguments(
      data: CreateSkillInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateSkillArgumentsToJson(
        CreateSkillArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

UpdateSkillArguments _$UpdateSkillArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateSkillArguments(
      data: UpdateSkillInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateSkillArgumentsToJson(
        UpdateSkillArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
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

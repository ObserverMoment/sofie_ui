// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.12

part of 'graphql_api.graphql.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClubChatSummary _$ClubChatSummaryFromJson(Map<String, dynamic> json) =>
    ClubChatSummary()
      ..id = json['id'] as String
      ..name = json['name'] as String
      ..coverImageUri = json['coverImageUri'] as String?
      ..owner = UserAvatarData.fromJson(json['Owner'] as Map<String, dynamic>)
      ..admins = (json['Admins'] as List<dynamic>)
          .map((e) => UserAvatarData.fromJson(e as Map<String, dynamic>))
          .toList()
      ..members = (json['Members'] as List<dynamic>)
          .map((e) => UserAvatarData.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ClubChatSummaryToJson(ClubChatSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'coverImageUri': instance.coverImageUri,
      'Owner': instance.owner.toJson(),
      'Admins': instance.admins.map((e) => e.toJson()).toList(),
      'Members': instance.members.map((e) => e.toJson()).toList(),
    };

ClubChatSummary$Query _$ClubChatSummary$QueryFromJson(
        Map<String, dynamic> json) =>
    ClubChatSummary$Query()
      ..clubChatSummary = json['clubChatSummary'] == null
          ? null
          : ClubChatSummary.fromJson(
              json['clubChatSummary'] as Map<String, dynamic>);

Map<String, dynamic> _$ClubChatSummary$QueryToJson(
        ClubChatSummary$Query instance) =>
    <String, dynamic>{
      'clubChatSummary': instance.clubChatSummary?.toJson(),
    };

ClubChatSummaryMixin$UserAvatarData
    _$ClubChatSummaryMixin$UserAvatarDataFromJson(Map<String, dynamic> json) =>
        ClubChatSummaryMixin$UserAvatarData()
          ..$$typename = json['__typename'] as String?
          ..id = json['id'] as String
          ..avatarUri = json['avatarUri'] as String?
          ..displayName = json['displayName'] as String;

Map<String, dynamic> _$ClubChatSummaryMixin$UserAvatarDataToJson(
        ClubChatSummaryMixin$UserAvatarData instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'avatarUri': instance.avatarUri,
      'displayName': instance.displayName,
    };

DeleteClub$Mutation _$DeleteClub$MutationFromJson(Map<String, dynamic> json) =>
    DeleteClub$Mutation()..deleteClub = json['deleteClub'] as String;

Map<String, dynamic> _$DeleteClub$MutationToJson(
        DeleteClub$Mutation instance) =>
    <String, dynamic>{
      'deleteClub': instance.deleteClub,
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

ClubSummary _$ClubSummaryFromJson(Map<String, dynamic> json) => ClubSummary()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
  ..name = json['name'] as String
  ..description = json['description'] as String?
  ..coverImageUri = json['coverImageUri'] as String?
  ..introVideoUri = json['introVideoUri'] as String?
  ..introVideoThumbUri = json['introVideoThumbUri'] as String?
  ..introAudioUri = json['introAudioUri'] as String?
  ..contentAccessScope = $enumDecode(
      _$ContentAccessScopeEnumMap, json['contentAccessScope'],
      unknownValue: ContentAccessScope.artemisUnknown)
  ..location = json['location'] as String?
  ..memberCount = json['memberCount'] as int
  ..workoutCount = json['workoutCount'] as int
  ..planCount = json['planCount'] as int
  ..owner = UserAvatarData.fromJson(json['Owner'] as Map<String, dynamic>)
  ..admins = (json['Admins'] as List<dynamic>)
      .map((e) => UserAvatarData.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$ClubSummaryToJson(ClubSummary instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'name': instance.name,
      'description': instance.description,
      'coverImageUri': instance.coverImageUri,
      'introVideoUri': instance.introVideoUri,
      'introVideoThumbUri': instance.introVideoThumbUri,
      'introAudioUri': instance.introAudioUri,
      'contentAccessScope':
          _$ContentAccessScopeEnumMap[instance.contentAccessScope],
      'location': instance.location,
      'memberCount': instance.memberCount,
      'workoutCount': instance.workoutCount,
      'planCount': instance.planCount,
      'Owner': instance.owner.toJson(),
      'Admins': instance.admins.map((e) => e.toJson()).toList(),
    };

const _$ContentAccessScopeEnumMap = {
  ContentAccessScope.private: 'PRIVATE',
  ContentAccessScope.public: 'PUBLIC',
  ContentAccessScope.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

ClubSummary$Query _$ClubSummary$QueryFromJson(Map<String, dynamic> json) =>
    ClubSummary$Query()
      ..clubSummary = json['clubSummary'] == null
          ? null
          : ClubSummary.fromJson(json['clubSummary'] as Map<String, dynamic>);

Map<String, dynamic> _$ClubSummary$QueryToJson(ClubSummary$Query instance) =>
    <String, dynamic>{
      'clubSummary': instance.clubSummary?.toJson(),
    };

CreateClub$Mutation _$CreateClub$MutationFromJson(Map<String, dynamic> json) =>
    CreateClub$Mutation()
      ..createClub =
          ClubSummary.fromJson(json['createClub'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateClub$MutationToJson(
        CreateClub$Mutation instance) =>
    <String, dynamic>{
      'createClub': instance.createClub.toJson(),
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

UpdateClubSummary$Mutation _$UpdateClubSummary$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateClubSummary$Mutation()
      ..updateClubSummary = ClubSummary.fromJson(
          json['updateClubSummary'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateClubSummary$MutationToJson(
        UpdateClubSummary$Mutation instance) =>
    <String, dynamic>{
      'updateClubSummary': instance.updateClubSummary.toJson(),
    };

UpdateClubSummaryInput _$UpdateClubSummaryInputFromJson(
        Map<String, dynamic> json) =>
    UpdateClubSummaryInput(
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

Map<String, dynamic> _$UpdateClubSummaryInputToJson(
        UpdateClubSummaryInput instance) =>
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

ClubSummaries$Query _$ClubSummaries$QueryFromJson(Map<String, dynamic> json) =>
    ClubSummaries$Query()
      ..clubSummaries = (json['clubSummaries'] as List<dynamic>)
          .map((e) => ClubSummary.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ClubSummaries$QueryToJson(
        ClubSummaries$Query instance) =>
    <String, dynamic>{
      'clubSummaries': instance.clubSummaries.map((e) => e.toJson()).toList(),
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

UserGoal _$UserGoalFromJson(Map<String, dynamic> json) => UserGoal()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
  ..updatedAt = fromGraphQLDateTimeToDartDateTime(json['updatedAt'] as int)
  ..name = json['name'] as String
  ..description = json['description'] as String?
  ..deadline = fromGraphQLDateTimeNullableToDartDateTimeNullable(
      json['deadline'] as int?)
  ..completedDate = fromGraphQLDateTimeNullableToDartDateTimeNullable(
      json['completedDate'] as int?);

Map<String, dynamic> _$UserGoalToJson(UserGoal instance) => <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'updatedAt': fromDartDateTimeToGraphQLDateTime(instance.updatedAt),
      'name': instance.name,
      'description': instance.description,
      'deadline':
          fromDartDateTimeNullableToGraphQLDateTimeNullable(instance.deadline),
      'completedDate': fromDartDateTimeNullableToGraphQLDateTimeNullable(
          instance.completedDate),
    };

CreateUserGoal$Mutation _$CreateUserGoal$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateUserGoal$Mutation()
      ..createUserGoal =
          UserGoal.fromJson(json['createUserGoal'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateUserGoal$MutationToJson(
        CreateUserGoal$Mutation instance) =>
    <String, dynamic>{
      'createUserGoal': instance.createUserGoal.toJson(),
    };

CreateUserGoalInput _$CreateUserGoalInputFromJson(Map<String, dynamic> json) =>
    CreateUserGoalInput(
      deadline: fromGraphQLDateTimeNullableToDartDateTimeNullable(
          json['deadline'] as int?),
      description: json['description'] as String?,
      name: json['name'] as String,
    );

Map<String, dynamic> _$CreateUserGoalInputToJson(
        CreateUserGoalInput instance) =>
    <String, dynamic>{
      'deadline':
          fromDartDateTimeNullableToGraphQLDateTimeNullable(instance.deadline),
      'description': instance.description,
      'name': instance.name,
    };

DeleteUserGoal$Mutation _$DeleteUserGoal$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteUserGoal$Mutation()
      ..deleteUserGoal = json['deleteUserGoal'] as String;

Map<String, dynamic> _$DeleteUserGoal$MutationToJson(
        DeleteUserGoal$Mutation instance) =>
    <String, dynamic>{
      'deleteUserGoal': instance.deleteUserGoal,
    };

UserSleepWellLog _$UserSleepWellLogFromJson(Map<String, dynamic> json) =>
    UserSleepWellLog()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..year = json['year'] as int
      ..dayNumber = json['dayNumber'] as int
      ..rating = $enumDecode(_$UserDayLogRatingEnumMap, json['rating'],
          unknownValue: UserDayLogRating.artemisUnknown)
      ..minutesSlept = json['minutesSlept'] as int?
      ..note = json['note'] as String?;

Map<String, dynamic> _$UserSleepWellLogToJson(UserSleepWellLog instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'year': instance.year,
      'dayNumber': instance.dayNumber,
      'rating': _$UserDayLogRatingEnumMap[instance.rating],
      'minutesSlept': instance.minutesSlept,
      'note': instance.note,
    };

const _$UserDayLogRatingEnumMap = {
  UserDayLogRating.average: 'AVERAGE',
  UserDayLogRating.bad: 'BAD',
  UserDayLogRating.good: 'GOOD',
  UserDayLogRating.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

CreateUserSleepWellLog$Mutation _$CreateUserSleepWellLog$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateUserSleepWellLog$Mutation()
      ..createUserSleepWellLog = UserSleepWellLog.fromJson(
          json['createUserSleepWellLog'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateUserSleepWellLog$MutationToJson(
        CreateUserSleepWellLog$Mutation instance) =>
    <String, dynamic>{
      'createUserSleepWellLog': instance.createUserSleepWellLog.toJson(),
    };

CreateUserSleepWellLogInput _$CreateUserSleepWellLogInputFromJson(
        Map<String, dynamic> json) =>
    CreateUserSleepWellLogInput(
      dayNumber: json['dayNumber'] as int,
      minutesSlept: json['minutesSlept'] as int?,
      note: json['note'] as String?,
      rating: $enumDecode(_$UserDayLogRatingEnumMap, json['rating'],
          unknownValue: UserDayLogRating.artemisUnknown),
      year: json['year'] as int,
    );

Map<String, dynamic> _$CreateUserSleepWellLogInputToJson(
        CreateUserSleepWellLogInput instance) =>
    <String, dynamic>{
      'dayNumber': instance.dayNumber,
      'minutesSlept': instance.minutesSlept,
      'note': instance.note,
      'rating': _$UserDayLogRatingEnumMap[instance.rating],
      'year': instance.year,
    };

UpdateUserSleepWellLog$Mutation _$UpdateUserSleepWellLog$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateUserSleepWellLog$Mutation()
      ..updateUserSleepWellLog = UserSleepWellLog.fromJson(
          json['updateUserSleepWellLog'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateUserSleepWellLog$MutationToJson(
        UpdateUserSleepWellLog$Mutation instance) =>
    <String, dynamic>{
      'updateUserSleepWellLog': instance.updateUserSleepWellLog.toJson(),
    };

UpdateUserSleepWellLogInput _$UpdateUserSleepWellLogInputFromJson(
        Map<String, dynamic> json) =>
    UpdateUserSleepWellLogInput(
      id: json['id'] as String,
      minutesSlept: json['minutesSlept'] as int?,
      note: json['note'] as String?,
      rating: $enumDecodeNullable(_$UserDayLogRatingEnumMap, json['rating'],
          unknownValue: UserDayLogRating.artemisUnknown),
    );

Map<String, dynamic> _$UpdateUserSleepWellLogInputToJson(
        UpdateUserSleepWellLogInput instance) =>
    <String, dynamic>{
      'id': instance.id,
      'minutesSlept': instance.minutesSlept,
      'note': instance.note,
      'rating': _$UserDayLogRatingEnumMap[instance.rating],
    };

UpdateUserGoal$Mutation _$UpdateUserGoal$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateUserGoal$Mutation()
      ..updateUserGoal =
          UserGoal.fromJson(json['updateUserGoal'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateUserGoal$MutationToJson(
        UpdateUserGoal$Mutation instance) =>
    <String, dynamic>{
      'updateUserGoal': instance.updateUserGoal.toJson(),
    };

UpdateUserGoalInput _$UpdateUserGoalInputFromJson(Map<String, dynamic> json) =>
    UpdateUserGoalInput(
      completedDate: fromGraphQLDateTimeNullableToDartDateTimeNullable(
          json['completedDate'] as int?),
      deadline: fromGraphQLDateTimeNullableToDartDateTimeNullable(
          json['deadline'] as int?),
      description: json['description'] as String?,
      id: json['id'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$UpdateUserGoalInputToJson(
        UpdateUserGoalInput instance) =>
    <String, dynamic>{
      'completedDate': fromDartDateTimeNullableToGraphQLDateTimeNullable(
          instance.completedDate),
      'deadline':
          fromDartDateTimeNullableToGraphQLDateTimeNullable(instance.deadline),
      'description': instance.description,
      'id': instance.id,
      'name': instance.name,
    };

UserMeditationLog _$UserMeditationLogFromJson(Map<String, dynamic> json) =>
    UserMeditationLog()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..year = json['year'] as int
      ..dayNumber = json['dayNumber'] as int
      ..minutesLogged = json['minutesLogged'] as int
      ..note = json['note'] as String?;

Map<String, dynamic> _$UserMeditationLogToJson(UserMeditationLog instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'year': instance.year,
      'dayNumber': instance.dayNumber,
      'minutesLogged': instance.minutesLogged,
      'note': instance.note,
    };

CreateUserMeditationLog$Mutation _$CreateUserMeditationLog$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateUserMeditationLog$Mutation()
      ..createUserMeditationLog = UserMeditationLog.fromJson(
          json['createUserMeditationLog'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateUserMeditationLog$MutationToJson(
        CreateUserMeditationLog$Mutation instance) =>
    <String, dynamic>{
      'createUserMeditationLog': instance.createUserMeditationLog.toJson(),
    };

CreateUserMeditationLogInput _$CreateUserMeditationLogInputFromJson(
        Map<String, dynamic> json) =>
    CreateUserMeditationLogInput(
      dayNumber: json['dayNumber'] as int,
      minutesLogged: json['minutesLogged'] as int,
      note: json['note'] as String?,
      year: json['year'] as int,
    );

Map<String, dynamic> _$CreateUserMeditationLogInputToJson(
        CreateUserMeditationLogInput instance) =>
    <String, dynamic>{
      'dayNumber': instance.dayNumber,
      'minutesLogged': instance.minutesLogged,
      'note': instance.note,
      'year': instance.year,
    };

DeleteUserDayLogMood$Mutation _$DeleteUserDayLogMood$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteUserDayLogMood$Mutation()
      ..deleteUserDayLogMood = json['deleteUserDayLogMood'] as String;

Map<String, dynamic> _$DeleteUserDayLogMood$MutationToJson(
        DeleteUserDayLogMood$Mutation instance) =>
    <String, dynamic>{
      'deleteUserDayLogMood': instance.deleteUserDayLogMood,
    };

UserEatWellLog _$UserEatWellLogFromJson(Map<String, dynamic> json) =>
    UserEatWellLog()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..year = json['year'] as int
      ..dayNumber = json['dayNumber'] as int
      ..rating = $enumDecode(_$UserDayLogRatingEnumMap, json['rating'],
          unknownValue: UserDayLogRating.artemisUnknown)
      ..note = json['note'] as String?;

Map<String, dynamic> _$UserEatWellLogToJson(UserEatWellLog instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'year': instance.year,
      'dayNumber': instance.dayNumber,
      'rating': _$UserDayLogRatingEnumMap[instance.rating],
      'note': instance.note,
    };

CreateUserEatWellLog$Mutation _$CreateUserEatWellLog$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateUserEatWellLog$Mutation()
      ..createUserEatWellLog = UserEatWellLog.fromJson(
          json['createUserEatWellLog'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateUserEatWellLog$MutationToJson(
        CreateUserEatWellLog$Mutation instance) =>
    <String, dynamic>{
      'createUserEatWellLog': instance.createUserEatWellLog.toJson(),
    };

CreateUserEatWellLogInput _$CreateUserEatWellLogInputFromJson(
        Map<String, dynamic> json) =>
    CreateUserEatWellLogInput(
      dayNumber: json['dayNumber'] as int,
      note: json['note'] as String?,
      rating: $enumDecode(_$UserDayLogRatingEnumMap, json['rating'],
          unknownValue: UserDayLogRating.artemisUnknown),
      year: json['year'] as int,
    );

Map<String, dynamic> _$CreateUserEatWellLogInputToJson(
        CreateUserEatWellLogInput instance) =>
    <String, dynamic>{
      'dayNumber': instance.dayNumber,
      'note': instance.note,
      'rating': _$UserDayLogRatingEnumMap[instance.rating],
      'year': instance.year,
    };

UpdateUserMeditationLog$Mutation _$UpdateUserMeditationLog$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateUserMeditationLog$Mutation()
      ..updateUserMeditationLog = UserMeditationLog.fromJson(
          json['updateUserMeditationLog'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateUserMeditationLog$MutationToJson(
        UpdateUserMeditationLog$Mutation instance) =>
    <String, dynamic>{
      'updateUserMeditationLog': instance.updateUserMeditationLog.toJson(),
    };

UpdateUserMeditationLogInput _$UpdateUserMeditationLogInputFromJson(
        Map<String, dynamic> json) =>
    UpdateUserMeditationLogInput(
      id: json['id'] as String,
      minutesLogged: json['minutesLogged'] as int?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$UpdateUserMeditationLogInputToJson(
        UpdateUserMeditationLogInput instance) =>
    <String, dynamic>{
      'id': instance.id,
      'minutesLogged': instance.minutesLogged,
      'note': instance.note,
    };

UserDayLogMood _$UserDayLogMoodFromJson(Map<String, dynamic> json) =>
    UserDayLogMood()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..moodScore = json['moodScore'] as int
      ..energyScore = json['energyScore'] as int
      ..tags = (json['tags'] as List<dynamic>).map((e) => e as String).toList()
      ..note = json['note'] as String?;

Map<String, dynamic> _$UserDayLogMoodToJson(UserDayLogMood instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'moodScore': instance.moodScore,
      'energyScore': instance.energyScore,
      'tags': instance.tags,
      'note': instance.note,
    };

CreateUserDayLogMood$Mutation _$CreateUserDayLogMood$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateUserDayLogMood$Mutation()
      ..createUserDayLogMood = UserDayLogMood.fromJson(
          json['createUserDayLogMood'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateUserDayLogMood$MutationToJson(
        CreateUserDayLogMood$Mutation instance) =>
    <String, dynamic>{
      'createUserDayLogMood': instance.createUserDayLogMood.toJson(),
    };

CreateUserDayLogMoodInput _$CreateUserDayLogMoodInputFromJson(
        Map<String, dynamic> json) =>
    CreateUserDayLogMoodInput(
      energyScore: json['energyScore'] as int,
      moodScore: json['moodScore'] as int,
      note: json['note'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$CreateUserDayLogMoodInputToJson(
        CreateUserDayLogMoodInput instance) =>
    <String, dynamic>{
      'energyScore': instance.energyScore,
      'moodScore': instance.moodScore,
      'note': instance.note,
      'tags': instance.tags,
    };

UpdateUserEatWellLog$Mutation _$UpdateUserEatWellLog$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateUserEatWellLog$Mutation()
      ..updateUserEatWellLog = UserEatWellLog.fromJson(
          json['updateUserEatWellLog'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateUserEatWellLog$MutationToJson(
        UpdateUserEatWellLog$Mutation instance) =>
    <String, dynamic>{
      'updateUserEatWellLog': instance.updateUserEatWellLog.toJson(),
    };

UpdateUserEatWellLogInput _$UpdateUserEatWellLogInputFromJson(
        Map<String, dynamic> json) =>
    UpdateUserEatWellLogInput(
      id: json['id'] as String,
      note: json['note'] as String?,
      rating: $enumDecodeNullable(_$UserDayLogRatingEnumMap, json['rating'],
          unknownValue: UserDayLogRating.artemisUnknown),
    );

Map<String, dynamic> _$UpdateUserEatWellLogInputToJson(
        UpdateUserEatWellLogInput instance) =>
    <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
      'rating': _$UserDayLogRatingEnumMap[instance.rating],
    };

UserMeditationLogs$Query _$UserMeditationLogs$QueryFromJson(
        Map<String, dynamic> json) =>
    UserMeditationLogs$Query()
      ..userMeditationLogs = (json['userMeditationLogs'] as List<dynamic>)
          .map((e) => UserMeditationLog.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserMeditationLogs$QueryToJson(
        UserMeditationLogs$Query instance) =>
    <String, dynamic>{
      'userMeditationLogs':
          instance.userMeditationLogs.map((e) => e.toJson()).toList(),
    };

UserEatWellLogs$Query _$UserEatWellLogs$QueryFromJson(
        Map<String, dynamic> json) =>
    UserEatWellLogs$Query()
      ..userEatWellLogs = (json['userEatWellLogs'] as List<dynamic>)
          .map((e) => UserEatWellLog.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserEatWellLogs$QueryToJson(
        UserEatWellLogs$Query instance) =>
    <String, dynamic>{
      'userEatWellLogs':
          instance.userEatWellLogs.map((e) => e.toJson()).toList(),
    };

UserSleepWellLogs$Query _$UserSleepWellLogs$QueryFromJson(
        Map<String, dynamic> json) =>
    UserSleepWellLogs$Query()
      ..userSleepWellLogs = (json['userSleepWellLogs'] as List<dynamic>)
          .map((e) => UserSleepWellLog.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserSleepWellLogs$QueryToJson(
        UserSleepWellLogs$Query instance) =>
    <String, dynamic>{
      'userSleepWellLogs':
          instance.userSleepWellLogs.map((e) => e.toJson()).toList(),
    };

UserGoals$Query _$UserGoals$QueryFromJson(Map<String, dynamic> json) =>
    UserGoals$Query()
      ..userGoals = (json['userGoals'] as List<dynamic>)
          .map((e) => UserGoal.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserGoals$QueryToJson(UserGoals$Query instance) =>
    <String, dynamic>{
      'userGoals': instance.userGoals.map((e) => e.toJson()).toList(),
    };

UserDayLogMoods$Query _$UserDayLogMoods$QueryFromJson(
        Map<String, dynamic> json) =>
    UserDayLogMoods$Query()
      ..userDayLogMoods = (json['userDayLogMoods'] as List<dynamic>)
          .map((e) => UserDayLogMood.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserDayLogMoods$QueryToJson(
        UserDayLogMoods$Query instance) =>
    <String, dynamic>{
      'userDayLogMoods':
          instance.userDayLogMoods.map((e) => e.toJson()).toList(),
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

WorkoutSummary _$WorkoutSummaryFromJson(Map<String, dynamic> json) =>
    WorkoutSummary()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..updatedAt = fromGraphQLDateTimeToDartDateTime(json['updatedAt'] as int)
      ..archived = json['archived'] as bool
      ..name = json['name'] as String
      ..user = UserAvatarData.fromJson(json['User'] as Map<String, dynamic>)
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
      ..sectionTypes = (json['sectionTypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList()
      ..goals =
          (json['goals'] as List<dynamic>).map((e) => e as String).toList()
      ..tags = (json['tags'] as List<dynamic>).map((e) => e as String).toList()
      ..bodyAreas =
          (json['bodyAreas'] as List<dynamic>).map((e) => e as String).toList();

Map<String, dynamic> _$WorkoutSummaryToJson(WorkoutSummary instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'updatedAt': fromDartDateTimeToGraphQLDateTime(instance.updatedAt),
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
      'sectionTypes': instance.sectionTypes,
      'goals': instance.goals,
      'tags': instance.tags,
      'bodyAreas': instance.bodyAreas,
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
      ..updatedAt = fromGraphQLDateTimeToDartDateTime(json['updatedAt'] as int)
      ..archived = json['archived'] as bool
      ..name = json['name'] as String
      ..description = json['description'] as String?
      ..coverImageUri = json['coverImageUri'] as String?
      ..lengthWeeks = json['lengthWeeks'] as int
      ..daysPerWeek = json['daysPerWeek'] as int
      ..workoutsCount = json['workoutsCount'] as int
      ..user = UserAvatarData.fromJson(json['User'] as Map<String, dynamic>)
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
      'updatedAt': fromDartDateTimeToGraphQLDateTime(instance.updatedAt),
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

WorkoutSummaryMixin$UserAvatarData _$WorkoutSummaryMixin$UserAvatarDataFromJson(
        Map<String, dynamic> json) =>
    WorkoutSummaryMixin$UserAvatarData()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..avatarUri = json['avatarUri'] as String?
      ..displayName = json['displayName'] as String;

Map<String, dynamic> _$WorkoutSummaryMixin$UserAvatarDataToJson(
        WorkoutSummaryMixin$UserAvatarData instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'avatarUri': instance.avatarUri,
      'displayName': instance.displayName,
    };

WorkoutPlanSummaryMixin$UserAvatarData
    _$WorkoutPlanSummaryMixin$UserAvatarDataFromJson(
            Map<String, dynamic> json) =>
        WorkoutPlanSummaryMixin$UserAvatarData()
          ..$$typename = json['__typename'] as String?
          ..id = json['id'] as String
          ..avatarUri = json['avatarUri'] as String?
          ..displayName = json['displayName'] as String;

Map<String, dynamic> _$WorkoutPlanSummaryMixin$UserAvatarDataToJson(
        WorkoutPlanSummaryMixin$UserAvatarData instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'avatarUri': instance.avatarUri,
      'displayName': instance.displayName,
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

MarkWelcomeTodoItemAsSeen$Mutation _$MarkWelcomeTodoItemAsSeen$MutationFromJson(
        Map<String, dynamic> json) =>
    MarkWelcomeTodoItemAsSeen$Mutation()
      ..markWelcomeTodoItemAsSeen = json['markWelcomeTodoItemAsSeen'] as String;

Map<String, dynamic> _$MarkWelcomeTodoItemAsSeen$MutationToJson(
        MarkWelcomeTodoItemAsSeen$Mutation instance) =>
    <String, dynamic>{
      'markWelcomeTodoItemAsSeen': instance.markWelcomeTodoItemAsSeen,
    };

MarkWelcomeTodoItemAsSeenInput _$MarkWelcomeTodoItemAsSeenInputFromJson(
        Map<String, dynamic> json) =>
    MarkWelcomeTodoItemAsSeenInput(
      userId: json['userId'] as String,
      welcomeTodoItemId: json['welcomeTodoItemId'] as String,
    );

Map<String, dynamic> _$MarkWelcomeTodoItemAsSeenInputToJson(
        MarkWelcomeTodoItemAsSeenInput instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'welcomeTodoItemId': instance.welcomeTodoItemId,
    };

WelcomeTodoItem _$WelcomeTodoItemFromJson(Map<String, dynamic> json) =>
    WelcomeTodoItem()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..videoUri = json['videoUri'] as String?
      ..routeTo = json['routeTo'] as String?
      ..title = json['title'] as String;

Map<String, dynamic> _$WelcomeTodoItemToJson(WelcomeTodoItem instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'videoUri': instance.videoUri,
      'routeTo': instance.routeTo,
      'title': instance.title,
    };

WelcomeTodoItems$Query _$WelcomeTodoItems$QueryFromJson(
        Map<String, dynamic> json) =>
    WelcomeTodoItems$Query()
      ..welcomeTodoItems = (json['welcomeTodoItems'] as List<dynamic>)
          .map((e) => WelcomeTodoItem.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$WelcomeTodoItems$QueryToJson(
        WelcomeTodoItems$Query instance) =>
    <String, dynamic>{
      'welcomeTodoItems':
          instance.welcomeTodoItems.map((e) => e.toJson()).toList(),
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
  ..updatedAt = fromGraphQLDateTimeToDartDateTime(json['updatedAt'] as int)
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
  ..user = UserAvatarData.fromJson(json['User'] as Map<String, dynamic>)
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
      'updatedAt': fromDartDateTimeToGraphQLDateTime(instance.updatedAt),
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

WorkoutDataMixin$UserAvatarData _$WorkoutDataMixin$UserAvatarDataFromJson(
        Map<String, dynamic> json) =>
    WorkoutDataMixin$UserAvatarData()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..avatarUri = json['avatarUri'] as String?
      ..displayName = json['displayName'] as String;

Map<String, dynamic> _$WorkoutDataMixin$UserAvatarDataToJson(
        WorkoutDataMixin$UserAvatarData instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'avatarUri': instance.avatarUri,
      'displayName': instance.displayName,
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
  ..duration = json['duration'] as int
  ..workoutMoves = (json['WorkoutMoves'] as List<dynamic>)
      .map((e) => WorkoutMove.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$WorkoutSetToJson(WorkoutSet instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'sortPosition': instance.sortPosition,
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
          ..updatedAt =
              fromGraphQLDateTimeToDartDateTime(json['updatedAt'] as int)
          ..archived = json['archived'] as bool
          ..name = json['name'] as String
          ..description = json['description'] as String?
          ..coverImageUri = json['coverImageUri'] as String?
          ..lengthWeeks = json['lengthWeeks'] as int
          ..daysPerWeek = json['daysPerWeek'] as int
          ..workoutsCount = json['workoutsCount'] as int
          ..user = UserAvatarData.fromJson(json['User'] as Map<String, dynamic>)
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
          'updatedAt': fromDartDateTimeToGraphQLDateTime(instance.updatedAt),
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
      ..user = UserAvatarData.fromJson(json['User'] as Map<String, dynamic>);

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
  ..updatedAt = fromGraphQLDateTimeToDartDateTime(json['updatedAt'] as int)
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
  ..user = UserAvatarData.fromJson(json['User'] as Map<String, dynamic>)
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
      'updatedAt': fromDartDateTimeToGraphQLDateTime(instance.updatedAt),
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
      ..workoutPlanEnrolmentById = json['workoutPlanEnrolmentById'] == null
          ? null
          : WorkoutPlanEnrolmentWithPlan.fromJson(
              json['workoutPlanEnrolmentById'] as Map<String, dynamic>);

Map<String, dynamic> _$WorkoutPlanEnrolmentById$QueryToJson(
        WorkoutPlanEnrolmentById$Query instance) =>
    <String, dynamic>{
      'workoutPlanEnrolmentById': instance.workoutPlanEnrolmentById?.toJson(),
    };

WorkoutPlanDataMixin$UserAvatarData
    _$WorkoutPlanDataMixin$UserAvatarDataFromJson(Map<String, dynamic> json) =>
        WorkoutPlanDataMixin$UserAvatarData()
          ..$$typename = json['__typename'] as String?
          ..id = json['id'] as String
          ..avatarUri = json['avatarUri'] as String?
          ..displayName = json['displayName'] as String;

Map<String, dynamic> _$WorkoutPlanDataMixin$UserAvatarDataToJson(
        WorkoutPlanDataMixin$UserAvatarData instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'avatarUri': instance.avatarUri,
      'displayName': instance.displayName,
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
          ..user =
              UserAvatarData.fromJson(json['User'] as Map<String, dynamic>);

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
          ..user =
              UserAvatarData.fromJson(json['User'] as Map<String, dynamic>);

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

LoggedWorkoutMove _$LoggedWorkoutMoveFromJson(Map<String, dynamic> json) =>
    LoggedWorkoutMove()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..sortPosition = json['sortPosition'] as int
      ..repType = $enumDecode(_$WorkoutMoveRepTypeEnumMap, json['repType'],
          unknownValue: WorkoutMoveRepType.artemisUnknown)
      ..reps = (json['reps'] as num).toDouble()
      ..distanceUnit = $enumDecode(_$DistanceUnitEnumMap, json['distanceUnit'],
          unknownValue: DistanceUnit.artemisUnknown)
      ..loadAmount = (json['loadAmount'] as num).toDouble()
      ..loadUnit = $enumDecode(_$LoadUnitEnumMap, json['loadUnit'],
          unknownValue: LoadUnit.artemisUnknown)
      ..timeUnit = $enumDecode(_$TimeUnitEnumMap, json['timeUnit'],
          unknownValue: TimeUnit.artemisUnknown)
      ..move = Move.fromJson(json['Move'] as Map<String, dynamic>)
      ..equipment = json['Equipment'] == null
          ? null
          : Equipment.fromJson(json['Equipment'] as Map<String, dynamic>);

Map<String, dynamic> _$LoggedWorkoutMoveToJson(LoggedWorkoutMove instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'sortPosition': instance.sortPosition,
      'repType': _$WorkoutMoveRepTypeEnumMap[instance.repType],
      'reps': instance.reps,
      'distanceUnit': _$DistanceUnitEnumMap[instance.distanceUnit],
      'loadAmount': instance.loadAmount,
      'loadUnit': _$LoadUnitEnumMap[instance.loadUnit],
      'timeUnit': _$TimeUnitEnumMap[instance.timeUnit],
      'Move': instance.move.toJson(),
      'Equipment': instance.equipment?.toJson(),
    };

LoggedWorkoutSet _$LoggedWorkoutSetFromJson(Map<String, dynamic> json) =>
    LoggedWorkoutSet()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..sortPosition = json['sortPosition'] as int
      ..sectionRoundNumber = json['sectionRoundNumber'] as int
      ..timeTakenSeconds = json['timeTakenSeconds'] as int?
      ..loggedWorkoutMoves = (json['LoggedWorkoutMoves'] as List<dynamic>)
          .map((e) => LoggedWorkoutMove.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$LoggedWorkoutSetToJson(LoggedWorkoutSet instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'sortPosition': instance.sortPosition,
      'sectionRoundNumber': instance.sectionRoundNumber,
      'timeTakenSeconds': instance.timeTakenSeconds,
      'LoggedWorkoutMoves':
          instance.loggedWorkoutMoves.map((e) => e.toJson()).toList(),
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
      ..loggedWorkoutSets = (json['LoggedWorkoutSets'] as List<dynamic>)
          .map((e) => LoggedWorkoutSet.fromJson(e as Map<String, dynamic>))
          .toList();

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
      'LoggedWorkoutSets':
          instance.loggedWorkoutSets.map((e) => e.toJson()).toList(),
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
          : UserAvatarData.fromJson(json['User'] as Map<String, dynamic>)
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
      ..loggedWorkoutById = json['loggedWorkoutById'] == null
          ? null
          : LoggedWorkout.fromJson(
              json['loggedWorkoutById'] as Map<String, dynamic>);

Map<String, dynamic> _$LoggedWorkoutById$QueryToJson(
        LoggedWorkoutById$Query instance) =>
    <String, dynamic>{
      'loggedWorkoutById': instance.loggedWorkoutById?.toJson(),
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
          loggedWorkoutSets: (json['LoggedWorkoutSets'] as List<dynamic>)
              .map((e) =>
                  CreateLoggedWorkoutSetInLoggedWorkoutSectionInput.fromJson(
                      e as Map<String, dynamic>))
              .toList(),
          workoutSectionType: ConnectRelationInput.fromJson(
              json['WorkoutSectionType'] as Map<String, dynamic>),
          name: json['name'] as String?,
          repScore: json['repScore'] as int?,
          sortPosition: json['sortPosition'] as int,
          timeTakenSeconds: json['timeTakenSeconds'] as int,
        );

Map<String, dynamic> _$CreateLoggedWorkoutSectionInLoggedWorkoutInputToJson(
        CreateLoggedWorkoutSectionInLoggedWorkoutInput instance) =>
    <String, dynamic>{
      'LoggedWorkoutSets':
          instance.loggedWorkoutSets.map((e) => e.toJson()).toList(),
      'WorkoutSectionType': instance.workoutSectionType.toJson(),
      'name': instance.name,
      'repScore': instance.repScore,
      'sortPosition': instance.sortPosition,
      'timeTakenSeconds': instance.timeTakenSeconds,
    };

CreateLoggedWorkoutSetInLoggedWorkoutSectionInput
    _$CreateLoggedWorkoutSetInLoggedWorkoutSectionInputFromJson(
            Map<String, dynamic> json) =>
        CreateLoggedWorkoutSetInLoggedWorkoutSectionInput(
          loggedWorkoutMoves: (json['LoggedWorkoutMoves'] as List<dynamic>)
              .map((e) =>
                  CreateLoggedWorkoutMoveInLoggedWorkoutSetInput.fromJson(
                      e as Map<String, dynamic>))
              .toList(),
          sectionRoundNumber: json['sectionRoundNumber'] as int,
          sortPosition: json['sortPosition'] as int,
          timeTakenSeconds: json['timeTakenSeconds'] as int?,
        );

Map<String, dynamic> _$CreateLoggedWorkoutSetInLoggedWorkoutSectionInputToJson(
        CreateLoggedWorkoutSetInLoggedWorkoutSectionInput instance) =>
    <String, dynamic>{
      'LoggedWorkoutMoves':
          instance.loggedWorkoutMoves.map((e) => e.toJson()).toList(),
      'sectionRoundNumber': instance.sectionRoundNumber,
      'sortPosition': instance.sortPosition,
      'timeTakenSeconds': instance.timeTakenSeconds,
    };

CreateLoggedWorkoutMoveInLoggedWorkoutSetInput
    _$CreateLoggedWorkoutMoveInLoggedWorkoutSetInputFromJson(
            Map<String, dynamic> json) =>
        CreateLoggedWorkoutMoveInLoggedWorkoutSetInput(
          equipment: json['Equipment'] == null
              ? null
              : ConnectRelationInput.fromJson(
                  json['Equipment'] as Map<String, dynamic>),
          move: ConnectRelationInput.fromJson(
              json['Move'] as Map<String, dynamic>),
          distanceUnit: $enumDecodeNullable(
              _$DistanceUnitEnumMap, json['distanceUnit'],
              unknownValue: DistanceUnit.artemisUnknown),
          loadAmount: (json['loadAmount'] as num?)?.toDouble(),
          loadUnit: $enumDecodeNullable(_$LoadUnitEnumMap, json['loadUnit'],
              unknownValue: LoadUnit.artemisUnknown),
          repType: $enumDecode(_$WorkoutMoveRepTypeEnumMap, json['repType'],
              unknownValue: WorkoutMoveRepType.artemisUnknown),
          reps: (json['reps'] as num).toDouble(),
          sortPosition: json['sortPosition'] as int,
          timeUnit: $enumDecodeNullable(_$TimeUnitEnumMap, json['timeUnit'],
              unknownValue: TimeUnit.artemisUnknown),
        );

Map<String, dynamic> _$CreateLoggedWorkoutMoveInLoggedWorkoutSetInputToJson(
        CreateLoggedWorkoutMoveInLoggedWorkoutSetInput instance) =>
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

DeleteLoggedWorkoutMove$Mutation _$DeleteLoggedWorkoutMove$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteLoggedWorkoutMove$Mutation()
      ..deleteLoggedWorkoutMove = json['deleteLoggedWorkoutMove'] as String;

Map<String, dynamic> _$DeleteLoggedWorkoutMove$MutationToJson(
        DeleteLoggedWorkoutMove$Mutation instance) =>
    <String, dynamic>{
      'deleteLoggedWorkoutMove': instance.deleteLoggedWorkoutMove,
    };

UpdateLoggedWorkoutMove _$UpdateLoggedWorkoutMoveFromJson(
        Map<String, dynamic> json) =>
    UpdateLoggedWorkoutMove()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..sortPosition = json['sortPosition'] as int
      ..repType = $enumDecode(_$WorkoutMoveRepTypeEnumMap, json['repType'],
          unknownValue: WorkoutMoveRepType.artemisUnknown)
      ..reps = (json['reps'] as num).toDouble()
      ..distanceUnit = $enumDecode(_$DistanceUnitEnumMap, json['distanceUnit'],
          unknownValue: DistanceUnit.artemisUnknown)
      ..loadAmount = (json['loadAmount'] as num).toDouble()
      ..loadUnit = $enumDecode(_$LoadUnitEnumMap, json['loadUnit'],
          unknownValue: LoadUnit.artemisUnknown)
      ..timeUnit = $enumDecode(_$TimeUnitEnumMap, json['timeUnit'],
          unknownValue: TimeUnit.artemisUnknown);

Map<String, dynamic> _$UpdateLoggedWorkoutMoveToJson(
        UpdateLoggedWorkoutMove instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'sortPosition': instance.sortPosition,
      'repType': _$WorkoutMoveRepTypeEnumMap[instance.repType],
      'reps': instance.reps,
      'distanceUnit': _$DistanceUnitEnumMap[instance.distanceUnit],
      'loadAmount': instance.loadAmount,
      'loadUnit': _$LoadUnitEnumMap[instance.loadUnit],
      'timeUnit': _$TimeUnitEnumMap[instance.timeUnit],
    };

UpdateLoggedWorkoutMove$Mutation _$UpdateLoggedWorkoutMove$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateLoggedWorkoutMove$Mutation()
      ..updateLoggedWorkoutMove = UpdateLoggedWorkoutMove.fromJson(
          json['updateLoggedWorkoutMove'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateLoggedWorkoutMove$MutationToJson(
        UpdateLoggedWorkoutMove$Mutation instance) =>
    <String, dynamic>{
      'updateLoggedWorkoutMove': instance.updateLoggedWorkoutMove.toJson(),
    };

UpdateLoggedWorkoutMoveInput _$UpdateLoggedWorkoutMoveInputFromJson(
        Map<String, dynamic> json) =>
    UpdateLoggedWorkoutMoveInput(
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
      reps: (json['reps'] as num).toDouble(),
      timeUnit: $enumDecodeNullable(_$TimeUnitEnumMap, json['timeUnit'],
          unknownValue: TimeUnit.artemisUnknown),
    );

Map<String, dynamic> _$UpdateLoggedWorkoutMoveInputToJson(
        UpdateLoggedWorkoutMoveInput instance) =>
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

UpdateLoggedWorkoutSection _$UpdateLoggedWorkoutSectionFromJson(
        Map<String, dynamic> json) =>
    UpdateLoggedWorkoutSection()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..name = json['name'] as String?
      ..repScore = json['repScore'] as int?
      ..timeTakenSeconds = json['timeTakenSeconds'] as int
      ..sortPosition = json['sortPosition'] as int;

Map<String, dynamic> _$UpdateLoggedWorkoutSectionToJson(
        UpdateLoggedWorkoutSection instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'name': instance.name,
      'repScore': instance.repScore,
      'timeTakenSeconds': instance.timeTakenSeconds,
      'sortPosition': instance.sortPosition,
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
      id: json['id'] as String,
      repScore: json['repScore'] as int?,
      timeTakenSeconds: json['timeTakenSeconds'] as int?,
    );

Map<String, dynamic> _$UpdateLoggedWorkoutSectionInputToJson(
        UpdateLoggedWorkoutSectionInput instance) =>
    <String, dynamic>{
      'id': instance.id,
      'repScore': instance.repScore,
      'timeTakenSeconds': instance.timeTakenSeconds,
    };

UpdateLoggedWorkoutSet _$UpdateLoggedWorkoutSetFromJson(
        Map<String, dynamic> json) =>
    UpdateLoggedWorkoutSet()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..sortPosition = json['sortPosition'] as int
      ..sectionRoundNumber = json['sectionRoundNumber'] as int
      ..timeTakenSeconds = json['timeTakenSeconds'] as int?;

Map<String, dynamic> _$UpdateLoggedWorkoutSetToJson(
        UpdateLoggedWorkoutSet instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'sortPosition': instance.sortPosition,
      'sectionRoundNumber': instance.sectionRoundNumber,
      'timeTakenSeconds': instance.timeTakenSeconds,
    };

UpdateLoggedWorkoutSet$Mutation _$UpdateLoggedWorkoutSet$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateLoggedWorkoutSet$Mutation()
      ..updateLoggedWorkoutSet = UpdateLoggedWorkoutSet.fromJson(
          json['updateLoggedWorkoutSet'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateLoggedWorkoutSet$MutationToJson(
        UpdateLoggedWorkoutSet$Mutation instance) =>
    <String, dynamic>{
      'updateLoggedWorkoutSet': instance.updateLoggedWorkoutSet.toJson(),
    };

UpdateLoggedWorkoutSetInput _$UpdateLoggedWorkoutSetInputFromJson(
        Map<String, dynamic> json) =>
    UpdateLoggedWorkoutSetInput(
      id: json['id'] as String,
      timeTakenSeconds: json['timeTakenSeconds'] as int?,
    );

Map<String, dynamic> _$UpdateLoggedWorkoutSetInputToJson(
        UpdateLoggedWorkoutSetInput instance) =>
    <String, dynamic>{
      'id': instance.id,
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
      ..user = UserAvatarData.fromJson(json['User'] as Map<String, dynamic>);

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

ClubWorkouts _$ClubWorkoutsFromJson(Map<String, dynamic> json) => ClubWorkouts()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..workouts = (json['workouts'] as List<dynamic>)
      .map((e) => WorkoutSummary.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$ClubWorkoutsToJson(ClubWorkouts instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'workouts': instance.workouts.map((e) => e.toJson()).toList(),
    };

RemoveWorkoutFromClub$Mutation _$RemoveWorkoutFromClub$MutationFromJson(
        Map<String, dynamic> json) =>
    RemoveWorkoutFromClub$Mutation()
      ..removeWorkoutFromClub = ClubWorkouts.fromJson(
          json['removeWorkoutFromClub'] as Map<String, dynamic>);

Map<String, dynamic> _$RemoveWorkoutFromClub$MutationToJson(
        RemoveWorkoutFromClub$Mutation instance) =>
    <String, dynamic>{
      'removeWorkoutFromClub': instance.removeWorkoutFromClub.toJson(),
    };

ClubWorkoutsMixin$WorkoutSummary _$ClubWorkoutsMixin$WorkoutSummaryFromJson(
        Map<String, dynamic> json) =>
    ClubWorkoutsMixin$WorkoutSummary()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..updatedAt = fromGraphQLDateTimeToDartDateTime(json['updatedAt'] as int)
      ..archived = json['archived'] as bool
      ..name = json['name'] as String
      ..user = UserAvatarData.fromJson(json['User'] as Map<String, dynamic>)
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
      ..sectionTypes = (json['sectionTypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList()
      ..goals =
          (json['goals'] as List<dynamic>).map((e) => e as String).toList()
      ..tags = (json['tags'] as List<dynamic>).map((e) => e as String).toList()
      ..bodyAreas =
          (json['bodyAreas'] as List<dynamic>).map((e) => e as String).toList();

Map<String, dynamic> _$ClubWorkoutsMixin$WorkoutSummaryToJson(
        ClubWorkoutsMixin$WorkoutSummary instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'updatedAt': fromDartDateTimeToGraphQLDateTime(instance.updatedAt),
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
      'sectionTypes': instance.sectionTypes,
      'goals': instance.goals,
      'tags': instance.tags,
      'bodyAreas': instance.bodyAreas,
    };

ClubWorkoutPlans _$ClubWorkoutPlansFromJson(Map<String, dynamic> json) =>
    ClubWorkoutPlans()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..workoutPlans = (json['workoutPlans'] as List<dynamic>)
          .map((e) => WorkoutPlanSummary.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ClubWorkoutPlansToJson(ClubWorkoutPlans instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'workoutPlans': instance.workoutPlans.map((e) => e.toJson()).toList(),
    };

RemoveWorkoutPlanFromClub$Mutation _$RemoveWorkoutPlanFromClub$MutationFromJson(
        Map<String, dynamic> json) =>
    RemoveWorkoutPlanFromClub$Mutation()
      ..removeWorkoutPlanFromClub = ClubWorkoutPlans.fromJson(
          json['removeWorkoutPlanFromClub'] as Map<String, dynamic>);

Map<String, dynamic> _$RemoveWorkoutPlanFromClub$MutationToJson(
        RemoveWorkoutPlanFromClub$Mutation instance) =>
    <String, dynamic>{
      'removeWorkoutPlanFromClub': instance.removeWorkoutPlanFromClub.toJson(),
    };

ClubWorkoutPlansMixin$WorkoutPlanSummary
    _$ClubWorkoutPlansMixin$WorkoutPlanSummaryFromJson(
            Map<String, dynamic> json) =>
        ClubWorkoutPlansMixin$WorkoutPlanSummary()
          ..$$typename = json['__typename'] as String?
          ..id = json['id'] as String
          ..createdAt =
              fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
          ..updatedAt =
              fromGraphQLDateTimeToDartDateTime(json['updatedAt'] as int)
          ..archived = json['archived'] as bool
          ..name = json['name'] as String
          ..description = json['description'] as String?
          ..coverImageUri = json['coverImageUri'] as String?
          ..lengthWeeks = json['lengthWeeks'] as int
          ..daysPerWeek = json['daysPerWeek'] as int
          ..workoutsCount = json['workoutsCount'] as int
          ..user = UserAvatarData.fromJson(json['User'] as Map<String, dynamic>)
          ..enrolmentsCount = json['enrolmentsCount'] as int
          ..goals = (json['goals'] as List<dynamic>)
              .map((e) => WorkoutGoal.fromJson(e as Map<String, dynamic>))
              .toList()
          ..tags =
              (json['tags'] as List<dynamic>).map((e) => e as String).toList()
          ..reviewScore = (json['reviewScore'] as num?)?.toDouble()
          ..reviewCount = json['reviewCount'] as int;

Map<String, dynamic> _$ClubWorkoutPlansMixin$WorkoutPlanSummaryToJson(
        ClubWorkoutPlansMixin$WorkoutPlanSummary instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'updatedAt': fromDartDateTimeToGraphQLDateTime(instance.updatedAt),
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

AddWorkoutToClub$Mutation _$AddWorkoutToClub$MutationFromJson(
        Map<String, dynamic> json) =>
    AddWorkoutToClub$Mutation()
      ..addWorkoutToClub = ClubWorkouts.fromJson(
          json['addWorkoutToClub'] as Map<String, dynamic>);

Map<String, dynamic> _$AddWorkoutToClub$MutationToJson(
        AddWorkoutToClub$Mutation instance) =>
    <String, dynamic>{
      'addWorkoutToClub': instance.addWorkoutToClub.toJson(),
    };

AddWorkoutPlanToClub$Mutation _$AddWorkoutPlanToClub$MutationFromJson(
        Map<String, dynamic> json) =>
    AddWorkoutPlanToClub$Mutation()
      ..addWorkoutPlanToClub = ClubWorkoutPlans.fromJson(
          json['addWorkoutPlanToClub'] as Map<String, dynamic>);

Map<String, dynamic> _$AddWorkoutPlanToClub$MutationToJson(
        AddWorkoutPlanToClub$Mutation instance) =>
    <String, dynamic>{
      'addWorkoutPlanToClub': instance.addWorkoutPlanToClub.toJson(),
    };

ClubWorkouts$Query _$ClubWorkouts$QueryFromJson(Map<String, dynamic> json) =>
    ClubWorkouts$Query()
      ..clubWorkouts =
          ClubWorkouts.fromJson(json['clubWorkouts'] as Map<String, dynamic>);

Map<String, dynamic> _$ClubWorkouts$QueryToJson(ClubWorkouts$Query instance) =>
    <String, dynamic>{
      'clubWorkouts': instance.clubWorkouts.toJson(),
    };

ClubWorkoutPlans$Query _$ClubWorkoutPlans$QueryFromJson(
        Map<String, dynamic> json) =>
    ClubWorkoutPlans$Query()
      ..clubWorkoutPlans = ClubWorkoutPlans.fromJson(
          json['clubWorkoutPlans'] as Map<String, dynamic>);

Map<String, dynamic> _$ClubWorkoutPlans$QueryToJson(
        ClubWorkoutPlans$Query instance) =>
    <String, dynamic>{
      'clubWorkoutPlans': instance.clubWorkoutPlans.toJson(),
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
      ..workoutPlanById = json['workoutPlanById'] == null
          ? null
          : WorkoutPlan.fromJson(
              json['workoutPlanById'] as Map<String, dynamic>);

Map<String, dynamic> _$WorkoutPlanById$QueryToJson(
        WorkoutPlanById$Query instance) =>
    <String, dynamic>{
      'workoutPlanById': instance.workoutPlanById?.toJson(),
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
      ..updatedAt = fromGraphQLDateTimeToDartDateTime(json['updatedAt'] as int)
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
      'updatedAt': fromDartDateTimeToGraphQLDateTime(instance.updatedAt),
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

UserAvatarById$Query _$UserAvatarById$QueryFromJson(
        Map<String, dynamic> json) =>
    UserAvatarById$Query()
      ..userAvatarById = json['userAvatarById'] == null
          ? null
          : UserAvatarData.fromJson(
              json['userAvatarById'] as Map<String, dynamic>);

Map<String, dynamic> _$UserAvatarById$QueryToJson(
        UserAvatarById$Query instance) =>
    <String, dynamic>{
      'userAvatarById': instance.userAvatarById?.toJson(),
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

const _$UserProfileScopeEnumMap = {
  UserProfileScope.private: 'PRIVATE',
  UserProfileScope.public: 'PUBLIC',
  UserProfileScope.artemisUnknown: 'ARTEMIS_UNKNOWN',
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

CustomMoves$Query _$CustomMoves$QueryFromJson(Map<String, dynamic> json) =>
    CustomMoves$Query()
      ..customMoves = (json['customMoves'] as List<dynamic>)
          .map((e) => Move.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$CustomMoves$QueryToJson(CustomMoves$Query instance) =>
    <String, dynamic>{
      'customMoves': instance.customMoves.map((e) => e.toJson()).toList(),
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
      ..lastname = json['lastname'] as String?
      ..workoutsPerWeekTarget = json['workoutsPerWeekTarget'] as int?
      ..activeProgressWidgets =
          (json['activeProgressWidgets'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList()
      ..activeLogDataWidgets = (json['activeLogDataWidgets'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList();

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
      'workoutsPerWeekTarget': instance.workoutsPerWeekTarget,
      'activeProgressWidgets': instance.activeProgressWidgets,
      'activeLogDataWidgets': instance.activeLogDataWidgets,
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
      activeLogDataWidgets: (json['activeLogDataWidgets'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      activeProgressWidgets: (json['activeProgressWidgets'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
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
      workoutsPerWeekTarget: json['workoutsPerWeekTarget'] as int?,
      youtubeHandle: json['youtubeHandle'] as String?,
    );

Map<String, dynamic> _$UpdateUserProfileInputToJson(
        UpdateUserProfileInput instance) =>
    <String, dynamic>{
      'activeLogDataWidgets': instance.activeLogDataWidgets,
      'activeProgressWidgets': instance.activeProgressWidgets,
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
      'workoutsPerWeekTarget': instance.workoutsPerWeekTarget,
      'youtubeHandle': instance.youtubeHandle,
    };

Skill _$SkillFromJson(Map<String, dynamic> json) => Skill()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
  ..updatedAt = fromGraphQLDateTimeToDartDateTime(json['updatedAt'] as int)
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
      'updatedAt': fromDartDateTimeToGraphQLDateTime(instance.updatedAt),
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
  ..workoutsPerWeekTarget = json['workoutsPerWeekTarget'] as int?
  ..activeProgressWidgets = (json['activeProgressWidgets'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList()
  ..activeLogDataWidgets = (json['activeLogDataWidgets'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList()
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
      'workoutsPerWeekTarget': instance.workoutsPerWeekTarget,
      'activeProgressWidgets': instance.activeProgressWidgets,
      'activeLogDataWidgets': instance.activeLogDataWidgets,
      'Clubs': instance.clubs.map((e) => e.toJson()).toList(),
      'LifetimeLogStatsSummary': instance.lifetimeLogStatsSummary?.toJson(),
      'Skills': instance.skills.map((e) => e.toJson()).toList(),
      'BenchmarksWithBestEntries':
          instance.benchmarksWithBestEntries.map((e) => e.toJson()).toList(),
    };

UserProfile$Query _$UserProfile$QueryFromJson(Map<String, dynamic> json) =>
    UserProfile$Query()
      ..userProfile = json['userProfile'] == null
          ? null
          : UserProfile.fromJson(json['userProfile'] as Map<String, dynamic>);

Map<String, dynamic> _$UserProfile$QueryToJson(UserProfile$Query instance) =>
    <String, dynamic>{
      'userProfile': instance.userProfile?.toJson(),
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

UserRecentlyViewedObject _$UserRecentlyViewedObjectFromJson(
        Map<String, dynamic> json) =>
    UserRecentlyViewedObject()
      ..$$typename = json['__typename'] as String?
      ..club = json['Club'] == null
          ? null
          : ClubSummary.fromJson(json['Club'] as Map<String, dynamic>)
      ..workout = json['Workout'] == null
          ? null
          : WorkoutSummary.fromJson(json['Workout'] as Map<String, dynamic>)
      ..workoutPlan = json['WorkoutPlan'] == null
          ? null
          : WorkoutPlanSummary.fromJson(
              json['WorkoutPlan'] as Map<String, dynamic>);

Map<String, dynamic> _$UserRecentlyViewedObjectToJson(
        UserRecentlyViewedObject instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'Club': instance.club?.toJson(),
      'Workout': instance.workout?.toJson(),
      'WorkoutPlan': instance.workoutPlan?.toJson(),
    };

UserRecentlyViewedObjects$Query _$UserRecentlyViewedObjects$QueryFromJson(
        Map<String, dynamic> json) =>
    UserRecentlyViewedObjects$Query()
      ..userRecentlyViewedObjects =
          (json['userRecentlyViewedObjects'] as List<dynamic>)
              .map((e) =>
                  UserRecentlyViewedObject.fromJson(e as Map<String, dynamic>))
              .toList();

Map<String, dynamic> _$UserRecentlyViewedObjects$QueryToJson(
        UserRecentlyViewedObjects$Query instance) =>
    <String, dynamic>{
      'userRecentlyViewedObjects':
          instance.userRecentlyViewedObjects.map((e) => e.toJson()).toList(),
    };

UpdateWorkoutSet _$UpdateWorkoutSetFromJson(Map<String, dynamic> json) =>
    UpdateWorkoutSet()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..sortPosition = json['sortPosition'] as int
      ..duration = json['duration'] as int;

Map<String, dynamic> _$UpdateWorkoutSetToJson(UpdateWorkoutSet instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'sortPosition': instance.sortPosition,
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
    );

Map<String, dynamic> _$UpdateWorkoutSetInputToJson(
        UpdateWorkoutSetInput instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'id': instance.id,
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
      sortPosition: json['sortPosition'] as int,
    );

Map<String, dynamic> _$CreateWorkoutSetInputToJson(
        CreateWorkoutSetInput instance) =>
    <String, dynamic>{
      'WorkoutSection': instance.workoutSection.toJson(),
      'duration': instance.duration,
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
      ..duration = json['duration'] as int;

Map<String, dynamic> _$CreateWorkoutSetToJson(CreateWorkoutSet instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'sortPosition': instance.sortPosition,
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

ProgressWidget _$ProgressWidgetFromJson(Map<String, dynamic> json) =>
    ProgressWidget()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..name = json['name'] as String
      ..subtitle = json['subtitle'] as String?
      ..description = json['description'] as String?;

Map<String, dynamic> _$ProgressWidgetToJson(ProgressWidget instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'name': instance.name,
      'subtitle': instance.subtitle,
      'description': instance.description,
    };

CoreData _$CoreDataFromJson(Map<String, dynamic> json) => CoreData()
  ..$$typename = json['__typename'] as String?
  ..bodyAreas = (json['bodyAreas'] as List<dynamic>)
      .map((e) => BodyArea.fromJson(e as Map<String, dynamic>))
      .toList()
  ..equipment = (json['equipment'] as List<dynamic>)
      .map((e) => Equipment.fromJson(e as Map<String, dynamic>))
      .toList()
  ..moveTypes = (json['moveTypes'] as List<dynamic>)
      .map((e) => MoveType.fromJson(e as Map<String, dynamic>))
      .toList()
  ..workoutGoals = (json['workoutGoals'] as List<dynamic>)
      .map((e) => WorkoutGoal.fromJson(e as Map<String, dynamic>))
      .toList()
  ..workoutSectionTypes = (json['workoutSectionTypes'] as List<dynamic>)
      .map((e) => WorkoutSectionType.fromJson(e as Map<String, dynamic>))
      .toList()
  ..standardMoves = (json['standardMoves'] as List<dynamic>)
      .map((e) => Move.fromJson(e as Map<String, dynamic>))
      .toList()
  ..progressWidgets = (json['progressWidgets'] as List<dynamic>)
      .map((e) => ProgressWidget.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$CoreDataToJson(CoreData instance) => <String, dynamic>{
      '__typename': instance.$$typename,
      'bodyAreas': instance.bodyAreas.map((e) => e.toJson()).toList(),
      'equipment': instance.equipment.map((e) => e.toJson()).toList(),
      'moveTypes': instance.moveTypes.map((e) => e.toJson()).toList(),
      'workoutGoals': instance.workoutGoals.map((e) => e.toJson()).toList(),
      'workoutSectionTypes':
          instance.workoutSectionTypes.map((e) => e.toJson()).toList(),
      'standardMoves': instance.standardMoves.map((e) => e.toJson()).toList(),
      'progressWidgets':
          instance.progressWidgets.map((e) => e.toJson()).toList(),
    };

CoreData$Query _$CoreData$QueryFromJson(Map<String, dynamic> json) =>
    CoreData$Query()
      ..coreData = CoreData.fromJson(json['coreData'] as Map<String, dynamic>);

Map<String, dynamic> _$CoreData$QueryToJson(CoreData$Query instance) =>
    <String, dynamic>{
      'coreData': instance.coreData.toJson(),
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

DeleteUserBenchmarkEntry$Mutation _$DeleteUserBenchmarkEntry$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteUserBenchmarkEntry$Mutation()
      ..deleteUserBenchmarkEntry = json['deleteUserBenchmarkEntry'] as String;

Map<String, dynamic> _$DeleteUserBenchmarkEntry$MutationToJson(
        DeleteUserBenchmarkEntry$Mutation instance) =>
    <String, dynamic>{
      'deleteUserBenchmarkEntry': instance.deleteUserBenchmarkEntry,
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

UserBenchmark$Query _$UserBenchmark$QueryFromJson(Map<String, dynamic> json) =>
    UserBenchmark$Query()
      ..userBenchmark =
          UserBenchmark.fromJson(json['userBenchmark'] as Map<String, dynamic>);

Map<String, dynamic> _$UserBenchmark$QueryToJson(
        UserBenchmark$Query instance) =>
    <String, dynamic>{
      'userBenchmark': instance.userBenchmark.toJson(),
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

DeleteUserBenchmark$Mutation _$DeleteUserBenchmark$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteUserBenchmark$Mutation()
      ..deleteUserBenchmark = json['deleteUserBenchmark'] as String;

Map<String, dynamic> _$DeleteUserBenchmark$MutationToJson(
        DeleteUserBenchmark$Mutation instance) =>
    <String, dynamic>{
      'deleteUserBenchmark': instance.deleteUserBenchmark,
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

MarkAnnouncementUpdateAsSeen$Mutation
    _$MarkAnnouncementUpdateAsSeen$MutationFromJson(
            Map<String, dynamic> json) =>
        MarkAnnouncementUpdateAsSeen$Mutation()
          ..markAnnouncementUpdateAsSeen =
              json['markAnnouncementUpdateAsSeen'] as String;

Map<String, dynamic> _$MarkAnnouncementUpdateAsSeen$MutationToJson(
        MarkAnnouncementUpdateAsSeen$Mutation instance) =>
    <String, dynamic>{
      'markAnnouncementUpdateAsSeen': instance.markAnnouncementUpdateAsSeen,
    };

MarkAnnouncementUpdateAsSeenInput _$MarkAnnouncementUpdateAsSeenInputFromJson(
        Map<String, dynamic> json) =>
    MarkAnnouncementUpdateAsSeenInput(
      announcementUpdateId: json['announcementUpdateId'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$MarkAnnouncementUpdateAsSeenInputToJson(
        MarkAnnouncementUpdateAsSeenInput instance) =>
    <String, dynamic>{
      'announcementUpdateId': instance.announcementUpdateId,
      'userId': instance.userId,
    };

AnnouncementUpdateAction _$AnnouncementUpdateActionFromJson(
        Map<String, dynamic> json) =>
    AnnouncementUpdateAction()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..text = json['text'] as String
      ..routeTo = json['routeTo'] as String;

Map<String, dynamic> _$AnnouncementUpdateActionToJson(
        AnnouncementUpdateAction instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'text': instance.text,
      'routeTo': instance.routeTo,
    };

AnnouncementUpdate _$AnnouncementUpdateFromJson(Map<String, dynamic> json) =>
    AnnouncementUpdate()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..imageUri = json['imageUri'] as String?
      ..videoUri = json['videoUri'] as String?
      ..audioUri = json['audioUri'] as String?
      ..articleUrl = json['articleUrl'] as String?
      ..title = json['title'] as String
      ..subtitle = json['subtitle'] as String?
      ..bodyOne = json['bodyOne'] as String?
      ..bodyTwo = json['bodyTwo'] as String?
      ..actions = (json['actions'] as List<dynamic>)
          .map((e) =>
              AnnouncementUpdateAction.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$AnnouncementUpdateToJson(AnnouncementUpdate instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'imageUri': instance.imageUri,
      'videoUri': instance.videoUri,
      'audioUri': instance.audioUri,
      'articleUrl': instance.articleUrl,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'bodyOne': instance.bodyOne,
      'bodyTwo': instance.bodyTwo,
      'actions': instance.actions.map((e) => e.toJson()).toList(),
    };

AnnouncementUpdates$Query _$AnnouncementUpdates$QueryFromJson(
        Map<String, dynamic> json) =>
    AnnouncementUpdates$Query()
      ..announcementUpdates = (json['announcementUpdates'] as List<dynamic>)
          .map((e) => AnnouncementUpdate.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$AnnouncementUpdates$QueryToJson(
        AnnouncementUpdates$Query instance) =>
    <String, dynamic>{
      'announcementUpdates':
          instance.announcementUpdates.map((e) => e.toJson()).toList(),
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

StreamActivityReactionCounts _$StreamActivityReactionCountsFromJson(
        Map<String, dynamic> json) =>
    StreamActivityReactionCounts()
      ..likes = json['likes'] as int?
      ..comments = json['comments'] as int?;

Map<String, dynamic> _$StreamActivityReactionCountsToJson(
        StreamActivityReactionCounts instance) =>
    <String, dynamic>{
      'likes': instance.likes,
      'comments': instance.comments,
    };

StreamFeedUserData _$StreamFeedUserDataFromJson(Map<String, dynamic> json) =>
    StreamFeedUserData()
      ..name = json['name'] as String?
      ..image = json['image'] as String?;

Map<String, dynamic> _$StreamFeedUserDataToJson(StreamFeedUserData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
    };

StreamFeedUser _$StreamFeedUserFromJson(Map<String, dynamic> json) =>
    StreamFeedUser()
      ..id = json['id'] as String
      ..data =
          StreamFeedUserData.fromJson(json['data'] as Map<String, dynamic>);

Map<String, dynamic> _$StreamFeedUserToJson(StreamFeedUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data': instance.data.toJson(),
    };

StreamFeedClubData _$StreamFeedClubDataFromJson(Map<String, dynamic> json) =>
    StreamFeedClubData()
      ..name = json['name'] as String?
      ..image = json['image'] as String?;

Map<String, dynamic> _$StreamFeedClubDataToJson(StreamFeedClubData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
    };

StreamFeedClub _$StreamFeedClubFromJson(Map<String, dynamic> json) =>
    StreamFeedClub()
      ..id = json['id'] as String
      ..data =
          StreamFeedClubData.fromJson(json['data'] as Map<String, dynamic>);

Map<String, dynamic> _$StreamFeedClubToJson(StreamFeedClub instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data': instance.data.toJson(),
    };

StreamActivityExtraData _$StreamActivityExtraDataFromJson(
        Map<String, dynamic> json) =>
    StreamActivityExtraData()
      ..title = json['title'] as String?
      ..caption = json['caption'] as String?
      ..tags = (json['tags'] as List<dynamic>).map((e) => e as String).toList()
      ..articleUrl = json['articleUrl'] as String?
      ..audioUrl = json['audioUrl'] as String?
      ..imageUrl = json['imageUrl'] as String?
      ..videoUrl = json['videoUrl'] as String?
      ..originalPostId = json['originalPostId'] as String?
      ..creator = json['creator'] == null
          ? null
          : StreamFeedUser.fromJson(json['creator'] as Map<String, dynamic>)
      ..club = json['club'] == null
          ? null
          : StreamFeedClub.fromJson(json['club'] as Map<String, dynamic>);

Map<String, dynamic> _$StreamActivityExtraDataToJson(
        StreamActivityExtraData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'caption': instance.caption,
      'tags': instance.tags,
      'articleUrl': instance.articleUrl,
      'audioUrl': instance.audioUrl,
      'imageUrl': instance.imageUrl,
      'videoUrl': instance.videoUrl,
      'originalPostId': instance.originalPostId,
      'creator': instance.creator?.toJson(),
      'club': instance.club?.toJson(),
    };

StreamEnrichedActivity _$StreamEnrichedActivityFromJson(
        Map<String, dynamic> json) =>
    StreamEnrichedActivity()
      ..id = json['id'] as String
      ..verb = json['verb'] as String
      ..object = json['object'] as String
      ..time = fromGraphQLDateTimeToDartDateTime(json['time'] as int)
      ..userLikeReactionId = json['userLikeReactionId'] as String?
      ..reactionCounts = json['reactionCounts'] == null
          ? null
          : StreamActivityReactionCounts.fromJson(
              json['reactionCounts'] as Map<String, dynamic>)
      ..actor = StreamFeedUser.fromJson(json['actor'] as Map<String, dynamic>)
      ..extraData = StreamActivityExtraData.fromJson(
          json['extraData'] as Map<String, dynamic>);

Map<String, dynamic> _$StreamEnrichedActivityToJson(
        StreamEnrichedActivity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'verb': instance.verb,
      'object': instance.object,
      'time': fromDartDateTimeToGraphQLDateTime(instance.time),
      'userLikeReactionId': instance.userLikeReactionId,
      'reactionCounts': instance.reactionCounts?.toJson(),
      'actor': instance.actor.toJson(),
      'extraData': instance.extraData.toJson(),
    };

CreateClubMembersFeedPost$Mutation _$CreateClubMembersFeedPost$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateClubMembersFeedPost$Mutation()
      ..createClubMembersFeedPost = StreamEnrichedActivity.fromJson(
          json['createClubMembersFeedPost'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateClubMembersFeedPost$MutationToJson(
        CreateClubMembersFeedPost$Mutation instance) =>
    <String, dynamic>{
      'createClubMembersFeedPost': instance.createClubMembersFeedPost.toJson(),
    };

CreateStreamFeedActivityInput _$CreateStreamFeedActivityInputFromJson(
        Map<String, dynamic> json) =>
    CreateStreamFeedActivityInput(
      actor: json['actor'] as String,
      extraData: CreateStreamFeedActivityExtraDataInput.fromJson(
          json['extraData'] as Map<String, dynamic>),
      object: json['object'] as String,
      verb: json['verb'] as String,
    );

Map<String, dynamic> _$CreateStreamFeedActivityInputToJson(
        CreateStreamFeedActivityInput instance) =>
    <String, dynamic>{
      'actor': instance.actor,
      'extraData': instance.extraData.toJson(),
      'object': instance.object,
      'verb': instance.verb,
    };

CreateStreamFeedActivityExtraDataInput
    _$CreateStreamFeedActivityExtraDataInputFromJson(
            Map<String, dynamic> json) =>
        CreateStreamFeedActivityExtraDataInput(
          articleUrl: json['articleUrl'] as String?,
          audioUrl: json['audioUrl'] as String?,
          caption: json['caption'] as String?,
          creator: json['creator'] as String?,
          imageUrl: json['imageUrl'] as String?,
          originalPostId: json['originalPostId'] as String?,
          tags:
              (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
          title: json['title'] as String?,
          videoUrl: json['videoUrl'] as String?,
        );

Map<String, dynamic> _$CreateStreamFeedActivityExtraDataInputToJson(
        CreateStreamFeedActivityExtraDataInput instance) =>
    <String, dynamic>{
      'articleUrl': instance.articleUrl,
      'audioUrl': instance.audioUrl,
      'caption': instance.caption,
      'creator': instance.creator,
      'imageUrl': instance.imageUrl,
      'originalPostId': instance.originalPostId,
      'tags': instance.tags,
      'title': instance.title,
      'videoUrl': instance.videoUrl,
    };

ClubMembersFeedPosts$Query _$ClubMembersFeedPosts$QueryFromJson(
        Map<String, dynamic> json) =>
    ClubMembersFeedPosts$Query()
      ..clubMembersFeedPosts = (json['clubMembersFeedPosts'] as List<dynamic>)
          .map(
              (e) => StreamEnrichedActivity.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ClubMembersFeedPosts$QueryToJson(
        ClubMembersFeedPosts$Query instance) =>
    <String, dynamic>{
      'clubMembersFeedPosts':
          instance.clubMembersFeedPosts.map((e) => e.toJson()).toList(),
    };

DeleteClubMembersFeedPost$Mutation _$DeleteClubMembersFeedPost$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteClubMembersFeedPost$Mutation()
      ..deleteClubMembersFeedPost = json['deleteClubMembersFeedPost'] as String;

Map<String, dynamic> _$DeleteClubMembersFeedPost$MutationToJson(
        DeleteClubMembersFeedPost$Mutation instance) =>
    <String, dynamic>{
      'deleteClubMembersFeedPost': instance.deleteClubMembersFeedPost,
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
      ..updatedAt = fromGraphQLDateTimeToDartDateTime(json['updatedAt'] as int)
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
      'updatedAt': fromDartDateTimeToGraphQLDateTime(instance.updatedAt),
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
      name: json['name'] as String,
    );

Map<String, dynamic> _$CreateWorkoutInputToJson(CreateWorkoutInput instance) =>
    <String, dynamic>{
      'contentAccessScope':
          _$ContentAccessScopeEnumMap[instance.contentAccessScope],
      'name': instance.name,
    };

WorkoutById$Query _$WorkoutById$QueryFromJson(Map<String, dynamic> json) =>
    WorkoutById$Query()
      ..workoutById = json['workoutById'] == null
          ? null
          : Workout.fromJson(json['workoutById'] as Map<String, dynamic>);

Map<String, dynamic> _$WorkoutById$QueryToJson(WorkoutById$Query instance) =>
    <String, dynamic>{
      'workoutById': instance.workoutById?.toJson(),
    };

ClubMemberNote _$ClubMemberNoteFromJson(Map<String, dynamic> json) =>
    ClubMemberNote()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..updatedAt = fromGraphQLDateTimeToDartDateTime(json['updatedAt'] as int)
      ..note = json['note'] as String
      ..tags = (json['tags'] as List<dynamic>).map((e) => e as String).toList()
      ..user = json['User'] == null
          ? null
          : UserAvatarData.fromJson(json['User'] as Map<String, dynamic>);

Map<String, dynamic> _$ClubMemberNoteToJson(ClubMemberNote instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'updatedAt': fromDartDateTimeToGraphQLDateTime(instance.updatedAt),
      'note': instance.note,
      'tags': instance.tags,
      'User': instance.user?.toJson(),
    };

UpdateClubMemberNote$Mutation _$UpdateClubMemberNote$MutationFromJson(
        Map<String, dynamic> json) =>
    UpdateClubMemberNote$Mutation()
      ..updateClubMemberNote = ClubMemberNote.fromJson(
          json['updateClubMemberNote'] as Map<String, dynamic>);

Map<String, dynamic> _$UpdateClubMemberNote$MutationToJson(
        UpdateClubMemberNote$Mutation instance) =>
    <String, dynamic>{
      'updateClubMemberNote': instance.updateClubMemberNote.toJson(),
    };

UpdateClubMemberNoteInput _$UpdateClubMemberNoteInputFromJson(
        Map<String, dynamic> json) =>
    UpdateClubMemberNoteInput(
      id: json['id'] as String,
      note: json['note'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UpdateClubMemberNoteInputToJson(
        UpdateClubMemberNoteInput instance) =>
    <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
      'tags': instance.tags,
    };

CreateClubMemberNote$Mutation _$CreateClubMemberNote$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateClubMemberNote$Mutation()
      ..createClubMemberNote = ClubMemberNote.fromJson(
          json['createClubMemberNote'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateClubMemberNote$MutationToJson(
        CreateClubMemberNote$Mutation instance) =>
    <String, dynamic>{
      'createClubMemberNote': instance.createClubMemberNote.toJson(),
    };

CreateClubMemberNoteInput _$CreateClubMemberNoteInputFromJson(
        Map<String, dynamic> json) =>
    CreateClubMemberNoteInput(
      clubId: json['clubId'] as String,
      memberId: json['memberId'] as String,
      note: json['note'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$CreateClubMemberNoteInputToJson(
        CreateClubMemberNoteInput instance) =>
    <String, dynamic>{
      'clubId': instance.clubId,
      'memberId': instance.memberId,
      'note': instance.note,
      'tags': instance.tags,
    };

ClubMemberNotes$Query _$ClubMemberNotes$QueryFromJson(
        Map<String, dynamic> json) =>
    ClubMemberNotes$Query()
      ..clubMemberNotes = (json['clubMemberNotes'] as List<dynamic>)
          .map((e) => ClubMemberNote.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ClubMemberNotes$QueryToJson(
        ClubMemberNotes$Query instance) =>
    <String, dynamic>{
      'clubMemberNotes':
          instance.clubMemberNotes.map((e) => e.toJson()).toList(),
    };

UserMaxUnbrokenTrackerManualEntry _$UserMaxUnbrokenTrackerManualEntryFromJson(
        Map<String, dynamic> json) =>
    UserMaxUnbrokenTrackerManualEntry()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..completedOn =
          fromGraphQLDateTimeToDartDateTime(json['completedOn'] as int)
      ..score = json['score'] as int
      ..videoUri = json['videoUri'] as String?
      ..videoThumbUri = json['videoThumbUri'] as String?;

Map<String, dynamic> _$UserMaxUnbrokenTrackerManualEntryToJson(
        UserMaxUnbrokenTrackerManualEntry instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'completedOn': fromDartDateTimeToGraphQLDateTime(instance.completedOn),
      'score': instance.score,
      'videoUri': instance.videoUri,
      'videoThumbUri': instance.videoThumbUri,
    };

UserMaxUnbrokenExerciseTracker _$UserMaxUnbrokenExerciseTrackerFromJson(
        Map<String, dynamic> json) =>
    UserMaxUnbrokenExerciseTracker()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..repType = $enumDecode(_$WorkoutMoveRepTypeEnumMap, json['repType'],
          unknownValue: WorkoutMoveRepType.artemisUnknown)
      ..distanceUnit = $enumDecode(_$DistanceUnitEnumMap, json['distanceUnit'],
          unknownValue: DistanceUnit.artemisUnknown)
      ..loadAmount = (json['loadAmount'] as num).toDouble()
      ..loadUnit = $enumDecode(_$LoadUnitEnumMap, json['loadUnit'],
          unknownValue: LoadUnit.artemisUnknown)
      ..move = Move.fromJson(json['Move'] as Map<String, dynamic>)
      ..equipment = json['Equipment'] == null
          ? null
          : Equipment.fromJson(json['Equipment'] as Map<String, dynamic>)
      ..manualEntries = (json['ManualEntries'] as List<dynamic>)
          .map((e) => UserMaxUnbrokenTrackerManualEntry.fromJson(
              e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserMaxUnbrokenExerciseTrackerToJson(
        UserMaxUnbrokenExerciseTracker instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'repType': _$WorkoutMoveRepTypeEnumMap[instance.repType],
      'distanceUnit': _$DistanceUnitEnumMap[instance.distanceUnit],
      'loadAmount': instance.loadAmount,
      'loadUnit': _$LoadUnitEnumMap[instance.loadUnit],
      'Move': instance.move.toJson(),
      'Equipment': instance.equipment?.toJson(),
      'ManualEntries': instance.manualEntries.map((e) => e.toJson()).toList(),
    };

UserMaxUnbrokenExerciseTrackers$Query
    _$UserMaxUnbrokenExerciseTrackers$QueryFromJson(
            Map<String, dynamic> json) =>
        UserMaxUnbrokenExerciseTrackers$Query()
          ..userMaxUnbrokenExerciseTrackers =
              (json['userMaxUnbrokenExerciseTrackers'] as List<dynamic>)
                  .map((e) => UserMaxUnbrokenExerciseTracker.fromJson(
                      e as Map<String, dynamic>))
                  .toList();

Map<String, dynamic> _$UserMaxUnbrokenExerciseTrackers$QueryToJson(
        UserMaxUnbrokenExerciseTrackers$Query instance) =>
    <String, dynamic>{
      'userMaxUnbrokenExerciseTrackers': instance
          .userMaxUnbrokenExerciseTrackers
          .map((e) => e.toJson())
          .toList(),
    };

UserMaxLoadTrackerManualEntry _$UserMaxLoadTrackerManualEntryFromJson(
        Map<String, dynamic> json) =>
    UserMaxLoadTrackerManualEntry()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..completedOn =
          fromGraphQLDateTimeToDartDateTime(json['completedOn'] as int)
      ..loadAmount = (json['loadAmount'] as num).toDouble()
      ..videoUri = json['videoUri'] as String?
      ..videoThumbUri = json['videoThumbUri'] as String?;

Map<String, dynamic> _$UserMaxLoadTrackerManualEntryToJson(
        UserMaxLoadTrackerManualEntry instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'completedOn': fromDartDateTimeToGraphQLDateTime(instance.completedOn),
      'loadAmount': instance.loadAmount,
      'videoUri': instance.videoUri,
      'videoThumbUri': instance.videoThumbUri,
    };

UserMaxLoadExerciseTracker _$UserMaxLoadExerciseTrackerFromJson(
        Map<String, dynamic> json) =>
    UserMaxLoadExerciseTracker()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..reps = json['reps'] as int
      ..loadUnit = $enumDecode(_$LoadUnitEnumMap, json['loadUnit'],
          unknownValue: LoadUnit.artemisUnknown)
      ..move = Move.fromJson(json['Move'] as Map<String, dynamic>)
      ..equipment = json['Equipment'] == null
          ? null
          : Equipment.fromJson(json['Equipment'] as Map<String, dynamic>)
      ..manualEntries = (json['ManualEntries'] as List<dynamic>)
          .map((e) =>
              UserMaxLoadTrackerManualEntry.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserMaxLoadExerciseTrackerToJson(
        UserMaxLoadExerciseTracker instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'reps': instance.reps,
      'loadUnit': _$LoadUnitEnumMap[instance.loadUnit],
      'Move': instance.move.toJson(),
      'Equipment': instance.equipment?.toJson(),
      'ManualEntries': instance.manualEntries.map((e) => e.toJson()).toList(),
    };

UserMaxLoadExerciseTrackers$Query _$UserMaxLoadExerciseTrackers$QueryFromJson(
        Map<String, dynamic> json) =>
    UserMaxLoadExerciseTrackers$Query()
      ..userMaxLoadExerciseTrackers = (json['userMaxLoadExerciseTrackers']
              as List<dynamic>)
          .map((e) =>
              UserMaxLoadExerciseTracker.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserMaxLoadExerciseTrackers$QueryToJson(
        UserMaxLoadExerciseTrackers$Query instance) =>
    <String, dynamic>{
      'userMaxLoadExerciseTrackers':
          instance.userMaxLoadExerciseTrackers.map((e) => e.toJson()).toList(),
    };

UserFastestTimeTrackerManualEntry _$UserFastestTimeTrackerManualEntryFromJson(
        Map<String, dynamic> json) =>
    UserFastestTimeTrackerManualEntry()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..completedOn =
          fromGraphQLDateTimeToDartDateTime(json['completedOn'] as int)
      ..timeTakenMs = json['timeTakenMs'] as int
      ..videoUri = json['videoUri'] as String?
      ..videoThumbUri = json['videoThumbUri'] as String?;

Map<String, dynamic> _$UserFastestTimeTrackerManualEntryToJson(
        UserFastestTimeTrackerManualEntry instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'completedOn': fromDartDateTimeToGraphQLDateTime(instance.completedOn),
      'timeTakenMs': instance.timeTakenMs,
      'videoUri': instance.videoUri,
      'videoThumbUri': instance.videoThumbUri,
    };

UserFastestTimeExerciseTracker _$UserFastestTimeExerciseTrackerFromJson(
        Map<String, dynamic> json) =>
    UserFastestTimeExerciseTracker()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..createdAt = fromGraphQLDateTimeToDartDateTime(json['createdAt'] as int)
      ..repType = $enumDecode(_$WorkoutMoveRepTypeEnumMap, json['repType'],
          unknownValue: WorkoutMoveRepType.artemisUnknown)
      ..reps = (json['reps'] as num).toDouble()
      ..distanceUnit = $enumDecode(_$DistanceUnitEnumMap, json['distanceUnit'],
          unknownValue: DistanceUnit.artemisUnknown)
      ..loadAmount = (json['loadAmount'] as num).toDouble()
      ..loadUnit = $enumDecode(_$LoadUnitEnumMap, json['loadUnit'],
          unknownValue: LoadUnit.artemisUnknown)
      ..move = Move.fromJson(json['Move'] as Map<String, dynamic>)
      ..equipment = json['Equipment'] == null
          ? null
          : Equipment.fromJson(json['Equipment'] as Map<String, dynamic>)
      ..manualEntries = (json['ManualEntries'] as List<dynamic>)
          .map((e) => UserFastestTimeTrackerManualEntry.fromJson(
              e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$UserFastestTimeExerciseTrackerToJson(
        UserFastestTimeExerciseTracker instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'createdAt': fromDartDateTimeToGraphQLDateTime(instance.createdAt),
      'repType': _$WorkoutMoveRepTypeEnumMap[instance.repType],
      'reps': instance.reps,
      'distanceUnit': _$DistanceUnitEnumMap[instance.distanceUnit],
      'loadAmount': instance.loadAmount,
      'loadUnit': _$LoadUnitEnumMap[instance.loadUnit],
      'Move': instance.move.toJson(),
      'Equipment': instance.equipment?.toJson(),
      'ManualEntries': instance.manualEntries.map((e) => e.toJson()).toList(),
    };

UserFastestTimeExerciseTrackers$Query
    _$UserFastestTimeExerciseTrackers$QueryFromJson(
            Map<String, dynamic> json) =>
        UserFastestTimeExerciseTrackers$Query()
          ..userFastestTimeExerciseTrackers =
              (json['userFastestTimeExerciseTrackers'] as List<dynamic>)
                  .map((e) => UserFastestTimeExerciseTracker.fromJson(
                      e as Map<String, dynamic>))
                  .toList();

Map<String, dynamic> _$UserFastestTimeExerciseTrackers$QueryToJson(
        UserFastestTimeExerciseTrackers$Query instance) =>
    <String, dynamic>{
      'userFastestTimeExerciseTrackers': instance
          .userFastestTimeExerciseTrackers
          .map((e) => e.toJson())
          .toList(),
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

ClubMemberSummary _$ClubMemberSummaryFromJson(Map<String, dynamic> json) =>
    ClubMemberSummary()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..displayName = json['displayName'] as String
      ..avatarUri = json['avatarUri'] as String?
      ..townCity = json['townCity'] as String?
      ..countryCode = json['countryCode'] as String?
      ..tagline = json['tagline'] as String?
      ..skills =
          (json['skills'] as List<dynamic>).map((e) => e as String).toList();

Map<String, dynamic> _$ClubMemberSummaryToJson(ClubMemberSummary instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'displayName': instance.displayName,
      'avatarUri': instance.avatarUri,
      'townCity': instance.townCity,
      'countryCode': instance.countryCode,
      'tagline': instance.tagline,
      'skills': instance.skills,
    };

ClubMembers _$ClubMembersFromJson(Map<String, dynamic> json) => ClubMembers()
  ..$$typename = json['__typename'] as String?
  ..id = json['id'] as String
  ..owner = ClubMemberSummary.fromJson(json['Owner'] as Map<String, dynamic>)
  ..admins = (json['Admins'] as List<dynamic>)
      .map((e) => ClubMemberSummary.fromJson(e as Map<String, dynamic>))
      .toList()
  ..members = (json['Members'] as List<dynamic>)
      .map((e) => ClubMemberSummary.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$ClubMembersToJson(ClubMembers instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'Owner': instance.owner.toJson(),
      'Admins': instance.admins.map((e) => e.toJson()).toList(),
      'Members': instance.members.map((e) => e.toJson()).toList(),
    };

RemoveMemberAdminStatus$Mutation _$RemoveMemberAdminStatus$MutationFromJson(
        Map<String, dynamic> json) =>
    RemoveMemberAdminStatus$Mutation()
      ..removeMemberAdminStatus = ClubMembers.fromJson(
          json['removeMemberAdminStatus'] as Map<String, dynamic>);

Map<String, dynamic> _$RemoveMemberAdminStatus$MutationToJson(
        RemoveMemberAdminStatus$Mutation instance) =>
    <String, dynamic>{
      'removeMemberAdminStatus': instance.removeMemberAdminStatus.toJson(),
    };

AddUserToClubViaInviteToken$Mutation
    _$AddUserToClubViaInviteToken$MutationFromJson(Map<String, dynamic> json) =>
        AddUserToClubViaInviteToken$Mutation()
          ..addUserToClubViaInviteToken =
              json['addUserToClubViaInviteToken'] as String;

Map<String, dynamic> _$AddUserToClubViaInviteToken$MutationToJson(
        AddUserToClubViaInviteToken$Mutation instance) =>
    <String, dynamic>{
      'addUserToClubViaInviteToken': instance.addUserToClubViaInviteToken,
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

ClubInviteTokens _$ClubInviteTokensFromJson(Map<String, dynamic> json) =>
    ClubInviteTokens()
      ..$$typename = json['__typename'] as String?
      ..id = json['id'] as String
      ..tokens = (json['tokens'] as List<dynamic>)
          .map((e) => ClubInviteToken.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ClubInviteTokensToJson(ClubInviteTokens instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'tokens': instance.tokens.map((e) => e.toJson()).toList(),
    };

ClubInviteTokens$Query _$ClubInviteTokens$QueryFromJson(
        Map<String, dynamic> json) =>
    ClubInviteTokens$Query()
      ..clubInviteTokens = ClubInviteTokens.fromJson(
          json['clubInviteTokens'] as Map<String, dynamic>);

Map<String, dynamic> _$ClubInviteTokens$QueryToJson(
        ClubInviteTokens$Query instance) =>
    <String, dynamic>{
      'clubInviteTokens': instance.clubInviteTokens.toJson(),
    };

RemoveUserFromClub$Mutation _$RemoveUserFromClub$MutationFromJson(
        Map<String, dynamic> json) =>
    RemoveUserFromClub$Mutation()
      ..removeUserFromClub = ClubMembers.fromJson(
          json['removeUserFromClub'] as Map<String, dynamic>);

Map<String, dynamic> _$RemoveUserFromClub$MutationToJson(
        RemoveUserFromClub$Mutation instance) =>
    <String, dynamic>{
      'removeUserFromClub': instance.removeUserFromClub.toJson(),
    };

CheckUserClubMemberStatus$Query _$CheckUserClubMemberStatus$QueryFromJson(
        Map<String, dynamic> json) =>
    CheckUserClubMemberStatus$Query()
      ..checkUserClubMemberStatus = $enumDecode(
          _$UserClubMemberStatusEnumMap, json['checkUserClubMemberStatus'],
          unknownValue: UserClubMemberStatus.artemisUnknown);

Map<String, dynamic> _$CheckUserClubMemberStatus$QueryToJson(
        CheckUserClubMemberStatus$Query instance) =>
    <String, dynamic>{
      'checkUserClubMemberStatus':
          _$UserClubMemberStatusEnumMap[instance.checkUserClubMemberStatus],
    };

const _$UserClubMemberStatusEnumMap = {
  UserClubMemberStatus.admin: 'ADMIN',
  UserClubMemberStatus.member: 'MEMBER',
  UserClubMemberStatus.none: 'NONE',
  UserClubMemberStatus.owner: 'OWNER',
  UserClubMemberStatus.artemisUnknown: 'ARTEMIS_UNKNOWN',
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
      ..updateClubInviteToken = ClubInviteTokens.fromJson(
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
      clubId: json['clubId'] as String,
      id: json['id'] as String,
      inviteLimit: json['inviteLimit'] as int?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$UpdateClubInviteTokenInputToJson(
        UpdateClubInviteTokenInput instance) =>
    <String, dynamic>{
      'active': instance.active,
      'clubId': instance.clubId,
      'id': instance.id,
      'inviteLimit': instance.inviteLimit,
      'name': instance.name,
    };

DeleteClubInviteToken$Mutation _$DeleteClubInviteToken$MutationFromJson(
        Map<String, dynamic> json) =>
    DeleteClubInviteToken$Mutation()
      ..deleteClubInviteToken = ClubInviteTokens.fromJson(
          json['deleteClubInviteToken'] as Map<String, dynamic>);

Map<String, dynamic> _$DeleteClubInviteToken$MutationToJson(
        DeleteClubInviteToken$Mutation instance) =>
    <String, dynamic>{
      'deleteClubInviteToken': instance.deleteClubInviteToken.toJson(),
    };

DeleteClubInviteTokenInput _$DeleteClubInviteTokenInputFromJson(
        Map<String, dynamic> json) =>
    DeleteClubInviteTokenInput(
      clubId: json['clubId'] as String,
      tokenId: json['tokenId'] as String,
    );

Map<String, dynamic> _$DeleteClubInviteTokenInputToJson(
        DeleteClubInviteTokenInput instance) =>
    <String, dynamic>{
      'clubId': instance.clubId,
      'tokenId': instance.tokenId,
    };

GiveMemberAdminStatus$Mutation _$GiveMemberAdminStatus$MutationFromJson(
        Map<String, dynamic> json) =>
    GiveMemberAdminStatus$Mutation()
      ..giveMemberAdminStatus = ClubMembers.fromJson(
          json['giveMemberAdminStatus'] as Map<String, dynamic>);

Map<String, dynamic> _$GiveMemberAdminStatus$MutationToJson(
        GiveMemberAdminStatus$Mutation instance) =>
    <String, dynamic>{
      'giveMemberAdminStatus': instance.giveMemberAdminStatus.toJson(),
    };

CreateClubInviteToken$Mutation _$CreateClubInviteToken$MutationFromJson(
        Map<String, dynamic> json) =>
    CreateClubInviteToken$Mutation()
      ..createClubInviteToken = ClubInviteTokens.fromJson(
          json['createClubInviteToken'] as Map<String, dynamic>);

Map<String, dynamic> _$CreateClubInviteToken$MutationToJson(
        CreateClubInviteToken$Mutation instance) =>
    <String, dynamic>{
      'createClubInviteToken': instance.createClubInviteToken.toJson(),
    };

CreateClubInviteTokenInput _$CreateClubInviteTokenInputFromJson(
        Map<String, dynamic> json) =>
    CreateClubInviteTokenInput(
      clubId: json['clubId'] as String,
      inviteLimit: json['inviteLimit'] as int,
      name: json['name'] as String,
    );

Map<String, dynamic> _$CreateClubInviteTokenInputToJson(
        CreateClubInviteTokenInput instance) =>
    <String, dynamic>{
      'clubId': instance.clubId,
      'inviteLimit': instance.inviteLimit,
      'name': instance.name,
    };

DeleteUserMaxUnbrokenTrackerManualEntry$Mutation
    _$DeleteUserMaxUnbrokenTrackerManualEntry$MutationFromJson(
            Map<String, dynamic> json) =>
        DeleteUserMaxUnbrokenTrackerManualEntry$Mutation()
          ..deleteUserMaxUnbrokenTrackerManualEntry =
              UserMaxUnbrokenExerciseTracker.fromJson(
                  json['deleteUserMaxUnbrokenTrackerManualEntry']
                      as Map<String, dynamic>);

Map<String, dynamic> _$DeleteUserMaxUnbrokenTrackerManualEntry$MutationToJson(
        DeleteUserMaxUnbrokenTrackerManualEntry$Mutation instance) =>
    <String, dynamic>{
      'deleteUserMaxUnbrokenTrackerManualEntry':
          instance.deleteUserMaxUnbrokenTrackerManualEntry.toJson(),
    };

CreateUserMaxLoadTrackerManualEntry$Mutation
    _$CreateUserMaxLoadTrackerManualEntry$MutationFromJson(
            Map<String, dynamic> json) =>
        CreateUserMaxLoadTrackerManualEntry$Mutation()
          ..createUserMaxLoadTrackerManualEntry =
              UserMaxLoadExerciseTracker.fromJson(
                  json['createUserMaxLoadTrackerManualEntry']
                      as Map<String, dynamic>);

Map<String, dynamic> _$CreateUserMaxLoadTrackerManualEntry$MutationToJson(
        CreateUserMaxLoadTrackerManualEntry$Mutation instance) =>
    <String, dynamic>{
      'createUserMaxLoadTrackerManualEntry':
          instance.createUserMaxLoadTrackerManualEntry.toJson(),
    };

CreateUserMaxLoadTrackerManualEntryInput
    _$CreateUserMaxLoadTrackerManualEntryInputFromJson(
            Map<String, dynamic> json) =>
        CreateUserMaxLoadTrackerManualEntryInput(
          userMaxLoadExerciseTracker: ConnectRelationInput.fromJson(
              json['UserMaxLoadExerciseTracker'] as Map<String, dynamic>),
          completedOn:
              fromGraphQLDateTimeToDartDateTime(json['completedOn'] as int),
          loadAmount: (json['loadAmount'] as num).toDouble(),
          videoThumbUri: json['videoThumbUri'] as String?,
          videoUri: json['videoUri'] as String?,
        );

Map<String, dynamic> _$CreateUserMaxLoadTrackerManualEntryInputToJson(
        CreateUserMaxLoadTrackerManualEntryInput instance) =>
    <String, dynamic>{
      'UserMaxLoadExerciseTracker':
          instance.userMaxLoadExerciseTracker.toJson(),
      'completedOn': fromDartDateTimeToGraphQLDateTime(instance.completedOn),
      'loadAmount': instance.loadAmount,
      'videoThumbUri': instance.videoThumbUri,
      'videoUri': instance.videoUri,
    };

DeleteUserMaxLoadTrackerManualEntry$Mutation
    _$DeleteUserMaxLoadTrackerManualEntry$MutationFromJson(
            Map<String, dynamic> json) =>
        DeleteUserMaxLoadTrackerManualEntry$Mutation()
          ..deleteUserMaxLoadTrackerManualEntry =
              UserMaxLoadExerciseTracker.fromJson(
                  json['deleteUserMaxLoadTrackerManualEntry']
                      as Map<String, dynamic>);

Map<String, dynamic> _$DeleteUserMaxLoadTrackerManualEntry$MutationToJson(
        DeleteUserMaxLoadTrackerManualEntry$Mutation instance) =>
    <String, dynamic>{
      'deleteUserMaxLoadTrackerManualEntry':
          instance.deleteUserMaxLoadTrackerManualEntry.toJson(),
    };

CreateUserMaxUnbrokenTrackerManualEntry$Mutation
    _$CreateUserMaxUnbrokenTrackerManualEntry$MutationFromJson(
            Map<String, dynamic> json) =>
        CreateUserMaxUnbrokenTrackerManualEntry$Mutation()
          ..createUserMaxUnbrokenTrackerManualEntry =
              UserMaxUnbrokenExerciseTracker.fromJson(
                  json['createUserMaxUnbrokenTrackerManualEntry']
                      as Map<String, dynamic>);

Map<String, dynamic> _$CreateUserMaxUnbrokenTrackerManualEntry$MutationToJson(
        CreateUserMaxUnbrokenTrackerManualEntry$Mutation instance) =>
    <String, dynamic>{
      'createUserMaxUnbrokenTrackerManualEntry':
          instance.createUserMaxUnbrokenTrackerManualEntry.toJson(),
    };

CreateUserMaxUnbrokenTrackerManualEntryInput
    _$CreateUserMaxUnbrokenTrackerManualEntryInputFromJson(
            Map<String, dynamic> json) =>
        CreateUserMaxUnbrokenTrackerManualEntryInput(
          userMaxUnbrokenExerciseTracker: ConnectRelationInput.fromJson(
              json['UserMaxUnbrokenExerciseTracker'] as Map<String, dynamic>),
          completedOn:
              fromGraphQLDateTimeToDartDateTime(json['completedOn'] as int),
          score: json['score'] as int,
          videoThumbUri: json['videoThumbUri'] as String?,
          videoUri: json['videoUri'] as String?,
        );

Map<String, dynamic> _$CreateUserMaxUnbrokenTrackerManualEntryInputToJson(
        CreateUserMaxUnbrokenTrackerManualEntryInput instance) =>
    <String, dynamic>{
      'UserMaxUnbrokenExerciseTracker':
          instance.userMaxUnbrokenExerciseTracker.toJson(),
      'completedOn': fromDartDateTimeToGraphQLDateTime(instance.completedOn),
      'score': instance.score,
      'videoThumbUri': instance.videoThumbUri,
      'videoUri': instance.videoUri,
    };

CreateUserFastestTimeTrackerManualEntry$Mutation
    _$CreateUserFastestTimeTrackerManualEntry$MutationFromJson(
            Map<String, dynamic> json) =>
        CreateUserFastestTimeTrackerManualEntry$Mutation()
          ..createUserFastestTimeTrackerManualEntry =
              UserFastestTimeExerciseTracker.fromJson(
                  json['createUserFastestTimeTrackerManualEntry']
                      as Map<String, dynamic>);

Map<String, dynamic> _$CreateUserFastestTimeTrackerManualEntry$MutationToJson(
        CreateUserFastestTimeTrackerManualEntry$Mutation instance) =>
    <String, dynamic>{
      'createUserFastestTimeTrackerManualEntry':
          instance.createUserFastestTimeTrackerManualEntry.toJson(),
    };

CreateUserFastestTimeTrackerManualEntryInput
    _$CreateUserFastestTimeTrackerManualEntryInputFromJson(
            Map<String, dynamic> json) =>
        CreateUserFastestTimeTrackerManualEntryInput(
          userFastestTimeExerciseTracker: ConnectRelationInput.fromJson(
              json['UserFastestTimeExerciseTracker'] as Map<String, dynamic>),
          completedOn:
              fromGraphQLDateTimeToDartDateTime(json['completedOn'] as int),
          timeTakenMs: json['timeTakenMs'] as int,
          videoThumbUri: json['videoThumbUri'] as String?,
          videoUri: json['videoUri'] as String?,
        );

Map<String, dynamic> _$CreateUserFastestTimeTrackerManualEntryInputToJson(
        CreateUserFastestTimeTrackerManualEntryInput instance) =>
    <String, dynamic>{
      'UserFastestTimeExerciseTracker':
          instance.userFastestTimeExerciseTracker.toJson(),
      'completedOn': fromDartDateTimeToGraphQLDateTime(instance.completedOn),
      'timeTakenMs': instance.timeTakenMs,
      'videoThumbUri': instance.videoThumbUri,
      'videoUri': instance.videoUri,
    };

DeleteUserFastestTimeTrackerManualEntry$Mutation
    _$DeleteUserFastestTimeTrackerManualEntry$MutationFromJson(
            Map<String, dynamic> json) =>
        DeleteUserFastestTimeTrackerManualEntry$Mutation()
          ..deleteUserFastestTimeTrackerManualEntry =
              UserFastestTimeExerciseTracker.fromJson(
                  json['deleteUserFastestTimeTrackerManualEntry']
                      as Map<String, dynamic>);

Map<String, dynamic> _$DeleteUserFastestTimeTrackerManualEntry$MutationToJson(
        DeleteUserFastestTimeTrackerManualEntry$Mutation instance) =>
    <String, dynamic>{
      'deleteUserFastestTimeTrackerManualEntry':
          instance.deleteUserFastestTimeTrackerManualEntry.toJson(),
    };

CreateUserMaxUnbrokenExerciseTracker$Mutation
    _$CreateUserMaxUnbrokenExerciseTracker$MutationFromJson(
            Map<String, dynamic> json) =>
        CreateUserMaxUnbrokenExerciseTracker$Mutation()
          ..createUserMaxUnbrokenExerciseTracker =
              UserMaxUnbrokenExerciseTracker.fromJson(
                  json['createUserMaxUnbrokenExerciseTracker']
                      as Map<String, dynamic>);

Map<String, dynamic> _$CreateUserMaxUnbrokenExerciseTracker$MutationToJson(
        CreateUserMaxUnbrokenExerciseTracker$Mutation instance) =>
    <String, dynamic>{
      'createUserMaxUnbrokenExerciseTracker':
          instance.createUserMaxUnbrokenExerciseTracker.toJson(),
    };

CreateUserMaxUnbrokenExerciseTrackerInput
    _$CreateUserMaxUnbrokenExerciseTrackerInputFromJson(
            Map<String, dynamic> json) =>
        CreateUserMaxUnbrokenExerciseTrackerInput(
          equipment: json['Equipment'] == null
              ? null
              : ConnectRelationInput.fromJson(
                  json['Equipment'] as Map<String, dynamic>),
          move: ConnectRelationInput.fromJson(
              json['Move'] as Map<String, dynamic>),
          distanceUnit: $enumDecode(_$DistanceUnitEnumMap, json['distanceUnit'],
              unknownValue: DistanceUnit.artemisUnknown),
          loadAmount: (json['loadAmount'] as num).toDouble(),
          loadUnit: $enumDecode(_$LoadUnitEnumMap, json['loadUnit'],
              unknownValue: LoadUnit.artemisUnknown),
          repType: $enumDecode(_$WorkoutMoveRepTypeEnumMap, json['repType'],
              unknownValue: WorkoutMoveRepType.artemisUnknown),
        );

Map<String, dynamic> _$CreateUserMaxUnbrokenExerciseTrackerInputToJson(
        CreateUserMaxUnbrokenExerciseTrackerInput instance) =>
    <String, dynamic>{
      'Equipment': instance.equipment?.toJson(),
      'Move': instance.move.toJson(),
      'distanceUnit': _$DistanceUnitEnumMap[instance.distanceUnit],
      'loadAmount': instance.loadAmount,
      'loadUnit': _$LoadUnitEnumMap[instance.loadUnit],
      'repType': _$WorkoutMoveRepTypeEnumMap[instance.repType],
    };

CreateUserFastestTimeExerciseTracker$Mutation
    _$CreateUserFastestTimeExerciseTracker$MutationFromJson(
            Map<String, dynamic> json) =>
        CreateUserFastestTimeExerciseTracker$Mutation()
          ..createUserFastestTimeExerciseTracker =
              UserFastestTimeExerciseTracker.fromJson(
                  json['createUserFastestTimeExerciseTracker']
                      as Map<String, dynamic>);

Map<String, dynamic> _$CreateUserFastestTimeExerciseTracker$MutationToJson(
        CreateUserFastestTimeExerciseTracker$Mutation instance) =>
    <String, dynamic>{
      'createUserFastestTimeExerciseTracker':
          instance.createUserFastestTimeExerciseTracker.toJson(),
    };

CreateUserFastestTimeExerciseTrackerInput
    _$CreateUserFastestTimeExerciseTrackerInputFromJson(
            Map<String, dynamic> json) =>
        CreateUserFastestTimeExerciseTrackerInput(
          equipment: json['Equipment'] == null
              ? null
              : ConnectRelationInput.fromJson(
                  json['Equipment'] as Map<String, dynamic>),
          move: ConnectRelationInput.fromJson(
              json['Move'] as Map<String, dynamic>),
          distanceUnit: $enumDecode(_$DistanceUnitEnumMap, json['distanceUnit'],
              unknownValue: DistanceUnit.artemisUnknown),
          loadAmount: (json['loadAmount'] as num).toDouble(),
          loadUnit: $enumDecode(_$LoadUnitEnumMap, json['loadUnit'],
              unknownValue: LoadUnit.artemisUnknown),
          repType: $enumDecode(_$WorkoutMoveRepTypeEnumMap, json['repType'],
              unknownValue: WorkoutMoveRepType.artemisUnknown),
          reps: (json['reps'] as num).toDouble(),
        );

Map<String, dynamic> _$CreateUserFastestTimeExerciseTrackerInputToJson(
        CreateUserFastestTimeExerciseTrackerInput instance) =>
    <String, dynamic>{
      'Equipment': instance.equipment?.toJson(),
      'Move': instance.move.toJson(),
      'distanceUnit': _$DistanceUnitEnumMap[instance.distanceUnit],
      'loadAmount': instance.loadAmount,
      'loadUnit': _$LoadUnitEnumMap[instance.loadUnit],
      'repType': _$WorkoutMoveRepTypeEnumMap[instance.repType],
      'reps': instance.reps,
    };

CreateUserMaxLoadExerciseTracker$Mutation
    _$CreateUserMaxLoadExerciseTracker$MutationFromJson(
            Map<String, dynamic> json) =>
        CreateUserMaxLoadExerciseTracker$Mutation()
          ..createUserMaxLoadExerciseTracker =
              UserMaxLoadExerciseTracker.fromJson(
                  json['createUserMaxLoadExerciseTracker']
                      as Map<String, dynamic>);

Map<String, dynamic> _$CreateUserMaxLoadExerciseTracker$MutationToJson(
        CreateUserMaxLoadExerciseTracker$Mutation instance) =>
    <String, dynamic>{
      'createUserMaxLoadExerciseTracker':
          instance.createUserMaxLoadExerciseTracker.toJson(),
    };

CreateUserMaxLoadExerciseTrackerInput
    _$CreateUserMaxLoadExerciseTrackerInputFromJson(
            Map<String, dynamic> json) =>
        CreateUserMaxLoadExerciseTrackerInput(
          equipment: json['Equipment'] == null
              ? null
              : ConnectRelationInput.fromJson(
                  json['Equipment'] as Map<String, dynamic>),
          move: ConnectRelationInput.fromJson(
              json['Move'] as Map<String, dynamic>),
          loadUnit: $enumDecode(_$LoadUnitEnumMap, json['loadUnit'],
              unknownValue: LoadUnit.artemisUnknown),
          reps: json['reps'] as int,
        );

Map<String, dynamic> _$CreateUserMaxLoadExerciseTrackerInputToJson(
        CreateUserMaxLoadExerciseTrackerInput instance) =>
    <String, dynamic>{
      'Equipment': instance.equipment?.toJson(),
      'Move': instance.move.toJson(),
      'loadUnit': _$LoadUnitEnumMap[instance.loadUnit],
      'reps': instance.reps,
    };

DeleteUserMaxLoadExerciseTracker$Mutation
    _$DeleteUserMaxLoadExerciseTracker$MutationFromJson(
            Map<String, dynamic> json) =>
        DeleteUserMaxLoadExerciseTracker$Mutation()
          ..deleteUserMaxLoadExerciseTracker =
              json['deleteUserMaxLoadExerciseTracker'] as String;

Map<String, dynamic> _$DeleteUserMaxLoadExerciseTracker$MutationToJson(
        DeleteUserMaxLoadExerciseTracker$Mutation instance) =>
    <String, dynamic>{
      'deleteUserMaxLoadExerciseTracker':
          instance.deleteUserMaxLoadExerciseTracker,
    };

DeleteUserMaxUnbrokenExerciseTracker$Mutation
    _$DeleteUserMaxUnbrokenExerciseTracker$MutationFromJson(
            Map<String, dynamic> json) =>
        DeleteUserMaxUnbrokenExerciseTracker$Mutation()
          ..deleteUserMaxUnbrokenExerciseTracker =
              json['deleteUserMaxUnbrokenExerciseTracker'] as String;

Map<String, dynamic> _$DeleteUserMaxUnbrokenExerciseTracker$MutationToJson(
        DeleteUserMaxUnbrokenExerciseTracker$Mutation instance) =>
    <String, dynamic>{
      'deleteUserMaxUnbrokenExerciseTracker':
          instance.deleteUserMaxUnbrokenExerciseTracker,
    };

DeleteUserFastestTimeExerciseTracker$Mutation
    _$DeleteUserFastestTimeExerciseTracker$MutationFromJson(
            Map<String, dynamic> json) =>
        DeleteUserFastestTimeExerciseTracker$Mutation()
          ..deleteUserFastestTimeExerciseTracker =
              json['deleteUserFastestTimeExerciseTracker'] as String;

Map<String, dynamic> _$DeleteUserFastestTimeExerciseTracker$MutationToJson(
        DeleteUserFastestTimeExerciseTracker$Mutation instance) =>
    <String, dynamic>{
      'deleteUserFastestTimeExerciseTracker':
          instance.deleteUserFastestTimeExerciseTracker,
    };

ClubChatSummaryArguments _$ClubChatSummaryArgumentsFromJson(
        Map<String, dynamic> json) =>
    ClubChatSummaryArguments(
      clubId: json['clubId'] as String,
    );

Map<String, dynamic> _$ClubChatSummaryArgumentsToJson(
        ClubChatSummaryArguments instance) =>
    <String, dynamic>{
      'clubId': instance.clubId,
    };

DeleteClubArguments _$DeleteClubArgumentsFromJson(Map<String, dynamic> json) =>
    DeleteClubArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DeleteClubArgumentsToJson(
        DeleteClubArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

ClubSummaryArguments _$ClubSummaryArgumentsFromJson(
        Map<String, dynamic> json) =>
    ClubSummaryArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$ClubSummaryArgumentsToJson(
        ClubSummaryArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
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

UpdateClubSummaryArguments _$UpdateClubSummaryArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateClubSummaryArguments(
      data:
          UpdateClubSummaryInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateClubSummaryArgumentsToJson(
        UpdateClubSummaryArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
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

ClubSummariesArguments _$ClubSummariesArgumentsFromJson(
        Map<String, dynamic> json) =>
    ClubSummariesArguments(
      ids: (json['ids'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ClubSummariesArgumentsToJson(
        ClubSummariesArguments instance) =>
    <String, dynamic>{
      'ids': instance.ids,
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

CreateUserGoalArguments _$CreateUserGoalArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateUserGoalArguments(
      data: CreateUserGoalInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateUserGoalArgumentsToJson(
        CreateUserGoalArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DeleteUserGoalArguments _$DeleteUserGoalArgumentsFromJson(
        Map<String, dynamic> json) =>
    DeleteUserGoalArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DeleteUserGoalArgumentsToJson(
        DeleteUserGoalArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

CreateUserSleepWellLogArguments _$CreateUserSleepWellLogArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateUserSleepWellLogArguments(
      data: CreateUserSleepWellLogInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateUserSleepWellLogArgumentsToJson(
        CreateUserSleepWellLogArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

UpdateUserSleepWellLogArguments _$UpdateUserSleepWellLogArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateUserSleepWellLogArguments(
      data: UpdateUserSleepWellLogInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateUserSleepWellLogArgumentsToJson(
        UpdateUserSleepWellLogArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

UpdateUserGoalArguments _$UpdateUserGoalArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateUserGoalArguments(
      data: UpdateUserGoalInput.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateUserGoalArgumentsToJson(
        UpdateUserGoalArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

CreateUserMeditationLogArguments _$CreateUserMeditationLogArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateUserMeditationLogArguments(
      data: CreateUserMeditationLogInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateUserMeditationLogArgumentsToJson(
        CreateUserMeditationLogArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DeleteUserDayLogMoodArguments _$DeleteUserDayLogMoodArgumentsFromJson(
        Map<String, dynamic> json) =>
    DeleteUserDayLogMoodArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DeleteUserDayLogMoodArgumentsToJson(
        DeleteUserDayLogMoodArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

CreateUserEatWellLogArguments _$CreateUserEatWellLogArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateUserEatWellLogArguments(
      data: CreateUserEatWellLogInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateUserEatWellLogArgumentsToJson(
        CreateUserEatWellLogArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

UpdateUserMeditationLogArguments _$UpdateUserMeditationLogArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateUserMeditationLogArguments(
      data: UpdateUserMeditationLogInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateUserMeditationLogArgumentsToJson(
        UpdateUserMeditationLogArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

CreateUserDayLogMoodArguments _$CreateUserDayLogMoodArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateUserDayLogMoodArguments(
      data: CreateUserDayLogMoodInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateUserDayLogMoodArgumentsToJson(
        CreateUserDayLogMoodArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

UpdateUserEatWellLogArguments _$UpdateUserEatWellLogArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateUserEatWellLogArguments(
      data: UpdateUserEatWellLogInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateUserEatWellLogArgumentsToJson(
        UpdateUserEatWellLogArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
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

MarkWelcomeTodoItemAsSeenArguments _$MarkWelcomeTodoItemAsSeenArgumentsFromJson(
        Map<String, dynamic> json) =>
    MarkWelcomeTodoItemAsSeenArguments(
      data: MarkWelcomeTodoItemAsSeenInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MarkWelcomeTodoItemAsSeenArgumentsToJson(
        MarkWelcomeTodoItemAsSeenArguments instance) =>
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

DeleteLoggedWorkoutMoveArguments _$DeleteLoggedWorkoutMoveArgumentsFromJson(
        Map<String, dynamic> json) =>
    DeleteLoggedWorkoutMoveArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DeleteLoggedWorkoutMoveArgumentsToJson(
        DeleteLoggedWorkoutMoveArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

UpdateLoggedWorkoutMoveArguments _$UpdateLoggedWorkoutMoveArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateLoggedWorkoutMoveArguments(
      data: UpdateLoggedWorkoutMoveInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateLoggedWorkoutMoveArgumentsToJson(
        UpdateLoggedWorkoutMoveArguments instance) =>
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

UpdateLoggedWorkoutSetArguments _$UpdateLoggedWorkoutSetArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateLoggedWorkoutSetArguments(
      data: UpdateLoggedWorkoutSetInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateLoggedWorkoutSetArgumentsToJson(
        UpdateLoggedWorkoutSetArguments instance) =>
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

ClubWorkoutsArguments _$ClubWorkoutsArgumentsFromJson(
        Map<String, dynamic> json) =>
    ClubWorkoutsArguments(
      clubId: json['clubId'] as String,
    );

Map<String, dynamic> _$ClubWorkoutsArgumentsToJson(
        ClubWorkoutsArguments instance) =>
    <String, dynamic>{
      'clubId': instance.clubId,
    };

ClubWorkoutPlansArguments _$ClubWorkoutPlansArgumentsFromJson(
        Map<String, dynamic> json) =>
    ClubWorkoutPlansArguments(
      clubId: json['clubId'] as String,
    );

Map<String, dynamic> _$ClubWorkoutPlansArgumentsToJson(
        ClubWorkoutPlansArguments instance) =>
    <String, dynamic>{
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

UserProfileArguments _$UserProfileArgumentsFromJson(
        Map<String, dynamic> json) =>
    UserProfileArguments(
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$UserProfileArgumentsToJson(
        UserProfileArguments instance) =>
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

DeleteUserBenchmarkEntryArguments _$DeleteUserBenchmarkEntryArgumentsFromJson(
        Map<String, dynamic> json) =>
    DeleteUserBenchmarkEntryArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DeleteUserBenchmarkEntryArgumentsToJson(
        DeleteUserBenchmarkEntryArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

UserBenchmarkArguments _$UserBenchmarkArgumentsFromJson(
        Map<String, dynamic> json) =>
    UserBenchmarkArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$UserBenchmarkArgumentsToJson(
        UserBenchmarkArguments instance) =>
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

DeleteUserBenchmarkArguments _$DeleteUserBenchmarkArgumentsFromJson(
        Map<String, dynamic> json) =>
    DeleteUserBenchmarkArguments(
      id: json['id'] as String,
    );

Map<String, dynamic> _$DeleteUserBenchmarkArgumentsToJson(
        DeleteUserBenchmarkArguments instance) =>
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

MarkAnnouncementUpdateAsSeenArguments
    _$MarkAnnouncementUpdateAsSeenArgumentsFromJson(
            Map<String, dynamic> json) =>
        MarkAnnouncementUpdateAsSeenArguments(
          data: MarkAnnouncementUpdateAsSeenInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$MarkAnnouncementUpdateAsSeenArgumentsToJson(
        MarkAnnouncementUpdateAsSeenArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
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

CreateClubMembersFeedPostArguments _$CreateClubMembersFeedPostArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateClubMembersFeedPostArguments(
      clubId: json['clubId'] as String,
      data: CreateStreamFeedActivityInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateClubMembersFeedPostArgumentsToJson(
        CreateClubMembersFeedPostArguments instance) =>
    <String, dynamic>{
      'clubId': instance.clubId,
      'data': instance.data.toJson(),
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

DeleteClubMembersFeedPostArguments _$DeleteClubMembersFeedPostArgumentsFromJson(
        Map<String, dynamic> json) =>
    DeleteClubMembersFeedPostArguments(
      activityId: json['activityId'] as String,
    );

Map<String, dynamic> _$DeleteClubMembersFeedPostArgumentsToJson(
        DeleteClubMembersFeedPostArguments instance) =>
    <String, dynamic>{
      'activityId': instance.activityId,
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

UpdateClubMemberNoteArguments _$UpdateClubMemberNoteArgumentsFromJson(
        Map<String, dynamic> json) =>
    UpdateClubMemberNoteArguments(
      data: UpdateClubMemberNoteInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateClubMemberNoteArgumentsToJson(
        UpdateClubMemberNoteArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

CreateClubMemberNoteArguments _$CreateClubMemberNoteArgumentsFromJson(
        Map<String, dynamic> json) =>
    CreateClubMemberNoteArguments(
      data: CreateClubMemberNoteInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateClubMemberNoteArgumentsToJson(
        CreateClubMemberNoteArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

ClubMemberNotesArguments _$ClubMemberNotesArgumentsFromJson(
        Map<String, dynamic> json) =>
    ClubMemberNotesArguments(
      clubId: json['clubId'] as String,
      memberId: json['memberId'] as String,
      cursor: json['cursor'] as String?,
      take: json['take'] as int?,
    );

Map<String, dynamic> _$ClubMemberNotesArgumentsToJson(
        ClubMemberNotesArguments instance) =>
    <String, dynamic>{
      'clubId': instance.clubId,
      'memberId': instance.memberId,
      'cursor': instance.cursor,
      'take': instance.take,
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

ClubInviteTokensArguments _$ClubInviteTokensArgumentsFromJson(
        Map<String, dynamic> json) =>
    ClubInviteTokensArguments(
      clubId: json['clubId'] as String,
    );

Map<String, dynamic> _$ClubInviteTokensArgumentsToJson(
        ClubInviteTokensArguments instance) =>
    <String, dynamic>{
      'clubId': instance.clubId,
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

CheckUserClubMemberStatusArguments _$CheckUserClubMemberStatusArgumentsFromJson(
        Map<String, dynamic> json) =>
    CheckUserClubMemberStatusArguments(
      clubId: json['clubId'] as String,
    );

Map<String, dynamic> _$CheckUserClubMemberStatusArgumentsToJson(
        CheckUserClubMemberStatusArguments instance) =>
    <String, dynamic>{
      'clubId': instance.clubId,
    };

ClubMembersArguments _$ClubMembersArgumentsFromJson(
        Map<String, dynamic> json) =>
    ClubMembersArguments(
      clubId: json['clubId'] as String,
    );

Map<String, dynamic> _$ClubMembersArgumentsToJson(
        ClubMembersArguments instance) =>
    <String, dynamic>{
      'clubId': instance.clubId,
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

DeleteClubInviteTokenArguments _$DeleteClubInviteTokenArgumentsFromJson(
        Map<String, dynamic> json) =>
    DeleteClubInviteTokenArguments(
      data: DeleteClubInviteTokenInput.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeleteClubInviteTokenArgumentsToJson(
        DeleteClubInviteTokenArguments instance) =>
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

DeleteUserMaxUnbrokenTrackerManualEntryArguments
    _$DeleteUserMaxUnbrokenTrackerManualEntryArgumentsFromJson(
            Map<String, dynamic> json) =>
        DeleteUserMaxUnbrokenTrackerManualEntryArguments(
          entryId: json['entryId'] as String,
          parentId: json['parentId'] as String,
        );

Map<String, dynamic> _$DeleteUserMaxUnbrokenTrackerManualEntryArgumentsToJson(
        DeleteUserMaxUnbrokenTrackerManualEntryArguments instance) =>
    <String, dynamic>{
      'entryId': instance.entryId,
      'parentId': instance.parentId,
    };

CreateUserMaxLoadTrackerManualEntryArguments
    _$CreateUserMaxLoadTrackerManualEntryArgumentsFromJson(
            Map<String, dynamic> json) =>
        CreateUserMaxLoadTrackerManualEntryArguments(
          data: CreateUserMaxLoadTrackerManualEntryInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$CreateUserMaxLoadTrackerManualEntryArgumentsToJson(
        CreateUserMaxLoadTrackerManualEntryArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DeleteUserMaxLoadTrackerManualEntryArguments
    _$DeleteUserMaxLoadTrackerManualEntryArgumentsFromJson(
            Map<String, dynamic> json) =>
        DeleteUserMaxLoadTrackerManualEntryArguments(
          entryId: json['entryId'] as String,
          parentId: json['parentId'] as String,
        );

Map<String, dynamic> _$DeleteUserMaxLoadTrackerManualEntryArgumentsToJson(
        DeleteUserMaxLoadTrackerManualEntryArguments instance) =>
    <String, dynamic>{
      'entryId': instance.entryId,
      'parentId': instance.parentId,
    };

CreateUserMaxUnbrokenTrackerManualEntryArguments
    _$CreateUserMaxUnbrokenTrackerManualEntryArgumentsFromJson(
            Map<String, dynamic> json) =>
        CreateUserMaxUnbrokenTrackerManualEntryArguments(
          data: CreateUserMaxUnbrokenTrackerManualEntryInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$CreateUserMaxUnbrokenTrackerManualEntryArgumentsToJson(
        CreateUserMaxUnbrokenTrackerManualEntryArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

CreateUserFastestTimeTrackerManualEntryArguments
    _$CreateUserFastestTimeTrackerManualEntryArgumentsFromJson(
            Map<String, dynamic> json) =>
        CreateUserFastestTimeTrackerManualEntryArguments(
          data: CreateUserFastestTimeTrackerManualEntryInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$CreateUserFastestTimeTrackerManualEntryArgumentsToJson(
        CreateUserFastestTimeTrackerManualEntryArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DeleteUserFastestTimeTrackerManualEntryArguments
    _$DeleteUserFastestTimeTrackerManualEntryArgumentsFromJson(
            Map<String, dynamic> json) =>
        DeleteUserFastestTimeTrackerManualEntryArguments(
          entryId: json['entryId'] as String,
          parentId: json['parentId'] as String,
        );

Map<String, dynamic> _$DeleteUserFastestTimeTrackerManualEntryArgumentsToJson(
        DeleteUserFastestTimeTrackerManualEntryArguments instance) =>
    <String, dynamic>{
      'entryId': instance.entryId,
      'parentId': instance.parentId,
    };

CreateUserMaxUnbrokenExerciseTrackerArguments
    _$CreateUserMaxUnbrokenExerciseTrackerArgumentsFromJson(
            Map<String, dynamic> json) =>
        CreateUserMaxUnbrokenExerciseTrackerArguments(
          data: CreateUserMaxUnbrokenExerciseTrackerInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$CreateUserMaxUnbrokenExerciseTrackerArgumentsToJson(
        CreateUserMaxUnbrokenExerciseTrackerArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

CreateUserFastestTimeExerciseTrackerArguments
    _$CreateUserFastestTimeExerciseTrackerArgumentsFromJson(
            Map<String, dynamic> json) =>
        CreateUserFastestTimeExerciseTrackerArguments(
          data: CreateUserFastestTimeExerciseTrackerInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$CreateUserFastestTimeExerciseTrackerArgumentsToJson(
        CreateUserFastestTimeExerciseTrackerArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

CreateUserMaxLoadExerciseTrackerArguments
    _$CreateUserMaxLoadExerciseTrackerArgumentsFromJson(
            Map<String, dynamic> json) =>
        CreateUserMaxLoadExerciseTrackerArguments(
          data: CreateUserMaxLoadExerciseTrackerInput.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$CreateUserMaxLoadExerciseTrackerArgumentsToJson(
        CreateUserMaxLoadExerciseTrackerArguments instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };

DeleteUserMaxLoadExerciseTrackerArguments
    _$DeleteUserMaxLoadExerciseTrackerArgumentsFromJson(
            Map<String, dynamic> json) =>
        DeleteUserMaxLoadExerciseTrackerArguments(
          id: json['id'] as String,
        );

Map<String, dynamic> _$DeleteUserMaxLoadExerciseTrackerArgumentsToJson(
        DeleteUserMaxLoadExerciseTrackerArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

DeleteUserMaxUnbrokenExerciseTrackerArguments
    _$DeleteUserMaxUnbrokenExerciseTrackerArgumentsFromJson(
            Map<String, dynamic> json) =>
        DeleteUserMaxUnbrokenExerciseTrackerArguments(
          id: json['id'] as String,
        );

Map<String, dynamic> _$DeleteUserMaxUnbrokenExerciseTrackerArgumentsToJson(
        DeleteUserMaxUnbrokenExerciseTrackerArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

DeleteUserFastestTimeExerciseTrackerArguments
    _$DeleteUserFastestTimeExerciseTrackerArgumentsFromJson(
            Map<String, dynamic> json) =>
        DeleteUserFastestTimeExerciseTrackerArguments(
          id: json['id'] as String,
        );

Map<String, dynamic> _$DeleteUserFastestTimeExerciseTrackerArgumentsToJson(
        DeleteUserFastestTimeExerciseTrackerArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

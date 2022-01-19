// The width of chat messages - must be less than 1 so received and sent messages can appear on either side of the screen.
const double kChatMessageWidthFactor = 0.75;

/// These fields are passed to [Message.extraData] when sharing internal content to the chat feed.
const kSharedContentTypeField = 'shared-content-type';
const kSharedContentIdField = 'shared-content-id';
const kSharedContentNameField = 'shared-content-name';

/// Chat message types
enum ChatMessageType { regular, workout, workoutPlan, club, loggedWorkout }

/// Maps local enum to a string which gets sent to Stream in field [message.type].
const Map<ChatMessageType, String> chatMessageTypeToStreamLabel = {
  ChatMessageType.regular: 'regular',
  ChatMessageType.workout: 'workout',
  ChatMessageType.workoutPlan: 'workoutPlan',
  ChatMessageType.club: 'club',
  ChatMessageType.loggedWorkout: 'loggedWorkout',
};
const Map<String, ChatMessageType> streamLabelToChatMessageType = {
  'regular': ChatMessageType.regular,
  'workout': ChatMessageType.workout,
  'workoutPlan': ChatMessageType.workoutPlan,
  'club': ChatMessageType.club,
  'loggedWorkout': ChatMessageType.loggedWorkout,
};

/// Audio, image, video can be sent as an attachment.
/// Attachment types.
enum ChatAttachmentType { audio, image, video }

/// Maps local enum to a string which gets sent to Stream in field [attachment.type].
const Map<ChatAttachmentType, String> chatAttachmentTypeToStreamLabel = {
  ChatAttachmentType.audio: 'audio',
  ChatAttachmentType.image: 'image',
  ChatAttachmentType.video: 'video',
};
const Map<String, ChatAttachmentType> streamLabelToChatAttachmentType = {
  'audio': ChatAttachmentType.audio,
  'image': ChatAttachmentType.image,
  'video': ChatAttachmentType.video,
};

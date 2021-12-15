import 'package:flutter/cupertino.dart';

class JournalNoteTextCreator extends StatefulWidget {
  final void Function(String text) createTextNote;
  final String? textNote;
  const JournalNoteTextCreator(
      {Key? key, required this.createTextNote, this.textNote})
      : super(key: key);

  @override
  _JournalNoteTextCreatorState createState() => _JournalNoteTextCreatorState();
}

class _JournalNoteTextCreatorState extends State<JournalNoteTextCreator> {
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class JournalNoteVoiceCreator extends StatefulWidget {
  final void Function(String uri) createVoiceNote;
  final String? voiceNoteUri;
  const JournalNoteVoiceCreator(
      {Key? key, required this.createVoiceNote, this.voiceNoteUri})
      : super(key: key);

  @override
  _JournalNoteVoiceCreatorState createState() =>
      _JournalNoteVoiceCreatorState();
}

class _JournalNoteVoiceCreatorState extends State<JournalNoteVoiceCreator> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

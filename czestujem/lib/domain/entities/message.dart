import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String content;
  final DateTime sent;
  final String from;
  final bool seen;

  Message(this.content, this.sent, this.from, this.seen);

  Message.fromJson(Map<String, dynamic> json)
      : sent = json['sent'].toDate(),
        content = json['content'] as String,
        from = json['from'] as String,
        seen = json['seen'] as bool;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'sent': Timestamp.fromDate(sent),
    'content': content,
    'from': from,
    'seen' : seen
  };

}

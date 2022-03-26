class Message {
  final String content;
  final DateTime date;
  final String from;

  Message(this.content, this.date, this.from);

  Message.fromJson(Map<dynamic, dynamic> json)
      : date = DateTime.parse(json['date'] as String),
        content = json['text'] as String,
        from = json['text'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'date': date.toString(),
    'content': content,
    'from': from
  };

}

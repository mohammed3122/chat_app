class MessageModel {
  final String message;
  final String id;

  MessageModel({required this.id, required this.message});

  factory MessageModel.fromjson(json) {
    return MessageModel(message: json['message'], id: json['id']);
  }
}

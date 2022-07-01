class Message {
  final String senderId;
  final String message;
  final String time;

  Message({required this.senderId, required this.message, required this.time});

  Message.fromJson(Map<dynamic, dynamic> json)
      : senderId = json['senderId'],
        message = json['message'],
        time = json['time'];

  Map<dynamic, dynamic> toJson() => {
        'senderId': senderId,
        'message': message,
        'time': time,
      };
}

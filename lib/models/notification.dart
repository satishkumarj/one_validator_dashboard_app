class OVDNotification {
  OVDNotification({this.id, this.title, this.message, this.oneAddress, this.timeStamp});

  final int id;
  final String title;
  final String message;
  final String oneAddress;
  final int timeStamp;

  factory OVDNotification.fromJson(Map<String, dynamic> data) => new OVDNotification(
        id: data["id"],
        title: data["title"],
        message: data["message"],
        oneAddress: data["oneAddress"],
        timeStamp: data["timeStamp"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "message": message,
        "oneAddress": oneAddress,
        "timeStamp": timeStamp,
      };
}

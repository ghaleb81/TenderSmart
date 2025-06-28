class ContractorNotification {
  final int id;
  final String title;
  final String body;
  bool isRead; // mutable to allow marking as read locally

  ContractorNotification({
    required this.id,
    required this.title,
    required this.body,
    this.isRead = false,
  });

  factory ContractorNotification.fromJson(Map<String, dynamic> json) =>
      ContractorNotification(
        id: json['id'] as int,
        title: json['title'] as String,
        body: json['body'] as String,
        isRead: (json['is_read'] as int?) == 1,
      );
}

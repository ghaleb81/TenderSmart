class NotificationItem {
  final String title;
  final String body;
  final int? tenderId; // قد يكون null

  NotificationItem({required this.title, required this.body, this.tenderId});

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      NotificationItem(
        title: json['title'] as String,
        body: json['body'] as String,
        tenderId: json['tender_id'] as int?,
      );
}

/// Bildirim derin bağlantı (deep link) yükünü temsil eden model.
///
/// Örnek gelen JSON:
/// ```json
/// {
///   "type": "product",
///   "id": 25
/// }
/// ```
class NotificationPayload {
  final String? type;
  final int? id;

  const NotificationPayload({this.type, this.id});

  factory NotificationPayload.fromJson(Map<String, dynamic> json) {
    return NotificationPayload(
      type: json['type'] as String?,
      id: json['id'] as int?,
    );
  }
}

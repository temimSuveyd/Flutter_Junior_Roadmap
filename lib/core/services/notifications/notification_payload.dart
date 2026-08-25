/// Model representing a notification deep-link payload.
///
/// Example incoming JSON:
/// ```json
/// {
///   "type": "product",
///   "id": 25
/// }
/// ```
class NotificationPayload {

  const NotificationPayload({this.type, this.id});

  factory NotificationPayload.fromJson(Map<String, dynamic> json) {
    return NotificationPayload(
      type: json['type'] as String?,
      id: json['id'] as int?,
    );
  }
  final String? type;
  final int? id;
}

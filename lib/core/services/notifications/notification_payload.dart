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
    final rawId = json['id'];
    final id = rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '');
    return NotificationPayload(
      type: json['type'] as String?,
      id: id,
    );
  }
  final String? type;
  final int? id;
}

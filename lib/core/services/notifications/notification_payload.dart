class NotificationPayload {

  const NotificationPayload({this.type, this.id});

  factory NotificationPayload.fromJson(Map<String, dynamic> json) {
    final rawId = json['product'] ?? json['id'];
    final id = rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '');
    final type = json['type'] as String? ??
        (json.containsKey('product') ? 'product' : null);
    return NotificationPayload(
      type: type,
      id: id,
    );
  }
  final String? type;
  final int? id;
}

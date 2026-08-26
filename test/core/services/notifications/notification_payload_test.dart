import 'package:flutter_test/flutter_test.dart';
import 'package:juniorflutterroadmap/core/services/notifications/notification_payload.dart';

/// Tests for parsing an FCM data payload into a deep-link target.
void main() {
  group('NotificationPayload', () {
    test('parses a product payload with type and id', () {
      final payload = NotificationPayload.fromJson({
        'type': 'product',
        'id': 25,
      });

      expect(payload.type, 'product');
      expect(payload.id, 25);
    });

    test('derives type from the product key when type is missing', () {
      final payload = NotificationPayload.fromJson({'product': 42});

      expect(payload.type, 'product');
      expect(payload.id, 42);
    });

    test('returns a null id when the payload has no id', () {
      final payload = NotificationPayload.fromJson({'type': 'promo'});

      expect(payload.type, 'promo');
      expect(payload.id, isNull);
    });

    test('keeps the id but is not a product deep-link when type differs', () {
      final payload = NotificationPayload.fromJson({
        'type': 'promo',
        'id': 7,
      });

      // id is parsed, but the deep-link guard (type != 'product') ignores it.
      expect(payload.type, 'promo');
      expect(payload.id, 7);
    });
  });
}

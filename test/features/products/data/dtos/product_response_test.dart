import 'package:flutter_test/flutter_test.dart';
import 'package:juniorflutterroadmap/features/products/data/dtos/product_response.dart';

/// Tests that the raw API JSON is parsed into a product response.
void main() {
  test('fromJson reads fields from the API shape', () {
    final response = ProductResponse.fromJson({
      'images': ['https://img/x.jpg'],
      'title': 'Phone',
      'description': 'Smartphone',
      'price': 100,
      'id': 11,
      'category': {'id': 1, 'name': 'Electronics'},
    });

    expect(response.id, 11);
    expect(response.title, 'Phone');
    expect(response.price, 100.0);
    expect(response.category, 'Electronics');
    expect(response.image, ['https://img/x.jpg']);
  });
}
